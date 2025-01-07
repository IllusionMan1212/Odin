package jfif

import "core:bytes"
import "core:compress"
import "core:fmt"
import "core:image"
import "core:slice"

Image :: image.Image
Error :: image.Error
Options :: image.Options

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

	if (compress.read_data(ctx, image.JPEG_Marker) or_return) != .SOI {
		return img, .Invalid_Signature
	}

	img = new(Image)
	img.which = .JPEG

	for {
		marker := compress.read_data(ctx, image.JPEG_Marker) or_return
		#partial switch marker {
		case .SOI:
			// TODO: SOI was already handled in the header. This is likely an error.
			fmt.eprintln("Duplicate SOI found")
		case .APP0:
			length := cast(int)((compress.read_data(ctx, u16be) or_return) - 2)
			// TODO: Assuming the identifier is 4 bytes long with a 5th NUL byte is wrong.
			// The NUL byte is there to terminate a string of arbitrary length, so we should read until we encounter
			// the NUL byte.
			ident := compress.read_data(ctx, u32be) or_return
			// skip NUL byte
			compress.read_u8(ctx) or_return
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

				// When precision is 0, we read 64 u8s.
				// when it's 1, we read 64 u16s.
				table_bytes := 64
				if precision == 1 {
					table_bytes = 128
				}

				table := compress.read_slice(ctx, table_bytes) or_return
				table2 := slice.reinterpret([]u16be, table)

				fmt.println("Precision and index:", precision, index)
				if precision == 0 {
					fmt.println("Quantization Table len:", len(table))
					fmt.println("Quantization Table:", table)
				} else if precision == 1 {
					fmt.println("Quantization Table len:", len(table2))
					fmt.println("Quantization Table:", table2)
				}

				length -= table_bytes + 1
			}
		case .DHT:
			length := (compress.read_data(ctx, u16be) or_return) - 2

			for length > 0 {
				// high 4 is type (0=DC, 1=AC)
				// low 4 is table index
				type_index := compress.read_u8(ctx) or_return
				type := (type_index >> 4) & 0xF

				bits := compress.read_slice(ctx, 16) or_return
				table_len := 0
				for bit in bits {
					table_len += cast(int)bit
				}

				huffman := compress.read_slice(ctx, table_len) or_return

				length -= cast(u16be)(1 + 16 + table_len)

				fmt.println("Huffman Type|Index:", type_index)
				fmt.println("Huffman Type:", type)
				fmt.println("Huffman bits:", bits)
				fmt.println("Huffman table len:", table_len)
				fmt.println("Huffman table:", huffman)
			}
		case .EOI:
			fmt.println("Got EOI")
			break
		case .RST0..=.RST7:
			// TODO: These are parameter-less markers. i.e. No length, No value. Just a marker.
		case .SOF0: // Baseline DCT
			fmt.println("GOT", marker)
			length := (compress.read_data(ctx, u16be) or_return) - 2
			precision := compress.read_u8(ctx) or_return
			height := compress.read_data(ctx, u16be) or_return
			width := compress.read_data(ctx, u16be) or_return
			components := compress.read_u8(ctx) or_return
			img.width = cast(int)width
			img.height = cast(int)height
			img.depth = cast(int)precision
			img.channels = cast(int)components
			fmt.println("Precision:", precision)
			fmt.println("Height:", height)
			fmt.println("Width:", width)
			fmt.println("components:", components)
			for i in 0..<components {
				// 1 = Y,
				// 2 = Cb,
				// 3 = Cr
				id := compress.read_u8(ctx) or_return
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

			fmt.println("GOT SOS")
			length := (compress.read_data(ctx, u16be) or_return) - 2
			num_components := compress.read_u8(ctx) or_return
			fmt.println("Components:", num_components)
			for i in 0..<num_components {
				component_id := compress.read_u8(ctx) or_return
				// high 4 is DC, low 4 is AC
				dc_ac_table := compress.read_u8(ctx) or_return
				fmt.println("Component ID:", component_id)
				fmt.println("DC AC Table:", dc_ac_table)
			}
			Ss := compress.read_u8(ctx) or_return
			Se := compress.read_u8(ctx) or_return
			Ah_Al := compress.read_u8(ctx) or_return
			fmt.println("Ss:", Ss)
			fmt.println("Se:", Se)
			fmt.println("Ah Al:", Ah_Al)

			// TODO: after reading `length` of data, ECS (Entropy-Coded-Segment) comes which is just the compressed
			// and encoded image data.
			// We skip the ECS data for now
			for {
				byte := compress.read_u8(ctx) or_return
				if byte == 0xFF {
					byte = compress.read_u8(ctx) or_return
					switch byte {
					// If any reset markers or data (0xFF00), continue skipping
					case 0xD0..=0xD7, 0x00:
						continue
					// If any other marker, break and handle it.
					case:
						break
					}
				}
			}
		case:
			length := (compress.read_data(ctx, u16be) or_return) - 2
			fmt.printfln("Unhandled marker: %v. Skipping %v bytes", marker, length)
			compress.read_slice_from_memory(ctx, cast(int)length) or_return
		}
	}

	// TODO:
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
