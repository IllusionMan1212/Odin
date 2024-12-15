#+build vita
package vita

import "core:c"

foreign import usbserv "system:SceUsbServ_stub"
foreign import usbservkern "system:SceUsbServForDriver_stub"

SceUsbservErrorCode :: enum c.uint {
	UNAVAILABLE    = 0x80248002,
	INVALID_PARAM  = 0x80248003,
	NOT_SUPPORTED  = 0x80248004,
	FATAL          = 0x802480FF
}

foreign usbserv {
  /**
  * Enable accessory port
  *
  * @return 0 on success, < 0 on error
  *
  */
  sceUsbServAccessoryActivate :: proc() -> c.int ---

  /**
  * Disable accessory port
  *
  * @return 0 on success, < 0 on error
  *
  */
  sceUsbServAccessoryDeactivate :: proc() -> c.int ---
}

foreign usbservkern {
	/**
	* Enable PSTV ethernet
	*
	* @return 0 on success, < 0 on error
	*
	* @note NID 0x30AE5F66
	*/
	ksceUsbServEtherEnable :: proc() -> c.int ---

	/**
	* Disable PSTV ethernet
	*
	* @return 0 on success, < 0 on error
	*
	* @note NID 0xD787B191
	*/
	ksceUsbServEtherDisable :: proc() -> c.int ---

	/**
	* Enable accessory port
	*
	* @return 0 on success, < 0 on error
	*
	* @note NID 0xAA6D4409
	*/
	ksceUsbServAccessoryActivate :: proc() -> c.int ---

	/**
	* Disable accessory port
	*
	* @return 0 on success, < 0 on error
	*
	* @note NID 0x853CB8E4
	*/
	ksceUsbServAccessoryDeactivate :: proc() -> c.int ---

	/**
	* Set USB port mode
	*
	* @return 0 on success, < 0 on error
	*
	* @param usbPort usb port number (0,1,2)
	* @param clientMode 0 = host mode, 1 = client mode
	*
	* @note NID 0x7AD36284
	*/
	ksceUsbServMacSelect :: proc(usbPort: SceUInt, clientMode: SceBool) -> c.int ---

	/**
	* Get USB port mode
	*
	* @return usb port mode (1 = client, 0 = host)
	*
	* @param usbPort usb port number (0,1,2)
	*
	* @note NID 0xF0553A69
	*/
	ksceUsbServMacGet :: proc(usbPort: SceUInt) -> SceBool ---

	/**
	* Prevent PSTV ethernet hibernation
	*
	* @return 0 on success, < 0 on error
	*
	* @note NID 0x6D738018, guessed name
	*/
	ksceUsbServDisableEtherSuspend :: proc() -> c.int ---
}

