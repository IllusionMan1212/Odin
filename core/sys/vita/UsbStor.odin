#+build vita
package vita

import "core:c"

foreign import usbstor "system:SceUsbstorVStorDriver_stub"

SceUsbstorVstorType :: enum c.int {
	FAT     = 0,
	CDROM   = 5
}

foreign usbstor {
  /**
  * Set image file path
  *
  * @param[in] path - Image file path
  *
  * @return 0 on success, < 0 on error.
  */
  sceUsbstorVStorSetImgFilePath :: proc(path: cstring) -> c.int ---

  /**
  * Set USB descriptor device information
  *
  * @param[in] name - Name
  * @param[in] version - Version
  *
  * @return 0 on success, < 0 on error.
  */
  sceUsbstorVStorSetDeviceInfo :: proc(name: cstring, version: cstring) -> c.int ---

  /**
  * Start USB virtual storage
  *
  * @param[in] type - One of ::SceUsbstorVstorType
  *
  * @return 0 on success, < 0 on error.
  */
  sceUsbstorVStorStart :: proc(type: SceUsbstorVstorType) -> c.int ---

  /**
  * Stop USB virtual storage
  *
  * @return 0 on success, < 0 on error.
  */
  sceUsbstorVStorStop :: proc() -> c.int ---
}

