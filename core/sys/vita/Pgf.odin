#+build vita
package vita

import "core:c"

foreign import pgf "system:ScePgf_stub"

SceFontLibHandle :: rawptr
SceFontHandle :: rawptr

/* struct */

SceFontErrorCode :: enum c.uint {
	OUT_OF_MEMORY        = 0x80460001,
	INVALID_LIBID        = 0x80460002,
	INVALID_PARAMETER    = 0x80460003,
	HANDLER_OPEN_FAILED  = 0x80460005,
	TOO_MANY_OPEN_FONTS  = 0x80460009,
	INVALID_FONT_DATA    = 0x8046000A,
}

SceFontNewLibParams :: struct {
  userData: rawptr,
	numFonts: c.uint,
	cacheData: rawptr,

	// Driver callbacks.
  allocFunc: #type ^proc "c" (_: rawptr, __: c.uint) -> rawptr,
  freeFunc: #type ^proc "c" (_: rawptr, __: rawptr),
	openFunc: rawptr,
	closeFunc: rawptr,
	readFunc: rawptr,
	seekFunc: rawptr,
	errorFunc: rawptr,
	ioFinishFunc: rawptr,
}

SceFontFamilyCode :: enum c.int {
	DEFAULT    = 0,
	SANS_SERIF = 1,
	SERIF      = 2,
	ROUNDED    = 3,
}

SceFontStyleCode :: enum c.int {
	DEFAULT       = 0,
	REGULAR       = 1,
	ITALIC        = 2,
	NARROW        = 3,
	NARROW_ITALIC = 4,
	BOLD          = 5,
	BOLD_ITALIC   = 6,
	BLACK         = 7,
	BLACK_ITALIC  = 8,
	L             = 101,
	M             = 102,
	DB            = 103, //!< Demi-Bold / semi-bold
	B             = 104,
	EB            = 105,
	UB            = 106,
}

SceFontLanguageCode :: enum c.int {
	DEFAULT  = 0,
	JAPANESE = 1,
	LATIN    = 2,
	KOREAN   = 3,
	CHINESE  = 4,
	CJK      = 5,
}

SceFontPixelFormatCode :: enum c.int {
	PIXELFORMAT_4     = 0, //!< 2 pixels packed in 1 byte (natural order)
	PIXELFORMAT_4_REV = 1, //!< 2 pixels packed in 1 byte (reversed order)
	PIXELFORMAT_8     = 2, //!< 1 pixel in 1 byte
	PIXELFORMAT_24    = 3, //!< 1 pixel in 3 bytes (RGB)
	PIXELFORMAT_32    = 4, //!< 1 pixel in 4 bytes (RGBA)
}

SceFontImageRect :: struct {
  width: c.ushort,
	height: c.ushort,
}
#assert(size_of(SceFontImageRect) == 4)

SceFontGlyphImage :: struct {
  pixelFormat: c.uint,
	xPos64: c.int,
	yPos64: c.int,
	bufWidth: c.ushort,
	bufHeight: c.ushort,
	bytesPerLine: c.ushort,
	pad: c.ushort,
	bufferPtr: c.uint,
}
#assert(size_of(SceFontGlyphImage) == 0x18)

SceFontStyle :: struct {
  fontH: c.float,
	fontV: c.float,
	fontHRes: c.float,
	fontVRes: c.float,
	fontWeight: c.float,
	fontFamily: c.ushort,
	fontStyle: c.ushort,
	// Check.
	fontStyleSub: c.ushort,
	fontLanguage: c.ushort,
	fontRegion: c.ushort,
	fontCountry: c.ushort,
	fontName: [64]c.char,
	fontFileName: [64]c.char,
	fontAttributes: c.uint,
	fontExpire: c.uint,
}
#assert(size_of(SceFontStyle) == 0xA8)

SceFontCharInfo :: struct {
  bitmapWidth: c.uint,
	bitmapHeight: c.uint,
	bitmapLeft: c.uint,
	bitmapTop: c.uint,
	// Glyph metrics (in 26.6 signed fixed-point).
	sfp26Width: c.uint,
	sfp26Height: c.uint,
	sfp26Ascender: c.int,
	sfp26Descender: c.int,
	sfp26BearingHX: c.int,
	sfp26BearingHY: c.int,
	sfp26BearingVX: c.int,
	sfp26BearingVY: c.int,
	sfp26AdvanceH: c.int,
	sfp26AdvanceV: c.int,
	shadowFlags: c.short,
	shadowId: c.short,
}
#assert(size_of(SceFontCharInfo) == 0x3C)

