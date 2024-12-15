#+build vita
package vita

import "core:c"

foreign import gxm "system:SceGxm_stub"

// Error Codes
SceGxmErrorCode :: enum c.uint {
	UNINITIALIZED                                 = 0x805B0000,
	ALREADY_INITIALIZED                           = 0x805B0001,
	OUT_OF_MEMORY                                 = 0x805B0002,
	INVALID_VALUE                                 = 0x805B0003,
	INVALID_POINTER                               = 0x805B0004,
	INVALID_ALIGNMENT                             = 0x805B0005,
	NOT_WITHIN_SCENE                              = 0x805B0006,
	WITHIN_SCENE                                  = 0x805B0007,
	NULL_PROGRAM                                  = 0x805B0008,
	UNSUPPORTED                                   = 0x805B0009,
	PATCHER_INTERNAL                              = 0x805B000A,
	RESERVE_FAILED                                = 0x805B000B,
	PROGRAM_IN_USE                                = 0x805B000C,
	INVALID_INDEX_COUNT                           = 0x805B000D,
	INVALID_POLYGON_MODE                          = 0x805B000E,
	INVALID_SAMPLER_RESULT_TYPE_PRECISION         = 0x805B000F,
	INVALID_SAMPLER_RESULT_TYPE_COMPONENT_COUNT   = 0x805B0010,
	UNIFORM_BUFFER_NOT_RESERVED                   = 0x805B0011,
	INVALID_AUXILIARY_SURFACE                     = 0x805B0013,
	INVALID_PRECOMPUTED_DRAW                      = 0x805B0014,
	INVALID_PRECOMPUTED_VERTEX_STATE              = 0x805B0015,
	INVALID_PRECOMPUTED_FRAGMENT_STATE            = 0x805B0016,
	DRIVER                                        = 0x805B0017,
	INVALID_TEXTURE                               = 0x805B0018,
	INVALID_TEXTURE_DATA_POINTER                  = 0x805B0019,
	INVALID_TEXTURE_PALETTE_POINTER               = 0x805B001A,
	OUT_OF_RENDER_TARGETS                         = 0x805B0027
}

SceGxmDisplayQueueCallback :: #type proc(callbackData: rawptr)

SceGxmInitializeParams :: struct {
  flags: c.uint,
	displayQueueMaxPendingCount: c.uint,
	displayQueueCallback: ^SceGxmDisplayQueueCallback,
	displayQueueCallbackDataSize: c.uint,
	parameterBufferSize: SceSize,
}

SceGxmMemoryAttribFlags :: enum c.int {
	READ  = 1,
	WRITE = 2,
	RW    = (READ | WRITE)
}

SceGxmAttributeFormat :: enum c.int {
	U8,
	S8,
	U16,
	S16,
	U8N,
	S8N,
	U16N,
	S16N,
	F16,
	F32,
	UNTYPED
}

SceGxmDepthStencilFormat :: enum c.uint {
	DF32     = 0x00044000,
	S8       = 0x00022000,
	DF32_S8  = 0x00066000,
	DF32M    = 0x000CC000,
	DF32M_S8 = 0x000EE000,
	S8D24    = 0x01266000,
	D16      = 0x02444000,
}

SceGxmPrimitiveType :: enum c.uint {
	TRIANGLES       = 0x00000000,
	LINES           = 0x04000000,
	POINTS          = 0x08000000,
	TRIANGLE_STRIP  = 0x0C000000,
	TRIANGLE_FAN    = 0x10000000,
	TRIANGLE_EDGES  = 0x14000000,
}

SceGxmEdgeEnableFlags :: enum c.uint {
	EDGE_ENABLE_01  = 0x00000100,
	EDGE_ENABLE_12  = 0x00000200,
	EDGE_ENABLE_20  = 0x00000400,
}

SceGxmRegionClipMode :: enum c.uint {
	NONE    = 0x00000000,
	ALL     = 0x40000000,
	OUTSIDE = 0x80000000,
	INSIDE  = 0xC0000000,
}

SceGxmDepthFunc :: enum c.uint {
	NEVER          = 0x00000000,
	LESS           = 0x00400000,
	EQUAL          = 0x00800000,
	LESS_EQUAL     = 0x00C00000,
	GREATER        = 0x01000000,
	NOT_EQUAL      = 0x01400000,
	GREATER_EQUAL  = 0x01800000,
	ALWAYS         = 0x01C00000,
}

SceGxmStencilFunc :: enum c.uint {
	NEVER          = 0x00000000,
	LESS           = 0x02000000,
	EQUAL          = 0x04000000,
	LESS_EQUAL     = 0x06000000,
	GREATER        = 0x08000000,
	NOT_EQUAL      = 0x0A000000,
	GREATER_EQUAL  = 0x0C000000,
	ALWAYS         = 0x0E000000,
}

SceGxmStencilOp :: enum c.uint {
	KEEP      = 0x00000000,
	ZERO      = 0x00000001,
	REPLACE   = 0x00000002,
	INCR      = 0x00000003,
	DECR      = 0x00000004,
	INVERT    = 0x00000005,
	INCR_WRAP = 0x00000006,
	DECR_WRAP = 0x00000007,
}

SceGxmCullMode :: enum c.uint {
	NONE = 0x00000000,
	CW   = 0x00000001,
	CCW  = 0x00000002,
}

SceGxmPassType :: enum c.uint {
	OPAQUE        = 0x00000000,
	TRANSLUCENT   = 0x02000000,
	DISCARD       = 0x04000000,
	MASK_UPDATE   = 0x06000000,
	DEPTH_REPLACE = 0x0A000000,
}

SceGxmPolygonMode :: enum c.uint {
	TRIANGLE_FILL  = 0x00000000,
	LINE           = 0x00008000,
	POINT_10UV     = 0x00010000,
	POINT          = 0x00018000,
	POINT_01UV     = 0x00020000,
	TRIANGLE_LINE  = 0x00028000,
	TRIANGLE_POINT = 0x00030000,
}

SceGxmColorSwizzle4Mode :: enum c.uint {
	ABGR	= 0x00000000,
	ARGB	= 0x00100000,
	RGBA	= 0x00200000,
	BGRA	= 0x00300000,
}

SceGxmColorSwizzle3Mode :: enum c.uint {
	BGR = 0x00000000,
	RGB = 0x00100000,
}

SceGxmColorSwizzle2Mode :: enum c.uint {
	GR = 0x00000000,
	RG = 0x00100000,
	RA = 0x00200000,
	AR = 0x00300000,
}

SceGxmColorSwizzle1Mode :: enum c.uint {
	R = 0x00000000,
	G = 0x00100000,
	A = 0x00100000,
}

SceGxmColorBaseFormat :: enum c.uint {
	U8U8U8U8     = 0x00000000,
	U8U8U8       = 0x10000000,
	U5U6U5       = 0x30000000,
	U1U5U5U5     = 0x40000000,
	U4U4U4U4     = 0x50000000,
	U8U3U3U2     = 0x60000000,
	F16          = 0xF0000000,
	F16F16       = 0x00800000,
	F32          = 0x10800000,
	S16          = 0x20800000,
	S16S16       = 0x30800000,
	U16          = 0x40800000,
	U16U16       = 0x50800000,
	U2U10U10U10  = 0x60800000,
	U8           = 0x80800000,
	S8           = 0x90800000,
	S5S5U6       = 0xA0800000,
	U8U8         = 0xB0800000,
	S8S8         = 0xC0800000,
	U8S8S8U8     = 0xD0800000,
	S8S8S8S8     = 0xE0800000,
	F16F16F16F16 = 0x01000000,
	F32F32       = 0x11000000,
	F11F11F10    = 0x21000000,
	SE5M9M9M9    = 0x31000000,
	U2F10F10F10  = 0x41000000,
}

//! Supported color formats
SceGxmColorFormat :: enum c.uint {
	U8U8U8U8_ABGR = c.uint(SceGxmColorBaseFormat.U8U8U8U8) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	U8U8U8U8_ARGB = c.uint(SceGxmColorBaseFormat.U8U8U8U8) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	U8U8U8U8_RGBA = c.uint(SceGxmColorBaseFormat.U8U8U8U8) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	U8U8U8U8_BGRA = c.uint(SceGxmColorBaseFormat.U8U8U8U8) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	U8U8U8_BGR = c.uint(SceGxmColorBaseFormat.U8U8U8) | c.uint(SceGxmColorSwizzle3Mode.BGR),
	U8U8U8_RGB = c.uint(SceGxmColorBaseFormat.U8U8U8) | c.uint(SceGxmColorSwizzle3Mode.RGB),

	U5U6U5_BGR = c.uint(SceGxmColorBaseFormat.U5U6U5) | c.uint(SceGxmColorSwizzle3Mode.BGR),
	U5U6U5_RGB = c.uint(SceGxmColorBaseFormat.U5U6U5) | c.uint(SceGxmColorSwizzle3Mode.RGB),

	U1U5U5U5_ABGR = c.uint(SceGxmColorBaseFormat.U1U5U5U5) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	U1U5U5U5_ARGB = c.uint(SceGxmColorBaseFormat.U1U5U5U5) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	U5U5U5U1_RGBA = c.uint(SceGxmColorBaseFormat.U1U5U5U5) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	U5U5U5U1_BGRA = c.uint(SceGxmColorBaseFormat.U1U5U5U5) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	U4U4U4U4_ABGR = c.uint(SceGxmColorBaseFormat.U4U4U4U4) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	U4U4U4U4_ARGB = c.uint(SceGxmColorBaseFormat.U4U4U4U4) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	U4U4U4U4_RGBA = c.uint(SceGxmColorBaseFormat.U4U4U4U4) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	U4U4U4U4_BGRA = c.uint(SceGxmColorBaseFormat.U4U4U4U4) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	U8U3U3U2_ARGB = c.uint(c.uint(SceGxmColorBaseFormat.U8U3U3U2)),

	F16_R = c.uint(SceGxmColorBaseFormat.F16) | c.uint(SceGxmColorSwizzle1Mode.R),
	F16_G = c.uint(SceGxmColorBaseFormat.F16) | c.uint(SceGxmColorSwizzle1Mode.G),

	F16F16_GR = c.uint(SceGxmColorBaseFormat.F16F16) | c.uint(SceGxmColorSwizzle2Mode.GR),
	F16F16_RG = c.uint(SceGxmColorBaseFormat.F16F16) | c.uint(SceGxmColorSwizzle2Mode.RG),

	F32_R = c.uint(SceGxmColorBaseFormat.F32) | c.uint(SceGxmColorSwizzle1Mode.R),

	S16_R = c.uint(SceGxmColorBaseFormat.S16) | c.uint(SceGxmColorSwizzle1Mode.R),
	S16_G = c.uint(SceGxmColorBaseFormat.S16) | c.uint(SceGxmColorSwizzle1Mode.G),

	S16S16_GR = c.uint(SceGxmColorBaseFormat.S16S16) | c.uint(SceGxmColorSwizzle2Mode.GR),
	S16S16_RG = c.uint(SceGxmColorBaseFormat.S16S16) | c.uint(SceGxmColorSwizzle2Mode.RG),

	U16_R = c.uint(SceGxmColorBaseFormat.U16) | c.uint(SceGxmColorSwizzle1Mode.R),
	U16_G = c.uint(SceGxmColorBaseFormat.U16) | c.uint(SceGxmColorSwizzle1Mode.G),

	U16U16_GR = c.uint(SceGxmColorBaseFormat.U16U16) | c.uint(SceGxmColorSwizzle2Mode.GR),
	U16U16_RG = c.uint(SceGxmColorBaseFormat.U16U16) | c.uint(SceGxmColorSwizzle2Mode.RG),

	U2U10U10U10_ABGR = c.uint(SceGxmColorBaseFormat.U2U10U10U10) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	U2U10U10U10_ARGB = c.uint(SceGxmColorBaseFormat.U2U10U10U10) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	U10U10U10U2_RGBA = c.uint(SceGxmColorBaseFormat.U2U10U10U10) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	U10U10U10U2_BGRA = c.uint(SceGxmColorBaseFormat.U2U10U10U10) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	U8_R = c.uint(SceGxmColorBaseFormat.U8) | c.uint(SceGxmColorSwizzle1Mode.R),
	U8_A = c.uint(SceGxmColorBaseFormat.U8) | c.uint(SceGxmColorSwizzle1Mode.A),

	S8_R = c.uint(SceGxmColorBaseFormat.S8) | c.uint(SceGxmColorSwizzle1Mode.R),
	S8_A = c.uint(SceGxmColorBaseFormat.S8) | c.uint(SceGxmColorSwizzle1Mode.A),

	U6S5S5_BGR = c.uint(SceGxmColorBaseFormat.S5S5U6) | c.uint(SceGxmColorSwizzle3Mode.BGR),
	S5S5U6_RGB = c.uint(SceGxmColorBaseFormat.S5S5U6) | c.uint(SceGxmColorSwizzle3Mode.RGB),

	U8U8_GR = c.uint(SceGxmColorBaseFormat.U8U8) | c.uint(SceGxmColorSwizzle2Mode.GR),
	U8U8_RG = c.uint(SceGxmColorBaseFormat.U8U8) | c.uint(SceGxmColorSwizzle2Mode.RG),
	U8U8_RA = c.uint(SceGxmColorBaseFormat.U8U8) | c.uint(SceGxmColorSwizzle2Mode.RA),
	U8U8_AR = c.uint(SceGxmColorBaseFormat.U8U8) | c.uint(SceGxmColorSwizzle2Mode.AR),

	S8S8_GR = c.uint(SceGxmColorBaseFormat.S8S8) | c.uint(SceGxmColorSwizzle2Mode.GR),
	S8S8_RG = c.uint(SceGxmColorBaseFormat.S8S8) | c.uint(SceGxmColorSwizzle2Mode.RG),
	S8S8_RA = c.uint(SceGxmColorBaseFormat.S8S8) | c.uint(SceGxmColorSwizzle2Mode.RA),
	S8S8_AR = c.uint(SceGxmColorBaseFormat.S8S8) | c.uint(SceGxmColorSwizzle2Mode.AR),

	U8S8S8U8_ABGR = c.uint(SceGxmColorBaseFormat.U8S8S8U8) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	U8U8S8S8_ARGB = c.uint(SceGxmColorBaseFormat.U8S8S8U8) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	U8S8S8U8_RGBA = c.uint(SceGxmColorBaseFormat.U8S8S8U8) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	S8S8U8U8_BGRA = c.uint(SceGxmColorBaseFormat.U8S8S8U8) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	S8S8S8S8_ABGR = c.uint(SceGxmColorBaseFormat.S8S8S8S8) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	S8S8S8S8_ARGB = c.uint(SceGxmColorBaseFormat.S8S8S8S8) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	S8S8S8S8_RGBA = c.uint(SceGxmColorBaseFormat.S8S8S8S8) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	S8S8S8S8_BGRA = c.uint(SceGxmColorBaseFormat.S8S8S8S8) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	F16F16F16F16_ABGR = c.uint(SceGxmColorBaseFormat.F16F16F16F16) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	F16F16F16F16_ARGB = c.uint(SceGxmColorBaseFormat.F16F16F16F16) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	F16F16F16F16_RGBA = c.uint(SceGxmColorBaseFormat.F16F16F16F16) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	F16F16F16F16_BGRA = c.uint(SceGxmColorBaseFormat.F16F16F16F16) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	F32F32_GR = c.uint(SceGxmColorBaseFormat.F32F32) | c.uint(SceGxmColorSwizzle2Mode.GR),
	F32F32_RG = c.uint(SceGxmColorBaseFormat.F32F32) | c.uint(SceGxmColorSwizzle2Mode.RG),

	F10F11F11_BGR = c.uint(SceGxmColorBaseFormat.F11F11F10) | c.uint(SceGxmColorSwizzle3Mode.BGR),
	F11F11F10_RGB = c.uint(SceGxmColorBaseFormat.F11F11F10) | c.uint(SceGxmColorSwizzle3Mode.RGB),

	SE5M9M9M9_BGR = c.uint(SceGxmColorBaseFormat.SE5M9M9M9) | c.uint(SceGxmColorSwizzle3Mode.BGR),
	SE5M9M9M9_RGB = c.uint(SceGxmColorBaseFormat.SE5M9M9M9) | c.uint(SceGxmColorSwizzle3Mode.RGB),

	U2F10F10F10_ABGR = c.uint(SceGxmColorBaseFormat.U2F10F10F10) | c.uint(SceGxmColorSwizzle4Mode.ABGR),
	U2F10F10F10_ARGB = c.uint(SceGxmColorBaseFormat.U2F10F10F10) | c.uint(SceGxmColorSwizzle4Mode.ARGB),
	F10F10F10U2_RGBA = c.uint(SceGxmColorBaseFormat.U2F10F10F10) | c.uint(SceGxmColorSwizzle4Mode.RGBA),
	F10F10F10U2_BGRA = c.uint(SceGxmColorBaseFormat.U2F10F10F10) | c.uint(SceGxmColorSwizzle4Mode.BGRA),

	// Legacy formats

	A8B8G8R8 = U8U8U8U8_ABGR,
	A8R8G8B8 = U8U8U8U8_ARGB,
	R5G6B5   = U5U6U5_RGB,
	A1R5G5B5 = U1U5U5U5_ARGB,
	A4R4G4B4 = U4U4U4U4_ARGB,
	A8 = U8_A,
}

