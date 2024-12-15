#+build vita
package vita

import "core:c"

foreign import fios2 "system:SceFios2Kernel_stub"
foreign import fios2kern "system:SceFios2KernelForDriver_stub"

SCE_FIOS2_OVERLAY_PATH_SIZE       :: (292)
SCE_FIOS2_OVERLAY_PATH_MAX_LENGTH :: (SCE_FIOS2_OVERLAY_PATH_SIZE - 1)

SceFiosKernelOverlayDH :: c.int32_t
SceFiosKernelOverlayID :: c.int32_t
SceFiosOverlayID :: c.int32_t

// missing structs
SceFiosKernelOverlay :: struct{}
SceFiosNativeStat :: struct{}
SceFiosNativeDirEntry :: struct{}

SceFiosDHOpenSyncSyscallArgs :: struct {
	to_order: SceUInt8,
	padding: [2]c.int,
}
#assert(size_of(SceFiosDHOpenSyncSyscallArgs) == 0xC)

SceFiosGetListSyscallArgs :: struct {
	out_ids: ^SceFiosKernelOverlayID,
	data_0x04: c.int,
	data_0x08: c.int,
	data_0x0C: SceSize,
	data_0x10: c.int,
	data_0x14: c.int,
}

SceFiosResolveSyncSyscallArgs :: struct {
	out_path: cstring,
	data_0x04: c.int,
	data_0x08: c.int,
	data_0x0C: c.int,
	data_0x10: c.int,
	data_0x14: c.int,
}

SceFiosResolveWithRangeSyncSyscallArgs :: struct {
	out_path: cstring,
	data_0x04: c.int,
	data_0x08: SceUInt8,
	data_0x09: SceUInt8,
	data_0x0C: c.int,
	data_0x10: c.int,
	data_0x14: c.int,
}

SceFiosOverlayType :: enum c.int {
  // src replaces dst. All accesses to dst are redirected to src.
  OPAQUE      = 0,

  // src merges with dst. Reads check src first, then dst. Writes go to dst.
  TRANSLUCENT = 1,

  // src merges with dst. Reads check both src and dst, and use whichever has the most recent modification time.
  // If both src and dst have the same modification time, dst is used.
  // If no file exists at src or dst, dst is used; if no file exists at dst, but a file exists at src, src is used. Writes go to dst.
  NEWER       = 2,

  // src merges with dst. Reads check src first, then dst. Writes go to src.
  WRITABLE    = 3
}

SceFiosOverlay :: struct {
	type: c.uint8_t, // see SceFiosOverlayType
  order: c.uint8_t,
  dst_len: c.uint16_t,
  src_len: c.uint16_t,
  unk2: c.uint16_t,
  pid: SceUID,
  id: SceFiosOverlayID,
  dst: [SCE_FIOS2_OVERLAY_PATH_SIZE]c.char,
  src: [SCE_FIOS2_OVERLAY_PATH_SIZE]c.char, // src path replaces dst path based on type policy
}
#assert(size_of(SceFiosOverlay) == 0x258)

