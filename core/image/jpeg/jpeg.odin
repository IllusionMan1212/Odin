package jpeg

import "core:bytes"
import "core:compress"
import "core:fmt"
import "core:os"
import "core:image"
import "core:slice"

Image :: image.Image
Error :: image.Error
Options :: image.Options

HUFFMAN_MAX_SYMBOLS :: 162
HUFFMAN_MAX_BITS  :: 16

Coefficient :: enum u8 {
	DC,
	AC,
}

Component :: enum u8 {
	Y = 1,
	Cb = 2,
	Cr = 3,
	I = 4,
	Q = 5,
}

HuffmanTable :: struct {
	symbols: [HUFFMAN_MAX_SYMBOLS]byte,
	codes: [HUFFMAN_MAX_SYMBOLS]u32,
	offsets: [HUFFMAN_MAX_BITS + 1]byte,
}

QuantizationTable :: []u16be

ColorComponent :: struct {
	dc_table_id: u8,
	ac_table_id: u8,
	quantization_table_id: u8,
}

MCU :: [Component][64]i16

zigzag := [?]byte{
    0,   1,  8, 16,  9,  2,  3, 10,
    17, 24, 32, 25, 18, 11,  4,  5,
    12, 19, 26, 33, 40, 48, 41, 34,
    27, 20, 13,  6,  7, 14, 21, 28,
    35, 42, 49, 56, 57, 50, 43, 36,
    29, 22, 15, 23, 30, 37, 44, 51,
    58, 59, 52, 45, 38, 31, 39, 46,
    53, 60, 61, 54, 47, 55, 62, 63,
}

@(optimization_mode="favor_size")
refill_msb_from_memory :: #force_inline proc(z: ^compress.Context_Memory_Input, width := i8(48)) {
	refill := u64(width)
	b      := u64(0)

	if z.num_bits > refill {
		return
	}

	for {
		if len(z.input_data) != 0 {
			b = u64(z.input_data[0])

			if len(z.input_data) > 1 {
				next := u64(z.input_data[1])

				if b == 0xFF && next == 0x00 {
					z.input_data = z.input_data[2:]
				} else {
					z.input_data = z.input_data[1:]
				}
			} else {
				z.input_data = z.input_data[1:]
			}
		} else {
			b = 0
		}

		z.code_buffer |= ((b << 56) >> u8(z.num_bits))
		z.num_bits += 8
		if z.num_bits > refill {
			break
		}
	}
}

refill_msb :: proc{refill_msb_from_memory}

@(optimization_mode="favor_size")
consume_bits_msb_from_memory :: #force_inline proc(z: ^compress.Context_Memory_Input, width: u8) {
	z.code_buffer <<= width
	z.num_bits -= u64(width)
}

consume_bits_msb :: proc{consume_bits_msb_from_memory}

@(optimization_mode="favor_size")
peek_bits_msb_from_memory :: #force_inline proc(z: ^compress.Context_Memory_Input, width: u8) -> u32 {
	if z.num_bits < u64(width) {
		refill_msb(z)
	}
	return u32((z.code_buffer &~ (max(u64) >> width)) >> (64 - width))
}

peek_bits_msb :: proc{peek_bits_msb_from_memory}

@(optimization_mode="favor_size")
read_bits_msb_from_memory :: #force_inline proc(z: ^compress.Context_Memory_Input, width: u8) -> u32 {
	k := #force_inline peek_bits_msb(z, width)
	#force_inline consume_bits_msb(z, width)
	return k
}

// TODO: We could do something like png.odin where we return generic metadata about the
// image and its pixel data but for more specific stuff (read: JFIF APP0, JFXX APP0, Application APP0) we provide
// helper function that parse and read jpeg chunks (read: segments) and the user can extract that data themselves.
// Not sure. TGA stores specific data in its *_Info struct, maybe because it doesn't have chunks/segments like PNG
// and JPEG?

