#+build vita
package vita

import "core:c"

foreign import avplayer "system:SceAvPlayer_stub"

SceAvPlayerHandle :: distinct c.int

SceAvPlayerErrorCode :: enum c.uint {
	INVALID_PARAM = 0x806A0001,
	OUT_OF_MEMORY = 0x806A0003
}

SceAvPlayerTrickSpeeds :: enum c.int {
	REWIND_32X       = -3200, //!< Rewind 32x
	REWIND_16X       = -1600, //!< Rewind 16x
	REWIND_8X        = -800,  //!< Rewind 8x
	NORMAL           =  100,  //!< Normal Speed
	FAST_FORWARD_2X  =  200,  //!< Fast Forward 2x
	FAST_FORWARD_4X  =  400,  //!< Fast Forward 4x
	FAST_FORWARD_8X  =  800,  //!< Fast Forward 8x
	FAST_FORWARD_16X = 1600,  //!< Fast Forward 16x
	FAST_FORWARD_32X = 3200   //!< Fast Forward 32x
}

SceAvPlayerStreamType :: enum c.int {
	VIDEO,     //!< Video stream type
	AUDIO,     //!< Audio stream type
	TIMEDTEXT  //!< Timed text (subtitles) stream type
}

SceAvPlayerAlloc :: #type ^proc(arg: rawptr, alignment: c.uint32_t, size: c.uint32_t) -> rawptr
SceAvPlayerFree :: #type ^proc(arg: rawptr, ptr: rawptr)
SceAvPlayerAllocFrame :: #type ^proc(arg: rawptr, alignment: c.uint32_t, size: c.uint32_t) -> rawptr
SceAvPlayerFreeFrame :: #type ^proc(arg: rawptr, ptr: rawptr)

SceAvPlayerOpenFile :: #type ^proc(p: rawptr, filename: cstring) -> c.int
SceAvPlayerCloseFile :: #type ^proc(p: rawptr) -> c.int
SceAvPlayerReadOffsetFile :: #type ^proc(p: rawptr, buffer: [^]c.uint8_t, position: c.uint64_t, length: c.uint32_t) -> c.int
SceAvPlayerSizeFile :: #type ^proc(p: rawptr) -> c.uint64_t

SceAvPlayerEventCallback :: #type ^proc(p: rawptr, argEventId: c.int32_t, argSourceId: c.int32_t, argEventData: rawptr)

SceAvPlayerMemReplacement :: struct {
  objectPointer: rawptr,
	allocate: SceAvPlayerAlloc,               //!< Memory allocator for generic data
	deallocate: SceAvPlayerFree,              //!< Memory deallocator for generic data
	allocateTexture: SceAvPlayerAllocFrame,   //!< Memory allocator for video frames
	deallocateTexture: SceAvPlayerFreeFrame,  //!< Memory deallocator for video frames
}

SceAvPlayerFileReplacement :: struct {
  objectPointer: rawptr,
	open: SceAvPlayerOpenFile,                //!< File open
	close: SceAvPlayerCloseFile,              //!< File close
	readOffset: SceAvPlayerReadOffsetFile,    //!< File read from offset
	size: SceAvPlayerSizeFile,                //!< File size
}

SceAvPlayerEventReplacement:: struct {
  objectPointer: rawptr,
	eventCallback: SceAvPlayerEventCallback,
}

SceAvPlayerInitData :: struct {
  memoryReplacement: SceAvPlayerMemReplacement,  //!< Memory allocator replacement
	fileReplacement: SceAvPlayerFileReplacement,   //!< File I/O replacement
	eventReplacement: SceAvPlayerEventReplacement, //!< Event callback replacement
	debugLevel: c.int32_t,
	basePriority: c.uint32_t,                        //!< Base priority of the thread running the video player
	numOutputVideoFrameBuffers: c.int32_t,
	autoStart: SceBool,                            //!< Flag indicating whether the video player should start playback automatically
	reserved: [3]c.uint8_t,                          //!< Reserved data
	defaultLanguage: cstring,
}

SceAvPlayerAudio :: struct {
  channelCount: c.uint16_t, //!< The number of audio channels of the audio frame.
	reserved: [2]c.uint8_t,   //!< Reserved data.
	sampleRate: c.uint32_t,   //!< The samplerate of the audio frame in Hz.
	size: c.uint32_t,         //!< The size of the audio frame in bytes.
	languageCode: c.uint32_t, //!< The language code of the audio frame.
}
#assert(size_of(SceAvPlayerAudio) == 0x10)

SceAvPlayerVideo :: struct {
  width: c.uint32_t,        //!< The width of the video frame in pixels.
	height: c.uint32_t,       //!< The height of the video frame in pixels.
	aspectRatio: c.float,     //!< The aspect ratio of the video frame.
	languageCode: c.uint32_t, //!< The language code of the video frame.
}
#assert(size_of(SceAvPlayerVideo) == 0x10)

