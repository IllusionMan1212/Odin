#+build vita
package vita

import "core:c"

foreign import pvf "system:ScePvf_stub"

SCE_PVF_MAX_OPEN :: 18

SCE_PVF_FONTNAME_LENGTH     :: 64
SCE_PVF_STYLENAME_LENGTH    :: 64
SCE_PVF_FONTFILENAME_LENGTH :: 64

SCE_PVF_MIN_EMBOLDEN_RATE  :: -20.0
SCE_PVF_MAX_EMBOLDEN_RATE  :: 40.0
SCE_PVF_MIN_SKEW_VALUE     :: -30.0
SCE_PVF_MAX_SKEW_VALUE     :: 30.0

ScePvfErrorCode :: enum c.uint {
	NOMEMORY         = 0x80460001,
	LIBID            = 0x80460002,
	ARG              = 0x80460003,
	NOFILE           = 0x80460004,
	FILEOPEN         = 0x80460005,
	FILECLOSE        = 0x80460006,
	FILEREAD         = 0x80460007,
	FILESEEK         = 0x80460008,
	TOOMANYOPENED    = 0x80460009,
	ILLEGALVERSION   = 0x8046000A,
	DATAINCONSISTENT = 0x8046000B,
	EXPIRED          = 0x8046000C,
	NOSUPPORT        = 0x8046000E,
	NOGLYPH          = 0x8046000F,
	UNKNOWN          = 0x8046FFFF
}

ScePvfFamilyCode :: enum c.int {
	DEFAULT_FAMILY_CODE = 0,
	FAMILY_SANSERIF     = 1,
	FAMILY_SERIF        = 2,
	FAMILY_ROUNDED      = 3
}

ScePvfStyleCode :: enum c.int {
	DEFAULT_STYLE_CODE    = 0,
	STYLE_REGULAR         = 1,
	STYLE_OBLIQUE         = 2,
	STYLE_NARROW          = 3,
	STYLE_NARROW_OBLIQUE  = 4,
	STYLE_BOLD            = 5,
	STYLE_BOLD_OBLIQUE    = 6,
	STYLE_BLACK           = 7,
	STYLE_BLACK_OBLIQUE   = 8,
	STYLE_L               = 101,
	STYLE_M               = 102,
	STYLE_DB              = 103,
	STYLE_B               = 104,
	STYLE_EB              = 105,
	STYLE_UB              = 106
}

ScePvfImageByfferPixelFormatType :: enum c.int {
	USERIMAGE_DIRECT4_L = 0,
	USERIMAGE_DIRECT8   = 2
}

ScePvfLanguageCode :: enum c.int {
	DEFAULT_LANGUAGE_CODE = 0,
	LANGUAGE_J            = 1,
	LANGUAGE_LATIN        = 2,
	LANGUAGE_K            = 3,
	LANGUAGE_C            = 4,
	LANGUAGE_CJK          = 5
}

ScePvfRegionCode :: enum c.int {
	GENERIC_REGION_CODE = 0,
	REGION_001          = 1,
	REGION_002          = 2,
	REGION_003          = 3,
	REGION_004          = 4,
	REGION_005          = 5,
	REGION_006          = 6,
	REGION_007          = 7
}

ScePvfFontVendorCountryCode :: enum c.int {
	GENERIC_COUNTRY_CODE  = 0,
	COUNTRY_JAPAN         = 1,
	COUNTRY_USA           = 2,
	COUNTRY_KOREA         = 3
}

ScePvfBoolValue :: enum c.int {
	FALSE       = 0,
	TRUE        = 1
}

ScePvfSubstyle :: enum c.int {
	VERTICALLAYOUT = 0x0001,
	PSEUDO_BOLD    = 0x0002,
	PSEUDO_SLANT   = 0x0004
}

ScePvfDataAccessMode :: enum c.int {
	FILEBASEDSTREAM     = 0,
	MEMORYBASEDSTREAM   = 1
}

ScePvfU32 :: c.uint
ScePvfS32 :: c.int
ScePvfU16 :: c.ushort
ScePvfU8  :: c.uchar
ScePvfFloat32 :: c.float
ScePvfBool :: ScePvfU32
ScePvfLibId :: rawptr
ScePvfFontId :: rawptr
ScePvfPointer :: rawptr
ScePvfHandle :: rawptr
ScePvfError :: ScePvfS32
ScePvfInt :: ScePvfS32
ScePvfCharCode :: ScePvfU16
ScePvfFontIndex :: ScePvfS32

