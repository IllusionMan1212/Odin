#+private
#+build vita
package sync

import "core:time"

_futex_wait :: proc "contextless" (futex: ^Futex, expected: u32) -> bool {
	//unimplemented("futexes are not implemented")
	return false
}

_futex_wait_with_timeout :: proc "contextless" (futex: ^Futex, expected: u32, duration: time.Duration) -> bool {
	//unimplemented("futexes are not implemented")
	return false
}

_futex_signal :: proc "contextless" (futex: ^Futex) {
	//unimplemented("futexes are not implemented")
}

_futex_broadcast :: proc "contextless" (futex: ^Futex)  {
	//unimplemented("futexes are not implemented")
}