load_from_bytes :: proc(data: []byte, options := Options{}, allocator := context.allocator) -> (img: ^Image, err: Error) {
	ctx := &compress.Context_Memory_Input{
		input_data = data,
	}

	img, err = load_from_context(ctx, options, allocator)
	return img, err
}

get_symbol :: proc(ctx: ^$C, huffman_table: HuffmanTable) -> byte {
	possible_code: u32 = 0

	for i in 0..<HUFFMAN_MAX_BITS {
		bit := read_bits_msb_from_memory(ctx, 1)
		possible_code = (possible_code << 1) | bit

		for j := huffman_table.offsets[i]; j < huffman_table.offsets[i + 1]; j += 1 {
			if possible_code == huffman_table.codes[j] {
				return huffman_table.symbols[j]
			}
		}
	}

	return 0
}

load_from_context :: proc(ctx: ^$C, options := Options{}, allocator := context.allocator) -> (img: ^Image, err: Error) {
	context.allocator = allocator
	options := options

	// TODO: make sure to handle all the supported options
	if .info in options {
		options += {.return_metadata, .do_not_decompress_image}
		options -= {.info}
	}

	if .return_header in options && .return_metadata in options {
		options -= {.return_header}
	}

	first := compress.read_u8(ctx) or_return
	soi := cast(image.JPEG_Marker)compress.read_u8(ctx) or_return
	if first != 0xFF && soi != .SOI {
		return img, .Invalid_Signature
	}

	img = new(Image)
	img.which = .JPEG

	huffman: [Coefficient][4]HuffmanTable
	quantization: [4]QuantizationTable
	defer for i in 0..<4 {
		delete(quantization[i])
	}
	color_components: [Component]ColorComponent
	mcus: []MCU

	loop: for {
		first := compress.read_u8(ctx) or_return
		if first == 0xFF {
			marker := cast(image.JPEG_Marker)compress.read_u8(ctx) or_return
			#partial switch marker {
			case cast(image.JPEG_Marker)0xFF:
				// If we encounter multiple FF then just skip them
				continue
			case .SOI:
				// TODO: SOI was already handled before the loop. This is likely an error.
				fmt.eprintln("Duplicate SOI found")
			case .APP0:
				length := cast(int)((compress.read_data(ctx, u16be) or_return) - 2)
				// TODO: Assuming the identifier is 4 bytes long with a 5th NUL byte is wrong.
				// The NUL byte is there to terminate a string of arbitrary length, so we should read until we encounter
				// the NUL byte.
				ident := compress.read_data(ctx, u32be) or_return
				// skip NUL byte
				NUL := compress.read_u8(ctx) or_return
				assert(NUL == 0x00, "APP0 identifier NUL byte is not NUL. Identifier might not be 4 bytes long")
				switch ident {
				case image.JFIF_Magic:
					version := compress.read_data(ctx, u16be) or_return
					units := cast(image.JFIF_Unit)(compress.read_u8(ctx) or_return)
					x_density := compress.read_data(ctx, u16be) or_return
					y_density := compress.read_data(ctx, u16be) or_return
					x_thumbnail := cast(int)compress.read_u8(ctx) or_return
					y_thumbnail := cast(int)compress.read_u8(ctx) or_return
					thumbnail: []image.RGB_Pixel

					if x_thumbnail * y_thumbnail != 0 {
						thumb_pixels := slice.reinterpret([]image.RGB_Pixel, compress.read_slice_from_memory(ctx, x_thumbnail * y_thumbnail * 3) or_return)
						// TODO: this leaks if we don't have .return_metadata on
						thumbnail = make([]image.RGB_Pixel, x_thumbnail * y_thumbnail)
						copy(thumbnail, thumb_pixels)
					}

					if .return_metadata in options {
						info: ^image.JPEG_Info
						if img.metadata == nil {
							info = new(image.JPEG_Info)
						} else {
							info = img.metadata.(^image.JPEG_Info)
						}
						info.jfif_app0 = image.JFIF_APP0{
							ident,
							version,
							units,
							x_density,
							y_density,
							cast(u8)x_thumbnail,
							cast(u8)y_thumbnail,
							thumbnail,
						}
						img.metadata = info
					}
				case image.JFXX_Magic:
					extension_code := cast(image.JFXX_Extension_Code)compress.read_u8(ctx) or_return
					thumbnail: []image.RGB_Pixel

					switch extension_code {
					case .Thumbnail_JPEG:
						// +1 for the NUL byte
						thumbnail_len := length - (size_of(image.JFXX_Magic) + 1 + size_of(image.JFXX_Extension_Code))
						thumbnail_jpeg := compress.read_slice(ctx, thumbnail_len) or_return
						thumbnail_img, err := load_from_bytes(thumbnail_jpeg)
						// TODO: Implement jpeg decoding for the thumbnail
						// Not sure how to handle the returned ^Image and freeing it considering we want the pixel data
						// to exist after APP0 is processed.
						// I guess we just copy the pixel data to `thumbnail` and disregard
						// all the other information the jpeg-compressed thumbnail provides.

						unimplemented(fmt.tprintf("%v", extension_code))
					case .Thumbnail_3_Byte_RGB:
						x_thumbnail := compress.read_u8(ctx) or_return
						y_thumbnail := compress.read_u8(ctx) or_return
						pixels := slice.reinterpret([]image.RGB_Pixel, compress.read_slice(ctx, cast(int)x_thumbnail * cast(int)y_thumbnail * 3) or_return)
						// TODO: leak if we don't .return_metadata
						thumbnail := make([]image.RGB_Pixel, cast(int)x_thumbnail * cast(int)y_thumbnail)
						copy(thumbnail, pixels)

						if .return_metadata in options {
							info: ^image.JPEG_Info
							if img.metadata == nil {
								info = new(image.JPEG_Info)
							} else {
								info = img.metadata.(^image.JPEG_Info)
							}
							info.jfxx_app0 = image.JFXX_APP0{
								extension_code,
								x_thumbnail,
								y_thumbnail,
								thumbnail,
							}
							img.metadata = info
						}
					case .Thumbnail_1_Byte_Palette:
						panic("Got a 1 byte palette JFXX thumbnail. Test to see if the dumped data is correct using imagemagick\n`display -size WxH -depth 8 RGB:image.file`")
						//x_thumbnail := compress.read_u8(ctx) or_return
						//y_thumbnail := compress.read_u8(ctx) or_return
						//palette := slice.reinterpret([]image.RGB_Pixel, compress.read_slice(ctx, 768) or_return)
						//old_pixels := compress.read_slice(ctx, cast(int)x_thumbnail * cast(int)y_thumbnail) or_return
						// TODO: leak if we don't .return_metadata
						//pixels := make([]image.RGB_Pixel, x_thumbnail * y_thumbnail)

						//for i in 0..<x_thumbnail*y_thumbnail {
						//	pixels[i] = palette[old_pixels[i]]
						//}

						//if .return_metadata in options {
						//	info: ^image.JPEG_Info
						//	if img.metadata == nil {
						//		info = new(image.JPEG_Info)
						//	} else {
						//		info = img.metadata.(^image.JPEG_Info)
						//	}
						//	info.jfxx_app0 = image.JFXX_APP0{
						//		extension_code,
						//		x_thumbnail,
						//		y_thumbnail,
						//		pixels,
						//	}
						//	img.metadata = info
						//}
					case:
						// TODO: should this be an error or should we gracefully ignore unknown/corrupt extension codes?
						fmt.println("Invalid JFXX extension code")
					}
				case:
					fmt.println("Unrecognized APP0 identifier. Skipping")
					// TODO: ditto about the arbitrary length string. We're subtracting 5
					// for the 4 byte identifier and the 5th NUL byte which is wrong.
					compress.read_slice(ctx, length - 5) or_return
					continue
				}
			case .COM:
				// TODO: comments should probably be stored in metadata
				length := (compress.read_data(ctx, u16be) or_return) - 2
				comment := compress.read_slice(ctx, cast(int)length) or_return
			case .DQT:
				length := cast(int)(compress.read_data(ctx, u16be) or_return) - 2

				for length > 0 {
					precision_and_index := compress.read_u8(ctx) or_return
					precision := precision_and_index >> 4
					index := precision_and_index & 0xF

					quantization[index] = make(QuantizationTable, 64)

					// When precision is 0, we read 64 u8s.
					// when it's 1, we read 64 u16s.
					table_bytes := 64
					if precision == 1 {
						table_bytes = 128
						table := compress.read_slice(ctx, table_bytes) or_return
						for v, i in slice.reinterpret([]u16be, table) {
							quantization[index][i] = v
						}
					} else {
						table := compress.read_slice(ctx, table_bytes) or_return
						for v, i in table {
							quantization[index][i] = cast(u16be)v
						}
					}

					length -= table_bytes + 1
				}
			case .DHT:
				length := (compress.read_data(ctx, u16be) or_return) - 2

				for length > 0 {
					type_index := compress.read_u8(ctx) or_return
					type := cast(Coefficient)((type_index >> 4) & 0xF)
					id := type_index & 0xF

					lengths := compress.read_slice(ctx, HUFFMAN_MAX_BITS) or_return
					num_symbols := 0
					for length, i in lengths {
						num_symbols += cast(int)length
						huffman[type][id].offsets[i + 1] = cast(u8)num_symbols
					}

					symbols := compress.read_slice(ctx, num_symbols) or_return
					copy(huffman[type][id].symbols[:], symbols)

					length -= cast(u16be)(1 + HUFFMAN_MAX_BITS + num_symbols)

					code: u32 = 0
					for i in 0..<HUFFMAN_MAX_BITS {
						for j := huffman[type][id].offsets[i]; j < huffman[type][id].offsets[i + 1]; j += 1 {
							huffman[type][id].codes[j] = code
							code += 1
						}
						code <<= 1
					}
				}
			case .EOI:
				fmt.println("Got EOI")
				break loop
			case .RST0..=.RST7:
				// TODO: These are parameter-less markers. i.e. No length, No value. Just a marker.
				unimplemented(fmt.tprint("%v marker", marker))
			case .SOF0: // Baseline DCT
				assert(img.channels == 0, "Encountered more than one SOF0 marker")

				length := (compress.read_data(ctx, u16be) or_return) - 2
				precision := compress.read_u8(ctx) or_return
				height := compress.read_data(ctx, u16be) or_return
				width := compress.read_data(ctx, u16be) or_return
				components := compress.read_u8(ctx) or_return
				img.width = cast(int)width
				img.height = cast(int)height
				img.depth = cast(int)precision
				img.channels = cast(int)components

				if width == 0 || height == 0 {
					panic("Invalid image dimensions")
					//TODO: return error
				}

				if components != 1 && components != 3 {
					panic("Unsupported number of channels")
					// TODO: return error
					// 4 components and 0 components should maybe return different errors
					// 0 components is just invalid, but 4 components means CMYK and maybe we can support that.
				}

				for i in 0..<components {
					// 1 = Y,
					// 2 = Cb,
					// 3 = Cr,
					// 4 = I,
					// 5 = Q,
					// TODO: YIQ is a different color space that JPEGs supposedly support, will have to double check the spec.
					// I will likely not have IQ in the component enum and just treat them as errors.
					// If someone can provide enough evidence that the JPEG compression format OR the JFIF file format
					// is supposed to support this color space then we'll add support for it, but now for this is just noise.
					id := cast(Component)compress.read_u8(ctx) or_return

					if id == .I || id == .Q {
						panic("YIQ color space detected")
						// TODO: return error or something
					}

					// TODO: some images write zero-based IDs for the components which violate the spec, but most (if not all)
					// decoders handle them just fine. I guess we'll add support for that too.
					if id == cast(Component)0 || id > .Cr {
						panic("Invalid component ID")
						// TODO: return error
					}

					// high 4 is H, low 4 is V
					// The H and V sampling factors dictate the final size of the component they are associated with.
					// For instance, the color space defaults to YCbCr and the H and V sampling factors for each component,
					// Y, Cb, and Cr, default to 2, 1, and 1, respectively (2 for both H and V of the Y component, etc.)
					// in the Jpeg-6a library by the Independent Jpeg Group. While this does mean that the Y component
					// will be twice the size of the other two components--giving it a higher resolution, the lower resolution
					// components are quartered in size during compression in order to achieve this difference.
					// Thus, the Cb and Cr components must be quadrupled in size during decompression
					// https://www.geocities.ws/crestwoodsdd/JPEG.htm
					h_v_factors := compress.read_u8(ctx) or_return
					quantization_table_id := compress.read_u8(ctx) or_return
					color_components[id].quantization_table_id = quantization_table_id
					fmt.printfln("Id: %v, H|V: %v, Quantization table: %v", id, h_v_factors, quantization_table_id)
				}
			case .SOF1: // Extended sequential DCT
				unimplemented("SOF1")
			case .SOF2: // Progressive DCT
				unimplemented("SOF2")
			case .SOF3: // Lossless (sequential)
				unimplemented("SOF3")
			case .SOF5: // Differential sequential DCT
				unimplemented("SOF5")
			case .SOF6: // Differential progressive DCT
				unimplemented("SOF6")
			case .SOF7: // Differential lossless (sequential)
				unimplemented("SOF7")
			case .SOF9: // Extended sequential DCT, Arithmetic coding
				unimplemented("SOF9")
			case .SOF10: // Progressive DCT, Arithmetic coding
				unimplemented("SOF10")
			case .SOF11: // Lossless (sequential), Arithmetic coding
				unimplemented("SOF11")
			case .SOF13: // Differential sequential DCT, Arithmetic coding
				unimplemented("SOF13")
			case .SOF14: // Differential progressive DCT, Arithmetic coding
				unimplemented("SOF14")
			case .SOF15: // Differential lossless (sequential), Arithmetic coding
				unimplemented("SOF15")
			case .SOS:
				// TODO: SOS cannot come before SOFn. This is a fatal decoding error and we should abort.

				length := (compress.read_data(ctx, u16be) or_return) - 2
				num_components := compress.read_u8(ctx) or_return
				for i in 0..<num_components {
					component_id := cast(Component)compress.read_u8(ctx) or_return
					// high 4 is DC, low 4 is AC
					huffman_table_info := compress.read_u8(ctx) or_return
					dc_table_id := huffman_table_info >> 4
					ac_table_id := huffman_table_info & 0xF
					color_components[component_id].dc_table_id = dc_table_id
					color_components[component_id].ac_table_id = ac_table_id
				}
				// TODO: These aren't used for baseline sequential DCT, only progressive.
				Ss := compress.read_u8(ctx) or_return
				Se := compress.read_u8(ctx) or_return
				Ah_Al := compress.read_u8(ctx) or_return
				//fmt.println("Ss:", Ss)
				//fmt.println("Se:", Se)
				//fmt.println("Ah Al:", Ah_Al)

				// TODO: Handle 0xFF00 by ignoring the 00, this is a bit harder because these 0x00 bytes are always byte-aligned
				// meaning we can't just look at 8 bits from the bitstream and see if they're 0s
				// we _could_ push to a dyn array but that's allocation and I think we can do it without allocation
				// maybe some mix of looking at bytes and bits (read_u8 and read_bits_lsb)

				mcuWidth := (img.width + 7) / 8
				mcuHeight := (img.height + 7) / 8
				mcu_count := (mcuHeight * mcuWidth)
				mcus = make([]MCU, mcu_count)

				previous_dc: [Component]i16

				fmt.println("MCU count:", mcu_count)

				for m in 0..<mcu_count {
				component_loop: for c in 1..=img.channels {
						c := cast(Component)c
						mcu := &mcus[m][c]
						dc_table := huffman[.DC][color_components[c].dc_table_id]
						ac_table := huffman[.AC][color_components[c].ac_table_id]
						quantization_table := quantization[color_components[c].quantization_table_id]

						length := get_symbol(ctx, dc_table)

						if length > 11 {
							fmt.println("DC coefficient length greater than 11")
						}

						dc_coeff := cast(i16)read_bits_msb_from_memory(ctx, length)

						if length != 0 && dc_coeff < (1 << (length - 1)) {
							dc_coeff -= (1 << length) - 1
						}
						mcu[0] = (dc_coeff + previous_dc[c]) * cast(i16)quantization_table[zigzag[0]]
						previous_dc[c] = dc_coeff + previous_dc[c]

						for i := 1; i < 64; i += 1 {
							// High nibble is amount of 0s to skip.
							// Low nibble is length of coeff.
							symbol := get_symbol(ctx, ac_table)

							// Special symbol used to indicate
							// that the rest of the MCU is filled with 0s
							if symbol == 0x00 {
								continue component_loop
							}

							amnt_zeros := symbol >> 4
							ac_coeff_len := symbol & 0xF
							ac_coeff: i16 = 0

							// Special symbol used to indicate
							// that the next 16 coeffs are 0s
							//if symbol == 0xF0 {
							//	amnt_zeros = 16
							//}

							if i + cast(int)amnt_zeros >= 64 {
								fmt.println("Zero run-length exceeded MCU")
							}

							i += cast(int)amnt_zeros

							if ac_coeff_len > 10 {
								fmt.println("AC coefficient length greater than 10")
							}

							ac_coeff = cast(i16)read_bits_msb_from_memory(ctx, ac_coeff_len)
							if ac_coeff < (1 << (ac_coeff_len - 1)) {
								ac_coeff -= (1 << ac_coeff_len) - 1
							}

							mcu[zigzag[i]] = ac_coeff * cast(i16)quantization_table[zigzag[i]]
						}
					}
				}

				fd := os.open("bruh.image", os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o777) or_else panic("Failed to open out file")

				for y in 0..<img.height {
					mcuRow := y / 8
					pixelRow := y % 8
					for x in 0..<img.width {
						mcuCol := x / 8
						pixelCol := x % 8
						mcuIndex := mcuRow * mcuWidth + mcuCol
						pixelIndex := pixelRow * 8 + pixelCol

						os.write_byte(fd, cast(u8)mcus[mcuIndex][.Y][pixelIndex])
						os.write_byte(fd, cast(u8)mcus[mcuIndex][.Cb][pixelIndex])
						os.write_byte(fd, cast(u8)mcus[mcuIndex][.Cr][pixelIndex])
					}
				}

				os.close(fd)

				break loop
			case .TEM:
				// TEM doesn't have a length, continue to next marker
			case:
				length := (compress.read_data(ctx, u16be) or_return) - 2
				fmt.printfln("Unhandled marker: %v. Skipping %v bytes", marker, length)
				compress.read_slice_from_memory(ctx, cast(int)length) or_return
			}
		}
	}

	return
}

destroy :: proc(img: ^Image) {
	if img == nil {
		return
	}

	bytes.buffer_destroy(&img.pixels)

	if v, ok := img.metadata.(^image.JPEG_Info); ok {
		if jfxx, ok := v.jfxx_app0.?; ok {
			delete(jfxx.thumbnail)
		}
		if jfif, ok := v.jfif_app0.?; ok {
			delete(jfif.thumbnail)
		}
		free(v)
	}
	free(img)
}

@(init, private)
_register :: proc() {
	image.register(.JPEG, load_from_bytes, destroy)
}