ScePvfIrect :: struct {
  width: ScePvfU16,
	height: ScePvfU16,
}
#assert(size_of(ScePvfIrect) == 4)

ScePvfRect :: struct {
  width: ScePvfU32,
	height: ScePvfU32,
}
#assert(size_of(ScePvfRect) == 8)

ScePvfFontCacheLockFunc :: #type ^proc "c" (cacheInstance: ScePvfPointer) -> ScePvfS32

ScePvfFontChcheUnlockFunc :: #type ^proc "c" (cacheInstance: ScePvfPointer) -> ScePvfS32

ScePvfFontChcheFindFunc :: #type ^proc "c" (
  chcheInstance: ScePvfPointer,
	hashValue: ScePvfU32,
  key: ScePvfPointer,
  result: ^ScePvfBool) -> ScePvfPointer

ScePvfFontChcheWriteKeyValueToCacheFunc :: #type ^proc "c" (
  cacheInstance: ScePvfPointer,
	chcheSlot: ScePvfPointer,
  key: ScePvfPointer) -> ScePvfS32

ScePvfFontChcheWriteToCacheFunc :: #type ^proc "c" (
  cacheInstance: ScePvfPointer,
	cacheSlot: ScePvfPointer,
  data0: ScePvfPointer,
  size: ScePvfInt) -> ScePvfS32

ScePvfFontChcheReadFromCacheFunc :: #type ^proc "c" (
  cacheInstance: ScePvfPointer,
	cacheSlot: ScePvfPointer,
  data0: ScePvfPointer) -> ScePvfS32

ScePvfCacheSystemInterface :: struct {
	cacheInstance: ^ScePvfPointer,
	lockFunc: ScePvfFontCacheLockFunc,
	unlockFunc: ScePvfFontChcheUnlockFunc,
	findFunc: ScePvfFontChcheFindFunc,
	writeKeyValueToCacheFunc: ScePvfFontChcheWriteKeyValueToCacheFunc,
	write0ToCacheFunc: ScePvfFontChcheWriteToCacheFunc,
	write1ToCacheFunc: ScePvfFontChcheWriteToCacheFunc,
	read0FromCacheFunc: ScePvfFontChcheReadFromCacheFunc,
	read1FromCacheFunc: ScePvfFontChcheReadFromCacheFunc,
}

ScePvfAllocFunc :: #type ^proc "c" (userData: ScePvfPointer, size: ScePvfU32) -> ScePvfPointer

ScePvfReallocFunc :: #type ^proc "c" (
  userData: ScePvfPointer,
  old_ptr: ScePvfPointer,
	size: ScePvfU32) -> ScePvfPointer

ScePvfFreeFunc :: #type ^proc "c" (userData: ScePvfPointer, ptr: ScePvfPointer)

ScePvfInitRec :: struct {
  userData: ScePvfPointer,
	maxNumFonts: ScePvfU32,
	cache: ^ScePvfCacheSystemInterface,
	reserved: ScePvfPointer,
	allocFunc: ScePvfAllocFunc,
	reallocFunc: ScePvfReallocFunc,
	freeFunc: ScePvfFreeFunc,
}

ScePvfFontStyleInfo :: struct {
  weight: ScePvfFloat32,
	familyCode: ScePvfU16,
	style: ScePvfU16,
	subStyle: ScePvfU16, //<! One of ::ScePvfSubstyle
	languageCode: ScePvfU16,
	regionCode: ScePvfU16,
	countryCode: ScePvfU16,
	fontName: [SCE_PVF_FONTNAME_LENGTH]ScePvfU8,
	styleName: [SCE_PVF_STYLENAME_LENGTH]ScePvfU8,
	fileName: [SCE_PVF_FONTFILENAME_LENGTH]ScePvfU8,
	extraAttributes: ScePvfU32,
	expireDate: ScePvfU32,
}
#assert(size_of(ScePvfFontStyleInfo) == 0xD8)

ScePvfUserImageBufferRec :: struct {
  pixelFormat: ScePvfU32,
	xPos64: ScePvfS32,
	yPos64: ScePvfS32,
	rect: ScePvfIrect,
	bytesPerLine: ScePvfU16,
	reserved: ScePvfU16,
	buffer: [^]ScePvfU8,
}

