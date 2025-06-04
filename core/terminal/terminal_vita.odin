#+private
package terminal

import "core:os"

_is_terminal :: proc(handle: os.Handle) -> bool {
	return false
}

_init_terminal :: proc() {}

_fini_terminal :: proc() { }
