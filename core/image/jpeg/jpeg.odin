package jpeg

import "core:bytes"
import "core:compress"
import "core:fmt"
import "core:math"
import "core:mem"
import "core:os"
import "core:image"
import "core:slice"

Image :: image.Image
Error :: image.Error
Options :: image.Options

HUFFMAN_MAX_SYMBOLS :: 162
HUFFMAN_MAX_BITS  :: 16

// IDCT scaling factors
m0 := 2.0 * math.cos_f32(1.0 / 16.0 * 2.0 * math.PI)
m1 := 2.0 * math.cos_f32(2.0 / 16.0 * 2.0 * math.PI)
m3 := 2.0 * math.cos_f32(2.0 / 16.0 * 2.0 * math.PI)
m5 := 2.0 * math.cos_f32(3.0 / 16.0 * 2.0 * math.PI)
m2 := m0 - m5
m4 := m0 + m5

s0 := math.cos_f32(0.0 / 16.0 * math.PI) / math.sqrt_f32(8.0)
s1 := math.cos_f32(1.0 / 16.0 * math.PI) / 2.0
s2 := math.cos_f32(2.0 / 16.0 * math.PI) / 2.0
s3 := math.cos_f32(3.0 / 16.0 * math.PI) / 2.0
s4 := math.cos_f32(4.0 / 16.0 * math.PI) / 2.0
s5 := math.cos_f32(5.0 / 16.0 * math.PI) / 2.0
s6 := math.cos_f32(6.0 / 16.0 * math.PI) / 2.0
s7 := math.cos_f32(7.0 / 16.0 * math.PI) / 2.0

Coefficient :: enum u8 {
	DC,
	AC,
}

Component :: enum u8 {
	Y = 1,
	Cb = 2,
	Cr = 3,
}

HuffmanTable :: struct {
	symbols: [HUFFMAN_MAX_SYMBOLS]byte,
	codes: [HUFFMAN_MAX_SYMBOLS]u32,
	offsets: [HUFFMAN_MAX_BITS + 1]byte,
}

QuantizationTable :: [64]u16be