SceGxmColorSurfaceType :: enum c.uint {
	LINEAR    = 0x00000000,
	TILED     = 0x04000000,
	SWIZZLED  = 0x08000000,
}

SceGxmColorSurfaceGammaMode :: enum c.uint {
	NONE = 0x00000000,
	R    = 0x00001000,
	GR   = 0x00003000,
	BGR  = 0x00001000,
}

SceGxmColorSurfaceDitherMode :: enum c.uint {
	DISABLED   = 0x00000000,
	ENABLED    = 0x00000008,
}

SceGxmDepthStencilSurfaceType :: enum c.uint {
	LINEAR  = 0x00000000,
	TILED   = 0x00011000,
}

SceGxmOutputRegisterFormat :: enum c.int {
	DECLARED,
	UCHAR4,
	CHAR4,
	USHORT2,
	SHORT2,
	HALF4,
	HALF2,
	FLOAT2,
	FLOAT,
}

SceGxmMultisampleMode :: enum c.int {
	MULTISAMPLE_NONE,
	MULTISAMPLE_2X,
	MULTISAMPLE_4X
}

SceGxmTextureSwizzle4Mode :: enum c.uint {
	SWIZZLE4_ABGR   = 0x00000000,
	SWIZZLE4_ARGB   = 0x00001000,
	SWIZZLE4_RGBA   = 0x00002000,
	SWIZZLE4_BGRA   = 0x00003000,
	SWIZZLE4_1BGR   = 0x00004000,
	SWIZZLE4_1RGB   = 0x00005000,
	SWIZZLE4_RGB1   = 0x00006000,
	SWIZZLE4_BGR1   = 0x00007000,
}

SceGxmTextureSwizzle3Mode :: enum c.uint {
	BGR   = 0x00000000,
	RGB   = 0x00001000,
}

SceGxmTextureSwizzle2Mode :: enum c.uint {
	SWIZZLE2_GR     = 0x00000000,
	SWIZZLE2_00GR   = 0x00001000,
	SWIZZLE2_GRRR   = 0x00002000,
	SWIZZLE2_RGGG   = 0x00003000,
	SWIZZLE2_GRGR   = 0x00004000,
	SWIZZLE2_00RG   = 0x00005000,
}

SceGxmTextureSwizzle2ModeAlt :: enum c.uint {
	SD = 0x00000000,
	DS = 0x00001000,
}

SceGxmTextureSwizzle1Mode :: enum c.uint {
	SWIZZLE1_R    = 0x00000000,
	SWIZZLE1_000R = 0x00001000,
	SWIZZLE1_111R = 0x00002000,
	SWIZZLE1_RRRR = 0x00003000,
	SWIZZLE1_0RRR = 0x00004000,
	SWIZZLE1_1RRR = 0x00005000,
	SWIZZLE1_R000 = 0x00006000,
	SWIZZLE1_R111 = 0x00007000,
}

SceGxmTextureSwizzleYUV422Mode :: enum c.uint {
	YUYV_CSC0 = 0x00000000,
	YVYU_CSC0 = 0x00001000,
	UYVY_CSC0 = 0x00002000,
	VYUY_CSC0 = 0x00003000,
	YUYV_CSC1 = 0x00004000,
	YVYU_CSC1 = 0x00005000,
	UYVY_CSC1 = 0x00006000,
	VYUY_CSC1 = 0x00007000,
}

SceGxmTextureSwizzleYUV420Mode :: enum c.uint {
	YUV_CSC0 = 0x00000000,
	YVU_CSC0 = 0x00001000,
	YUV_CSC1 = 0x00002000,
	YVU_CSC1 = 0x00003000,
}

SceGxmTextureBaseFormat :: enum c.uint {
	U8           = 0x00000000,
	S8           = 0x01000000,
	U4U4U4U4     = 0x02000000,
	U8U3U3U2     = 0x03000000,
	U1U5U5U5     = 0x04000000,
	U5U6U5       = 0x05000000,
	S5S5U6       = 0x06000000,
	U8U8         = 0x07000000,
	S8S8         = 0x08000000,
	U16          = 0x09000000,
	S16          = 0x0A000000,
	F16          = 0x0B000000,
	U8U8U8U8     = 0x0C000000,
	S8S8S8S8     = 0x0D000000,
	U2U10U10U10  = 0x0E000000,
	U16U16       = 0x0F000000,
	S16S16       = 0x10000000,
	F16F16       = 0x11000000,
	F32          = 0x12000000,
	F32M         = 0x13000000,
	X8S8S8U8     = 0x14000000,
	X8U24        = 0x15000000,
	U32          = 0x17000000,
	S32          = 0x18000000,
	SE5M9M9M9    = 0x19000000,
	F11F11F10    = 0x1A000000,
	F16F16F16F16 = 0x1B000000,
	U16U16U16U16 = 0x1C000000,
	S16S16S16S16 = 0x1D000000,
	F32F32       = 0x1E000000,
	U32U32       = 0x1F000000,
	PVRT2BPP     = 0x80000000,
	PVRT4BPP     = 0x81000000,
	PVRTII2BPP   = 0x82000000,
	PVRTII4BPP   = 0x83000000,
	UBC1         = 0x85000000,
	UBC2         = 0x86000000,
	UBC3         = 0x87000000,
	UBC4         = 0x88000000,
	SBC4         = 0x89000000,
	UBC5         = 0x8A000000,
	SBC5         = 0x8B000000,
	YUV420P2     = 0x90000000,
	YUV420P3     = 0x91000000,
	YUV422       = 0x92000000,
	P4           = 0x94000000,
	P8           = 0x95000000,
	U8U8U8       = 0x98000000,
	S8S8S8       = 0x99000000,
	U2F10F10F10  = 0x9A000000,
}

