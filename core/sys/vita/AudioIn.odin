#+build vita
package vita

import "core:c"

foreign import audioin "system:SceAudioIn_stub"

SceAudioInErrorCode :: enum c.uint {
	//! Undefined error
	FATAL                = 0x80260100,
	//! Bad value of port number
	INVALID_PORT         = 0x80260101,
	//! Invalid sample length
	INVALID_SIZE         = 0x80260102,
	//! Invalid sample frequency
	INVALID_SAMPLE_FREQ  = 0x80260103,
	//! Invalid port type
	INVALID_PORT_TYPE    = 0x80260104,
	//! Invalid pointer value
	INVALID_POINTER      = 0x80260105,
	//! Invalid port param
	INVALID_PORT_PARAM   = 0x80260106,
	//! Cannot open no ports
	PORT_FULL            = 0x80260107,
	//! Not enough memory
	OUT_OF_MEMORY        = 0x80260108,
	//! Port is not opened
	NOT_OPENED           = 0x80260109,
	//! Tried to input while busy
	BUSY                 = 0x8026010A,
	//! Invalid parameter
	INVALID_PARAMETER    = 0x8026010B
}

SceAudioInPortType :: enum c.int {
	VOICE   = 0,
	RAW     = 2
}

SceAudioInParam :: enum c.int {
	PARAM_FORMAT_S16_MONO  = 0,
	GETSTATUS_MUTE         = 1
}

foreign audioin {
	//! Open port
	sceAudioInOpenPort :: proc(portType: SceAudioInPortType, grain: c.int, freq: c.int, param: SceAudioInParam) -> c.int ---

	//! Close port
	sceAudioInReleasePort :: proc(port: c.int) -> c.int ---

	sceAudioInInput :: proc(port: c.int, destPtr: rawptr) -> c.int ---

	/* get status */
	sceAudioInGetAdopt :: proc(portType: SceAudioInPortType) -> c.int ---
	sceAudioInGetStatus :: proc(select: c.int) -> c.int ---
}
