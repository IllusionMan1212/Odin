#+build vita
package vita

import "core:c"

foreign import atrac "system:SceAtrac_stub"

SceAtracErrorCode :: enum c.uint {
	INVALID_POINTER               = 0x80630000,
	INVALID_SIZE                  = 0x80630001,
	INVALID_WORD_LENGTH           = 0x80630002,
	INVALID_TYPE                  = 0x80630003,
	INVALID_TOTAL_CH              = 0x80630004,
	INVALID_ALIGNMENT             = 0x80630005,
	ALREADY_CREATED               = 0x80630006,
	NOT_CREATED                   = 0x80630007,
	SHORTAGE_OF_CH                = 0x80630008,
	UNSUPPORTED_DATA              = 0x80630009,
	INVALID_DATA                  = 0x8063000A,
	READ_SIZE_IS_TOO_SMALL        = 0x8063000B,
	INVALID_HANDLE                = 0x8063000C,
	READ_SIZE_OVER_BUFFER         = 0x8063000D,
	MAIN_BUFFER_SIZE_IS_TOO_SMALL = 0x8063000E,
	SUB_BUFFER_SIZE_IS_TOO_SMALL  = 0x8063000F,
	DATA_SHORTAGE_IN_BUFFER       = 0x80630010,
	ALL_DATA_WAS_DECODED          = 0x80630011,
	INVALID_MAX_OUTPUT_SAMPLES    = 0x80630012,
	ADDED_DATA_IS_TOO_BIG         = 0x80630013,
	NEED_SUB_BUFFER               = 0x80630014,
	INVALID_SAMPLE                = 0x80630015,
	NO_NEED_SUB_BUFFER            = 0x80630016,
	INVALID_LOOP_STATUS           = 0x80630017,
	REMAIN_VALID_HANDLE           = 0x80630018,
	INVALID_LOOP_NUM              = 0x80630030
}

/* Memory alignment size */
SCE_ATRAC_ALIGNMENT_SIZE :: (SCE_AUDIODEC_ALIGNMENT_SIZE)

/* The macro of rounding up the memory size */
//SCE_ATRAC_ROUND_UP(size) ((size + SCE_ATRAC_ALIGNMENT_SIZE - 1) & ~(SCE_ATRAC_ALIGNMENT_SIZE - 1))

/* The definition of ATRAC(TM) type */
SCE_ATRAC_TYPE_AT9  : c.uint : (0x2003)

/* Maximum number of total total channels */
SCE_ATRAC_AT9_MAX_TOTAL_CH :: (SCE_AUDIODEC_AT9_MAX_CH_IN_LIBRARY)

/* The definition of wordLength */
SCE_ATRAC_WORD_LENGTH_16BITS :: (SCE_AUDIODEC_WORD_LENGTH_16BITS)

/* Maximum number of channels per stream */
SCE_ATRAC_AT9_MAX_CH_IN_DECODER :: (SCE_AUDIODEC_AT9_MAX_CH_IN_DECODER)

/* Maximum number of samples */
SCE_ATRAC_AT9_MAX_FRAME_SAMPLES :: (SCE_AUDIODEC_AT9_MAX_SAMPLES)

/* Maximum number of output samples */
SCE_ATRAC_MAX_OUTPUT_SAMPLES :: (2048)

/* Maximum number of output frames */
SCE_ATRAC_AT9_MAX_OUTPUT_FRAMES ::  (8)

/* Minimum number of loop samples */
SCE_ATRAC_AT9_MIN_LOOP_SAMPLES :: (3072)

/* The definition of ATRAC infinite loop */
SCE_ATRAC_INFINITE_LOOP_NUM  : c.int :  (-1)

/* The definition of ATRAC infinite samples */
SCE_ATRAC_INFINITE_SAMPLES  : c.int : (-1)

/* The definition of ATRAC decoder status */
SceAtracDecoderStatus :: enum c.int {
	ALL_DATA_WAS_DECODED       = 0x00000001,
	ALL_DATA_IS_ON_MEMORY      = 0x00000002,
	NONLOOP_PART_IS_ON_MEMORY  = 0x00000004,
	LOOP_PART_IS_ON_MEMORY     = 0x00000008
}

/* The definition of loop status */
SceAtracLoopStatus :: enum c.int {
	NON_RESETABLE_PART          = 0x00000000,
	RESETABLE_PART              = 0x00000001
}

/* The structure for decoder group */
SceAtracDecoderGroup :: struct {
  size: SceUInt32,
	wordLength: SceUInt32,
	totalCh: SceUInt32,
}
#assert(size_of(SceAtracDecoderGroup) == 0xC)

