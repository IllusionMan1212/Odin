#+build vita
package os

import "core:strings"
import "core:mem"
import "base:runtime"
import "core:sys/vita"

read_dir :: proc(fd: Handle, n: int, allocator := context.allocator) -> (fi: []File_Info, err: Errno) {
	err = ENOSYS
	return
}
