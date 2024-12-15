#+build vita
package vita

import "core:c"

foreign import pfsmgr "system:ScePfsMgeForKernel_stub"

ScePfsRndDriveId :: struct {
  drive_id: [0x10]c.char,
}
#assert(size_of(ScePfsRndDriveId) == 0x10)

foreign pfsmgr {
  /**
  * Mount pfs directory
  *
  * @param[in] path         - The pfs encrypted directory path
  * @param[in] rnd_drive_id - The pfs mount target Pseudo Drive strings
  * @param[in] authid       - The authid
  * @param[in] klicensee    - The klicensee
  * @param[in] mode_index   - The mode_index
  *
  * @return 0 on success, < 0 on error.
  */
  kscePfsMount :: proc(path: cstring, #by_ptr rnd_drive_id: ScePfsRndDriveId, program_authority_id: SceUInt64, klicensee: rawptr, mode_index: c.uint16_t) -> c.int ---

  /**
  * Mount pfs directory without authid
  *
  * @param[in] path         - The pfs encrypted directory path
  * @param[in] rnd_drive_id - The pfs mount target Pseudo Drive strings
  * @param[in] klicensee    - The klicensee
  * @param[in] mode_index   - The mode_index
  *
  * @return 0 on success, < 0 on error.
  */
  kscePfsMount2 :: proc(path: cstring, #by_ptr rnd_drive_id: ScePfsRndDriveId, klicensee: rawptr, mode_index: c.uint16_t) -> c.int ---

  /**
  * Unmount pfs directory
  *
  * @param[in] rnd_drive_id - The pfs mount drive strings
  *
  * @return 0 on success, < 0 on error.
  */
  kscePfsUnmount :: proc(#by_ptr rnd_drive_id: ScePfsRndDriveId) -> c.int ---

  kscePfsApprove :: proc(#by_ptr rnd_drive_id: ScePfsRndDriveId, program_authority_id: SceUInt64) -> c.int ---
  kscePfsDisapprove :: proc(#by_ptr rnd_drive_id: ScePfsRndDriveId, program_authority_id: SceUInt64) -> c.int ---
}