SceAvPlayerTextPosition :: struct {
  top: c.uint16_t,
	left: c.uint16_t,
	bottom: c.uint16_t,
	right: c.uint16_t,
}
#assert(size_of(SceAvPlayerTextPosition) == 8)

SceAvPlayerTimedText :: struct {
  languageCode: c.uint32_t,            //!< The language code of the subtitles.
	textSize: c.uint16_t,                //!< The size of the subtitles.
	fontSize: c.uint16_t,                //!< The size of the subtitles.
	position: SceAvPlayerTextPosition, //!< The position of the subtitles.
}
#assert(size_of(SceAvPlayerTimedText) == 0x10)

SceAvPlayerStreamDetails :: struct #raw_union {
  reserved: [4]c.uint32_t,      //!< Reserved data.
	audio: SceAvPlayerAudio,    //!< Audio details.
	video: SceAvPlayerVideo,    //!< Video details.
	subs: SceAvPlayerTimedText, //!< Subtitles details.
}
#assert(size_of(SceAvPlayerStreamDetails) == 0x10)

SceAvPlayerFrameInfo :: struct {
	pData: [^]c.uint8_t,                   //!< Pointer to the frame data.
	reserved: c.uint32_t,                //!< Reserved data
	timeStamp: c.uint64_t,               //!< Timestamp of the frame in milliseconds
	details: SceAvPlayerStreamDetails, //!< The frame details.
}

SceAvPlayerStreamInfo :: struct {
  type: c.uint32_t,                    //!< Type of the stream (One of ::SceAvPlayerStreamType)
	reserved: c.uint32_t,                //!< Reserved data             
	details: SceAvPlayerStreamDetails, //!< The stream details.
	duration: c.uint64_t,                //!< Total duration of the stream in milliseconds.
	startTime: c.uint64_t,               //!< Starting time of the stream in milliseconds.
}
#assert(size_of(SceAvPlayerStreamInfo) == 0x28)

foreign avplayer {
	/**
	* @param[in] data - Init data for the video player
	*
	* @return The video player handle on success, < 0 on error.
	*/
	sceAvPlayerInit :: proc(data: ^SceAvPlayerInitData) -> SceAvPlayerHandle ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerPause :: proc(handle: SceAvPlayerHandle) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerResume :: proc(handle: SceAvPlayerHandle) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerStart :: proc(handle: SceAvPlayerHandle) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerStop :: proc(handle: SceAvPlayerHandle) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	* @param[in] looping - A flag indicating whether the video playback should loop
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerSetLooping :: proc(handle: SceAvPlayerHandle, looping: SceBool) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	*
	* @return SCE_TRUE if the video playback is active, SCE_FALSE otherwise.
	*/
	sceAvPlayerIsActive :: proc(handle: SceAvPlayerHandle) -> SceBool ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	* @param[in] filename - Full path to the file to play
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerAddSource :: proc(handle: SceAvPlayerHandle, filename: cstring) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerClose :: proc(handle: SceAvPlayerHandle) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	* @param[out] info - Descriptor for the received data
	*
	* @return SCE_TRUE if new data is available, SCE_FALSE otherwise.
	*/
	sceAvPlayerGetAudioData :: proc(handle: SceAvPlayerHandle, info: ^SceAvPlayerFrameInfo) -> SceBool ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	* @param[out] info - Descriptor for the received data
	*
	* @return SCE_TRUE if new data is available, SCE_FALSE otherwise.
	*/
	sceAvPlayerGetVideoData :: proc(handle: SceAvPlayerHandle, info: ^SceAvPlayerFrameInfo) -> SceBool ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	*
	* @return Current time on the video playback in milliseconds.
	*/
	sceAvPlayerCurrentTime :: proc(handle: SceAvPlayerHandle) -> c.uint64_t ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	* @param[in] offset - Offset to jump to on the video playback in milliseconds.
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerJumpToTime :: proc(handle: SceAvPlayerHandle, offset: c.uint64_t) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	* @param[in] offset - One of ::SceAvPlayerTrickSpeeds.
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerSetTrickSpeed :: proc(handle: SceAvPlayerHandle, speed: c.int) -> c.int ---

	/**
	* @param[in] handle - A player handle created with ::sceAvPlayerInit
	* @param[in] id - Stream ID to get info for.
	* @param[out] info - Info retrieved for the requested stream.
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAvPlayerGetStreamInfo :: proc(handle: SceAvPlayerHandle, id: c.uint32_t, info: ^SceAvPlayerStreamInfo) -> c.int ---
}