SceFontInfo :: struct {
	// Glyph metrics (in 26.6 signed fixed-point).
  maxGlyphWidthI: c.uint,
	maxGlyphHeightI: c.uint,
	maxGlyphAscenderI: c.uint,
	maxGlyphDescenderI: c.uint,
	maxGlyphLeftXI: c.uint,
	maxGlyphBaseYI: c.uint,
	minGlyphCenterXI: c.uint,
	maxGlyphTopYI: c.uint,
	maxGlyphAdvanceXI: c.uint,
	maxGlyphAdvanceYI: c.uint,

	// Glyph metrics (replicated as float).
	maxGlyphWidthF: c.float,
	maxGlyphHeightF: c.float,
	maxGlyphAscenderF: c.float,
	maxGlyphDescenderF: c.float,
	maxGlyphLeftXF: c.float,
	maxGlyphBaseYF: c.float,
	minGlyphCenterXF: c.float,
	maxGlyphTopYF: c.float,
	maxGlyphAdvanceXF: c.float,
	maxGlyphAdvanceYF: c.float,

	// Bitmap dimensions.
	maxGlyphWidth: c.short,
	maxGlyphHeight: c.short,
	charMapLength: c.uint,   //!< Number of elements in the font's charmap.
	shadowMapLength: c.uint, //!< Number of elements in the font's shadow charmap.

	// Font style (used by font comparison functions).
	fontStyle: SceFontStyle,

	BPP: c.uint8_t, //!< Font's BPP.
	pad: [3]c.uint8_t,
}
#assert(size_of(SceFontInfo) == 0x108)

foreign pgf {
	sceFontNewLib :: proc(params: ^SceFontNewLibParams, errorCode: ^c.uint) -> SceFontLibHandle ---
	sceFontDoneLib :: proc(libHandle: SceFontLibHandle) -> c.int ---
	sceFontOpen :: proc(libHandle: SceFontLibHandle, index: c.int, mode: c.int, errorCode: ^c.uint) -> SceFontHandle ---
	sceFontOpenUserMemory :: proc(libHandle: SceFontLibHandle, pMemoryFont: rawptr, pMemoryFontSize: SceSize, errorCode: ^c.uint) -> SceFontHandle ---
	sceFontOpenUserFile :: proc(libHandle: SceFontLibHandle, file: cstring, mode: c.int, errorCode: ^c.uint) -> SceFontHandle ---
	sceFontClose :: proc(fontHandle: SceFontHandle) -> c.int ---
	sceFontGetNumFontList :: proc(libHandle: SceFontLibHandle, errorCode: ^c.uint) -> c.int ---
	sceFontFindOptimumFont :: proc(libHandle: SceFontLibHandle, fontStyle: ^SceFontStyle, errorCode: ^c.uint) -> c.int ---
	sceFontFindFont :: proc(libHandle: SceFontLibHandle, fontStyle: ^SceFontStyle, errorCode: ^c.uint) -> c.int ---
	sceFontGetFontInfo :: proc(fontHandle: SceFontHandle, fontInfo: ^SceFontInfo) -> c.int ---
	sceFontGetFontInfoByIndexNumber :: proc(libHandle: SceFontLibHandle, fontStyle: ^SceFontStyle, unknown: c.int, fontIndex: c.int) -> c.int ---
	sceFontSetResolution :: proc(libHandle: SceFontLibHandle, hRes: c.float, vRes: c.float) -> c.int ---
	sceFontGetFontList :: proc(libHandle: SceFontLibHandle, fontStyle: ^SceFontStyle, numFonts: c.int) -> c.int ---
	sceFontGetCharInfo :: proc(fontHandle: SceFontHandle, charCode: c.uint, charInfo: ^SceFontCharInfo) -> c.int ---
	sceFontGetCharImageRect :: proc(fontHandle: SceFontHandle, charCode: c.uint, charRect: ^SceFontImageRect) -> c.int ---
	sceFontGetCharGlyphImage :: proc(fontHandle: SceFontHandle, charCode: c.uint, glyphImage: ^SceFontGlyphImage) -> c.int ---
	sceFontGetCharGlyphImage_Clip :: proc(fontHandle: SceFontHandle, charCode: c.uint, glyphImage: ^SceFontGlyphImage, clipXPos: c.int, clipYPos: c.int, clipWidth: c.int, clipHeight: c.int) -> c.int ---
	sceFontPixelToPointH :: proc(libHandle: SceFontLibHandle, fontPixelsH: c.float, errorCode: ^c.uint) -> c.float ---
	sceFontPixelToPointV :: proc(libHandle: SceFontLibHandle, fontPixelsV: c.float, errorCode: ^c.uint) -> c.float ---
	sceFontPointToPixelH :: proc(libHandle: SceFontLibHandle, fontPointsH: c.float, errorCode: ^c.uint) -> c.float ---
	sceFontPointToPixelV :: proc(libHandle: SceFontLibHandle, fontPointsV: c.float, errorCode: ^c.uint) -> c.float ---
	sceFontSetAltCharacterCode :: proc(libHandle: SceFontLibHandle, charCode: c.uint) -> c.int ---
	sceFontFlush :: proc(fontHandle: SceFontHandle) -> c.int ---
}