foreign fios2 {
  _sceFiosKernelOverlayAdd :: proc(#by_ptr overlay: SceFiosKernelOverlay, out_id: ^SceFiosKernelOverlayID) -> c.int ---
  _sceFiosKernelOverlayAddForProcess :: proc(target_process: SceUID, #by_ptr overlay: SceFiosKernelOverlay, out_id: ^SceFiosKernelOverlayID) -> c.int ---
  _sceFiosKernelOverlayDHChstatSync :: proc(dh: SceFiosKernelOverlayDH, #by_ptr new_stat: SceFiosNativeStat, cbit: c.uint) -> c.int ---
  _sceFiosKernelOverlayDHCloseSync :: proc(dh: SceFiosKernelOverlayDH) -> c.int ---

  _sceFiosKernelOverlayDHOpenSync :: proc(out_dh: ^SceFiosKernelOverlayDH, path: cstring, from_order: SceUInt8, args: ^SceFiosDHOpenSyncSyscallArgs) -> c.int ---
  _sceFiosKernelOverlayDHReadSync :: proc(dh: SceFiosKernelOverlayDH, out_entry: ^SceFiosNativeDirEntry) -> c.int ---
  _sceFiosKernelOverlayDHStatSync :: proc(dh: SceFiosKernelOverlayDH, out_stat: ^SceFiosNativeStat) -> c.int ---
  _sceFiosKernelOverlayDHSyncSync :: proc(dh: SceFiosKernelOverlayDH, flag: c.int) -> c.int ---
  _sceFiosKernelOverlayGetInfo :: proc(id: SceFiosKernelOverlayID, out_overlay: ^SceFiosKernelOverlay) -> c.int ---
  _sceFiosKernelOverlayGetInfoForProcess :: proc(target_process: SceUID, id: SceFiosKernelOverlayID, out_overlay: ^SceFiosKernelOverlay) -> c.int ---

  _sceFiosKernelOverlayGetList :: proc(pid: SceUID, min_order: SceUInt8, max_order: SceUInt8, args: ^SceFiosGetListSyscallArgs) -> c.int ---
  _sceFiosKernelOverlayGetRecommendedScheduler :: proc(avail: c.int, partially_resolved_path: cstring, a3: ^SceUInt64) -> c.int ---
  _sceFiosKernelOverlayModify :: proc(id: SceFiosKernelOverlayID, #by_ptr new_value: SceFiosKernelOverlay) -> c.int ---
  _sceFiosKernelOverlayModifyForProcess :: proc(target_process: SceUID, id: SceFiosKernelOverlayID, #by_ptr new_value: SceFiosKernelOverlay) -> c.int ---
  _sceFiosKernelOverlayRemove :: proc(id: SceFiosKernelOverlayID) -> c.int ---
  _sceFiosKernelOverlayRemoveForProcess :: proc(target_process: SceUID, id: SceFiosKernelOverlayID) -> c.int ---

  _sceFiosKernelOverlayResolveSync :: proc(pid: SceUID, resolve_flag: c.int, in_path: cstring, args: ^SceFiosResolveSyncSyscallArgs) -> c.int ---

  _sceFiosKernelOverlayResolveWithRangeSync :: proc(pid: SceUID, resolve_flag: c.int, in_path: cstring, args: ^SceFiosResolveWithRangeSyncSyscallArgs) -> c.int ---
  _sceFiosKernelOverlayThreadIsDisabled :: proc() -> c.int ---
  _sceFiosKernelOverlayThreadSetDisabled :: proc(disabled: SceInt32) -> c.int ---

  sceFiosKernelOverlayAddForProcess02 :: proc(pid: SceUID, overlay: ^SceFiosOverlay, outID: ^SceFiosOverlayID) -> c.int ---
}

foreign fios2kern {
  /**
  * Overlay process file system overlay
  *
  * @param[in]  overlay - Overlay config pointer
  * @param[out] outID   - outID pointer
  *
  * @return     Error code or zero on success
  */
  ksceFiosKernelOverlayAdd :: proc(overlay: ^SceFiosOverlay, outID: ^SceFiosOverlayID) -> c.int ---

  /**
  * Overlay process file system overlay
  *
  * @param[in]  pid     - Process id
  * @param[in]  overlay - Overlay config pointer
  * @param[out] outID   - outID pointer
  *
  * @return     Error code or zero on success
  */
  ksceFiosKernelOverlayAddForProcess :: proc(pid: SceUID, overlay: ^SceFiosOverlay, outID: ^SceFiosOverlayID) -> c.int ---

  /**
  * Remove process file system overlay
  *
  * @param[in] pid - Process id
  * @param[in] id  - Overlay id
  *
  * @return     Error code or zero on success
  */
  ksceFiosKernelOverlayRemoveForProcess :: proc(pid: SceUID, id: SceFiosOverlayID) -> c.int ---

  /**
  * Resolve process file system overlay with sync
  *
  * @param[in]  pid         - Process id
  * @param[in]  resolveFlag - Some flags
  * @param[in]  inPath      - Path input
  * @param[out] outPath     - Path output
  * @param[in]  maxPath     - Path output max length
  *
  * @return     Error code or zero on success
  */
  ksceFiosKernelOverlayResolveSync :: proc(pid: SceUID, resolveFlag: c.int, inPath: cstring, outPath: [^]c.char, maxPath: SceSize) -> c.int ---
}

