#+build linux
#+private
package sync

import "core:sys/linux"

when ODIN_PLATFORM_SUBTARGET == .Android {
	foreign import libc "system:c"

	@(default_calling_convention="c")
	foreign libc {
		@(link_name="gettid", private="file")
		_bionic_gettid :: proc() -> i32 ---
	}
}

_current_thread_id :: proc "contextless" () -> int {
	when ODIN_PLATFORM_SUBTARGET == .Android {
		return cast(int)_bionic_gettid()
	} else {
		return cast(int) linux.gettid()
	}
}
