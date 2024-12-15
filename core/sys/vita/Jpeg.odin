#+build vita
package vita

import "core:c"

foreign import jpeg "system:SceJpeg_stub"
foreign import jpegarm "system:SceJpegArm_stub"
foreign import jpegenc "system:SceJpegEnc_stub"
foreign import jpegencarm "system:SceJpegEncArm_stub"
foreign import jpegkern "system:SceAvcodecForDriver_stub"

SceJpegMJpegInitParam :: struct {
    size: SceSize,
    decoderCount: SceInt32,
    options: SceInt32,
}
#assert(size_of(SceJpegMJpegInitParam) == 0xC)

SceJpegPitch :: struct {
  x: SceUInt32,
    y: SceUInt32,
}
#assert(size_of(SceJpegPitch) == 8)

SceJpegOutputInfo :: struct {
  colorSpace: SceInt32,
    width: SceUInt16,
    height: SceUInt16,
    outputSize: SceUInt32,
    unk_0xc: SceUInt32,
    unk_0x10: SceUInt32,
    pitch: [4]SceJpegPitch,
}
#assert(size_of(SceJpegOutputInfo) == 0x34)


SceJpegArmErrorCode :: enum c.int {
    OK = 0
}


SceJpegEncoderInitParamOption :: enum c.int {
	NONE          = 0,  //!< Default option
	LPDDR2_MEMORY = 1   //!< LPDDR2 memory will be used instead of CDRAM
}

SceJpegEncoderInitParam :: struct {
  size: SceSize,        //!< Size of this structure
	inWidth: c.int,     //!< Input width in pixels
	inHeight: c.int,    //!< Input height in pixels
	pixelFormat: c.int, //!< A valid ::SceJpegEncoderPixelFormat set of values
	outBuffer: rawptr,  //!< A physically continuous memory block 256 bytes aligned
	outSize: SceSize,     //!< Output size in bytes
	option: c.int,      //!< Additional options, OR of ::SceJpegEncoderInitParamOption
}


SCE_JPEGENCARM_MIN_COMP_RATIO     :: 1   //!< Lowest compression ratio, best quality.
SCE_JPEGENCARM_DEFAULT_COMP_RATIO :: 64  //!< Default compression ratio.
SCE_JPEGENCARM_MAX_COMP_RATIO     :: 255 //!< Highest compression ratio, lowest quality.

/**
 * Dynamically allocated encoder context.
 *
 * See @ref sceJpegArmEncoderGetContextSize() for required allocation size.
 * The address must be 4 byte aligned.
 */
SceJpegArmEncoderContext :: rawptr

/**
 * Error Codes
 */
SceJpegEncArmErrorCode :: enum c.uint {
	/**
	 * The image dimensions given are not supported, or are larger
	 * than those set at initialization.
	 */
	IMAGE_SIZE                = 0x80650300,
	/**
	 * The output buffer provided is not of sufficient size.
	 */
	INSUFFICIENT_BUFFER       = 0x80650301,
	/**
	 * The compression ratio given is not within the valid range.
	 */
	INVALID_COMP_RATIO        = 0x80650302,
	/**
	 * The pixelformat given is not one of ::SceJpegArmEncoderPixelFormat.
	 */
	INVALID_PIXELFORMAT       = 0x80650303,
	/**
	 * The headerMode given is not one of ::SceJpegArmEncoderHeaderMode.
	 */
	INVALID_HEADER_MODE       = 0x80650304,
	/**
	 * A null or badly aligned pointer was given.
	 */
	INVALID_POINTER           = 0x80650305
}

/**
 * Pixel Formats
 */
SceJpegArmEncoderPixelFormat :: enum c.int {
	YCBCR420       = 8,  //!< YCbCr420 format
	YCBCR422       = 9   //!< YCbCr422 format
}

/**
 * JPEG Header Modes
 */
SceJpegArmEncoderHeaderMode :: enum c.int {
	JPEG  = 0,  //!< JPEG header mode
	MJPEG = 1   //!< MJPEG header mode
}

SceJpegEncoderContext :: rawptr