ColorComponent :: struct {
	dc_table_idx: u8,
	ac_table_idx: u8,
	quantization_table_idx: u8,
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
	color_components: [Component]ColorComponent
	restart_interval: u16be
	mcus: []MCU
	defer delete(mcus)

	loop: for {
		first := compress.read_u8(ctx) or_return
		if first == 0xFF {
			marker := cast(image.JPEG_Marker)compress.read_u8(ctx) or_return
			#partial switch marker {
			case cast(image.JPEG_Marker)0xFF:
				// If we encounter multiple FF then just skip them
				continue
			case .SOI:
				return img, .Duplicate_SOI_Marker
			case .APP0:
				ident := make([dynamic]byte, 0, 16, context.temp_allocator)
				length := cast(int)((compress.read_data(ctx, u16be) or_return) - 2)
				for {
					b := compress.read_u8(ctx) or_return
					if b == 0x00 {
						break
					}
					append(&ident, b)
				}
				if slice.equal(ident[:], image.JFIF_Magic[:]) {
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
				} else if slice.equal(ident[:], image.JFXX_Magic[:]) {
					extension_code := cast(image.JFXX_Extension_Code)compress.read_u8(ctx) or_return
					// TODO: the thumbnail can be greyscale afaik. setting the type to []RGB_Pixel is le bad.
					// Ideally we'd have it be []byte and we'd specify if its RGB or greyscale. The JFXX_APP0
					// thumbnail member has to also be changed to fit this, we should also add an enum member to specify
					// how many channels it has (or just a is_RGB boolean member or something)
					//
					// JFIF_APP0's thumbnail member type MUST NOT be changed because it's always RGB.
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
						if err != nil {
							return img, .JPEG_Thumbnail_Decoding_Error
						}

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
						return img, .Invalid_JFXX_Extension_Code
					}
				} else {
					fmt.printfln("Unrecognized APP0 identifier \"%s\". Skipping", string(ident[:]))
					// - 1 for the NUL byte
					compress.read_slice(ctx, length - len(ident) - 1) or_return
					continue
				}
			// case .APP1: // Exif metadata
				// unimplemented("APP1")
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

					if precision != 0 && precision != 1 {
						return img, .Invalid_Quantization_Table_Precision
					}

					if index < 0 || index > 3 {
						return img, .Invalid_Quantization_Table_Index
					}

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
					index := type_index & 0xF

					if type != .DC && type != .AC {
						return img, .Invalid_Huffman_Coefficient_Type
					}

					if index < 0 || index > 3 {
						return img, .Invalid_Huffman_Table_Index
					}

					lengths := compress.read_slice(ctx, HUFFMAN_MAX_BITS) or_return
					num_symbols := 0
					for length, i in lengths {
						num_symbols += cast(int)length
						huffman[type][index].offsets[i + 1] = cast(u8)num_symbols
					}

					symbols := compress.read_slice(ctx, num_symbols) or_return
					copy(huffman[type][index].symbols[:], symbols)

					length -= cast(u16be)(1 + HUFFMAN_MAX_BITS + num_symbols)

					code: u32 = 0
					for i in 0..<HUFFMAN_MAX_BITS {
						for j := huffman[type][index].offsets[i]; j < huffman[type][index].offsets[i + 1]; j += 1 {
							huffman[type][index].codes[j] = code
							code += 1
						}
						code <<= 1
					}
				}
			case .EOI:
				// TODO: this is currently useless because we don't look for it when reading the Entropy Coded Stream
				// and we keep reading bits until we either finish all MCUs or we reach end of file.
				// Not sure what to do though.
				fmt.println("Got EOI")
				break loop
			case .DRI:
				length := (compress.read_data(ctx, u16be) or_return) - 2
				restart_interval = compress.read_data(ctx, u16be) or_return
				fmt.println("Restart Interval is:", restart_interval)
				// TODO: fix
				assert(restart_interval == 0, "Non-zero restart interval. We don't handle those")
			case .RST0..=.RST7:
				// TODO: These are parameter-less markers. i.e. No length, No value. Just a marker.
				unimplemented(fmt.tprint("%v marker", marker))
			case .SOF0: // Baseline sequential DCT
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

				if precision != 8 {
					return img, .Invalid_Frame_Bit_Depth_Combo
				}

				// TODO: spec allows for the height to be 0 on the condition that a DNL marker MUST exist to define
				// how many lines in the frame we have.
				// ISO/IEC 10918-1: 1993.
				// Section B.2.5
				if width == 0 || height == 0 {
					return img, .Invalid_Image_Dimensions
				}

				if components != 1 && components != 3 {
					return img, .Invalid_Number_Of_Channels
				}

				for i in 0..<components {
					id := cast(Component)compress.read_u8(ctx) or_return

					// TODO: some images write zero-based IDs for the components which violate the spec, but most (if not all)
					// decoders handle them just fine. Should we support that too?
					if id < .Y || id > .Cr {
						return img, .Image_Does_Not_Adhere_to_Spec
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
					horizontal_sampling := h_v_factors >> 4
					vertical_sampling := h_v_factors & 0xF

					if horizontal_sampling < 1 || horizontal_sampling > 4 {
						return img, .Invalid_Horizontal_Sampling_Factor
					}
					if vertical_sampling < 1 || vertical_sampling > 4 {
						return img, .Invalid_Vertical_Sampling_Factor
					}

					quantization_table_idx := compress.read_u8(ctx) or_return

					if quantization_table_idx < 0 || quantization_table_idx > 3 {
						return img, .Invalid_Quantization_Table_Index
					}

					color_components[id].quantization_table_idx = quantization_table_idx
					fmt.printfln("Id: %v, H|V: %v, Quantization table: %v", id, h_v_factors, quantization_table_idx)
					assert(h_v_factors == 17, "H V factors aren't 1:1. We don't support others for now")
				}
			case .SOF1: // Extended sequential DCT
				unimplemented("SOF1")
			case .SOF2: // Progressive DCT
				unimplemented("SOF2")
			case .SOF9: // Extended sequential DCT, Arithmetic coding
				unimplemented("SOF9")
			case .SOF3: // Lossless (sequential)
				fallthrough
			case .SOF5: // Differential sequential DCT
				fallthrough
			case .SOF6: // Differential progressive DCT
				fallthrough
			case .SOF7: // Differential lossless (sequential)
				fallthrough
			case .SOF10: // Progressive DCT, Arithmetic coding
				fallthrough
			case .SOF11: // Lossless (sequential), Arithmetic coding
				fallthrough
			case .SOF13: // Differential sequential DCT, Arithmetic coding
				fallthrough
			case .SOF14: // Differential progressive DCT, Arithmetic coding
				fallthrough
			case .SOF15: // Differential lossless (sequential), Arithmetic coding
				return img, .Unsupported_Frame_Type
			case .SOS:
				if img.channels == 0 && img.depth == 0 && img.width == 0 && img.height == 0 {
					return img, .Encountered_SOS_Before_SOF
				}

				length := (compress.read_data(ctx, u16be) or_return) - 2
				num_components := compress.read_u8(ctx) or_return
				if num_components != 1 && num_components != 3 {
					return img, .Invalid_Number_Of_Channels
				}

				for i in 0..<num_components {
					component_id := cast(Component)compress.read_u8(ctx) or_return
					if component_id < .Y || component_id > .Cr {
						return img, .Image_Does_Not_Adhere_to_Spec
					}

					// high 4 is DC, low 4 is AC
					coefficient_indices := compress.read_u8(ctx) or_return
					dc_table_idx := coefficient_indices >> 4
					ac_table_idx := coefficient_indices & 0xF

					if (dc_table_idx < 0 || dc_table_idx > 3) || (ac_table_idx < 0 || ac_table_idx > 3) {
						return img, .Invalid_Huffman_Table_Index
					}

					color_components[component_id].dc_table_idx = dc_table_idx
					color_components[component_id].ac_table_idx = ac_table_idx
				}
				// TODO: These aren't used for sequential DCT, only progressive and lossless.
				Ss := compress.read_u8(ctx) or_return
				Se := compress.read_u8(ctx) or_return
				Ah_Al := compress.read_u8(ctx) or_return
				//fmt.println("Ss:", Ss)
				//fmt.println("Se:", Se)
				//fmt.println("Ah Al:", Ah_Al)

				mcu_width := (img.width + 7) / 8
				mcu_height := (img.height + 7) / 8
				mcu_count := (mcu_height * mcu_width)
				mcus = make([]MCU, mcu_count)

				previous_dc: [Component]i16

				fmt.println("MCU count:", mcu_count)

				for m in 0..<mcu_count {
				component_loop: for c in 1..=img.channels {
						c := cast(Component)c
						mcu := &mcus[m][c]
						dc_table := huffman[.DC][color_components[c].dc_table_idx]
						ac_table := huffman[.AC][color_components[c].ac_table_idx]
						quantization_table := quantization[color_components[c].quantization_table_idx]

						length := get_symbol(ctx, dc_table)

						if length > 11 {
							fmt.println("DC coefficient length greater than 11")
						}

						dc_coeff := cast(i16)read_bits_msb_from_memory(ctx, length)

						if length != 0 && dc_coeff < (1 << (length - 1)) {
							dc_coeff -= (1 << length) - 1
						}
						mcu[0] = (dc_coeff + previous_dc[c]) * cast(i16)quantization_table[0]
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

							mcu[zigzag[i]] = ac_coeff * cast(i16)quantization_table[i]
						}
					}

					for c in 1..=img.channels {
						c := cast(Component)c
						mcu := &mcus[m][c]

						for i in 0..<8 {
							g0 := cast(f32)mcu[0 * 8 + i] * s0
							g1 := cast(f32)mcu[4 * 8 + i] * s4
							g2 := cast(f32)mcu[2 * 8 + i] * s2
							g3 := cast(f32)mcu[6 * 8 + i] * s6
							g4 := cast(f32)mcu[5 * 8 + i] * s5
							g5 := cast(f32)mcu[1 * 8 + i] * s1
							g6 := cast(f32)mcu[7 * 8 + i] * s7
							g7 := cast(f32)mcu[3 * 8 + i] * s3

							f4 := g4 - g7
							f5 := g5 + g6
							f6 := g5 - g6
							f7 := g4 + g7

							e0 := g0
							e1 := g1
							e2 := g2 - g3
							e3 := g2 + g3
							e4 := f4
							e5 := f5 - f7
							e6 := f6
							e7 := f5 + f7
							e8 := f4 + f6

							d0 := e0
							d1 := e1
							d2 := e2 * m1
							d3 := e3
							d4 := e4 * m2
							d5 := e5 * m3
							d6 := e6 * m4
							d7 := e7
							d8 := e8 * m5

							c0 := d0 + d1
							c1 := d0 - d1
							c2 := d2 - d3
							c3 := d3
							c4 := d4 + d8
							c5 := d5 + d7
							c6 := d6 - d8
							c7 := d7
							c8 := c5 - c6

							b0 := c0 + c3
							b1 := c1 + c2
							b2 := c1 - c2
							b3 := c0 - c3
							b4 := c4 - c8
							b5 := c8
							b6 := c6 - c7
							b7 := c7

							mcu[0 * 8 + i] = cast(i16)(b0 + b7)
							mcu[1 * 8 + i] = cast(i16)(b1 + b6)
							mcu[2 * 8 + i] = cast(i16)(b2 + b5)
							mcu[3 * 8 + i] = cast(i16)(b3 + b4)
							mcu[4 * 8 + i] = cast(i16)(b3 - b4)
							mcu[5 * 8 + i] = cast(i16)(b2 - b5)
							mcu[6 * 8 + i] = cast(i16)(b1 - b6)
							mcu[7 * 8 + i] = cast(i16)(b0 - b7)
						}

						for i in 0..<8 {
							g0 := cast(f32)mcu[i * 8 + 0] * s0
							g1 := cast(f32)mcu[i * 8 + 4] * s4
							g2 := cast(f32)mcu[i * 8 + 2] * s2
							g3 := cast(f32)mcu[i * 8 + 6] * s6
							g4 := cast(f32)mcu[i * 8 + 5] * s5
							g5 := cast(f32)mcu[i * 8 + 1] * s1
							g6 := cast(f32)mcu[i * 8 + 7] * s7
							g7 := cast(f32)mcu[i * 8 + 3] * s3

							f4 := g4 - g7
							f5 := g5 + g6
							f6 := g5 - g6
							f7 := g4 + g7

							e0 := g0
							e1 := g1
							e2 := g2 - g3
							e3 := g2 + g3
							e4 := f4
							e5 := f5 - f7
							e6 := f6
							e7 := f5 + f7
							e8 := f4 + f6

							d0 := e0
							d1 := e1
							d2 := e2 * m1
							d3 := e3
							d4 := e4 * m2
							d5 := e5 * m3
							d6 := e6 * m4
							d7 := e7
							d8 := e8 * m5

							c0 := d0 + d1
							c1 := d0 - d1
							c2 := d2 - d3
							c3 := d3
							c4 := d4 + d8
							c5 := d5 + d7
							c6 := d6 - d8
							c7 := d7
							c8 := c5 - c6

							b0 := c0 + c3
							b1 := c1 + c2
							b2 := c1 - c2
							b3 := c0 - c3
							b4 := c4 - c8
							b5 := c8
							b6 := c6 - c7
							b7 := c7

							mcu[i * 8 + 0] = cast(i16)(b0 + b7)
							mcu[i * 8 + 1] = cast(i16)(b1 + b6)
							mcu[i * 8 + 2] = cast(i16)(b2 + b5)
							mcu[i * 8 + 3] = cast(i16)(b3 + b4)
							mcu[i * 8 + 4] = cast(i16)(b3 - b4)
							mcu[i * 8 + 5] = cast(i16)(b2 - b5)
							mcu[i * 8 + 6] = cast(i16)(b1 - b6)
							mcu[i * 8 + 7] = cast(i16)(b0 - b7)
						}
					}

					for i in 0..<64 {
						r := cast(i16)math.clamp(cast(f32)mcus[m][.Y][i] + 1.402 * cast(f32)mcus[m][.Cr][i] + 128, 0, 255)
						g := cast(i16)math.clamp(cast(f32)mcus[m][.Y][i] - 0.344 * cast(f32)mcus[m][.Cb][i] - 0.714 * cast(f32)mcus[m][.Cr][i] + 128, 0, 255)
						b := cast(i16)math.clamp(cast(f32)mcus[m][.Y][i] + 1.772 * cast(f32)mcus[m][.Cb][i] + 128, 0, 255)

						mcus[m][.Y][i] = r
						mcus[m][.Cb][i] = g
						mcus[m][.Cr][i] = b
					}
				}

				if resize(&img.pixels.buf, img.width * img.height * img.channels) != nil {
					return img, .Unable_To_Allocate_Or_Resize
				}

				for y in 0..<img.height {
					mcu_row := y / 8
					pixel_row := y % 8
					for x in 0..<img.width {
						mcu_col := x / 8
						pixel_col := x % 8
						mcu_idx := mcu_row * mcu_width + mcu_col
						pixel_idx := pixel_row * 8 + pixel_col


						if img.channels == 3 {
							out := mem.slice_data_cast([]image.RGB_Pixel, img.pixels.buf[:])
							out[y * img.width + x] = {
								cast(byte)mcus[mcu_idx][.Y][pixel_idx],
								cast(byte)mcus[mcu_idx][.Cb][pixel_idx],
								cast(byte)mcus[mcu_idx][.Cr][pixel_idx],
							}
						} else {
							img.pixels.buf[y * img.width + x] = cast(byte)mcus[mcu_idx][.Y][pixel_idx]
						}
					}
				}

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
