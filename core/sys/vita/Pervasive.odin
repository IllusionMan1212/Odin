#+build vita
package vita

import "core:c"

foreign import pervasive "system:ScePervasiveForDriver_stub"

foreign pervasive {
  UartClockDisable :: proc(port: c.int) -> c.int ---
  UartResetEnable :: proc(port: c.int) -> c.int ---
  UartResetDisable :: proc(port: c.int) -> c.int ---
  UartClockEnable :: proc(port: c.int) -> c.int ---
  UartSetBaudrate :: proc(port: c.int, baudrate: c.uint) -> c.int ---

  GpioResetEnable :: proc() -> c.int ---
  GpioResetDisable :: proc() -> c.int ---
  GpioClockEnable :: proc() -> c.int ---
  GpioClockDisable :: proc() -> c.int ---

  SpiResetEnable :: proc(port: c.int) -> c.int ---
  SpiResetDisable :: proc(port: c.int) -> c.int ---
  SpiClockDisable :: proc(port: c.int) -> c.int ---
  SpiClockEnable :: proc(port: c.int) -> c.int ---

  DsiResetEnable :: proc(port: c.int, mask: c.uint) -> c.int ---
  DsiResetDisable :: proc(port: c.int, mask: c.uint) -> c.int ---
  DsiClockEnable :: proc(port: c.int, mask: c.uint) -> c.int ---
  DsiClockDisable :: proc(port: c.int, mask: c.uint) -> c.int ---
  DsiSetPixelClock :: proc(port: c.int, pixelclock: c.int) -> c.int ---

  MsifResetEnable :: proc() -> c.int ---
  MsifResetDisable :: proc() -> c.int ---
  MsifClockEnable :: proc() -> c.int ---
  MsifClockDisable :: proc() -> c.int ---
  MsifSetClock :: proc(clock: c.uint) -> c.int ---

  RemovableMemoryGetCardInsertState :: proc() -> c.int ---

  GetSoCRevision :: proc() -> SceUInt32 ---
}