ScePvfIGlyphMetricsInfo :: struct {
  width64: ScePvfU32,
	height64: ScePvfU32,
	ascender64: ScePvfS32,
	descender64: ScePvfS32,
	horizontalBearingX64: ScePvfS32,
	horizontalBearingY64: ScePvfS32,
	verticalBearingX64: ScePvfS32,
	verticalBearingY64: ScePvfS32,
	horizontalAdvance64: ScePvfS32,
	verticalAdvance64: ScePvfS32,
}
#assert(size_of(ScePvfIGlyphMetricsInfo) == 0x28)

ScePvfCharInfo :: struct {
  bitmapWidth: ScePvfU32,
	bitmapHeight: ScePvfU32,
	bitmapPitch: ScePvfU32,
	bitmapLeft: ScePvfS32,
	bitmapTop: ScePvfS32,
	glyphMetrics: ScePvfIGlyphMetricsInfo,
	reserved0: [2]ScePvfU8,
	reserved1: ScePvfU16,
}
#assert(size_of(ScePvfCharInfo) == 0x40)

ScePvfFGlyphMetricsInfo :: struct {
  width: ScePvfFloat32,
	height: ScePvfFloat32,
	ascender: ScePvfFloat32,
	descender: ScePvfFloat32,
	horizontalBearingX: ScePvfFloat32,
	horizontalBearingY: ScePvfFloat32,
	verticalBearingX: ScePvfFloat32,
	verticalBearingY: ScePvfFloat32,
	horizontalAdvance: ScePvfFloat32,
	verticalAdvance: ScePvfFloat32,
}
#assert(size_of(ScePvfFGlyphMetricsInfo) == 0x28)

ScePvfFontInfo :: struct {
  maxIGlyphMetrics: ScePvfIGlyphMetricsInfo,
	maxFGlyphMetrics: ScePvfFGlyphMetricsInfo,
	numChars: ScePvfU32,
	fontStyleInfo: ScePvfFontStyleInfo,
	reserved: [4]ScePvfU8,
}
#assert(size_of(ScePvfFontInfo) == 0x130)

ScePvfIKerningInfo :: struct {
  xOffset64: ScePvfS32,
	yOffset64: ScePvfS32,
}
#assert(size_of(ScePvfIKerningInfo) == 8)

ScePvfFKerningInfo :: struct {
  xOffset: ScePvfFloat32,
	yOffset: ScePvfFloat32,
}
#assert(size_of(ScePvfFKerningInfo) == 8)

ScePvfKerningInfo :: struct {
  iKerningInfo: ScePvfIKerningInfo,
	fKerningInfo: ScePvfFKerningInfo,
}
#assert(size_of(ScePvfKerningInfo) == 0x10)

ScePvfCacheKey :: struct {
  keyValue0: c.int,
	keyValue1: c.int,
	keyValue2: c.float,
	keyValue3: c.float,
	keyValue4: c.float,
	keyValue5: c.float,
	keyValue6: c.float,
	keyValue7: c.float,
	keyValue8: c.float,
}
#assert(size_of(ScePvfCacheKey) == 0x24)

scePvfGetCharGlyphImageClip :: scePvfGetCharGlyphImage_Clip

