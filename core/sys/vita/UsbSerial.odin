#+build vita
package vita

import "core:c"

foreign import usbserial "system:SceUsbSerial_stub"
foreign import usbserialkern "system:SceUsbSerialForDriver_stub"

foreign usbserial {
  /**
  * Activate USB serial device
  *
  * @return 0 on success, < 0 on error
  *
  * @note The user is responsible for making sure no other UDC driver is active. This activates UDC as a "PS Vita" Type D device.
  *
  * @note Wrapper for kernel function StartForDriver()
  */
  sceUsbSerialStart :: proc() -> c.int ---

  /**
  * Setup USB serial device
  *
  * @return 0 on success, < 0 on error
  *
  * @param unk Unknown
  *
  * @note Wrapper for kernel function SetupForDriver()
  */
  sceUsbSerialSetup :: proc(unk: c.int) -> c.int ---

  /**
  * Close USB serial device
  *
  * @note Wrapper for kernel function CloseForDriver()
  */
  sceUsbSerialClose :: proc() -> c.int ---

  /**
  * Close USB serial device
  *
  * @return Returns 1 when serial port is open
  *
  * @note Wrapper for kernel function StatusForDriver()
  */
  sceUsbSerialStatus :: proc() -> c.int ---

  /**
  * Get receive buffer length
  *
  * @return Returns length of USB rx buffer
  *
  * @note Wrapper for kernel function GetLenForDriver()
  */
  sceUsbSerialGetRecvBufferSize :: proc() -> c.uint ---

  /**
  * Send data
  * @param[in] *buffer data to send over usb
  * @param len int len of serial buffer data
  * @param unk1 Unknown
  * @param unk2 Unknown
  * @note max send length is 0x10000
  * @note Wrapper for kernel function SendForDriver()
  */
  sceUsbSerialSend :: proc(buffer: rawptr, len: c.uint, unk1: c.int, unk2: c.int) -> c.uint ---

  /**
  * Receive Data
  *
  * @param[out] *buffer buffer for incoming data
  * @param max_len max data length to receive
  * @param unk1 Unknown
  * @param unk2 Unknown
  * @note max recv length is 0x10000
  * @note Wrapper for kernel function RecvForDriver()
  */
  sceUsbSerialRecv :: proc(buffer: rawptr, max_len: c.uint, unk1: c.int, unk2: c.int) -> c.uint ---
}

foreign usbserialkern {
  /**
  * Activate USB serial device
  *
  * @return 0 on success, < 0 on error
  *
  * @note The user is responsible for making sure no other UDC driver is active. This activates UDC as a "PS Vita" Type D device.
  */
  ksceUsbSerialStart :: proc() -> c.int ---

  /**
  * Setup USB serial device
  *
  * @return 0 on success, < 0 on error
  *
  * @param unk Unknown
  */
  ksceUsbSerialSetup :: proc(unk: c.int) -> c.int ---

  /**
  * Get USB device status
  *
  * @return Returns 1 when serial port is open
  */
  ksceUsbSerialStatus :: proc() -> c.int ---

  /**
  * Close USB serial device
  */
  ksceUsbSerialClose :: proc() -> c.int ---

  /**
  * Get receive buffer length
  *
  * @return Returns length of USB rx buffer
  */
  ksceUsbSerialGetRecvBufferSize :: proc() -> c.uint ---

  /**
  * Send data
  *
  * @param[in] *buffer data to send over usb
  * @param[in] len int len of serial buffer data
  * @param unk1 Unknown
  * @param unk2 Unknown
  * @note max send length is 0x10000
  */
  ksceUsbSerialSend :: proc(buffer: rawptr, len: SceSize, unk1: c.int, unk2: c.int) -> SceSize ---

  /**
  * Receive Data
  *
  * @param[out] *buffer buffer for incoming data
  * @param[in] max_len max data length to receive
  * @param unk1 Unknown
  * @param unk2 Unknown
  * @note max recv length is 0x10000
  */
  ksceUsbSerialRecv :: proc(buffer: rawptr, max_len: SceSize, unk1: c.int, unk2: c.int) -> SceSize ---
}

