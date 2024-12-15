#+build vita
package vita

import "core:c"

foreign import dsi "system:SceDsiForDriver_stub"

SceDsiErrorCode :: enum c.uint {
	INVALID_HEAD	= 0x803F0600,
	INVALID_STATE	= 0x803F0601,
	INVALID_PARAM	= 0x803F0602,
	HEAD_NOT_ENABLED	= 0x803F0603,
}

SceDsiHead :: enum c.int {
	OLED_LCD	= 0,
	HDMI	= 1,
}

foreign dsi {
  ksceDsiEnableHead :: proc(head: c.int) -> c.int ---
  ksceDsiDisableHead :: proc(head: c.int) -> c.int ---
  ksceDsiSendBlankingPacket :: proc(head: c.int) -> c.int ---
  ksceDsiSetLanesAndPixelSize :: proc(head: c.int, lanes: c.int, pixelsize: c.int) -> c.int ---
  ksceDsiSetVic :: proc(head: c.int, vic: c.int) -> c.int ---
  ksceDsiGetVicResolution :: proc(vic: c.int, width: ^c.int, height: ^c.int) -> c.int ---
  ksceDsiGetPixelClock :: proc(head: c.int) -> c.int ---
  ksceDsiGenericShortWrite :: proc(head: c.int, param0: c.int, param1: c.int, param2: c.int) -> c.int ---
  ksceDsiGenericReadRequest :: proc(head: c.int, param: c.int, buff: rawptr, size: c.uint) -> c.int ---
  ksceDsiDcsShortWrite :: proc(head: c.int, param0: c.ushort, param1: c.int) -> c.int ---
  ksceDsiDcsRead :: proc(head: c.int, param: c.ushort, buff: rawptr, size: c.uint) -> c.int ---
}

