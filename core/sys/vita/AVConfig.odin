#+build vita
package vita

import "core:c"

foreign import avconfig "system:SceAVConfig_stub"

/** Color Space Mode values to specify to ::sceAVConfigSetDisplayColorSpaceMode */
SceAVConfigColorSpaceMode :: enum c.int {
	DEFAULT           = 0, //!< Default
	HIGH_CONTRAST     = 1  //!< High Contrast Mode
}

foreign avconfig {
  /**
  * Get the maximum brightness.
  *
  * @param[out] maxBrightness - Maximum brightness.
  *
  * @return 0 on success, < 0 on error.
  */
  sceAVConfigGetDisplayMaxBrightness :: proc(maxBrightness: ^c.int) -> c.int ---

  /**
  * Set the screen brightness.
  *
  * @param brightness - Brightness that the screen will be set to (range 21-65536, 0 turns off the screen).
  *
  * @return 0 on success, < 0 on error.
  */
  sceAVConfigSetDisplayBrightness :: proc(brightness: c.int) -> c.int ---

  /**
  * Get the shutter volume.
  *
  * @param[out] volume - shutter volume.
  *
  * @return 0 on success, < 0 on error.
  */
  sceAVConfigGetShutterVol :: proc(volume: ^c.int) -> c.int ---

  /**
  * Get the system volume.
  *
  * @param[out] volume - System volume.
  *
  * @return 0 on success, < 0 on error.
  */
  sceAVConfigGetSystemVol :: proc(volume: ^c.int) -> c.int ---

  /**
  * Set the system volume.
  *
  * @param volume - volume that the device will be set to (range 0-30).
  *
  * @return 0 on success, < 0 on error.
  */
  sceAVConfigSetSystemVol :: proc(volume: c.int) -> c.int ---

  /**
  * Turns on mute.
  *
  * @return 0 on success, < 0 on error.
  *
  */
  sceAVConfigMuteOn :: proc() -> c.int ---

  /**
  * Sets the color space mode on runtime.
  *
  * @param[in] csm - see ::SceAVConfigColorSpaceMode()
  *
  * @return 0 on success, < 0 on error.
  * @note - This does not change color_space_mode in the registry.
  */
  sceAVConfigSetDisplayColorSpaceMode :: proc(csm: c.int) -> c.int ---
}