SceJpegEncErrorCode :: enum c.uint {
	IMAGE_SIZE                = 0x80650200,
	INSUFFICIENT_BUFFER       = 0x80650201,
	INVALID_COMPRATIO         = 0x80650202,
	INVALID_PIXELFORMAT       = 0x80650203,
	INVALID_HEADER_MODE       = 0x80650204,
	INVALID_POINTER           = 0x80650205,
	NOT_PHY_CONTINUOUS_MEMORY = 0x80650206
}

SceJpegEncoderPixelFormat :: enum c.int {
	ARGB8888 = 0,       //!< ARGB8888 format
	YCBCR420 = 8,       //!< YCbCr420 format
	YCBCR422 = 9,       //!< YCbCr422 format
	CSC_ARGB_YCBCR = 16 //!< ARGB to YCbCr color conversion flag
}

SceJpegEncoderHeaderMode :: enum c.int {
	JPEG = 0,   //!< JPEG header mode
	MJPEG = 1   //!< MJPEG header mode
}

foreign jpeg {
  sceJpegInitMJpeg :: proc(decoderCount: SceInt32) -> c.int ---

  sceJpegInitMJpegWithParam :: proc(#by_ptr params: SceJpegMJpegInitParam) -> c.int ---

  sceJpegFinishMJpeg :: proc() -> c.int ---

  sceJpegGetOutputInfo :: proc(jpegData: [^]SceUInt8,
  jpegSize: SceSize,
  format: SceInt32,
  mode: SceInt32,
  output: ^SceJpegOutputInfo) -> c.int ---

  sceJpegDecodeMJpegYCbCr :: proc(jpegData: [^]SceUInt8,
  jpegSize: SceSize,
  mode: SceInt32,
  output: [^]SceUInt8,
  outputSize: SceSize,
  buffer: rawptr,
  bufferSize: SceSize) -> c.int ---

  sceJpegMJpegCsc :: proc(rgba: [^]SceUInt8,
  yuv: [^]SceUInt8,
  yuvSize: SceSize,
  imageWidth: SceInt32,
  format: SceInt32,
  sampling: SceInt32) -> c.int ---
}
 
foreign jpegarm {
  sceJpegArmDecodeMJpeg :: proc(pJpeg: [^]SceUInt8,
  isize: SceSize,
  decodeMode: SceInt,
  pRGBA: rawptr,
  osize: SceSize,
  pCoefBuffer: rawptr,
  coefBufferSize: SceSize) -> c.int ---

  sceJpegArmDecodeMJpegYCbCr :: proc(pJpeg: [^]SceUInt8,
  isize: SceSize,
  decodeMode: SceInt,
  pYCbCr: [^]SceUInt8,
  osize: SceSize,
  pCoefBuffer: rawptr,
  coefBufferSize: SceSize) -> c.int ---

  sceJpegArmGetOutputInfo :: proc(pJpeg: [^]SceUInt8,
  isize: SceSize,
  decodeMode: SceInt,
  outputFormat: SceInt,
  pOutputInfo: ^SceJpegOutputInfo) -> c.int ---
}

foreign jpegenc {
  /**
  * Initialize a jpeg encoder
  *
  * @param[in] _context - A pointer to a big enough allocated memory block
  * @param[in] inWidth - Input width in pixels
  * @param[in] inHeight - Input height in pixels
  * @param[in] pixelformat - A valid ::SceJpegEncoderPixelFormat set of values
  * @param[in] outBuffer - A physically continuous memory block 256 bytes aligned
  * @param[in] outSize - Output size in bytes
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderInit :: proc(_context: SceJpegEncoderContext, inWidth: c.int, inHeight: c.int, pixelformat: SceJpegEncoderPixelFormat, outBuffer: rawptr, outSize: SceSize) -> c.int ---

  /**
  * Initialize a jpeg encoder with param
  *
  * @param[in] initParam - A pointer to the initialization parameters
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderInitWithParam :: proc(_context: SceJpegEncoderContext, #by_ptr initParam: SceJpegEncoderInitParam) -> c.int ---

  /**
  * Terminate a jpeg encoder
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderEnd :: proc(_context: SceJpegEncoderContext) -> c.int ---

  /**
  * Execute a jpeg encode
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] inBuffer - A physically continuous memory block 256 bytes aligned
  *
  * @return encoded jpeg size on success, < 0 on error.
  */
  sceJpegEncoderEncode :: proc(_context: SceJpegEncoderContext, inBuffer: rawptr) -> c.int ---

  /**
  * Set encoder compression ratio
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] ratio - A value between 0 and 255 (higher = better compression, lower = better speed)
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderSetCompressionRatio :: proc(_context: SceJpegEncoderContext, ratio: c.int) -> c.int ---


  /**
  * Set encoder output address
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] outBuffer - A physically continuous memory block 256 bytes aligned
  * @param[in] outSize - Output buffer size in bytes
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderSetOutputAddr :: proc(_context: SceJpegEncoderContext, outBuffer: rawptr, outSize: SceSize) -> c.int ---

  /**
  * Execute a color conversion from ARGB to YCbCr
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] outBuffer - A physical continuous memory block 256 bytes aligned
  * @param[in] inBuffer - A pointer to a valid ARGB buffer
  * @param[in] inPitch - Input pitch value in pixels
  * @param[in] inPixelFormat - A valid ::SceJpegEncoderPixelFormat set of values
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderCsc :: proc(_context: SceJpegEncoderContext, outBuffer: rawptr, inBuffer: rawptr, inPitch: c.int, inPixelFormat: SceJpegEncoderPixelFormat) -> c.int ---

  /**
  * Return required free size to allocate a jpeg encoder
  *
  * @return Required free memory size in bytes, < 0 on error.
  */
  sceJpegEncoderGetContextSize :: proc() -> c.int ---

  /**
  * Set encoder valid region (?)
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] inWidth - Input width in pixels
  * @param[in] inHeight - Input height in pixels
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderSetValidRegion :: proc(_context: SceJpegEncoderContext, inWidth: c.int, inHeight: c.int) -> c.int ---

  /**
  * Set header used for output file
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] mode - One of ::SceJpegEncoderHeaderMode
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegEncoderSetHeaderMode :: proc(_context: SceJpegEncoderContext, mode: c.int) -> c.int ---
}

foreign jpegencarm {
  /**
  * Get required size of _context memory.
  *
  * @return Required size of allocated memory.
  */
  sceJpegArmEncoderGetContextSize :: proc() -> SceSize ---

  /**
  * Initialize a JPEG encoder.
  *
  * @param[in] _context     - An allocated encoder _context of appropriate size.
  * @param[in] inWidth     - Input width in pixels.
  * @param[in] inHeight    - Input height in pixels.
  * @param[in] pixelformat - One of ::SceJpegArmEncoderPixelFormat.
  * @param[in] outBuffer   - A sufficiently sized 8 byte aligned output buffer.
  * @param[in] outSize     - Output buffer size in bytes.
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegArmEncoderInit :: proc(_context: SceJpegArmEncoderContext, inWidth: SceUInt16, inHeight: SceUInt16, pixelformat: SceJpegArmEncoderPixelFormat, outBuffer: rawptr, outSize: SceSize) -> c.int ---

  /**
  * Terminate a JPEG encoder.
  *
  * @param[in] _context - An already initialized ::SceJpegArmEncoderContext.
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegArmEncoderEnd :: proc(_context: SceJpegArmEncoderContext) -> c.int ---

  /**
  * Execute a JPEG encode.
  *
  * @param[in] _context  - An already initialized ::SceJpegArmEncoderContext.
  * @param[in] inBuffer - An 8 byte aligned memory block of color data.
  *
  * @return Encoded JPEG size on success, < 0 on error.
  */
  sceJpegArmEncoderEncode :: proc(_context: SceJpegArmEncoderContext, inBuffer: rawptr) -> c.int ---

  /**
  * Set the encoder compression ratio.
  *
  * @param[in] _context - An already initialized ::SceJpegArmEncoderContext.
  * @param[in] ratio   - A value between 1 and 255 (higher = better compression, lower = better speed).
  *
  * See @ref SCE_JPEGENCARM_DEFAULT_COMP_RATIO for the default compression ratio.
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegArmEncoderSetCompressionRatio :: proc(_context: SceJpegArmEncoderContext, ratio: SceUInt8) -> c.int ---

  /**
  * Set encoder output address.
  *
  * @param[in] _context   - An already initialized ::SceJpegArmEncoderContext.
  * @param[in] outBuffer - A sufficiently sized 8 byte aligned output buffer.
  * @param[in] outSize   - Output buffer size in bytes.
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegArmEncoderSetOutputAddr :: proc(_context: SceJpegArmEncoderContext, outBuffer: rawptr, outSize: SceSize) -> c.int ---

  /**
  * Set the region of the image to be encoded as JPEG. The encoded region starts
  * from (0,0), which is the top left of the image, and expands outward by regionWidth and regionHeight.
  *
  * @param[in] _context      - An already initialized ::SceJpegArmEncoderContext.
  * @param[in] regionWidth  - Width of the region in pixels.
  * @param[in] regionHeight - Height of the region in pixels.
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegArmEncoderSetValidRegion :: proc(_context: SceJpegArmEncoderContext, regionWidth: SceUInt16, regionHeight: SceUInt16) -> c.int ---

  /**
  * Set header used for output file.
  *
  * @param[in] _context - An already initialized ::SceJpegArmEncoderContext.
  * @param[in] mode    - One of ::SceJpegArmEncoderHeaderMode.
  *
  * @return 0 on success, < 0 on error.
  */
  sceJpegArmEncoderSetHeaderMode :: proc(_context: SceJpegArmEncoderContext, mode: SceJpegArmEncoderHeaderMode) -> c.int ---
}

foreign jpegkern {
  /**
  * Initialize a jpeg encoder
  *
  * @param[in] _context - A pointer to a big enough allocated memory block
  * @param[in] inWidth - Input width in pixels
  * @param[in] inHeight - Input height in pixels
  * @param[in] pixelformat - A valid ::SceJpegEncoderPixelFormat set of values
  * @param[in] outBuffer - A physically continuous memory block 256 bytes aligned
  * @param[in] outSize - Output size in bytes
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderInit :: proc(_context: SceJpegEncoderContext, inWidth: c.int, inHeight: c.int, pixelformat: SceJpegEncoderPixelFormat, outBuffer: rawptr, outSize: SceSize) -> c.int ---

  /**
  * Terminate a jpeg encoder
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderEnd :: proc(_context: SceJpegEncoderContext) -> c.int ---

  /**
  * Execute a jpeg encode
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] inBuffer - A physically continuous memory block 256 bytes aligned
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderEncode :: proc(_context: SceJpegEncoderContext, inBuffer: rawptr) -> c.int ---

  /**
  * Set encoder compression ratio
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] ratio - A value between 0 and 255 (higher = better compression, lower = better speed)
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderSetCompressionRatio :: proc(_context: SceJpegEncoderContext, ratio: c.int) -> c.int ---


  /**
  * Set encoder output address
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] outBuffer - A physically continuous memory block 256 bytes aligned
  * @param[in] outSize - Output buffer size in bytes
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderSetOutputAddr :: proc(_context: SceJpegEncoderContext, outBuffer: rawptr, outSize: SceSize) -> c.int ---

  /**
  * Execute a color conversion from ARGB to YCbCr
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] outBuffer - A physical continuous memory block 256 bytes aligned
  * @param[in] inBuffer - A pointer to a valid ARGB buffer
  * @param[in] inPitch - Input pitch value in pixels
  * @param[in] inPixelFormat - A valid ::SceJpegEncoderPixelFormat set of values
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderCsc :: proc(_context: SceJpegEncoderContext, outBuffer: rawptr, inBuffer: rawptr, inPitch: c.int, inPixelFormat: SceJpegEncoderPixelFormat) -> c.int ---

  /**
  * Return required free size to allocate a jpeg encoder
  *
  * @return Required free memory size in bytes, < 0 on error.
  */
  ksceJpegEncoderGetContextSize :: proc() -> c.int ---

  /**
  * Set encoder valid region (?)
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] inWidth - Input width in pixels
  * @param[in] inHeight - Input height in pixels
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderSetValidRegion :: proc(_context: SceJpegEncoderContext, inWidth: c.int, inHeight: c.int) -> c.int ---

  /**
  * Set header used for output file
  *
  * @param[in] _context - A pointer to an already initialized ::SceJpegEncoderContext
  * @param[in] mode - One of ::SceJpegEncoderHeaderMode
  *
  * @return 0 on success, < 0 on error.
  */
  ksceJpegEncoderSetHeaderMode :: proc(_context: SceJpegEncoderContext, mode: c.int) -> c.int ---
}

