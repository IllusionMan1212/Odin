#+build vita
package vita

import "core:c"

foreign import shellsvc "system:SceShellSvc_stub"

SceShellUtilLockType :: enum c.int {
	PS_BTN             = 0x1,
	QUICK_MENU         = 0x2,
	POWEROFF_MENU      = 0x4,
	UNK8               = 0x8,
	USB_CONNECTION     = 0x10,
	MC_INSERTED        = 0x20,
	MC_REMOVED         = 0x40,
	UNK80              = 0x80,
	UNK100             = 0x100,
	UNK200             = 0x200,
	MUSIC_PLAYER       = 0x400,
	PS_BTN_2           = 0x800, //! without the stop symbol
}

SceShellUtilLockMode :: enum c.int {
	LOCK       = 1,
	UNLOCK     = 2
}

SceShellUtilEventHandler :: #type proc "c" (result: c.int, mode: SceShellUtilLockMode, type: SceShellUtilLockType, userData: rawptr)

SceShellUtilLaunchAppParam :: struct {
	cmd: cstring,
}

foreign shellsvc {
  /**
  * Init events
  *
  * @param[in] unk - Unknown, use 0
  *
  * @return 0 on success, < 0 on error.
  */
  sceShellUtilInitEvents :: proc(unk: c.int) -> c.int ---

  /**
  * Register event handler
  *
  * @param[in] handler - Event handler
  *
  * @param[in] userData - The user data passed to the handler
  *
  * @return 0 on success, < 0 on error.
  */
  sceShellUtilRegisterEventHandler :: proc(handler: ^SceShellUtilEventHandler, userData: rawptr) -> c.int ---

  /**
  * Lock event
  *
  * @param[in] type - One of ::SceShellUtilLockType
  *
  * @return 0 on success, < 0 on error.
  */
  sceShellUtilLock :: proc(type: SceShellUtilLockType) -> c.int ---

  /**
  * Unlock event
  *
  * @param[in] type - One of ::SceShellUtilLockType
  *
  * @return 0 on success, < 0 on error.
  */
  sceShellUtilUnlock :: proc(type: SceShellUtilLockType) -> c.int ---


  sceShellUtilRequestLaunchApp :: proc(param: ^SceShellUtilLaunchAppParam) -> c.int ---
  sceShellUtilLaunchAppRequestLaunchApp :: proc(param: ^SceShellUtilLaunchAppParam) -> c.int ---
}

