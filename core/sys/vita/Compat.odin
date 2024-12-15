#+build vita
package vita

import "core:c"

foreign import compat "system:SceCompat_stub"

SceCompatCacheMode :: enum c.int {
	NONE           = 0,
	INVALIDATE     = 1,
	WRITEBACK      = 2
}

SceCompatPeripheralMode :: enum c.int {
	POWER_IS_SUSPEND_REQUIRED   = 1,
	POWER_GET_BATTERY_LIFETIME  = 2,
	POWER_GET_BATTERY_PERCENT   = 3,
	HPREMOTE_IS_HEADPHONE_EXIST = 4
}

SceCompatCdram :: struct {
  cached_cdram: rawptr,
	uncached_cdram: rawptr,
}

SceCtrlDataPsp :: struct {
  TimeStamp: c.uint,
	Buttons: c.uint,
	Lx: c.uchar,
	Ly: c.uchar,
	Rx: c.uchar,
	Ry: c.uchar,
	Rsrv: [4]c.uchar,
}
#assert(size_of(SceCtrlDataPsp) == 0x10)

foreign compat {
  /**
  * Init compat
  *
  * @param[in] unk - Unknown, pass 0
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatInitEx :: proc(unk: c.int) -> c.int ---

  /**
  * Uninit compat
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatUninit :: proc() -> c.int ---

  /**
  * Start compat
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatStart :: proc() -> c.int ---

  /**
  * Stop compat
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatStop :: proc() -> c.int ---

  /**
  * Allocate cdram with hole
  *
  * @param[out] cdram - A pointer to a ::SceCompatCdram structure.
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatAllocCdramWithHole :: proc(cdram: ^SceCompatCdram) -> c.int ---

  /**
  * Framebuffer init
  *
  * @param[in] framebuffer - Pointer to framebuffer
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatFrameBufferInit :: proc(framebuffer: rawptr) -> c.int ---

  /**
  * Set suspend semaphores
  *
  * @param[in] semaid1 - Semaphore id 1
  * @param[in] semaid2 - Semaphore id 2
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatSetSuspendSema :: proc(semaid1: SceUID, semaid2: SceUID) -> c.int ---

  /**
  * Suspend/resume compat
  *
  * @param[in] unk - Unknown, pass 1
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatSuspendResume :: proc(unk: c.int) -> c.int ---

  /**
  * Cache operation
  *
  * @param[in] mode - One of ::SceCompatCacheMode
  * @param[in] addr - Address
  * @param[in] size - Size
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatCache :: proc(mode: SceCompatCacheMode, addr: rawptr, size: SceSize) -> c.int ---

  /**
  * Wait for special request
  *
  * @param[in] unk - Unknown, pass 1
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatWaitSpecialRequest :: proc(unk: c.int) -> c.int ---

  /**
  * Interrupt code
  *
  * @param[in] intr_code - Interrupt code
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatInterrupt :: proc(intr_code: c.int) -> c.int ---

  /**
  * LCDC sync
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatLCDCSync :: proc() -> c.int ---

  /**
  * Get primary head
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatGetPrimaryHead :: proc() -> c.int ---

  /**
  * Get peripheral state
  *
  * @param[in] mode - One of ::SceCompatPeripheralMode
  *
  * @return state on success, < 0 on error.
  */
  sceCompatGetPeripheralState :: proc(mode: SceCompatPeripheralMode) -> c.int ---

  /**
  * Get compat status
  *
  * @return status on success, < 0 on error.
  */
  sceCompatGetStatus :: proc() -> c.int ---

  /**
  * Get update state
  *
  * @return state on success, < 0 on error.
  */
  sceCompatGetUpdateState :: proc() -> c.int ---

  /**
  * Set update state
  *
  * @param[in] state - State
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatSetUpdateState :: proc(state: c.int) -> c.int ---

  /**
  * Set display config
  *
  * @param[in] unk0 - Unknown
  * @param[in] unk1 - Unknown
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatSetDisplayConfig :: proc(unk0: c.int, unk1: c.int) -> c.int ---

  /**
  * Set RIF name
  *
  * @param[in] rif - RIF name (max. 36 chars)
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatSetRif :: proc(rif: cstring) -> c.int ---

  /**
  * Get PSP system software version
  *
  * @return version on success, < 0 on error.
  */
  sceCompatGetPspSystemSoftwareVersion :: proc() -> c.int ---

  /**
  * Get color space setting availability
  *
  * @return 1 if true, 0 if false, < 0 on error.
  */
  sceCompatAvailableColorSpaceSetting :: proc() -> c.int ---

  /**
  * Check if pocket station application is available
  *
  * @return 1 if true, 0 if false, < 0 on error.
  */
  sceCompatCheckPocketStation :: proc() -> c.int ---

  /**
  * Check if current title is a pocket station game
  *
  * @return 1 if true, 0 if false, < 0 on error.
  */
  sceCompatIsPocketStationTitle :: proc() -> c.int ---

  /**
  * Wait for command and get request
  *
  * @param[in] mode - Mode
  * @param[in] id - ID
  *
  * @return pointer to request in PspEmu RAM on success, < 0 on error.
  */
  sceCompatWaitAndGetRequest :: proc(mode: c.int, id: c.int) -> c.int ---

  /**
  * Read from shared sram
  *
  * @param[in] location - Location
  * @param[out] value - Pointer to a int buffer to hold the value
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatReadShared32 :: proc(location: c.int, value: ^c.int) -> c.int ---

  /**
  * Write to shared sram
  *
  * @param[in] location - Location
  * @param[in] value - Value
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatWriteShared32 :: proc(location: c.int, value: c.int) -> c.int ---

  /**
  * Write shared control
  *
  * @param[in] info - A pointer to a ::SceCtrlDataPsp structure.
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatWriteSharedCtrl :: proc(pad_data: ^SceCtrlDataPsp) -> c.int ---

  /**
  * Get title list
  *
  * @param[out] buf - A 100 bytes buffer for the title list
  * @param[in] length - Must be 100
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatGetTitleList :: proc(buf: rawptr, length: SceSize) -> c.int ---

  /**
  * Get Memory Card device information
  *
  * @param[out] info - A pointer to a ::SceIoDevInfo structure.
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatGetDevInf :: proc(info: ^SceIoDevInfo) -> c.int ---

  /**
  * Get current secure tick
  *
  * @param[out] tick - A pointer to a ::SceRtcTick structure.
  *
  * @return 0 on success, < 0 on error.
  */
  sceCompatGetCurrentSecureTick :: proc(tick: ^SceRtcTick) -> c.int ---
}

