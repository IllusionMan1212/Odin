#+build vita
package vita

import "core:c"

foreign import vshbridge "system:SceVshBridge_stub"

foreign vshbridge {
  /**
  * Gets real system firmware information.
  *
  * @param[out] data - firmware information.
  */
  _vshSblGetSystemSwVersion :: proc(data: ^SceKernelFwInfo) -> c.int ---

  /**
  * @brief Get service/manufacturing information (factory/minimum firmware).
  *
  * @param[out] info - The info output pointer
  *
  * @return 0 on success, < 0 on error.
  */
  _vshSblAimgrGetSMI :: proc(info: ^SceUInt32) -> c.int ---

  _vshSblAimgrGetConsoleId :: proc(CID: [32]c.char) -> c.int ---

  /**
  * @brief Check if a module is loaded.
  *
  * @param[in] module_name - The module's name
  * @param[in] buffer - Set a buffer with a size of 8 bytes
  *
  * @return the SceUID of the module on success, < 0 on error.
  */
  _vshKernelSearchModuleByName :: proc(module_name: cstring, buffer: rawptr) -> SceUID ---

  /**
  * @param[in] id - mount id
  * @param[in] path - mount path
  * @param[in] permission - 1/RO 2/RW
  * @param[in] buf - work buffer
  *
  * @return 0 >= on success, < 0 on error.
  */
  _vshIoMount :: proc(id: c.int, path: cstring, permission: c.int, buf: rawptr) -> c.int ---


  /**
  * @param[in] id - mount id
  * @param[in] force - Set to 1 to force umount
  * @param[in] unk2 - Unknown, set 0
  * @param[in] unk3 - Unknown, set 0
  *
  * @return 0 >= on success, < 0 on error.
  */
  vshIoUmount :: proc(id: c.int, force: c.int, unk2: c.int, unk3: c.int) -> c.int ---

  vshIdStorageIsDirty :: proc() -> c.int ---
  vshIdStorageIsFormatted :: proc() -> c.int ---
  vshIdStorageIsReadOnly :: proc() -> c.int ---

  /**
  * @param[in]  leafnum - The read target leaf number
  * @param[out] buf     - The leaf data buffer pointer, size is 512 byte
  *
  * @return 0 on success, < 0 on error.
  */
  vshIdStorageReadLeaf :: proc(leafnum: SceSize, buf: rawptr) -> c.int ---

  /**
  * @param[in] leafnum - The write target leaf number
  * @param[in] buf     - The leaf data buffer pointer, size is 512 byte
  *
  * @return 0 on success, < 0 on error.
  *
  * note - Writing to leaf requires manufacturing mode.
  */
  vshIdStorageWriteLeaf :: proc(leafnum: SceSize, buf: rawptr) -> c.int ---

  /**
  * Verify a eboot.pbp signature "__sce_ebootpbp"
  *
  * @param[in]  eboot_pbp_path         - The pointer of the file path of the EBOOT.PBP file
  * @param[in]  eboot_signature        - The pointer of data of __sce_ebootpbp signature. size is 0x200
  * @param[in]  eboot_signature_magic  - The pointer of a pointer of magic number within __sce_ebootpbp, "NPUMDSIG" or "PSISOSIG"
  *
  * @return 0 on success, < 0 on error.
  */
  _vshNpDrmEbootSigVerify :: proc(eboot_pbp_path: cstring, eboot_signature: cstring, eboot_signature_header: ^cstring) -> c.int ---

  /**
  * Verify an older 0x100 byte eboot.pbp signature "__sce_ebootpbp" from firmware <2.00
  *
  * @param[in]  eboot_pbp_path         - The pointer of the file path of the EBOOT.PBP file
  * @param[in]  eboot_signature        - The pointer of data of __sce_ebootpbp signature. size is 0x100
  * @param[in]  eboot_signature_magic  - The pointer of a pointer of magic number within __sce_ebootpbp, "NPUMDSIG" or "PSISOSIG"
  *
  * @return 0 on success, < 0 on error.
  */
  _vshNpDrmPspEbootVerify :: proc(eboot_pbp_path: cstring, eboot_signature: cstring, eboot_signature_header: ^cstring) -> c.int ---

  /**
  * Generate an older 0x100 byte eboot.pbp signature "__sce_ebootpbp" for a PSP game - this is unused in firmware >2.00
  * 
  * @param[in]  eboot_pbp_path         - The pointer of the file path of the EBOOT.PBP file
  * @param[in]  eboot_sha256           - The pointer of SHA256 hash of first (data.psar offset + 0x1C0000) bytes into the EBOOT.PBP file
  * @param[out] eboot_signature        - The pointer of the output eboot signature data. size is 0x100
  *
  * @return eboot_signature size on success, < 0 on error.
  */
  _vshNpDrmPspEbootSigGen :: proc(eboot_pbp_path: cstring, eboot_sha256: rawptr, eboot_signature: rawptr) -> c.int ---

  /**
  * Convert an older 0x100 byte eboot.pbp signature "__sce_ebootpbp" to a 0x200 byte one used in firmwares >2.00
  * 
  * @param[in]  eboot_pbp_path         - The pointer of the file path of the EBOOT.PBP file
  * @param[in]  old_eboot_signature    - The pointer of old eboot signature data. size is 0x100
  * @param[out] new_eboot_signature    - The pointer of new eboot signature data. size is 0x200
  *
  * @return eboot_signature size on success, < 0 on error.
  */
  _vshNpDrmEbootSigConvert :: proc(eboot_pbp_path: cstring, old_eboot_signature: rawptr, new_eboot_signature: rawptr)  -> c.int ---


  /**
  * Generate eboot.pbp signature "__sce_ebootpbp" for a PSP game
  *
  * @param[in]  eboot_pbp_path         - The pointer of the file path of the EBOOT.PBP file
  * @param[in]  eboot_sha256           - The pointer of SHA256 hash of first (data.psar offset + 0x1C0000) bytes into the EBOOT.PBP file
  * @param[out] eboot_signature        - The pointer of the output eboot signature data. size is 0x200
  * @param[in]  sw_version             - The pointer of the minimum firmware version the signature can be used on. cannot be lower than current firmware
  *
  * @return eboot_signature size on success, < 0 on error.
  */
  _vshNpDrmEbootSigGenPsp :: proc(eboot_pbp_path: cstring, eboot_sha256: rawptr, eboot_signature: rawptr, sw_version: ^c.int) -> c.int ---


  /**
  * Generate eboot.pbp signature "__sce_ebootpbp" for a single-disc PS1 game
  *
  * @param[in]  eboot_pbp_path         - The pointer of the file path of the EBOOT.PBP file
  * @param[in]  eboot_sha256           - The pointer of SHA256 hash of first (data.psar offset + 0x1C0000) bytes into the EBOOT.PBP file
  * @param[out] eboot_signature        - The pointer of the output eboot signature data. size is 0x200
  * @param[in]  sw_version             - The pointer of the minimum firmware version the signature can be used on. cannot be lower than current firmware
  *
  * @return eboot_signature size on success, < 0 on error.
  */
  _vshNpDrmEbootSigGenPs1 :: proc(eboot_pbp_path: cstring, eboot_sha256: rawptr, eboot_signature: rawptr, sw_version: ^c.int) -> c.int ---

  /**
  * Generate eboot.pbp signature "__sce_discinfo" for a multi-disc PS1 game
  *
  * @param[in]  eboot_pbp_path         - The pointer of the file path of the EBOOT.PBP file
  * @param[in]  sce_discinfo           - The pointer of contents of vs0:/app/NPXS10028/__sce_discinfo
  * @param[out] eboot_signature        - The pointer of the output eboot signature data. size is 0x100
  * @param[in]  sw_version             - The pointer of the minimum firmware version the signature can be used on. cannot be lower than current firmware
  *
  * @return eboot_signature size on success, < 0 on error.
  */
  _vshNpDrmEbootSigGenMultiDisc :: proc(eboot_pbp_path: cstring, sce_discinfo: rawptr, eboot_signature: rawptr, sw_version: ^c.int) -> c.int ---

  vshSblAimgrIsCEX :: proc() -> c.int ---
  vshSblAimgrIsDEX :: proc() -> c.int ---
  vshSblAimgrIsVITA :: proc() -> c.int ---
  vshSblAimgrIsGenuineVITA :: proc() -> c.int ---
  vshSblAimgrIsDolce :: proc() -> c.int ---
  vshSblAimgrIsGenuineDolce :: proc() -> c.int ---
  vshSblAimgrIsTest :: proc() -> c.int ---
  vshSblAimgrIsTool :: proc() -> c.int ---
  vshSblSsIsDevelopmentMode :: proc() -> c.int ---

  vshSysconHasWWAN :: proc() -> c.int ---

  vshSysconIsDownLoaderMode :: proc() -> c.int ---
  vshSysconIsIduMode :: proc() -> c.int ---
  vshSysconIsMCEmuCapable :: proc() -> c.int ---
  vshSysconIsShowMode :: proc() -> c.int ---

  vshSysconIduModeSet :: proc() -> c.int ---
  vshSysconIduModeClear :: proc() -> c.int ---

  vshSysconShowModeSet :: proc() -> c.int ---
  vshSysconShowModeClear :: proc() -> c.int ---

  vshMemoryCardGetCardInsertState :: proc() -> c.int ---
  vshRemovableMemoryGetCardInsertState :: proc() -> c.int ---

  vshMsifGetMsInfo :: proc(info: ^SceMsInfo) -> c.int ---
}