SceGxmTextureFormat :: enum c.uint {
	// Supported formats

	U8_000R = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	U8_111R = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	U8_RRRR = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	U8_0RRR = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	U8_1RRR = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	U8_R000 = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	U8_R111 = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	U8_R    = c.uint(SceGxmTextureBaseFormat.U8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	S8_000R = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	S8_111R = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	S8_RRRR = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	S8_0RRR = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	S8_1RRR = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	S8_R000 = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	S8_R111 = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	S8_R    = c.uint(SceGxmTextureBaseFormat.S8) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	U4U4U4U4_ABGR = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	U4U4U4U4_ARGB = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	U4U4U4U4_RGBA = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	U4U4U4U4_BGRA = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X4U4U4U4_1BGR = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X4U4U4U4_1RGB = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	U4U4U4X4_RGB1 = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	U4U4U4X4_BGR1 = c.uint(SceGxmTextureBaseFormat.U4U4U4U4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	U8U3U3U2_ARGB = c.uint(SceGxmTextureBaseFormat.U8U3U3U2),

	U1U5U5U5_ABGR = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	U1U5U5U5_ARGB = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	U5U5U5U1_RGBA = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	U5U5U5U1_BGRA = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X1U5U5U5_1BGR = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X1U5U5U5_1RGB = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	U5U5U5X1_RGB1 = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	U5U5U5X1_BGR1 = c.uint(SceGxmTextureBaseFormat.U1U5U5U5) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	U5U6U5_BGR = c.uint(SceGxmTextureBaseFormat.U5U6U5) | c.uint(SceGxmTextureSwizzle3Mode.BGR),
	U5U6U5_RGB = c.uint(SceGxmTextureBaseFormat.U5U6U5) | c.uint(SceGxmTextureSwizzle3Mode.RGB),

	U6S5S5_BGR = c.uint(SceGxmTextureBaseFormat.S5S5U6) | c.uint(SceGxmTextureSwizzle3Mode.BGR),
	S5S5U6_RGB = c.uint(SceGxmTextureBaseFormat.S5S5U6) | c.uint(SceGxmTextureSwizzle3Mode.RGB),

	U8U8_00GR = c.uint(SceGxmTextureBaseFormat.U8U8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	U8U8_GRRR = c.uint(SceGxmTextureBaseFormat.U8U8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	U8U8_RGGG = c.uint(SceGxmTextureBaseFormat.U8U8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	U8U8_GRGR = c.uint(SceGxmTextureBaseFormat.U8U8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	U8U8_00RG = c.uint(SceGxmTextureBaseFormat.U8U8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	U8U8_GR   = c.uint(SceGxmTextureBaseFormat.U8U8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	S8S8_00GR = c.uint(SceGxmTextureBaseFormat.S8S8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	S8S8_GRRR = c.uint(SceGxmTextureBaseFormat.S8S8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	S8S8_RGGG = c.uint(SceGxmTextureBaseFormat.S8S8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	S8S8_GRGR = c.uint(SceGxmTextureBaseFormat.S8S8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	S8S8_00RG = c.uint(SceGxmTextureBaseFormat.S8S8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	S8S8_GR   = c.uint(SceGxmTextureBaseFormat.S8S8) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	U16_000R = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	U16_111R = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	U16_RRRR = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	U16_0RRR = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	U16_1RRR = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	U16_R000 = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	U16_R111 = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	U16_R    = c.uint(SceGxmTextureBaseFormat.U16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	S16_000R = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	S16_111R = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	S16_RRRR = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	S16_0RRR = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	S16_1RRR = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	S16_R000 = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	S16_R111 = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	S16_R    = c.uint(SceGxmTextureBaseFormat.S16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	F16_000R = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	F16_111R = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	F16_RRRR = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	F16_0RRR = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	F16_1RRR = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	F16_R000 = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	F16_R111 = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	F16_R    = c.uint(SceGxmTextureBaseFormat.F16) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	U8U8U8U8_ABGR = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	U8U8U8U8_ARGB = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	U8U8U8U8_RGBA = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	U8U8U8U8_BGRA = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X8U8U8U8_1BGR = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X8U8U8U8_1RGB = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	U8U8U8X8_RGB1 = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	U8U8U8X8_BGR1 = c.uint(SceGxmTextureBaseFormat.U8U8U8U8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	S8S8S8S8_ABGR = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	S8S8S8S8_ARGB = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	S8S8S8S8_RGBA = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	S8S8S8S8_BGRA = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X8S8S8S8_1BGR = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X8S8S8S8_1RGB = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	S8S8S8X8_RGB1 = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	S8S8S8X8_BGR1 = c.uint(SceGxmTextureBaseFormat.S8S8S8S8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	U2U10U10U10_ABGR = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	U2U10U10U10_ARGB = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	U10U10U10U2_RGBA = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	U10U10U10U2_BGRA = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X2U10U10U10_1BGR = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X2U10U10U10_1RGB = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	U10U10U10X2_RGB1 = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	U10U10U10X2_BGR1 = c.uint(SceGxmTextureBaseFormat.U2U10U10U10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	U16U16_00GR = c.uint(SceGxmTextureBaseFormat.U16U16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	U16U16_GRRR = c.uint(SceGxmTextureBaseFormat.U16U16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	U16U16_RGGG = c.uint(SceGxmTextureBaseFormat.U16U16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	U16U16_GRGR = c.uint(SceGxmTextureBaseFormat.U16U16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	U16U16_00RG = c.uint(SceGxmTextureBaseFormat.U16U16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	U16U16_GR   = c.uint(SceGxmTextureBaseFormat.U16U16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	S16S16_00GR = c.uint(SceGxmTextureBaseFormat.S16S16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	S16S16_GRRR = c.uint(SceGxmTextureBaseFormat.S16S16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	S16S16_RGGG = c.uint(SceGxmTextureBaseFormat.S16S16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	S16S16_GRGR = c.uint(SceGxmTextureBaseFormat.S16S16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	S16S16_00RG = c.uint(SceGxmTextureBaseFormat.S16S16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	S16S16_GR   = c.uint(SceGxmTextureBaseFormat.S16S16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	F16F16_00GR = c.uint(SceGxmTextureBaseFormat.F16F16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	F16F16_GRRR = c.uint(SceGxmTextureBaseFormat.F16F16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	F16F16_RGGG = c.uint(SceGxmTextureBaseFormat.F16F16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	F16F16_GRGR = c.uint(SceGxmTextureBaseFormat.F16F16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	F16F16_00RG = c.uint(SceGxmTextureBaseFormat.F16F16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	F16F16_GR   = c.uint(SceGxmTextureBaseFormat.F16F16) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	F32_000R = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	F32_111R = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	F32_RRRR = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	F32_0RRR = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	F32_1RRR = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	F32_R000 = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	F32_R111 = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	F32_R    = c.uint(SceGxmTextureBaseFormat.F32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	F32M_000R = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	F32M_111R = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	F32M_RRRR = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	F32M_0RRR = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	F32M_1RRR = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	F32M_R000 = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	F32M_R111 = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	F32M_R    = c.uint(SceGxmTextureBaseFormat.F32M) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	X8S8S8U8_1BGR = c.uint(SceGxmTextureBaseFormat.X8S8S8U8) | c.uint(SceGxmTextureSwizzle3Mode.BGR),
	X8U8S8S8_1RGB = c.uint(SceGxmTextureBaseFormat.X8S8S8U8) | c.uint(SceGxmTextureSwizzle3Mode.RGB),

	X8U24_SD = c.uint(SceGxmTextureBaseFormat.X8U24) | c.uint(SceGxmTextureSwizzle2ModeAlt.SD),
	U24X8_DS = c.uint(SceGxmTextureBaseFormat.X8U24) | c.uint(SceGxmTextureSwizzle2ModeAlt.DS),

	U32_000R = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	U32_111R = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	U32_RRRR = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	U32_0RRR = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	U32_1RRR = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	U32_R000 = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	U32_R111 = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	U32_R    = c.uint(SceGxmTextureBaseFormat.U32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	S32_000R = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	S32_111R = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	S32_RRRR = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	S32_0RRR = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	S32_1RRR = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	S32_R000 = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	S32_R111 = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	S32_R    = c.uint(SceGxmTextureBaseFormat.S32) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	SE5M9M9M9_BGR = c.uint(SceGxmTextureBaseFormat.SE5M9M9M9) | c.uint(SceGxmTextureSwizzle3Mode.BGR),
	SE5M9M9M9_RGB = c.uint(SceGxmTextureBaseFormat.SE5M9M9M9) | c.uint(SceGxmTextureSwizzle3Mode.RGB),

	F10F11F11_BGR = c.uint(SceGxmTextureBaseFormat.F11F11F10) | c.uint(SceGxmTextureSwizzle3Mode.BGR),
	F11F11F10_RGB = c.uint(SceGxmTextureBaseFormat.F11F11F10) | c.uint(SceGxmTextureSwizzle3Mode.RGB),

	F16F16F16F16_ABGR = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	F16F16F16F16_ARGB = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	F16F16F16F16_RGBA = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	F16F16F16F16_BGRA = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X16F16F16F16_1BGR = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X16F16F16F16_1RGB = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	F16F16F16X16_RGB1 = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	F16F16F16X16_BGR1 = c.uint(SceGxmTextureBaseFormat.F16F16F16F16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	U16U16U16U16_ABGR = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	U16U16U16U16_ARGB = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	U16U16U16U16_RGBA = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	U16U16U16U16_BGRA = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X16U16U16U16_1BGR = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X16U16U16U16_1RGB = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	U16U16U16X16_RGB1 = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	U16U16U16X16_BGR1 = c.uint(SceGxmTextureBaseFormat.U16U16U16U16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	S16S16S16S16_ABGR = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	S16S16S16S16_ARGB = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	S16S16S16S16_RGBA = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	S16S16S16S16_BGRA = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X16S16S16S16_1BGR = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X16S16S16S16_1RGB = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	S16S16S16X16_RGB1 = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	S16S16S16X16_BGR1 = c.uint(SceGxmTextureBaseFormat.S16S16S16S16) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	F32F32_00GR = c.uint(SceGxmTextureBaseFormat.F32F32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	F32F32_GRRR = c.uint(SceGxmTextureBaseFormat.F32F32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	F32F32_RGGG = c.uint(SceGxmTextureBaseFormat.F32F32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	F32F32_GRGR = c.uint(SceGxmTextureBaseFormat.F32F32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	F32F32_00RG = c.uint(SceGxmTextureBaseFormat.F32F32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	F32F32_GR   = c.uint(SceGxmTextureBaseFormat.F32F32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	U32U32_00GR = c.uint(SceGxmTextureBaseFormat.U32U32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	U32U32_GRRR = c.uint(SceGxmTextureBaseFormat.U32U32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	U32U32_RGGG = c.uint(SceGxmTextureBaseFormat.U32U32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	U32U32_GRGR = c.uint(SceGxmTextureBaseFormat.U32U32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	U32U32_00RG = c.uint(SceGxmTextureBaseFormat.U32U32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	U32U32_GR   = c.uint(SceGxmTextureBaseFormat.U32U32) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	PVRT2BPP_ABGR = c.uint(SceGxmTextureBaseFormat.PVRT2BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	PVRT2BPP_1BGR = c.uint(SceGxmTextureBaseFormat.PVRT2BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),

	PVRT4BPP_ABGR = c.uint(SceGxmTextureBaseFormat.PVRT4BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	PVRT4BPP_1BGR = c.uint(SceGxmTextureBaseFormat.PVRT4BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),

	PVRTII2BPP_ABGR = c.uint(SceGxmTextureBaseFormat.PVRTII2BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	PVRTII2BPP_1BGR = c.uint(SceGxmTextureBaseFormat.PVRTII2BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),

	PVRTII4BPP_ABGR = c.uint(SceGxmTextureBaseFormat.PVRTII4BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	PVRTII4BPP_1BGR = c.uint(SceGxmTextureBaseFormat.PVRTII4BPP) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),

	UBC1_ABGR = c.uint(SceGxmTextureBaseFormat.UBC1) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	UBC1_1BGR = c.uint(SceGxmTextureBaseFormat.UBC1) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),

	UBC2_ABGR = c.uint(SceGxmTextureBaseFormat.UBC2) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	UBC2_1BGR = c.uint(SceGxmTextureBaseFormat.UBC2) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),

	UBC3_ABGR = c.uint(SceGxmTextureBaseFormat.UBC3) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	UBC3_1BGR = c.uint(SceGxmTextureBaseFormat.UBC3) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),

	UBC4_000R = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	UBC4_111R = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	UBC4_RRRR = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	UBC4_0RRR = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	UBC4_1RRR = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	UBC4_R000 = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	UBC4_R111 = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	UBC4_R    = c.uint(SceGxmTextureBaseFormat.UBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	SBC4_000R = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_000R),
	SBC4_111R = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_111R),
	SBC4_RRRR = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_RRRR),
	SBC4_0RRR = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_0RRR),
	SBC4_1RRR = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_1RRR),
	SBC4_R000 = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R000),
	SBC4_R111 = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R111),
	SBC4_R    = c.uint(SceGxmTextureBaseFormat.SBC4) | c.uint(SceGxmTextureSwizzle1Mode.SWIZZLE1_R),

	UBC5_00GR = c.uint(SceGxmTextureBaseFormat.UBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	UBC5_GRRR = c.uint(SceGxmTextureBaseFormat.UBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	UBC5_RGGG = c.uint(SceGxmTextureBaseFormat.UBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	UBC5_GRGR = c.uint(SceGxmTextureBaseFormat.UBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	UBC5_00RG = c.uint(SceGxmTextureBaseFormat.UBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	UBC5_GR   = c.uint(SceGxmTextureBaseFormat.UBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	SBC5_00GR = c.uint(SceGxmTextureBaseFormat.SBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00GR),
	SBC5_GRRR = c.uint(SceGxmTextureBaseFormat.SBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRRR),
	SBC5_RGGG = c.uint(SceGxmTextureBaseFormat.SBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_RGGG),
	SBC5_GRGR = c.uint(SceGxmTextureBaseFormat.SBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GRGR),
	SBC5_00RG = c.uint(SceGxmTextureBaseFormat.SBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_00RG),
	SBC5_GR   = c.uint(SceGxmTextureBaseFormat.SBC5) | c.uint(SceGxmTextureSwizzle2Mode.SWIZZLE2_GR),

	YUV420P2_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV420P2) | c.uint(SceGxmTextureSwizzleYUV420Mode.YUV_CSC0),
	YVU420P2_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV420P2) | c.uint(SceGxmTextureSwizzleYUV420Mode.YVU_CSC0),
	YUV420P2_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV420P2) | c.uint(SceGxmTextureSwizzleYUV420Mode.YUV_CSC1),
	YVU420P2_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV420P2) | c.uint(SceGxmTextureSwizzleYUV420Mode.YVU_CSC1),

	YUV420P3_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV420P3) | c.uint(SceGxmTextureSwizzleYUV420Mode.YUV_CSC0),
	YVU420P3_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV420P3) | c.uint(SceGxmTextureSwizzleYUV420Mode.YVU_CSC0),
	YUV420P3_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV420P3) | c.uint(SceGxmTextureSwizzleYUV420Mode.YUV_CSC1),
	YVU420P3_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV420P3) | c.uint(SceGxmTextureSwizzleYUV420Mode.YVU_CSC1),

	YUYV422_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.YUYV_CSC0),
	YVYU422_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.YVYU_CSC0),
	UYVY422_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.UYVY_CSC0),
	VYUY422_CSC0 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.VYUY_CSC0),
	YUYV422_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.YUYV_CSC1),
	YVYU422_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.YVYU_CSC1),
	UYVY422_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.UYVY_CSC1),
	VYUY422_CSC1 = c.uint(SceGxmTextureBaseFormat.YUV422) | c.uint(SceGxmTextureSwizzleYUV422Mode.VYUY_CSC1),

	P4_ABGR = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	P4_ARGB = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	P4_RGBA = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	P4_BGRA = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	P4_1BGR = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	P4_1RGB = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	P4_RGB1 = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	P4_BGR1 = c.uint(SceGxmTextureBaseFormat.P4) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	P8_ABGR = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	P8_ARGB = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	P8_RGBA = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	P8_BGRA = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	P8_1BGR = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	P8_1RGB = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	P8_RGB1 = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	P8_BGR1 = c.uint(SceGxmTextureBaseFormat.P8) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	U8U8U8_BGR = c.uint(SceGxmTextureBaseFormat.U8U8U8) | c.uint(SceGxmTextureSwizzle3Mode.BGR),
	U8U8U8_RGB = c.uint(SceGxmTextureBaseFormat.U8U8U8) | c.uint(SceGxmTextureSwizzle3Mode.RGB),

	S8S8S8_BGR = c.uint(SceGxmTextureBaseFormat.S8S8S8) | c.uint(SceGxmTextureSwizzle3Mode.BGR),
	S8S8S8_RGB = c.uint(SceGxmTextureBaseFormat.S8S8S8) | c.uint(SceGxmTextureSwizzle3Mode.RGB),

	U2F10F10F10_ABGR = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ABGR),
	U2F10F10F10_ARGB = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_ARGB),
	F10F10F10U2_RGBA = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGBA),
	F10F10F10U2_BGRA = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGRA),
	X2F10F10F10_1BGR = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1BGR),
	X2F10F10F10_1RGB = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_1RGB),
	F10F10F10X2_RGB1 = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_RGB1),
	F10F10F10X2_BGR1 = c.uint(SceGxmTextureBaseFormat.U2F10F10F10) | c.uint(SceGxmTextureSwizzle4Mode.SWIZZLE4_BGR1),

	// Legacy formats

	L8 = U8_1RRR,
	A8 = U8_R000,
	R8 = U8_000R,
	A4R4G4B4 = U4U4U4U4_ARGB,
	A1R5G5B5 = U1U5U5U5_ARGB,
	R5G6B5 = U5U6U5_RGB,
	A8L8 = U8U8_GRRR,
	L8A8 = U8U8_RGGG,
	G8R8 = U8U8_00GR,
	L16 = U16_1RRR,
	A16 = U16_R000,
	R16 = U16_000R,
	D16 = U16_R,
	LF16 = F16_1RRR,
	AF16 = F16_R000,
	RF16 = F16_000R,
	A8R8G8B8 = U8U8U8U8_ARGB,
	A8B8G8R8 = U8U8U8U8_ABGR,
	AF16LF16 = F16F16_GRRR,
	LF16AF16 = F16F16_RGGG,
	GF16RF16 = F16F16_00GR,
	LF32M = F32M_1RRR,
	AF32M = F32M_R000,
	RF32M = F32M_000R,
	DF32M = F32M_R,
	VYUY = VYUY422_CSC0,
	YVYU = YVYU422_CSC0,
	UBC1 = UBC1_ABGR,
	UBC2 = UBC2_ABGR,
	UBC3 = UBC3_ABGR,
	PVRT2BPP = PVRT2BPP_ABGR,
	PVRT4BPP = PVRT4BPP_ABGR,
	PVRTII2BPP = PVRTII2BPP_ABGR,
	PVRTII4BPP = PVRTII4BPP_ABGR,
}

SceGxmTextureType :: enum c.uint {
	SWIZZLED             = 0x00000000,
	CUBE                 = 0x40000000,
	LINEAR               = 0x60000000,
	TILED                = 0x80000000,
	SWIZZLED_ARBITRARY   = 0xA0000000,
	LINEAR_STRIDED       = 0xC0000000,
	CUBE_ARBITRARY       = 0xE0000000,
}

SceGxmTextureFilter :: enum c.uint {
	POINT           = 0x00000000,
	LINEAR          = 0x00000001,
	MIPMAP_LINEAR   = 0x00000002,
	MIPMAP_POINT    = 0x00000003,
}

SceGxmTextureMipFilter :: enum c.uint {
	DISABLED = 0x00000000,
	ENABLED  = 0x00000200,
}

SceGxmTextureAddrMode :: enum c.uint {
	REPEAT                 = 0x00000000,
	MIRROR                 = 0x00000001,
	CLAMP                  = 0x00000002,
	MIRROR_CLAMP           = 0x00000003,
	REPEAT_IGNORE_BORDER   = 0x00000004,
	CLAMP_FULL_BORDER      = 0x00000005,
	CLAMP_IGNORE_BORDER    = 0x00000006,
	CLAMP_HALF_BORDER      = 0x00000007,
}

SceGxmTextureGammaMode :: enum c.uint {
	NONE  = 0x00000000,
	R     = 0x08000000,
	GR    = 0x18000000,
	BGR   = 0x08000000,
}

SceGxmTextureNormalizeMode :: enum c.uint {
	DISABLED = 0x00000000,
	ENABLED  = 0x80000000,
}

SceGxmIndexFormat :: enum c.uint {
	U16   = 0x00000000,
	U32   = 0x01000000,
}

SceGxmIndexSource :: enum c.uint {
	INDEX_16BIT    = 0x00000000,
	INDEX_32BIT    = 0x00000001,
	INSTANCE_16BIT = 0x00000002,
	INSTANCE_32BIT = 0x00000003,
}

SceGxmFragmentProgramMode :: enum c.uint {
	DISABLED   = 0x00200000,
	ENABLED    = 0x00000000,
}

SceGxmDepthWriteMode :: enum c.uint {
	DISABLED = 0x00100000,
	ENABLED  = 0x00000000,
}

SceGxmLineFillLastPixelMode :: enum c.uint {
	DISABLED = 0x00000000,
	ENABLED  = 0x00080000,
}

SceGxmTwoSidedMode :: enum c.uint {
	DISABLED  = 0x00000000,
	ENABLED   = 0x00000800,
}

SceGxmWClampMode :: enum c.uint {
	DISABLED  = 0x00000000,
	ENABLED   = 0x00008000,
}

SceGxmViewportMode :: enum c.uint {
	DISABLED   = 0x00010000,
	ENABLED    = 0x00000000,
}

SceGxmWBufferMode :: enum c.uint {
	DISABLED  = 0x00000000,
	ENABLED   = 0x00004000,
}

SceGxmDepthStencilForceLoadMode :: enum c.uint {
	DISABLED = 0x00000000,
	ENABLED  = 0x00000002,
}

SceGxmDepthStencilForceStoreMode :: enum c.uint {
	DISABLED = 0x00000000,
	ENABLED  = 0x00000004,
}

SceGxmSceneFlags :: enum c.uint {
	FRAGMENT_SET_DEPENDENCY     = 0x00000001,
	VERTEX_WAIT_FOR_DEPENDENCY  = 0x00000002,
	FRAGMENT_TRANSFER_SYNC       = 0x00000004,
	VERTEX_TRANSFER_SYNC         = 0x00000008,
}

SceGxmMidSceneFlags :: enum c.uint {
	PRESERVE_DEFAULT_UNIFORM_BUFFERS = 0x00000001,
}

SceGxmColorSurfaceScaleMode :: enum c.uint {
	NONE           = 0x00000000,
	MSAA_DOWNSCALE = 0x00000001,
}

SceGxmOutputRegisterSize :: enum c.uint {
	REGISTER_SIZE_32BIT = 0x00000000,
	REGISTER_SIZE_64BIT = 0x00000001,
}

SceGxmVisibilityTestMode :: enum c.uint {
	DISABLED = 0x00000000,
	ENABLED  = 0x00004000,
}

SceGxmVisibilityTestOp :: enum c.uint {
	INCREMENT = 0x00000000,
	SET       = 0x00040000,
}

SceGxmYuvProfile :: enum c.int {
	BT601_STANDARD,
	BT709_STANDARD,
	BT601_FULL_RANGE,
	BT709_FULL_RANGE,
}

SceGxmBlendFunc :: enum c.int {
	NONE,
	ADD,
	SUBTRACT,
	REVERSE_SUBTRACT,
	MIN,
	MAX
}

SceGxmBlendFactor :: enum c.int {
	ZERO,
	ONE,
	SRC_COLOR,
	ONE_MINUS_SRC_COLOR,
	SRC_ALPHA,
	ONE_MINUS_SRC_ALPHA,
	DST_COLOR,
	ONE_MINUS_DST_COLOR,
	DST_ALPHA,
	ONE_MINUS_DST_ALPHA,
	SRC_ALPHA_SATURATE,
	DST_ALPHA_SATURATE
}

SceGxmColorMask :: enum c.int {
	NONE = 0,
	A    = (1 << 0),
	R    = (1 << 1),
	G    = (1 << 2),
	B    = (1 << 3),
	ALL  = (A | B | G | R)
}

SceGxmTransferFormat :: enum c.uint {
	U8_R			= 0x00000000,
	U4U4U4U4_ABGR		= 0x00010000,
	U1U5U5U5_ABGR		= 0x00020000,
	U5U6U5_BGR		= 0x00030000,
	U8U8_GR			= 0x00040000,
	U8U8U8_BGR		= 0x00050000,
	U8U8U8U8_ABGR		= 0x00060000,
	VYUY422			= 0x00070000,
	YVYU422			= 0x00080000,
	UYVY422			= 0x00090000,
	YUYV422			= 0x000a0000,
	U2U10U10U10_ABGR	= 0x000d0000,
	RAW16			= 0x000f0000,
	RAW32			= 0x00110000,
	RAW64			= 0x00120000,
	RAW128			= 0x00130000,
}

SceGxmTransferFlags :: enum c.uint {
	FRAGMENT_SYNC	= 0x00000001,
	VERTEX_SYNC	= 0x00000002,
}

SceGxmTransferColorKeyMode :: enum c.int {
	NONE   = 0,
	PASS   = 1,
	REJECT = 2
}

SceGxmTransferType :: enum c.uint {
	LINEAR   = 0x00000000,
	TILED    = 0x00400000,
	SWIZZLED = 0x00800000,
}

SceGxmBlendInfo :: bit_field c.int {
	colorMask: c.uint8_t | 8, //!< Color Mask (One of ::SceGxmColorMask)
	colorFunc: c.uint8_t | 4, //!< Color blend function (One of ::SceGxmBlendFunc)
	alphaFunc: c.uint8_t | 4, //!< Alpha blend function (One of ::SceGxmBlendFunc)
	colorSrc: c.uint8_t | 4,  //!< Color source blend factor (One of ::SceGxmBlendFactor)
	colorDst: c.uint8_t | 4,  //!< Color destination blend factor (One of ::SceGxmBlendFactor)
	alphaSrc: c.uint8_t | 4,  //!< Alpha source blend factor (One of ::SceGxmBlendFactor)
	alphaDst: c.uint8_t | 4,  //!< Alpha destination blend factor (One of ::SceGxmBlendFactor)
}
#assert(size_of(SceGxmBlendInfo) == 4)

SceGxmRenderTarget :: struct{}

SceGxmSyncObject :: struct{}

SceGxmVertexAttribute :: struct {
	streamIndex: c.uint16_t,   //!< Vertex stream index
	offset: c.uint16_t,        //!< Offset for the stream data in bytes
	format: c.uint8_t,         //!< Stream data type (One of ::SceGxmAttributeFormat)
	componentCount: c.uint8_t, //!< Number of components for the stream data
	regIndex: c.uint16_t,      //!< The register index in the vertex shader to link stream to.
}
#assert(size_of(SceGxmVertexAttribute) == 8)

SceGxmVertexStream :: struct {
	stride: c.uint16_t,
	indexSource: c.uint16_t,
}
#assert(size_of(SceGxmVertexStream) == 4)

SceGxmTextureHi8Bytes :: struct {
	// Control Word 0
	using _: struct #raw_union {
		generic: bit_field c.int { // Non LINEAR_STRIDED textures
			unk0 : c.uint32_t | 1,        //!< Unknown field
			stride_ext : c.uint32_t | 2,  //!< Stride extension for a LINEAR_STRIDED texture
			vaddr_mode : c.uint32_t | 3,  //!< V Address Mode
			uaddr_mode : c.uint32_t | 3,  //!< U Address Mode
			mip_filter : c.uint32_t | 1,  //!< Mip filter for a non LINEAR_STRIDED texture
			min_filter : c.uint32_t | 2,  //!< Min filter for a non LINEAR_STRIDED texture)
			mag_filter : c.uint32_t | 2,  //!< Mag Filter (and Min filter if LINEAR_STRIDED texture)
			unk1 : c.uint32_t | 3,        //!< Unknown field
			mip_count : c.uint32_t | 4,   //!< Mip count for a non LINEAR_STRIDED texture
			lod_bias : c.uint32_t | 6,    //!< Level of Details value for a non LINEAR_STRIDED texture
			gamma_mode : c.uint32_t | 2,  //!< Gamma mode
			unk2 : c.uint32_t | 2,        //!< Unknown field
			format0 : c.uint32_t | 1,     //!< Texture format extension
		},
		linear_strided: bit_field c.int { // LINEAR_STRIDED textures
			unk0 : c.uint32_t | 1,        //!< Unknown field
			stride_ext : c.uint32_t | 2,  //!< Stride extension for a LINEAR_STRIDED texture
			vaddr_mode : c.uint32_t | 3,  //!< V Address Mode
			uaddr_mode : c.uint32_t | 3,  //!< U Address Mode
			stride_low : c.uint32_t | 3,  //!< Internal stride lower bits for a LINEAR_STRIDED texture
			mag_filter : c.uint32_t | 2,  //!< Mag Filter (and Min filter if LINEAR_STRIDED texture)
			unk1 : c.uint32_t | 3,        //!< Unknown field
			stride : c.uint32_t | 10,     //!< Stride for a LINEAR_STRIDED texture
			gamma_mode : c.uint32_t | 2,  //!< Gamma mode
			unk2 : c.uint32_t | 2,        //!< Unknown field
			format0 : c.uint32_t | 1,     //!< Texture format extension
		},
	},
	// Control Word 1
	using _ : struct #raw_union {
		generic2: bit_field c.int { // Non SWIZZLED and non CUBE textures
			height : c.uint32_t | 12,     //!< Texture height for non SWIZZLED and non CUBE textures
			width : c.uint32_t | 12,      //!< Texture width for non SWIZZLED and non CUBE textures
			base_format : c.uint32_t | 5, //!< Texture base format
			type : c.uint32_t | 3,        //!< Texture format type
		},
		swizzled_cube: bit_field c.int { // SWIZZLED and CUBE textures
			height_pot : c.uint32_t | 4,  //!< Power of 2 height value for SWIZZLED and CUBE textures
			reserved0 : c.uint32_t | 12,  //!< Reserved field
			width_pot : c.uint32_t | 4,   //!< Power of 2 width value for SWIZZLED and CUBE textures
			reserved1 : c.uint32_t | 4,   //!< Reserved field
			base_format : c.uint32_t | 5, //!< Texture base format
			type : c.uint32_t | 3,        //!< Texture format type
		},
	},
}
#assert(size_of(SceGxmTextureHi8Bytes) == 8)

SceGxmTextureLo8Bytes :: bit_field c.longlong {
	// Control Word 2
	lod_min0: c.uint32_t | 2,            //!< Level of Details higher bits
	data_addr: c.uint32_t | 30,          //!< Texture data address
	// Control Word 3
	palette_addr: c.uint32_t | 26,       //!< Texture palette address
	lod_min1: c.uint32_t | 2,            //!< Level of Details lower bits
	swizzle_format: c.uint32_t | 3,      //!< Texture format swizzling
	normalize_mode: c.uint32_t | 1,      //!< Normalize mode
}
#assert(size_of(SceGxmTextureLo8Bytes) == 8)

//! Texture struct
SceGxmTexture :: struct {
	using hi: SceGxmTextureHi8Bytes,
	using lo: SceGxmTextureLo8Bytes,
}

#assert(size_of(SceGxmTexture) == 0x10)

SceGxmCommandList :: struct {
	words: [8]c.uint32_t,
}
#assert(size_of(SceGxmCommandList) == 0x20)

SceGxmColorSurface :: struct {
	pbeSidebandWord: c.uint,
	pbeEmitWords: [6]c.uint,
	outputRegisterSize: c.uint,
	backgroundTex: SceGxmTexture,
}
#assert(size_of(SceGxmColorSurface) == 0x30)

SceGxmDepthStencilSurface :: struct {
	zlsControl: c.uint,
	depthData: rawptr,
	stencilData: rawptr,
	backgroundDepth: c.float,
	backgroundControl: c.uint,
}

//! Represents an auxiliary surface
SceGxmAuxiliarySurface :: struct {
	colorFormat: c.uint32_t, //!< Format of auxiliary surface data from SceGxmColorFormat
	type: c.uint32_t,        //!< Memory layout of the surface data from SceGxmColorSurfaceType
	width: c.uint32_t,       //!< Surface width
	height: c.uint32_t,      //!< Surface height
	stride: c.uint32_t,      //!< Surface stride in bytes
	data: rawptr,           //!< A pointer to the surface data
}

SceGxmNotification :: struct {
	address: ^c.uint,
	value: c.uint,
}

SceGxmValidRegion :: struct {
	xMax: c.uint32_t,
	yMax: c.uint32_t,
}
#assert(size_of(SceGxmValidRegion) == 8)

SceGxmContext :: struct{}

SCE_GXM_MINIMUM_CONTEXT_HOST_MEM_SIZE           :: (2 * 1024)
SCE_GXM_DEFAULT_PARAMETER_BUFFER_SIZE           :: (16 * 1024 * 1024)
SCE_GXM_DEFAULT_VDM_RING_BUFFER_SIZE            :: (128 * 1024)
SCE_GXM_DEFAULT_VERTEX_RING_BUFFER_SIZE         :: (2 * 1024 * 1024)
SCE_GXM_DEFAULT_FRAGMENT_RING_BUFFER_SIZE       :: (512 * 1024)
SCE_GXM_DEFAULT_FRAGMENT_USSE_RING_BUFFER_SIZE  :: (16 * 1024)

SceGxmContextParams :: struct {
	hostMem: rawptr,
	hostMemSize: SceSize,
	vdmRingBufferMem: rawptr,
	vdmRingBufferMemSize: SceSize,
	vertexRingBufferMem: rawptr,
	vertexRingBufferMemSize: SceSize,
	fragmentRingBufferMem: rawptr,
	fragmentRingBufferMemSize: SceSize,
	fragmentUsseRingBufferMem: rawptr,
	fragmentUsseRingBufferMemSize: SceSize,
	fragmentUsseRingBufferOffset: c.uint,
}

SceGxmDeferredContextParams :: struct {
	hostMem: rawptr,
	hostMemSize: SceSize,
	vdmCallback: #type ^proc(args: rawptr, requestedSize: SceSize, size: ^SceSize) -> rawptr,
	vertexCallback: #type ^proc(args: rawptr, requestedSize: SceSize, size: ^SceSize) -> rawptr,
	fragmentCallback: #type ^proc(args: rawptr, requestedSize: SceSize, size: ^SceSize) -> rawptr,
	callbackData: rawptr,
	vdmRingBufferMem: rawptr,
	vdmRingBufferMemSize: SceSize,
	vertexRingBufferMem: rawptr,
	vertexRingBufferMemSize: SceSize,
	fragmentRingBufferMem: rawptr,
	fragmentRingBufferMemSize: SceSize,
}

SceGxmVertexProgram :: struct{}

SceGxmFragmentProgram :: struct{}

SceGxmPrecomputedWordCount :: enum c.int {
	VERTEX_STATE_WORD_COUNT   = 7,
	FRAGMENT_STATE_WORD_COUNT = 9,
	DRAW_WORD_COUNT           = 11,
}

SceGxmPrecomputedVertexState :: struct {
	data: [SceGxmPrecomputedWordCount.VERTEX_STATE_WORD_COUNT]c.uint,
}
#assert(size_of(SceGxmPrecomputedVertexState) == 0x1C)

SceGxmPrecomputedFragmentState :: struct {
	data: [SceGxmPrecomputedWordCount.FRAGMENT_STATE_WORD_COUNT]c.uint,
}
#assert(size_of(SceGxmPrecomputedFragmentState) == 0x24)

SceGxmPrecomputedDraw :: struct {
	data: [SceGxmPrecomputedWordCount.DRAW_WORD_COUNT]c.uint,
}
#assert(size_of(SceGxmPrecomputedDraw) == 0x2C)

SCE_GXM_MAX_VERTEX_ATTRIBUTES  :: 16
SCE_GXM_MAX_VERTEX_STREAMS     :: 16
SCE_GXM_MAX_TEXTURE_UNITS      :: 16
SCE_GXM_MAX_UNIFORM_BUFFERS    :: 14
SCE_GXM_MAX_AUXILIARY_SURFACES :: 3

SCE_GXM_TILE_SHIFTX : c.uint : 5
SCE_GXM_TILE_SHIFTY : c.uint : 5
SCE_GXM_TILE_SIZEX  : c.uint : (1 << SCE_GXM_TILE_SHIFTX)
SCE_GXM_TILE_SIZEY  : c.uint : (1 << SCE_GXM_TILE_SHIFTY)

SCE_GXM_COLOR_SURFACE_ALIGNMENT        : c.uint : 4
SCE_GXM_TEXTURE_ALIGNMENT              : c.uint : 16
SCE_GXM_DEPTHSTENCIL_SURFACE_ALIGNMENT : c.uint : 16
SCE_GXM_PALETTE_ALIGNMENT              : c.uint : 64

SceGxmProgram :: struct{}

SceGxmProgramParameter :: struct{}

SceGxmProgramType :: enum c.int {
	VERTEX_PROGRAM,
	FRAGMENT_PROGRAM
}

SceGxmParameterCategory :: enum c.int {
	ATTRIBUTE,
	UNIFORM,
	SAMPLER,
	AUXILIARY_SURFACE,
	UNIFORM_BUFFER
}

SceGxmParameterType :: enum c.int {
	F32,
	F16,
	C10,
	U32,
	S32,
	U16,
	S16,
	U8,
	S8,
	AGGREGATE
}

SceGxmParameterSemantic :: enum c.int {
	NONE,
	ATTR,
	BCOL,
	BINORMAL,
	BLENDINDICES,
	BLENDWEIGHT,
	COLOR,
	DIFFUSE,
	FOGCOORD,
	NORMAL,
	POINTSIZE,
	POSITION,
	SPECULAR,
	TANGENT,
	TEXCOORD
}

SceGxmShaderPatcher :: struct{}

SceGxmRegisteredProgram :: struct{}

SceGxmShaderPatcherId :: ^SceGxmRegisteredProgram

SceGxmShaderPatcherHostAllocCallback :: #type proc(userData: rawptr, size: SceSize) -> rawptr
SceGxmShaderPatcherHostFreeCallback :: #type proc(userData: rawptr, mem: rawptr)
SceGxmShaderPatcherBufferAllocCallback :: #type proc(userData: rawptr, size: SceSize) -> rawptr
SceGxmShaderPatcherBufferFreeCallback :: #type proc(userData: rawptr, mem: rawptr)
SceGxmShaderPatcherUsseAllocCallback :: #type proc(userData: rawptr, size: SceSize, usseOffset: ^c.uint) -> rawptr
SceGxmShaderPatcherUsseFreeCallback :: #type proc(userData: rawptr, mem: rawptr)

SceGxmShaderPatcherParams :: struct {
	userData: rawptr,
	hostAllocCallback: ^SceGxmShaderPatcherHostAllocCallback,
	hostFreeCallback: ^SceGxmShaderPatcherHostFreeCallback,
	bufferAllocCallback: ^SceGxmShaderPatcherBufferAllocCallback,
	bufferFreeCallback: ^SceGxmShaderPatcherBufferFreeCallback,
	bufferMem: rawptr,
	bufferMemSize: SceSize,
	vertexUsseAllocCallback: ^SceGxmShaderPatcherUsseAllocCallback,
	vertexUsseFreeCallback: ^SceGxmShaderPatcherUsseFreeCallback,
	vertexUsseMem: rawptr,
	vertexUsseMemSize: SceSize,
	vertexUsseOffset: c.uint,
	fragmentUsseAllocCallback: ^SceGxmShaderPatcherUsseAllocCallback,
	fragmentUsseFreeCallback: ^SceGxmShaderPatcherUsseFreeCallback,
	fragmentUsseMem: rawptr,
	fragmentUsseMemSize: SceSize,
	fragmentUsseOffset: c.uint,
}

SceGxmRenderTargetFlags :: enum c.int {
	CUSTOM_MULTISAMPLE_LOCATIONS = (1 << 0)
}

SceGxmRenderTargetParams :: struct {
	flags: c.uint32_t,	                //!< Bitwise combined flags from ::SceGxmRenderTargetFlags.
	width: c.uint16_t,	                //!< The width of the render target in pixels.
	height: c.uint16_t,                //!< The height of the render target in pixels.
	scenesPerFrame: c.uint16_t,        //!< The expected number of scenes per frame, in the range [1,SCE_GXM_MAX_SCENES_PER_RENDERTARGET].
	multisampleMode: c.uint16_t,       //!< A value from the #SceGxmMultisampleMode enum.
	multisampleLocations: c.uint32_t,  //!< If enabled in the flags, the multisample locations to use.
	driverMemBlock: SceUID,          //!< The uncached LPDDR memblock for the render target GPU data structures or SCE_UID_INVALID_UID to specify memory should be allocated in libgxm.
}
#assert(size_of(SceGxmRenderTargetParams) == 0x14)


/** GXT error codes */
SceGxtErrorCode :: enum c.uint {
	INVALID_VALUE     = 0x805D0000,
	INVALID_POINTER   = 0x805D0001,
	INVALID_ALIGNMENT = 0x805D0002
}

/** Header for a GXT file */
SceGxtHeader :: struct {
	tag: c.uint32_t,           //!< GXT Identifier
	version: c.uint32_t,       //!< Version number
	numTextures: c.uint32_t,   //!< Number of textures
	dataOffset: c.uint32_t,    //!< Offset to the texture data
	dataSize: c.uint32_t,      //!< Total size of the texture data
	numP4Palettes: c.uint32_t, //!< Number of 16 entry palettes
	numP8Palettes: c.uint32_t, //!< Number of 256 entry palettes
	pad: c.uint32_t,           //!< Padding
}
#assert(size_of(SceGxtHeader) == 0x20)

/** This structure contains information about each texture in the GXT file */
SceGxtTextureInfo :: struct {
	dataOffset: c.uint32_t,        //!< Offset to the texture data
	dataSize: c.uint32_t,          //!< Size of the texture data
	paletteIndex: c.uint32_t,      //!< Index of the palette
	flags: c.uint32_t,             //!< Texture flags
	type: c.uint32_t,              //!< Texture type
	format: c.uint32_t,            //!< Texture format
	width: c.uint16_t,             //!< Texture width
	height: c.uint16_t,            //!< Texture height
	mipCount: c.uint8_t,           //!< Number of mipmaps
	pad: [3]c.uint8_t,             //!< Padding
}
#assert(size_of(SceGxtTextureInfo) == 0x20)

/**
 * Gets the start address of the texture data.
 *
 * @param	gxt	pointer to the GXT data
 * @return A pointer to the start of the texture data
 */
sceGxtGetDataAddress :: proc(gxt: rawptr) -> rawptr {
	header := cast(^SceGxtHeader)gxt
	return cast(rawptr)((cast(uintptr)gxt) + auto_cast header.dataOffset)
}

foreign gxm {
	sceGxmInitialize :: proc(#by_ptr params: SceGxmInitializeParams) -> c.int ---
	sceGxmVshInitialize :: proc(#by_ptr params: SceGxmInitializeParams) -> c.int ---
	sceGxmTerminate :: proc() -> c.int ---

	sceGxmGetNotificationRegion :: proc() -> ^c.uint ---
	sceGxmNotificationWait :: proc(#by_ptr notification: SceGxmNotification) -> c.int ---

	sceGxmMapMemory :: proc(base: rawptr, size: SceSize, attr: SceGxmMemoryAttribFlags) -> c.int ---
	sceGxmUnmapMemory :: proc(base: rawptr) -> c.int ---

	sceGxmMapVertexUsseMemory :: proc(base: rawptr, size: SceSize, offset: ^c.uint) -> c.int ---
	sceGxmUnmapVertexUsseMemory :: proc(base: rawptr) -> c.int ---

	sceGxmMapFragmentUsseMemory :: proc(base: rawptr, size: SceSize, offset: ^c.uint) -> c.int ---
	sceGxmUnmapFragmentUsseMemory :: proc(base: rawptr) -> c.int ---

	sceGxmDisplayQueueAddEntry :: proc(oldBuffer: ^SceGxmSyncObject, newBuffer: ^SceGxmSyncObject, callbackData: rawptr) -> c.int ---
	sceGxmDisplayQueueFinish :: proc() -> c.int ---

	sceGxmSyncObjectCreate :: proc(syncObject: ^^SceGxmSyncObject) -> c.int ---
	sceGxmSyncObjectDestroy :: proc(syncObject: ^SceGxmSyncObject) -> c.int ---

	sceGxmCreateContext :: proc(#by_ptr params: SceGxmContextParams, _context: ^^SceGxmContext) -> c.int ---
	sceGxmDestroyContext :: proc(_context: ^SceGxmContext) -> c.int ---

	sceGxmCreateDeferredContext :: proc(#by_ptr params: SceGxmDeferredContextParams, _context: ^^SceGxmContext) -> c.int ---
	sceGxmDestroyDeferredContext :: proc(_context: ^SceGxmContext) -> c.int ---

	sceGxmSetValidationEnable :: proc(_context: ^SceGxmContext, enable: SceBool) ---

	sceGxmSetVertexProgram :: proc(_context: ^SceGxmContext, #by_ptr vertexProgram: SceGxmVertexProgram) --- 
	sceGxmSetFragmentProgram :: proc(_context: ^SceGxmContext, #by_ptr fragmentProgram: SceGxmFragmentProgram) ---

	sceGxmReserveVertexDefaultUniformBuffer :: proc(_context: ^SceGxmContext, uniformBuffer: ^rawptr) -> c.int ---
	sceGxmReserveFragmentDefaultUniformBuffer :: proc(_context: ^SceGxmContext, uniformBuffer: ^rawptr) -> c.int ---

	sceGxmSetVertexDefaultUniformBuffer :: proc(_context: ^SceGxmContext, uniformBuffer: rawptr) -> c.int ---
	sceGxmSetFragmentDefaultUniformBuffer :: proc(_context: ^SceGxmContext, uniformBuffer: rawptr) -> c.int ---

	sceGxmSetVertexStream :: proc(_context: ^SceGxmContext, streamIndex: c.uint, streamData: rawptr) -> c.int ---
	sceGxmSetVertexTexture :: proc(_context: ^SceGxmContext, textureIndex: c.uint, #by_ptr texture: SceGxmTexture) -> c.int ---
	sceGxmSetFragmentTexture :: proc(_context: ^SceGxmContext, textureIndex: c.uint, #by_ptr texture: SceGxmTexture) -> c.int ---
	sceGxmSetVertexUniformBuffer :: proc(_context: ^SceGxmContext, bufferIndex: c.uint, bufferData: rawptr) -> c.int ---
	sceGxmSetFragmentUniformBuffer :: proc(_context: ^SceGxmContext, bufferIndex: c.uint, bufferData: rawptr) -> c.int ---
	sceGxmSetAuxiliarySurface :: proc(_context: ^SceGxmContext, surfaceIndex: c.uint, #by_ptr surface: SceGxmAuxiliarySurface) -> c.int ---

	sceGxmSetPrecomputedFragmentState :: proc(_context: ^SceGxmContext, #by_ptr precomputedState: SceGxmPrecomputedFragmentState) ---
	sceGxmSetPrecomputedVertexState :: proc(_context: ^SceGxmContext, #by_ptr precomputedState: SceGxmPrecomputedVertexState) ---

	sceGxmDrawPrecomputed :: proc(_context: ^SceGxmContext, #by_ptr precomputedDraw: SceGxmPrecomputedDraw) -> c.int ---
	sceGxmDraw :: proc(_context: ^SceGxmContext, primType: SceGxmPrimitiveType, indexType: SceGxmIndexFormat, indexData: rawptr, indexCount: c.uint) -> c.int ---
	sceGxmDrawInstanced :: proc(_context: ^SceGxmContext, primType: SceGxmPrimitiveType, indexType: SceGxmIndexFormat, indexData: rawptr, indexCount: c.uint, indexWrap: c.uint) -> c.int ---
	sceGxmSetVisibilityBuffer :: proc(_context: ^SceGxmContext, bufferBase: rawptr, stridePerCore: c.uint) -> c.int ---

	sceGxmBeginScene :: proc(_context: ^SceGxmContext, flags: c.uint, #by_ptr renderTarget: SceGxmRenderTarget, #by_ptr validRegion: SceGxmValidRegion, vertexSyncObject: ^SceGxmSyncObject, fragmentSyncObject: ^SceGxmSyncObject, #by_ptr colorSurface: SceGxmColorSurface, #by_ptr depthStencil: SceGxmDepthStencilSurface) -> c.int ---
	sceGxmMidSceneFlush :: proc(_context: ^SceGxmContext, flags: c.uint, vertexSyncObject: ^SceGxmSyncObject, #by_ptr vertexNotification: SceGxmNotification) -> c.int ---
	sceGxmEndScene :: proc(_context: ^SceGxmContext, #by_ptr vertexNotification: SceGxmNotification, #by_ptr fragmentNotification: SceGxmNotification) -> c.int ---

	sceGxmBeginCommandList :: proc(_context: ^SceGxmContext) -> c.int ---
	sceGxmExecuteCommandList :: proc(_context: ^SceGxmContext, list: ^SceGxmCommandList) -> c.int ---
	sceGxmEndCommandList :: proc(_context: ^SceGxmContext, list: ^SceGxmCommandList) -> c.int ---

	sceGxmSetFrontDepthFunc :: proc(_context: ^SceGxmContext, depthFunc: SceGxmDepthFunc) ---
	sceGxmSetBackDepthFunc :: proc(_context: ^SceGxmContext, depthFunc: SceGxmDepthFunc) ---
	sceGxmSetFrontFragmentProgramEnable :: proc(_context: ^SceGxmContext, enable: SceGxmFragmentProgramMode) ---
	sceGxmSetBackFragmentProgramEnable :: proc(_context: ^SceGxmContext, enable: SceGxmFragmentProgramMode) ---
	sceGxmSetFrontDepthWriteEnable :: proc(_context: ^SceGxmContext, enable: SceGxmDepthWriteMode) ---
	sceGxmSetBackDepthWriteEnable :: proc(_context: ^SceGxmContext, enable: SceGxmDepthWriteMode) ---
	sceGxmSetFrontLineFillLastPixelEnable :: proc(_context: ^SceGxmContext, enable: SceGxmLineFillLastPixelMode) ---
	sceGxmSetBackLineFillLastPixelEnable :: proc(_context: ^SceGxmContext, enable: SceGxmLineFillLastPixelMode) ---
	sceGxmSetFrontStencilRef :: proc(_context: ^SceGxmContext, sref: c.uint) ---
	sceGxmSetBackStencilRef :: proc(_context: ^SceGxmContext, sref: c.uint) ---
	sceGxmSetFrontPointLineWidth :: proc(_context: ^SceGxmContext, width: c.uint) ---
	sceGxmSetBackPointLineWidth :: proc(_context: ^SceGxmContext, width: c.uint) ---
	sceGxmSetFrontPolygonMode :: proc(_context: ^SceGxmContext, mode: SceGxmPolygonMode) ---
	sceGxmSetBackPolygonMode :: proc(_context: ^SceGxmContext, mode: SceGxmPolygonMode) ---
	sceGxmSetFrontStencilFunc :: proc(_context: ^SceGxmContext, func: SceGxmStencilFunc, stencilFail: SceGxmStencilOp, depthFail: SceGxmStencilOp, depthPass: SceGxmStencilOp, compareMask: c.uchar, writeMask: c.uchar) ---
	sceGxmSetBackStencilFunc :: proc(_context: ^SceGxmContext, func: SceGxmStencilFunc, stencilFail: SceGxmStencilOp, depthFail: SceGxmStencilOp, depthPass: SceGxmStencilOp, compareMask: c.uchar, writeMask: c.uchar) ---
	sceGxmSetFrontDepthBias :: proc(_context: ^SceGxmContext, factor: c.int, units: c.int) ---
	sceGxmSetBackDepthBias :: proc(_context: ^SceGxmContext, factor: c.int, units: c.int) ---
	sceGxmSetTwoSidedEnable :: proc(_context: ^SceGxmContext, enable: SceGxmTwoSidedMode) ---
	sceGxmSetViewport :: proc(_context: ^SceGxmContext, xOffset: c.float, xScale: c.float, yOffset: c.float, yScale: c.float, zOffset: c.float, zScale: c.float) ---
	sceGxmSetWClampValue :: proc(_context: ^SceGxmContext, clampValue: c.float) ---
	sceGxmSetWClampEnable :: proc(_context: ^SceGxmContext, enable: SceGxmWClampMode) ---
	sceGxmSetRegionClip :: proc(_context: ^SceGxmContext, mode: SceGxmRegionClipMode, xMin: c.uint, yMin: c.uint, xMax: c.uint, yMax: c.uint) ---
	sceGxmSetDefaultRegionClipAndViewport :: proc(_context: ^SceGxmContext, xMax: c.uint, yMax: c.uint) ---
	sceGxmSetCullMode :: proc(_context: ^SceGxmContext, mode: SceGxmCullMode) ---
	sceGxmSetViewportEnable :: proc(_context: ^SceGxmContext, enable: SceGxmViewportMode) ---
	sceGxmSetWBufferEnable :: proc(_context: ^SceGxmContext, enable: SceGxmWBufferMode) ---
	sceGxmSetFrontVisibilityTestIndex :: proc(_context: ^SceGxmContext, index: c.uint) ---
	sceGxmSetBackVisibilityTestIndex :: proc(_context: ^SceGxmContext, index: c.uint) ---
	sceGxmSetFrontVisibilityTestOp :: proc(_context: ^SceGxmContext, op: SceGxmVisibilityTestOp) ---
	sceGxmSetBackVisibilityTestOp :: proc(_context: ^SceGxmContext, op: SceGxmVisibilityTestOp) ---
	sceGxmSetFrontVisibilityTestEnable :: proc(_context: ^SceGxmContext, enable: SceGxmVisibilityTestMode) ---
	sceGxmSetBackVisibilityTestEnable :: proc(_context: ^SceGxmContext, enable: SceGxmVisibilityTestMode) ---

	sceGxmSetYuvProfile :: proc(_context: ^SceGxmContext, index: c.uint, profile: SceGxmYuvProfile ) -> c.int ---

	sceGxmFinish :: proc(_context: ^SceGxmContext) ---

	sceGxmPushUserMarker :: proc(_context: ^SceGxmContext, tag: cstring) -> c.int ---
	sceGxmPopUserMarker :: proc(_context: ^SceGxmContext) -> c.int ---
	sceGxmSetUserMarker :: proc(_context: ^SceGxmContext, tag: cstring) -> c.int ---

	sceGxmPadHeartbeat :: proc(#by_ptr displaySurface: SceGxmColorSurface, displaySyncObject: ^SceGxmSyncObject) -> c.int ---

	sceGxmPadTriggerGpuPaTrace :: proc() -> c.int ---

	sceGxmColorSurfaceInit :: proc(surface: ^SceGxmColorSurface, colorFormat: SceGxmColorFormat, surfaceType: SceGxmColorSurfaceType, scaleMode: SceGxmColorSurfaceScaleMode, outputRegisterSize: SceGxmOutputRegisterSize, width: c.uint, height: c.uint, strideInPixels: c.uint, data: rawptr) -> c.int ---
	sceGxmColorSurfaceInitDisabled :: proc(surface: ^SceGxmColorSurface) -> c.int ---
	sceGxmColorSurfaceIsEnabled :: proc(#by_ptr surface: SceGxmColorSurface) -> SceBool ---
	sceGxmColorSurfaceGetClip :: proc(#by_ptr surface: SceGxmColorSurface, xMin: ^c.uint, yMin: ^c.uint, xMax: ^c.uint, yMax: ^c.uint) ---
	sceGxmColorSurfaceSetClip :: proc(surface: ^SceGxmColorSurface, xMin: c.uint, yMin: c.uint, xMax: c.uint, yMax: c.uint) ---

	sceGxmColorSurfaceGetScaleMode :: proc(#by_ptr surface: SceGxmColorSurface) -> SceGxmColorSurfaceScaleMode ---
	sceGxmColorSurfaceSetScaleMode :: proc(surface: ^SceGxmColorSurface, scaleMode: SceGxmColorSurfaceScaleMode) ---

	sceGxmColorSurfaceGetData :: proc(#by_ptr surface: SceGxmColorSurface) -> rawptr ---
	sceGxmColorSurfaceSetData :: proc(surface: ^SceGxmColorSurface, data: rawptr) -> c.int ---

	sceGxmColorSurfaceGetFormat :: proc(#by_ptr surface: SceGxmColorSurface) -> SceGxmColorFormat ---
	sceGxmColorSurfaceSetFormat :: proc(surface: ^SceGxmColorSurface, format: SceGxmColorFormat) -> c.int ---
	sceGxmColorSurfaceGetType :: proc(#by_ptr surface: SceGxmColorSurface) -> SceGxmColorSurfaceType ---
	sceGxmColorSurfaceGetStrideInPixels :: proc(#by_ptr surface: SceGxmColorSurface) -> c.uint ---

	sceGxmDepthStencilSurfaceInit :: proc(surface: ^SceGxmDepthStencilSurface, depthStencilFormat: SceGxmDepthStencilFormat, surfaceType: SceGxmDepthStencilSurfaceType, strideInSamples: c.uint, depthData: rawptr, stencilData: rawptr) -> c.int ---
	sceGxmDepthStencilSurfaceInitDisabled :: proc(surface: ^SceGxmDepthStencilSurface) -> c.int ---
	sceGxmDepthStencilSurfaceGetBackgroundDepth :: proc(#by_ptr surface: SceGxmDepthStencilSurface) -> c.float ---
	sceGxmDepthStencilSurfaceSetBackgroundDepth :: proc(surface: ^SceGxmDepthStencilSurface, backgroundDepth: c.float) ---
	sceGxmDepthStencilSurfaceGetBackgroundStencil :: proc(#by_ptr surface: SceGxmDepthStencilSurface) -> c.uchar ---
	sceGxmDepthStencilSurfaceSetBackgroundStencil :: proc(surface: ^SceGxmDepthStencilSurface, backgroundStencil: c.uchar) ---
	sceGxmDepthStencilSurfaceIsEnabled :: proc(#by_ptr surface: SceGxmDepthStencilSurface) -> SceBool ---
	sceGxmDepthStencilSurfaceSetForceLoadMode :: proc(surface: ^SceGxmDepthStencilSurface, forceLoad: SceGxmDepthStencilForceLoadMode) ---
	sceGxmDepthStencilSurfaceGetForceLoadMode :: proc(#by_ptr surface: SceGxmDepthStencilSurface) -> SceGxmDepthStencilForceLoadMode ---
	sceGxmDepthStencilSurfaceSetForceStoreMode :: proc(surface: ^SceGxmDepthStencilSurface, forceStore: SceGxmDepthStencilForceStoreMode ) ---
	sceGxmDepthStencilSurfaceGetForceStoreMode :: proc(#by_ptr surface: SceGxmDepthStencilSurface) -> SceGxmDepthStencilForceStoreMode ---

	sceGxmColorSurfaceGetGammaMode :: proc(#by_ptr surface: SceGxmColorSurface) -> SceGxmColorSurfaceGammaMode ---
	sceGxmColorSurfaceSetGammaMode :: proc(surface: ^SceGxmColorSurface, gammaMode: SceGxmColorSurfaceGammaMode) -> c.int ---
	sceGxmColorSurfaceGetDitherMode :: proc(#by_ptr surface: SceGxmColorSurface) -> SceGxmColorSurfaceDitherMode ---
	sceGxmColorSurfaceSetDitherMode :: proc(surface: ^SceGxmColorSurface, ditherMode: SceGxmColorSurfaceDitherMode) -> c.int ---

	sceGxmDepthStencilSurfaceGetFormat :: proc(#by_ptr surface: SceGxmDepthStencilSurface) -> SceGxmDepthStencilFormat ---
	sceGxmDepthStencilSurfaceGetStrideInSamples :: proc(#by_ptr surface: SceGxmDepthStencilSurface) -> c.uint ---

	sceGxmProgramCheck :: proc(#by_ptr program: SceGxmProgram) -> c.int ---
	sceGxmProgramGetSize :: proc(#by_ptr program: SceGxmProgram) -> c.uint ---
	sceGxmProgramGetType :: proc(#by_ptr program: SceGxmProgram) -> SceGxmProgramType ---
	sceGxmProgramIsDiscardUsed :: proc(#by_ptr program: SceGxmProgram) -> SceBool ---
	sceGxmProgramIsDepthReplaceUsed :: proc(#by_ptr program: SceGxmProgram) -> SceBool ---
	sceGxmProgramIsSpriteCoordUsed :: proc(#by_ptr program: SceGxmProgram) -> SceBool ---
	sceGxmProgramGetDefaultUniformBufferSize :: proc(#by_ptr program: SceGxmProgram) -> c.uint ---
	sceGxmProgramGetParameterCount :: proc(#by_ptr program: SceGxmProgram) -> c.uint ---

	sceGxmProgramGetParameter :: proc(#by_ptr program: SceGxmProgram, index: c.uint) -> ^SceGxmProgramParameter ---
	sceGxmProgramFindParameterByName :: proc(#by_ptr program: SceGxmProgram, name: cstring) -> ^SceGxmProgramParameter ---
	sceGxmProgramFindParameterBySemantic :: proc(#by_ptr program: SceGxmProgram, semantic: SceGxmParameterSemantic, index: c.uint) -> ^SceGxmProgramParameter ---
	sceGxmProgramParameterGetIndex :: proc(#by_ptr program: SceGxmProgram, #by_ptr parameter: SceGxmProgramParameter) -> c.uint ---
	sceGxmProgramParameterGetCategory :: proc(#by_ptr parameter: SceGxmProgramParameter) -> SceGxmParameterCategory ---
	sceGxmProgramParameterGetName :: proc(#by_ptr parameter: SceGxmProgramParameter) -> cstring ---
	sceGxmProgramParameterGetSemantic :: proc(#by_ptr parameter: SceGxmProgramParameter) -> SceGxmParameterSemantic ---
	sceGxmProgramParameterGetSemanticIndex :: proc(#by_ptr parameter: SceGxmProgramParameter) -> c.uint ---
	sceGxmProgramParameterGetType :: proc(#by_ptr parameter: SceGxmProgramParameter) -> SceGxmParameterType ---
	sceGxmProgramParameterGetComponentCount :: proc(#by_ptr parameter: SceGxmProgramParameter) -> c.uint ---
	sceGxmProgramParameterGetArraySize :: proc(#by_ptr parameter: SceGxmProgramParameter) -> c.uint ---
	sceGxmProgramParameterGetResourceIndex :: proc(#by_ptr parameter: SceGxmProgramParameter) -> c.uint ---
	sceGxmProgramParameterGetContainerIndex :: proc(#by_ptr parameter: SceGxmProgramParameter) -> c.uint ---
	sceGxmProgramParameterIsSamplerCube :: proc(#by_ptr parameter: SceGxmProgramParameter) -> SceBool ---

	sceGxmFragmentProgramGetProgram :: proc(#by_ptr fragmentProgram: SceGxmFragmentProgram) -> ^SceGxmProgram ---
	sceGxmVertexProgramGetProgram :: proc(#by_ptr vertexProgram: SceGxmVertexProgram) -> ^SceGxmProgram ---

	sceGxmShaderPatcherCreate :: proc(#by_ptr params: SceGxmShaderPatcherParams, shaderPatcher: ^^SceGxmShaderPatcher) -> c.int ---
	sceGxmShaderPatcherSetUserData :: proc(shaderPatcher: ^SceGxmShaderPatcher, userData: rawptr) -> c.int ---
	sceGxmShaderPatcherGetUserData :: proc(shaderPatcher: ^SceGxmShaderPatcher) -> rawptr ---
	sceGxmShaderPatcherDestroy :: proc(shaderPatcher: ^SceGxmShaderPatcher) -> c.int ---
	sceGxmShaderPatcherRegisterProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, #by_ptr programHeader: SceGxmProgram, programId: ^SceGxmShaderPatcherId) -> c.int ---
	sceGxmShaderPatcherUnregisterProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, programId: SceGxmShaderPatcherId) -> c.int ---
	sceGxmShaderPatcherForceUnregisterProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, programId: SceGxmShaderPatcherId) -> c.int ---
	sceGxmShaderPatcherGetProgramFromId :: proc(programId: SceGxmShaderPatcherId) -> ^SceGxmProgram ---
	sceGxmShaderPatcherSetAuxiliarySurface :: proc(shaderPatcher: ^SceGxmShaderPatcher, auxSurfaceIndex: c.uint, #by_ptr auxSurface: SceGxmAuxiliarySurface) -> c.int ---
	sceGxmShaderPatcherCreateVertexProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, programId: SceGxmShaderPatcherId, attributes: [^]SceGxmVertexAttribute, attributeCount: c.uint, streams: [^]SceGxmVertexStream, streamCount: c.uint, vertexProgram: ^^SceGxmVertexProgram) -> c.int ---
	sceGxmShaderPatcherCreateFragmentProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, programId: SceGxmShaderPatcherId, outputFormat: SceGxmOutputRegisterFormat, multisampleMode: SceGxmMultisampleMode, #by_ptr blendInfo: SceGxmBlendInfo, #by_ptr vertexProgram: SceGxmProgram, fragmentProgram: ^^SceGxmFragmentProgram) -> c.int ---
	sceGxmShaderPatcherCreateMaskUpdateFragmentProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, fragmentProgram: ^^SceGxmFragmentProgram) -> c.int ---
	sceGxmShaderPatcherAddRefVertexProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, vertexProgram: ^SceGxmVertexProgram) -> c.int ---
	sceGxmShaderPatcherAddRefFragmentProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, fragmentProgram: ^SceGxmFragmentProgram) -> c.int ---
	sceGxmShaderPatcherGetVertexProgramRefCount :: proc(shaderPatcher: ^SceGxmShaderPatcher, fragmentProgram: ^SceGxmVertexProgram, count: ^c.uint) -> c.int ---
	sceGxmShaderPatcherGetFragmentProgramRefCount :: proc(shaderPatcher: ^SceGxmShaderPatcher, fragmentProgram: ^SceGxmFragmentProgram, count: ^c.uint) -> c.int ---
	sceGxmShaderPatcherReleaseVertexProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, vertexProgram: ^SceGxmVertexProgram) -> c.int ---
	sceGxmShaderPatcherReleaseFragmentProgram :: proc(shaderPatcher: ^SceGxmShaderPatcher, fragmentProgram: ^SceGxmFragmentProgram) -> c.int ---
	sceGxmShaderPatcherGetHostMemAllocated :: proc(#by_ptr shaderPatcher: SceGxmShaderPatcher) -> c.uint ---
	sceGxmShaderPatcherGetBufferMemAllocated :: proc(#by_ptr shaderPatcher: SceGxmShaderPatcher) -> c.uint ---
	sceGxmShaderPatcherGetVertexUsseMemAllocated :: proc(#by_ptr shaderPatcher: SceGxmShaderPatcher) -> c.uint ---
	sceGxmShaderPatcherGetFragmentUsseMemAllocated :: proc(#by_ptr shaderPatcher: SceGxmShaderPatcher) -> c.uint ---

	sceGxmTextureInitSwizzled :: proc(texture: ^SceGxmTexture,  data: rawptr, texFormat: SceGxmTextureFormat, width: c.uint, height: c.uint, mipCount: c.uint) -> c.int ---
	sceGxmTextureInitSwizzledArbitrary :: proc(texture: ^SceGxmTexture, data: rawptr, texFormat: SceGxmTextureFormat, width: c.uint, height: c.uint, mipCount: c.uint) -> c.int ---
	sceGxmTextureInitLinear :: proc(texture: ^SceGxmTexture, data: rawptr, texFormat: SceGxmTextureFormat, width: c.uint, height: c.uint, mipCount: c.uint) -> c.int ---
	sceGxmTextureInitLinearStrided :: proc(texture: ^SceGxmTexture, data: rawptr, texFormat: SceGxmTextureFormat, width: c.uint, height: c.uint, byteStride: c.uint) -> c.int ---
	sceGxmTextureInitTiled :: proc(texture: ^SceGxmTexture, data: rawptr, texFormat: SceGxmTextureFormat, width: c.uint, height: c.uint, mipCount: c.uint) -> c.int ---
	sceGxmTextureInitCube :: proc(texture: ^SceGxmTexture, data: rawptr, texFormat: SceGxmTextureFormat, width: c.uint, height: c.uint, mipCount: c.uint) -> c.int ---

	sceGxmTextureGetType :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureType ---
	sceGxmTextureValidate :: proc(#by_ptr texture: SceGxmTexture) -> c.int ---

	sceGxmTextureSetMinFilter :: proc(texture: ^SceGxmTexture, minFilter: SceGxmTextureFilter) -> c.int ---
	sceGxmTextureGetMinFilter :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureFilter ---

	sceGxmTextureSetMagFilter :: proc(texture: ^SceGxmTexture, magFilter: SceGxmTextureFilter) -> c.int ---
	sceGxmTextureGetMagFilter :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureFilter ---

	sceGxmTextureSetMipFilter :: proc(texture: ^SceGxmTexture, mipFilter: SceGxmTextureMipFilter) -> c.int ---
	sceGxmTextureGetMipFilter :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureMipFilter ---

	sceGxmTextureSetUAddrMode :: proc(texture: ^SceGxmTexture, addrMode: SceGxmTextureAddrMode) -> c.int ---
	sceGxmTextureGetUAddrMode :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureAddrMode ---

	sceGxmTextureSetVAddrMode :: proc(texture: ^SceGxmTexture, addrMode: SceGxmTextureAddrMode) -> c.int ---
	sceGxmTextureGetVAddrMode :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureAddrMode ---

	sceGxmTextureSetFormat :: proc(texture: ^SceGxmTexture, texFormat: SceGxmTextureFormat ) -> c.int ---
	sceGxmTextureGetFormat :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureFormat ---

	sceGxmTextureSetLodBias :: proc(texture: ^SceGxmTexture, bias: c.uint) -> c.int ---
	sceGxmTextureGetLodBias :: proc(#by_ptr texture: SceGxmTexture) -> c.uint ---

	sceGxmTextureSetStride :: proc(texture: ^SceGxmTexture, byteStride: c.uint) -> c.int ---
	sceGxmTextureGetStride :: proc(#by_ptr texture: SceGxmTexture) -> c.uint ---

	sceGxmTextureSetWidth :: proc(texture: ^SceGxmTexture, width: c.uint) -> c.int ---
	sceGxmTextureGetWidth :: proc(#by_ptr texture: SceGxmTexture) -> c.uint ---

	sceGxmTextureSetHeight :: proc(texture: ^SceGxmTexture, height: c.uint) -> c.int ---
	sceGxmTextureGetHeight :: proc(#by_ptr texture: SceGxmTexture) -> c.uint ---

	sceGxmTextureSetData :: proc(texture: ^SceGxmTexture,  data: rawptr) -> c.int ---
	sceGxmTextureGetData :: proc(#by_ptr texture: SceGxmTexture) -> rawptr ---

	sceGxmTextureSetMipmapCount :: proc(texture: ^SceGxmTexture, mipCount: c.uint) -> c.int ---
	sceGxmTextureGetMipmapCount :: proc(#by_ptr texture: SceGxmTexture) -> c.uint ---

	sceGxmTextureSetPalette :: proc(texture: ^SceGxmTexture,  paletteData: rawptr) -> c.int ---
	sceGxmTextureGetPalette :: proc(#by_ptr texture: SceGxmTexture) -> rawptr ---

	sceGxmTextureGetGammaMode :: proc(#by_ptr texture: SceGxmTexture) -> SceGxmTextureGammaMode ---
	sceGxmTextureSetGammaMode :: proc(texture: ^SceGxmTexture, gammaMode: SceGxmTextureGammaMode) -> c.int ---

	sceGxmGetPrecomputedVertexStateSize :: proc(#by_ptr vertexProgram: SceGxmVertexProgram) -> c.uint ---
	sceGxmPrecomputedVertexStateInit :: proc(precomputedState: ^SceGxmPrecomputedVertexState, #by_ptr vertexProgram: SceGxmVertexProgram, memBlock: rawptr) -> c.int ---
	sceGxmPrecomputedVertexStateSetDefaultUniformBuffer :: proc(precomputedState: ^SceGxmPrecomputedVertexState, defaultBuffer: rawptr) ---
	sceGxmPrecomputedVertexStateGetDefaultUniformBuffer :: proc(#by_ptr precomputedState: SceGxmPrecomputedVertexState) -> rawptr ---
	sceGxmPrecomputedVertexStateSetAllTextures :: proc(precomputedState: ^SceGxmPrecomputedVertexState, #by_ptr textures: SceGxmTexture) -> c.int ---
	sceGxmPrecomputedVertexStateSetTexture :: proc(precomputedState: ^SceGxmPrecomputedVertexState, textureIndex: c.uint, #by_ptr texture: SceGxmTexture) -> c.int ---
	sceGxmPrecomputedVertexStateSetAllUniformBuffers :: proc(precomputedState: ^SceGxmPrecomputedVertexState, bufferDataArray: ^rawptr) -> c.int ---
	sceGxmPrecomputedVertexStateSetUniformBuffer :: proc(precomputedState: ^SceGxmPrecomputedVertexState, bufferIndex: c.uint, bufferData: rawptr) -> c.int ---
	sceGxmGetPrecomputedFragmentStateSize :: proc(#by_ptr fragmentProgram: SceGxmFragmentProgram) -> c.uint ---
	sceGxmPrecomputedFragmentStateInit :: proc(precomputedState: ^SceGxmPrecomputedFragmentState, #by_ptr fragmentProgram: SceGxmFragmentProgram, memBlock: rawptr) -> c.int ---
	sceGxmPrecomputedFragmentStateSetDefaultUniformBuffer :: proc(precomputedState: ^SceGxmPrecomputedFragmentState, defaultBuffer: rawptr) ---
	sceGxmPrecomputedFragmentStateGetDefaultUniformBuffer :: proc(#by_ptr precomputedState: SceGxmPrecomputedFragmentState) -> rawptr ---
	sceGxmPrecomputedFragmentStateSetAllTextures :: proc(precomputedState: ^SceGxmPrecomputedFragmentState, textureArray: [^]SceGxmTexture) -> c.int ---
	sceGxmPrecomputedFragmentStateSetTexture :: proc(precomputedState: ^SceGxmPrecomputedFragmentState, textureIndex: c.uint, #by_ptr texture: SceGxmTexture) -> c.int ---
	sceGxmPrecomputedFragmentStateSetAllUniformBuffers :: proc(precomputedState: ^SceGxmPrecomputedFragmentState, bufferDataArray: ^rawptr) -> c.int ---
	sceGxmPrecomputedFragmentStateSetUniformBuffer :: proc(precomputedState: ^SceGxmPrecomputedFragmentState, bufferIndex: c.uint, bufferData: rawptr) -> c.int ---
	sceGxmPrecomputedFragmentStateSetAllAuxiliarySurfaces :: proc(precomputedState: ^SceGxmPrecomputedFragmentState, auxSurfaceArray: [^]SceGxmAuxiliarySurface) -> c.int ---
	sceGxmGetPrecomputedDrawSize :: proc(#by_ptr vertexProgram: SceGxmVertexProgram) -> c.uint ---
	sceGxmPrecomputedDrawInit :: proc(precomputedDraw: ^SceGxmPrecomputedDraw, #by_ptr vertexProgram: SceGxmVertexProgram, memBlock: rawptr) -> c.int ---
	sceGxmPrecomputedDrawSetAllVertexStreams :: proc(precomputedDraw: ^SceGxmPrecomputedDraw, streamDataArray: ^rawptr) -> c.int ---
	sceGxmPrecomputedDrawSetVertexStream :: proc(precomputedDraw: ^SceGxmPrecomputedDraw, streamIndex: c.uint, streamData: rawptr) -> c.int ---
	sceGxmPrecomputedDrawSetParams :: proc(precomputedDraw: ^SceGxmPrecomputedDraw, primType: SceGxmPrimitiveType, indexType: SceGxmIndexFormat, indexData: rawptr, indexCount: c.uint) ---
	sceGxmPrecomputedDrawSetParamsInstanced :: proc(precomputedDraw: ^SceGxmPrecomputedDraw, primType: SceGxmPrimitiveType, indexType: SceGxmIndexFormat, indexData: rawptr, indexCount: c.uint, indexWrap: c.uint) ---

	sceGxmGetRenderTargetMemSize :: proc(#by_ptr params: SceGxmRenderTargetParams, driverMemSize: ^c.uint) -> c.int ---
	sceGxmCreateRenderTarget :: proc(#by_ptr params: SceGxmRenderTargetParams, renderTarget: ^^SceGxmRenderTarget) -> c.int ---
	sceGxmRenderTargetGetHostMem :: proc(#by_ptr renderTarget: SceGxmRenderTarget, hostMem: ^rawptr) -> c.int ---
	sceGxmRenderTargetGetDriverMemBlock :: proc(#by_ptr renderTarget: SceGxmRenderTarget, driverMemBlock: ^SceUID) -> c.int ---
	sceGxmDestroyRenderTarget :: proc(renderTarget: ^SceGxmRenderTarget) -> c.int ---

	sceGxmSetUniformDataF :: proc(uniformBuffer: rawptr, #by_ptr parameter: SceGxmProgramParameter, componentOffset: c.uint, componentCount: c.uint, sourceData: ^c.float) -> c.int ---

	sceGxmTransferCopy :: proc(width: c.uint32_t, height: c.uint32_t, colorKeyValue: c.uint32_t, colorKeyMask: c.uint32_t, colorKeyMode: SceGxmTransferColorKeyMode, srcFormat: SceGxmTransferFormat, srcType: SceGxmTransferType, srcAddress: rawptr, srcX: c.uint32_t, srcY: c.uint32_t, srcStride: c.int32_t, destFormat: SceGxmTransferFormat, destType: SceGxmTransferType, destAddress: rawptr, destX: c.uint32_t, destY: c.uint32_t, destStride: c.int32_t, syncObject: ^SceGxmSyncObject, syncFlags: c.uint32_t, #by_ptr notification: SceGxmNotification) -> c.int ---
	sceGxmTransferDownscale :: proc(srcFormat: SceGxmTransferFormat, srcAddress: rawptr, srcX: c.uint, srcY: c.uint, srcWidth: c.uint, srcHeight: c.uint, srcStride: c.int, destFormat: SceGxmTransferFormat, destAddress: rawptr, destX: c.uint, destY: c.uint, destStride: c.int, syncObject: ^SceGxmSyncObject, syncFlags: c.uint, #by_ptr notification: SceGxmNotification) -> c.int ---
	sceGxmTransferFill :: proc(color: c.uint32_t, destFormat: SceGxmTransferFormat, destAddress: rawptr, destX: c.uint32_t, destY: c.uint32_t, destWidth: c.uint32_t, destHeight: c.uint32_t, destStride: c.int32_t, syncObject: ^SceGxmSyncObject, syncFlags: c.uint32_t, #by_ptr notification: SceGxmNotification) -> c.int ---
	sceGxmTransferFinish :: proc() -> c.int ---
}

