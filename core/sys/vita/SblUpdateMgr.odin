#+build vita
package vita

import "core:c"

foreign import sblupdatemgr "system:SceSblUpdateMgr_stub"

SCE_UPDATE_MODE_SWU_GUI :: 0x10
SCE_UPDATE_MODE_SWU_CUI :: 0x30

SceUpdateMode :: c.char

sceSblSsUpdateMgrGetBootMode :: sceSblUsGetUpdateMode
sceSblSsUpdateMgrSetBootMode :: sceSblUsSetUpdateMode

foreign sblupdatemgr {
  /**
  * Getting system update mode on boot
  *
  * @param[out] mode - The pointer of SceUpdateMode variable
  *
  * @return 0 on success, < 0 on error.
  */
  sceSblUsGetUpdateMode :: proc(mode: ^SceUpdateMode) -> c.int ---


  /**
  * Setting system update mode on boot
  *
  * @param[in] mode - The update mode
  *
  * @return 0 on success, < 0 on error.
  */
  sceSblUsSetUpdateMode :: proc(mode: SceUpdateMode) -> c.int ---


  /**
  * Verify PUP
  *
  * @param[in] path - The PUP path
  *
  * @return 0 on success, < 0 on error.
  *
  * note - If verify CEX PUP on Devkit system, got error.
  */
  sceSblUsVerifyPup :: proc(path: cstring) -> c.int ---
}

