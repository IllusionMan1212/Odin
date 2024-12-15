#+build vita
package vita

import "core:c"

foreign import i2c "system:SceI2cForDriver_stub"

SceI2cErrorCode :: enum c.uint {
	INVALID_BUS	= 0x803F0300,
	INVALID_SIZE	= 0x803F0302,
	INVALID_ADDR	= 0x803F0303,
}

SceI2cDebugHandlers :: struct {
  size: c.uint,
  write_start: #type ^proc "c" (bus: c.int, addr: c.int, buffer: [^]c.uchar, size: c.int),
  write_end: #type ^proc "c" (bus: c.int, error: c.int, result: c.int),
  read_start: #type ^proc "c" (bus: c.int, addr: c.int, buffer: [^]c.uchar, size: c.int),
  read_end: #type ^proc "c" (bus: c.int, error: c.int, result: c.int),
  write_read_start: #type ^proc "c" (bus: c.int, write_addr: c.int, write_buffer: [^]c.uchar, write_size: c.int,
		read_addr: c.uint, read_buffer: [^]c.uchar, read_size: c.int),
  write_read_end: #type ^proc "c" (bus: c.int, error: c.int, result: c.int),
}

foreign i2c {
  ksceI2cInit :: proc(bus: c.int) -> c.int ---
  ksceI2cReset :: proc(bus: c.int) -> c.int ---
  ksceI2cTransferRead :: proc(bus: c.int, addr: c.uint, buffer: [^]c.uchar, size: c.int) -> c.int ---
  ksceI2cTransferWrite :: proc(bus: c.int, addr: c.uint, buffer: [^]c.uchar, size: c.int) -> c.int ---
  ksceI2cTransferWriteRead :: proc(bus: c.int, write_addr: c.uint, write_buffer: [^]c.uchar, write_size: c.int, read_addr: c.uint, read_buffer: [^]c.uchar, read_size: c.int) -> c.int ---

  ksceI2cSetDebugHandlers :: proc(bus: c.int, debug_handlers: ^SceI2cDebugHandlers) -> c.int ---
}

