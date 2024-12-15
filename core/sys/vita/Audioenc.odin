#+build vita
package vita

import "core:c"

foreign import audioenc "system:SceAudioenc_stub"

SceAudioencErrorCode :: enum c.uint {
	API_FAIL             = 0x80860000,
	INVALID_TYPE         = 0x80860001,
	INVALID_INIT_PARAM   = 0x80860002,
	ALREADY_INITIALIZED  = 0x80860003,
	OUT_OF_MEMORY        = 0x80860004,
	NOT_INITIALIZED      = 0x80860005,
	A_HANDLE_IN_USE      = 0x80860006,
	ALL_HANDLES_IN_USE   = 0x80860007,
	INVALID_PTR          = 0x80860008,
	INVALID_HANDLE       = 0x80860009,
	NOT_HANDLE_IN_USE    = 0x8086000A,
	CH_SHORTAGE          = 0x8086000B,
	INVALID_WORD_LENGTH  = 0x8086000C,
	INVALID_SIZE         = 0x8086000D,
	INVALID_ALIGNMENT    = 0x8086000E,
	UNSUPPORTED          = 0x8086000F
}

SceAudioencCelpErrorCode :: enum c.uint {
	INVALID_CONFIG  = 0x80861001
}

SCE_AUDIOENC_WORD_LENGTH_16BITS         :: 16      //!< Definition of wordlength
SCE_AUDIOENC_TYPE_CELP                  : c.uint : 0x2006 //!< Audio encoder type
SCE_AUDIOENC_CELP_MAX_STREAMS           :: 1       //!< Max number of streams
SCE_AUDIOENC_CELP_MAX_SAMPLES           :: 320     //!< Max number of samples
SCE_AUDIOENC_CELP_MAX_ES_SIZE           :: 24      //!< Max elementary stream size
SCE_AUDIOENC_CELP_MPE                   :: (0)     //!< CELP encoder default excitation mode
SCE_AUDIOENC_CELP_SAMPLING_RATE_8KHZ    :: (8000)  //!< CELP encoder default sampling rate

SceAudioencCelpBitrate :: enum c.int {
	BIT_RATE_3850BPS  = 3850,
	BIT_RATE_4650BPS  = 4650,
	BIT_RATE_5700BPS  = 5700,
	BIT_RATE_6600BPS  = 6600,
	BIT_RATE_7300BPS  = 7300,
	BIT_RATE_8700BPS  = 8700,
	BIT_RATE_9900BPS  = 9900,
	BIT_RATE_10700BPS = 10700,
	BIT_RATE_11800BPS = 11800,
	BIT_RATE_12200BPS = 12200
}

/** Initialization structure to provide to ::SceAudioencInitParam */
SceAudioencInitStreamParam :: struct {
  size: SceSize,               //!< sizeof(SceAudioencInitStreamParam)
	totalStreams: c.uint,  //!< Total number of audio streams
}
#assert(size_of(SceAudioencInitStreamParam) == 8)

/** Information structure for CELP */
SceAudioencInfoCelp :: struct {
  size: SceSize,                    //!< sizeof(SceAudioencInfoCelp)
	excitationMode: c.uint,     //!< Excitation mode
	samplingRate: c.uint,       //!< Sampling rate
	bitRate: c.uint,            //!< Bit rate (one of ::SceAudioencCelpBitrate)
}
#assert(size_of(SceAudioencInfoCelp) == 0x10)

/** Optional information structure for CELP */
SceAudioencOptInfoCelp :: struct {
  size: SceSize,                  //!< sizeof(SceAudioencOptInfoCelp)
	header: [32]c.uint8_t,            //!< Header buffer
	headerSize: SceSize,            //!< Header size
	encoderVersion: c.uint,   //!< Encoder version
}
#assert(size_of(SceAudioencOptInfoCelp) == 0x2C)

/** Initialization structure to pass as argument to ::sceAudioencInitLibrary */
SceAudioencInitParam :: struct #raw_union {
  size: SceSize,                     //!< sizeof(SceAudioencInitParam)
	celp: SceAudioencInitStreamParam,  //!< See ::SceAudioencInitStreamParam
}
#assert(size_of(SceAudioencInitParam) == 8)

SceAudioencInfo :: struct #raw_union {
  size: SceSize,              //!< sizeof(SceAudioencInfo)
	celp: SceAudioencInfoCelp,  //!< Information structure for CELP
}
#assert(size_of(SceAudioencInfo) == 0x10)

/** Audio encoder optional info */
SceAudioencOptInfo :: struct #raw_union {
  size: SceSize,                 //!< sizeof(SceAudioencOptInfo)
	celp: SceAudioencOptInfoCelp,  //!< Optional information structure for CELP
}
#assert(size_of(SceAudioencOptInfo) == 0x2C)

SceAudioencCtrl :: struct {
  size: SceSize,                   //!< sizeof(SceAudioencCtrl)
	handle: c.int,                     //!< Encoder handle
	pInputPcm: rawptr,                //!< Pointer to elementary stream
	inputPcmSize: SceSize,           //!< Size of elementary stream used actually (in byte)
	maxPcmSize: SceSize,             //!< Max size of elementary stream used (in byte)
	pOutputEs: rawptr,                //!< Pointer to PCM
	outputEsSize: SceSize,           //!< Size of PCM output actually (in byte)
	maxEsSize: SceSize,              //!< Max size of PCM output (in byte)
	wordLength: SceSize,             //!< PCM bit depth
	pInfo: ^SceAudioencInfo,         //!< Pointer to ::SceAudioencInfo
	pOptInfo: ^SceAudioencOptInfo,   //!< Pointer to ::SceAudioencOptInfo
}

foreign audioenc {
	sceAudioencInitLibrary :: proc(codecType: c.int, pInitParam: ^SceAudioencInitParam) -> c.int ---
	sceAudioencTermLibrary :: proc(codecType: c.uint) -> c.int ---
	sceAudioencCreateEncoder :: proc(pCtrl: ^SceAudioencCtrl, codecType: c.int) -> c.int ---
	sceAudioencDeleteEncoder :: proc(pCtrl: ^SceAudioencCtrl) -> c.int ---
	sceAudioencEncode :: proc(pCtrl: ^SceAudioencCtrl) -> c.int ---
	sceAudioencClearContext :: proc(pCtrl: ^SceAudioencCtrl) -> c.int ---
	sceAudioencGetOptInfo :: proc(pCtrl: ^SceAudioencCtrl) -> c.int ---
	sceAudioencGetInternalError :: proc(pCtrl: ^SceAudioencCtrl, pInternalError: ^c.int) -> c.int ---
}