foreign pvf {
	scePvfNewLib :: proc(initParam: ^ScePvfInitRec, errorCode: ScePvfError) -> ScePvfLibId ---
	scePvfDoneLib :: proc(libID: ScePvfLibId) -> ScePvfError ---
	scePvfSetEM :: proc(libID: ScePvfLibId, emValue: ScePvfFloat32) -> ScePvfError ---
	scePvfSetResolution :: proc(libID: ScePvfLibId, hResolution: ScePvfFloat32, vResolution: ScePvfFloat32) -> ScePvfError ---
	scePvfGetNumFontList :: proc(libID: ScePvfLibId, errorCode: ScePvfError) -> ScePvfInt ---
	scePvfGetFontList :: proc(libID: ScePvfLibId, fontStyleInfo: ^ScePvfFontStyleInfo, arraySize: ScePvfInt) -> ScePvfError ---
	scePvfFindOptimumFont :: proc(libID: ScePvfLibId, fontStyleInfo: ^ScePvfFontStyleInfo, errorCode: ScePvfError) -> ScePvfFontIndex ---
	scePvfFindFont :: proc(libID: ScePvfLibId, fontStyleInfo: ^ScePvfFontStyleInfo, errorCode: ScePvfError) -> ScePvfFontIndex ---
	scePvfGetFontInfoByIndexNumber :: proc(libID: ScePvfLibId, fontStyleInfo: ^ScePvfFontStyleInfo, fontIndex: ScePvfFontIndex) -> ScePvfError ---
	scePvfOpen :: proc(libID: ScePvfLibId, fontIndex: ScePvfFontIndex, mode: ScePvfU32, errorCode: ScePvfError) -> ScePvfFontId ---
	scePvfOpenUserFile :: proc(libID: ScePvfLibId, filename: ScePvfPointer, mode: ScePvfU32, errorCode: ScePvfError) -> ScePvfFontId ---
	scePvfOpenUserFileWithSubfontIndex :: proc(libID: ScePvfLibId, filename: ScePvfPointer, mode: ScePvfU32, subFontIndex: ScePvfU32, errorCode: ScePvfError) -> ScePvfFontId ---
	scePvfOpenUserMemory :: proc(libID: ScePvfLibId, addr: ScePvfPointer, size: ScePvfU32, errorCode: ScePvfError) -> ScePvfFontId ---
	scePvfOpenUserMemoryWithSubfontIndex :: proc(libID: ScePvfLibId, addr: ScePvfPointer, size: ScePvfU32, subFontIndex: ScePvfU32, errorCode: ScePvfError) -> ScePvfFontId ---
	scePvfOpenDefaultJapaneseFontOnSharedMemory :: proc(libID: ScePvfLibId, errorCode: ScePvfError) -> ScePvfFontId ---
	scePvfOpenDefaultLatinFontOnSharedMemory :: proc(libID: ScePvfLibId, errorCode: ScePvfError) -> ScePvfFontId ---
	scePvfClose :: proc(fontID: ScePvfFontId) -> ScePvfError ---
	scePvfFlush :: proc(fontID: ScePvfFontId) -> ScePvfError ---
	scePvfSetCharSize :: proc(fontID: ScePvfFontId, hSize: ScePvfFloat32, vSize: ScePvfFloat32) -> ScePvfError ---
	scePvfSetEmboldenRate :: proc(fontID: ScePvfFontId, emboldenRate: ScePvfFloat32) -> ScePvfError ---
	scePvfSetSkewValue :: proc(fontID: ScePvfFontId, angleX: ScePvfFloat32, angleY: ScePvfFloat32) -> ScePvfError ---
	scePvfIsElement :: proc(fontID: ScePvfFontId, charCode: ScePvfCharCode) -> ScePvfBool ---
	scePvfGetFontInfo :: proc(fontID: ScePvfFontId, fontInfo: ^ScePvfFontInfo) -> ScePvfError ---
	scePvfGetCharInfo :: proc(fontID: ScePvfFontId, charCode: ScePvfCharCode, charInfo: ^ScePvfCharInfo) -> ScePvfError ---
	scePvfGetKerningInfo :: proc(fontID: ScePvfFontId, leftCharCode: ScePvfCharCode, rightCharCode: ScePvfCharCode, pKerningInfo: ^ScePvfKerningInfo) -> ScePvfError ---
	scePvfGetCharImageRect :: proc(fontID: ScePvfFontId, charCode: ScePvfCharCode, rect: ^ScePvfIrect) -> ScePvfError ---
	scePvfGetCharGlyphImage :: proc(fontID: ScePvfFontId, charCode: ScePvfCharCode, imageBuffer: ^ScePvfUserImageBufferRec) -> ScePvfError ---
	scePvfGetCharGlyphImage_Clip :: proc(fontID: ScePvfFontId, charCode: ScePvfCharCode, imageBuffer: ^ScePvfUserImageBufferRec, clipX: ScePvfS32, clipY: ScePvfS32, clipWidth: ScePvfU32, clipHeight: ScePvfU32) -> ScePvfError ---
	scePvfPixelToPointH :: proc(libID: ScePvfLibId, pixel: ScePvfFloat32, errorCode: ScePvfError) -> ScePvfFloat32 ---
	scePvfPixelToPointV :: proc(libID: ScePvfLibId, pixel: ScePvfFloat32, errorCode: ScePvfError) -> ScePvfFloat32 ---
	scePvfPointToPixelH :: proc(libID: ScePvfLibId, point: ScePvfFloat32, errorCode: ScePvfError) -> ScePvfFloat32 ---
	scePvfPointToPixelV :: proc(libID: ScePvfLibId, point: ScePvfFloat32, errorCode: ScePvfError) -> ScePvfFloat32 ---
	scePvfSetAltCharacterCode :: proc(libID: ScePvfLibId, charCode: ScePvfCharCode) -> ScePvfError ---
}

