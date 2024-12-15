#+build vita
package vita

import "core:c"

foreign import gpio "system:SceGpioForDriver_stub"

SceGpioErrorCode :: enum c.uint {
	INVALID_BUS	= 0x803F0100,
	INVALID_PORT	= 0x803F0101,
	INVALID_MODE	= 0x803F0102,
}

SceGpioPortMasks :: enum c.int {
	LED_GAMECARD = 1 << 6,
	LED_PS_BUTTON	= 1 << 7,
}

SceGpioPortMode :: enum c.int {
	OUTPUT	= 0,
	INPUT	= 1,
}

foreign gpio {
  ksceGpioPortRead :: proc(bus: c.int, port: c.int) -> c.int ---
  ksceGpioPortSet :: proc(bus: c.int, port: c.int) -> c.int ---
  ksceGpioPortClear :: proc(bus: c.int, port: c.int) -> c.int ---
  ksceGpioPortReset :: proc(bus: c.int, port: c.int) -> c.int ---
  ksceGpioSetPortMode :: proc(bus: c.int, port: c.int, mode: c.int) -> c.int ---
  ksceGpioGetPortMode :: proc(bus: c.int, port: c.int) -> c.int ---
  ksceGpioSetIntrMode :: proc(bus: c.int, port: c.int, intr_mode: c.int) -> c.int ---
  ksceGpioGetIntrMode :: proc(bus: c.int, port: c.int) -> c.int ---
  ksceGpioAcquireIntr :: proc(bus: c.int, port: c.int) -> c.int ---
  ksceGpioQueryIntr :: proc(bus: c.int, port: c.int) -> c.int ---
}

