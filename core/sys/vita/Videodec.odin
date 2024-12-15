#+build vita
package vita

import "core:c"

foreign import videodec "system:SceVideodec_stub"

SceVideodecErrorCode :: enum c.uint {
	INVALID_TYPE                 = 0x80620801,
	INVALID_PARAM                = 0x80620802,
	OUT_OF_MEMORY                = 0x80620803,
	INVALID_STATE                = 0x80620804,
	UNSUPPORT_IMAGE_SIZE         = 0x80620805,
	INVALID_COLOR_FORMAT         = 0x80620806,
	NOT_PHY_CONTINUOUS_MEMORY    = 0x80620807,
	ALREADY_USED                 = 0x80620808,
	INVALID_POINTER              = 0x80620809,
	ES_BUFFER_FULL               = 0x8062080A,
	INITIALIZE                   = 0x8062080B,
	NOT_INITIALIZE               = 0x8062080C,
	INVALID_STREAM               = 0x8062080D,
	INVALID_ARGUMENT_SIZE        = 0x8062080E
}

SceVideodecType :: enum c.int {
	HW_AVCDEC = 0x1001
}

SceAvcdecErrorCode :: enum c.uint {
	INVALID_TYPE                 = 0x80620001,
	INVALID_PARAM                = 0x80620002,
	OUT_OF_MEMORY                = 0x80620003,
	INVALID_STATE                = 0x80620004,
	UNSUPPORT_IMAGE_SIZE         = 0x80620005,
	INVALID_COLOR_FORMAT         = 0x80620006,
	NOT_PHY_CONTINUOUS_MEMORY    = 0x80620007,
	ALREADY_USED                 = 0x80620008,
	INVALID_POINTER              = 0x80620009,
	ES_BUFFER_FULL               = 0x8062000A,
	INITIALIZE                   = 0x8062000B,
	NOT_INITIALIZE               = 0x8062000C,
	INVALID_STREAM               = 0x8062000D,
	INVALID_ARGUMENT_SIZE        = 0x8062000E
}

SceAvcdecPixelFormat :: enum c.int {
	RGBA8888             = 0x00,
	RGBA565              = 0x01,
	RGBA5551             = 0x02,
	YUV420_RASTER        = 0x10,
	YUV420_PACKED_RASTER = 0x20
}

SceVideodecQueryInitInfoHwAvcdec :: struct {
  size: c.uint32_t,				//!< sizeof(SceVideodecQueryInitInfoHwAvcdec)
	horizontal: c.uint32_t,
	vertical: c.uint32_t,
	numOfRefFrames: c.uint32_t,    //!< Number of reference frames to use
	numOfStreams: c.uint32_t,      //!< Must be set to 1
}
#assert(size_of(SceVideodecQueryInitInfoHwAvcdec) == 0x14)

SceVideodecQueryInitInfo :: struct #raw_union {
  reserved: [32]c.uint8_t,
	hwAvc: SceVideodecQueryInitInfoHwAvcdec,
}
#assert(size_of(SceVideodecQueryInitInfo) == 0x20)

SceVideodecTimeStamp :: struct {
  upper: c.uint32_t,
	lower: c.uint32_t,
}
#assert(size_of(SceVideodecTimeStamp) == 8)

SceAvcdecQueryDecoderInfo :: struct {
  horizontal: c.uint32_t,
	vertical: c.uint32_t,
	numOfRefFrames: c.uint32_t,  //!< Number of reference frames
}
#assert(size_of(SceAvcdecQueryDecoderInfo) == 0xC)

SceAvcdecDecoderInfo :: struct {
  frameMemSize: c.uint32_t,
}
#assert(size_of(SceAvcdecDecoderInfo) == 4)

SceAvcdecBuf :: struct {
  pBuf: rawptr,
	size: c.uint32_t,
}

SceAvcdecCtrl :: struct {
  handle: c.uint32_t,
	frameBuf: SceAvcdecBuf,
}

SceAvcdecAu :: struct {
  pts: SceVideodecTimeStamp,
	dts: SceVideodecTimeStamp,
	es: SceAvcdecBuf,
}

