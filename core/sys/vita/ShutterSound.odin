#+build vita
package vita

import "core:c"

foreign import shuttersound "system:SceShutterSound_stub"

SceShutterSoundErrorCode :: enum c.uint {
	INVALID_ARGUMENT = 0x80105201, //!< Invalid argument
	INTERNAL         = 0x80105202, //!< Internal error
	FATAL            = 0x80105203  //!< Fatal error
}

SceShutterSoundType :: enum c.uint {
	SAVE_IMAGE       = 0,
	SAVE_VIDEO_START = 1,
	SAVE_VIDEO_END   = 2,
}

foreign shuttersound {
  /**
  * Plays a shutter sound
  *
  * @param[in] type - The sound type to play (One of ::SceShutterSoundType)
  *
  * @return 0 on success, < 0 on error.
  */
  sceShutterSoundPlay :: proc(type: SceShutterSoundType) -> c.int ---
}