/* Content information structure */
SceAtracContentInfo :: struct {
  size: SceUInt32,
	atracType: SceUInt32,
	channel: SceUInt32,
	samplingRate: SceUInt32,
	endSample: SceInt32,
	loopStartSample: SceInt32,
	loopEndSample: SceInt32,
	bitRate: SceUInt32,
	fixedEncBlockSize: SceUInt32,
	fixedEncBlockSample: SceUInt32,
	frameSample: SceUInt32,
	loopBlockOffset: SceUInt32,
	loopBlockSize: SceUInt32,
}
#assert(size_of(SceAtracContentInfo) == 0x34)

/* Stream information structure */
SceAtracStreamInfo :: struct {
  size: SceUInt32,
	pWritePosition: ^SceUChar8,
	readPosition: SceUInt32,
	writableSize: SceUInt32,
}

foreign atrac {
	sceAtracQueryDecoderGroupMemSize :: proc(atracType: SceUInt32, #by_ptr pDecoderGroup: SceAtracDecoderGroup) -> c.int ---
	sceAtracCreateDecoderGroup :: proc(atracType: SceUInt32, #by_ptr pDecoderGroup: SceAtracDecoderGroup, pvWorkMem: rawptr, initAudiodecFlag: c.int) -> c.int ---
	sceAtracDeleteDecoderGroup :: proc(atracType: SceUInt32, termAudiodecFlag: c.int) -> c.int ---
	sceAtracGetDecoderGroupInfo :: proc(atracType: SceUInt32, pCreatedDecoder: ^SceAtracDecoderGroup, pAvailableDecoder: ^SceAtracDecoderGroup) -> c.int ---
	sceAtracSetDataAndAcquireHandle :: proc(pucBuffer: [^]SceUChar8, uiReadSize: SceUInt32, uiBufferSize: SceUInt32) -> c.int ---
	sceAtracReleaseHandle :: proc(atracHandle: c.int) -> c.int ---
	sceAtracDecode :: proc(atracHandle: c.int, pOutputBuffer: rawptr, pOutputSamples: ^SceUInt32, pDecoderStatus: ^SceUInt32) -> c.int ---
	sceAtracGetStreamInfo :: proc(atracHandle: c.int, pStreamInfo: ^SceAtracStreamInfo) -> c.int ---
	sceAtracAddStreamData :: proc(atracHandle: c.int, addSize: SceUInt32) -> c.int ---
	sceAtracIsSubBufferNeeded :: proc(atracHandle: c.int) -> c.int ---
	sceAtracGetSubBufferInfo :: proc(atracHandle: c.int, pReadPosition: ^SceUInt32, pMinSubBufferSize: ^SceUInt32, pDataSize: ^SceUInt32) -> c.int ---
	sceAtracSetSubBuffer :: proc(atracHandle: c.int, pSubBuffer: [^]SceUChar8, subBufferSize: SceUInt32) -> c.int ---
	sceAtracSetLoopNum :: proc(atracHandle: c.int, loopNum: c.int) -> c.int ---
	sceAtracSetOutputSamples :: proc(atracHandle: c.int, outputSamples: SceUInt32) -> c.int ---
	sceAtracResetNextOutputPosition :: proc(atracHandle: c.int, resetSample: SceUInt32) -> c.int ---
	sceAtracGetContentInfo :: proc(atracHandle: c.int, pContentInfo: ^SceAtracContentInfo) -> c.int ---
	sceAtracGetLoopInfo :: proc(atracHandle: c.int, pLoopNum: ^c.int, pLoopStatus: ^SceUInt32) -> c.int ---
	sceAtracGetOutputSamples :: proc(atracHandle: c.int, pOutputSamples: ^SceUInt32) -> c.int ---
	sceAtracGetNextOutputPosition :: proc(atracHandle: c.int, pNextOutputSample: ^SceUInt32) -> c.int ---
	sceAtracGetRemainSamples :: proc(atracHandle: c.int, pRemainSamples: ^SceLong64) -> c.int ---
	sceAtracGetOutputableSamples :: proc(atracHandle: c.int, pOutputableSamples: ^SceLong64) -> c.int ---
	sceAtracGetDecoderStatus :: proc(atracHandle: c.int, pDecoderStatus: ^SceUInt32) -> c.int ---
	sceAtracGetVacantSize :: proc(atracHandle: c.int, pVacantSize: ^SceUInt32) -> c.int ---
	sceAtracGetInternalError :: proc(atracHandle: c.int, pInternalError: ^c.int) -> c.int ---
}

