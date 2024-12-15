#+build vita
package vita

import "core:c"

foreign import usbaudioin "system:SceUsbAudioIn_stub"

SceUsbAudioInErrorCode :: enum c.uint {
    INVALID_ARGUMENT = 0x803e0001,
    DUPLICATE_ID = 0x803e0002,
    NO_MEMORY = 0x803e0003,
    DEVICE_NOT_FOUND = 0x803e0004,
    NOT_SUPPORTED = 0x803e0005,
    CANNOT_GET_PORT_OWNERSHIP = 0x803e0006,
    PORT_IS_ALREADY_OPENED = 0x803e0007,
    PROCESS_HAS_NOT_A_DEVICE_OWNERSHIP = 0x803e0008,
    FAILED_TO_READ_STREAM = 0x803e0009,
    DEVICE_WAS_HALTED = 0x803e000a,
    NO_DATA_TO_READ = 0x803e000b,
    FAILED_TO_COPY_BUFFER = 0x803e000c,
    FAILED_TO_REQUEST_ISOCHRONOUS = 0x803e000d,
    TIMEOUT = 0x803e000e,
    PROCESS_CANNOT_OPEN_MORE_DEVICE = 0x803e000f,
}

SceUsbAudioInDeviceInfo :: struct {
  vendor: c.uint16_t,
  product: c.uint16_t,
  _reserved: [5]SceUInt32,
}
#assert(size_of(SceUsbAudioInDeviceInfo) == 0x18)

SceUsbAudioInDeviceListItem :: struct {
  device_id: SceUInt32,
}
#assert(size_of(SceUsbAudioInDeviceListItem) == 4)

foreign usbaudioin {
    /**
    * Open usb audio device
    *
    * @return 0 on success, < 0 on error
    *
    * @param[in] device_id - Device id
    * @param[in] bits - Bits per sample. Only 16 allowed
    * @param[in] rate - Bitrate in Hz. Only 48000 allowed
    */
    sceUsbAudioInOpenDevice :: proc(device_id: SceUInt32, bits: c.int, rate: c.int) -> SceInt32 ---

    /**
    * Close usb audio device
    *
    * @return 0 on success, < 0 on error
    *
    * @param[in] device_id - Device id
    */
    sceUsbAudioInCloseDevice :: proc(device_id: SceUInt32) -> SceInt32 ---

    /**
    * Get available audio usb devices
    *
    * @return 0 on success, < 0 on error
    *
    * @param[out] list - pointer to array of SceUsbAudioInDeviceListItem
    * @param[out] device_count - connected device count
    * @param[in] list_size - number of items in SceUsbAudioInDeviceListItem array
    *
    * @note While function accepts up to 127 as list_size it can only return maximum 7 devices
    */
    sceUsbAudioInGetDeviceIdList :: proc(list: ^SceUsbAudioInDeviceListItem, device_count: ^SceUInt32, list_size: SceUInt32) -> SceInt32 ---

    /**
    * Get usb audio device info
    *
    * @return 0 on success, < 0 on error
    *
    * @param[in] device_id - Device id
    * @param[out] info - pointer to SceUsbAudioInDeviceInfo
    */
    sceUsbAudioInGetDeviceInformation :: proc(device_id: SceUInt32, info: ^SceUsbAudioInDeviceInfo) -> SceInt32 ---

    /**
    * Get usb audio device max volume
    *
    * @return 0 on success, < 0 on error
    *
    * @param[in] device_id - Device id
    * @param[out] volume - maximum device volume
    *
    * @note You should OpenDevice first to use this function
    */
    sceUsbAudioInGetMaxValueOfVolume :: proc(device_id: SceUInt32, volume: ^SceUInt32) -> SceInt32 ---

    /**
    * Get usb audio device min volume
    *
    * @return 0 on success, < 0 on error
    *
    * @param[in] device_id - Device id
    * @param[out] volume - minimum device volume
    *
    * @note You should OpenDevice first to use this function
    */
    sceUsbAudioInGetMinValueOfVolume :: proc(device_id: SceUInt32, volume: ^SceUInt32) -> SceInt32 ---

    /**
    * Set usb audio device volume
    *
    * @return 0 on success, < 0 on error
    *
    * @param[in] device_id - Device id
    * @param[in] volume - new device volume
    *
    * @note You should OpenDevice first to use this function
    */
    sceUsbAudioInSetCurrentValueOfVolume :: proc(device_id: SceUInt32, volume: SceUInt32) -> SceInt32 ---

    /**
    * Receive sound data from usb device
    *
    * @return 0 on success, < 0 on error
    *
    * @param[in] device_id - Device id
    * @param[out] buffer - buffer for received data. Should be 0x600 bytes in size.
    *
    * @note You should call OpenDevice first to use this function
    * @note Data is in S16_MONO format. Granularity is 768 (thus buffer is 768*2)
    */
    sceUsbAudioInInput :: proc(device_id: SceUInt32, buffer: rawptr) -> SceInt32 ---
}