SceAvcdecInfo :: struct {
  numUnitsInTick: c.uint32_t,
	timeScale: c.uint32_t,
	fixedFrameRateFlag: c.uint8_t,

	aspectRatioIdc: c.uint8_t,
	sarWidth: c.uint16_t,
	sarHeight: c.uint16_t,

	colourPrimaries: c.uint8_t,
	transferCharacteristics: c.uint8_t,
	matrixCoefficients: c.uint8_t,

	videoFullRangeFlag: c.uint8_t,

	picStruct: [2]c.uint8_t,
	ctType: c.uint8_t,

	pts: SceVideodecTimeStamp,
}
#assert(size_of(SceAvcdecInfo) == 0x20)

SceAvcdecFrameOptionRGBA :: struct {
  alpha: c.uint8_t,
	cscCoefficient: c.uint8_t,
	reserved: [14]c.uint8_t,
}
#assert(size_of(SceAvcdecFrameOptionRGBA) == 0x10)

SceAvcdecFrameOption :: struct #raw_union {
  reserved: [16]c.uint8_t,
	rgba: SceAvcdecFrameOptionRGBA,
}
#assert(size_of(SceAvcdecFrameOption) == 0x10)

SceAvcdecFrame :: struct {
  pixelType: c.uint32_t,     //!< One of ::SceAvcdecPixelFormat
	framePitch: c.uint32_t,
	frameWidth: c.uint32_t,
	frameHeight: c.uint32_t,

	horizontalSize: c.uint32_t,
	verticalSize: c.uint32_t,

	frameCropLeftOffset: c.uint32_t,
	frameCropRightOffset: c.uint32_t,
	frameCropTopOffset: c.uint32_t,
	frameCropBottomOffset: c.uint32_t,

	opt: SceAvcdecFrameOption,

	pPicture: [2]rawptr,   //!< address of picture buffer
}

SceAvcdecPicture :: struct {
  size: c.uint32_t,
	frame: SceAvcdecFrame,
	info: SceAvcdecInfo,
}

SceAvcdecArrayPicture :: struct {
  numOfOutput: c.uint32_t, //!< Number of outputs
	numOfElm: c.uint32_t,    //!< Number of elements
	pPicture: ^^SceAvcdecPicture,
}

foreign videodec {
	/**
	* @param[in] codec - See ::SceVideodecType
	* @param[in] initInfo - See ::SceVideodecQueryInitInfoHwAvcdec
	*
	* @return 0 on success, < 0 on error.
	*/
	sceVideodecInitLibrary :: proc(codec: SceVideodecType, #by_ptr initInfo: SceVideodecQueryInitInfoHwAvcdec) -> c.int ---

	/**
	* @param[in] codec - See ::SceVideodecType
	*
	* @return 0 on success, < 0 on error.
	*/
	sceVideodecTermLibrary :: proc(codec: SceVideodecType) -> c.int ---

	/**
	* @param[in] codec - See ::SceVideodecType
	* @param[in] query - Should be copy from ::SceVideodecQueryInitInfoHwAvcdec.
	* @param[out] decoderInfo - Must be initialized with zeros.
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvcdecQueryDecoderMemSize :: proc(codec: SceVideodecType, #by_ptr query: SceAvcdecQueryDecoderInfo, decoderInfo: ^SceAvcdecDecoderInfo) -> c.int ---

	/**
	* @param[in] codec - See ::SceVideodecType
	* @param[out] decoder - Must be initialized frameBuf.size and frameBuf.pBuf
	* @param[in] query - Should be copy from ::SceVideodecQueryInitInfoHwAvcdec.
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvcdecCreateDecoder :: proc(codec: SceVideodecType, decoder: ^SceAvcdecCtrl, #by_ptr query: SceAvcdecQueryDecoderInfo) -> c.int ---

	/**
	* @param[in] decoder - A ::SceAvcdecCtrl decoder initialized with ::sceAvcdecCreateDecoder
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvcdecDeleteDecoder :: proc(decoder: ^SceAvcdecCtrl) -> c.int ---

	/**
	* @param[in] decoder
	* @param[in] au - Must set buffer information(es) and be initialized timestamps with 0xFFFFFFFF
	* @param[out] array_picture - Must set numOfElm and pPicture. See ::SceAvcdecArrayPicture
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvcdecDecode :: proc(#by_ptr decoder: SceAvcdecCtrl, #by_ptr au: SceAvcdecAu, array_picture: [^]SceAvcdecArrayPicture) -> c.int ---
}


