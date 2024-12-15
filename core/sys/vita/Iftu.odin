#+build vita
package vita

import "core:c"

foreign import iftu "system:SceIftuForDriver_stub"

SceIftuErrorCode :: enum c.uint {
	INVALID_PLANE		= 0x803F0700,
	INVALID_PARAM		= 0x803F0701,
	INVALID_PIXELFORMAT	= 0x803F0703,
	PLANE_BUSY		= 0x803F0704,
}

SceIftuPixelformat :: enum c.int {
	BGR565		= 0x01,
	RGB565		= 0x02,
	BGRA5551		= 0x04,
	RGBA5551		= 0x08,
	BGRX8888		= 0x10,
	RGBX8888		= 0x20,
	BGRA1010102	= 0x40,
	RGBA1010102	= 0x80,
	BGRP		= 0x100,	/* 3 planes - R, G, B */
	RGBX8888_MULT	= 0x1000,
	BGRX8888_MULT	= 0x2000,
	RGBA1010102_MULT	= 0x4000,
	BGRA1010102_MULT	= 0x8000,
	NV12		= 0x10000,	/* 2 planes - Y, Cb + Cr interleaved */
	YUV420		= 0x20000,	/* 3 planes - Y, Cb, Cr */
	YUV422		= 0x200000,	/* 3 planes - Y, Cb, Cr */
}

SceIftuCscParams :: struct {
	post_add_0: c.uint,		/* 10-bit integer */
	post_add_1_2: c.uint,		/* 10-bit integer */
	post_clamp_max_0: c.uint,		/* 10-bit integer */
	post_clamp_min_0: c.uint,		/* 10-bit integer */
	post_clamp_max_1_2: c.uint,	/* 10-bit integer */
	post_clamp_min_1_2: c.uint,	/* 10-bit integer */
	ctm: [3][3]c.uint,			/* S3.9 fixed point format */
}
#assert(size_of(SceIftuCscParams) == 0x3C)

SceIftuConvParams :: struct {
	size: c.uint,
	unk04: c.uint,
	csc_params1: ^SceIftuCscParams,
	csc_params2: ^SceIftuCscParams,
	csc_control: c.uint,
	unk14: c.uint,
	unk18: c.uint,
	unk1C: c.uint,
	alpha: c.uint,
	unk24: c.uint,
}

SceIftuFrameBuf :: struct {
	pixelformat: c.uint,
	width: c.uint,		/* Aligned to 16 */
	height: c.uint,		/* Aligned to 8 */
	leftover_stride: c.uint,	/* (pitch - aligned_w) * bpp */
	leftover_align: c.uint,	/* if YCbCr: (width >> 1) & 0xF [chroma align?] */
	paddr0: c.uint,		/* Physical address of the first plane */
	paddr1: c.uint,		/* Physical address of the second plane */
	paddr2: c.uint,		/* Physical address of the third plane */
}
#assert(size_of(SceIftuFrameBuf) == 0x20)

SceIftuPlaneState :: struct {
  fb: SceIftuFrameBuf,
	unk20: c.uint,
	src_x: c.uint,		/* In (0x10000 / 960) multiples */
	src_y: c.uint,		/* in (0x10000 / 544) multiples */
	src_w: c.uint,		/* in (0x10000 / 960) multiples */
	src_h: c.uint,		/* in (0x10000 / 544) multiples */
	dst_x: c.uint,
	dst_y: c.uint,
	dst_w: c.uint,
	dst_h: c.uint,
	vtop_padding: c.uint,
	vbot_padding: c.uint,	/* h - aligned_h */
	hleft_padding: c.uint,
	hright_padding: c.uint,	/* w - aligned_w */
}
#assert(size_of(SceIftuPlaneState) == 0x54)

foreign iftu {
	ksceIftuCsc :: proc(dst: ^SceIftuFrameBuf, src: ^SceIftuPlaneState, params: ^SceIftuConvParams) -> c.int ---
}

