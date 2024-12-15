#+build vita
package vita

import "core:c"

foreign import usbd "system:SceUsbd_stub"
foreign import usbdkern "system:SceUsbdForDriver_stub"

SCE_USBD_CLASS_PER_INTERFACE                :: 0x00
SCE_USBD_CLASS_AUDIO                        :: 0x01
SCE_USBD_CLASS_COMMUNICATIONS               :: 0x02
SCE_USBD_CLASS_HID                          :: 0x03
SCE_USBD_CLASS_MONITOR                      :: 0x04
SCE_USBD_CLASS_PHYSICAL                     :: 0x05
SCE_USBD_CLASS_POWER                        :: 0x06
SCE_USBD_CLASS_PRINTER                      :: 0x07
SCE_USBD_CLASS_STORAGE                      :: 0x08
SCE_USBD_CLASS_HUB                          :: 0x09
SCE_USBD_CLASS_DATA                         :: 0x0a
SCE_USBD_CLASS_VENDOR_SPECIFIC              :: 0xff

SCE_USBD_CONFIGURATION_RESERVED_ZERO        :: 0x1f
SCE_USBD_CONFIGURATION_REMOTE_WAKEUP        :: 0x20
SCE_USBD_CONFIGURATION_SELF_POWERED         :: 0x40
SCE_USBD_CONFIGURATION_RESERVED_ONE         :: 0x80

/* bmAttributes */
SCE_USBD_ENDPOINT_TRANSFER_TYPE_BITS        :: 0x03
SCE_USBD_ENDPOINT_TRANSFER_TYPE_SHIFT       :: 0
SCE_USBD_ENDPOINT_TRANSFER_TYPE_CONTROL     :: 0x00

SCE_USBD_ENDPOINT_TRANSFER_TYPE_ISOCHRONOUS :: 0x01
SCE_USBD_ENDPOINT_TRANSFER_TYPE_BULK        :: 0x02
SCE_USBD_ENDPOINT_TRANSFER_TYPE_INTERRUPT   :: 0x03

/* bEndpointAddress */
SCE_USBD_ENDPOINT_NUMBER_BITS               :: 0x1f
SCE_USBD_ENDPOINT_NUMBER_SHIFT              :: 0
SCE_USBD_ENDPOINT_DIRECTION_BITS            :: 0x80
SCE_USBD_ENDPOINT_DIRECTION_SHIFT           :: 7
SCE_USBD_ENDPOINT_DIRECTION_OUT             :: 0x00
SCE_USBD_ENDPOINT_DIRECTION_IN              :: 0x80

USB_DESCRIPTOR_DEVICE                   :: 0x01    // bDescriptorType for a Device Descriptor.
USB_DESCRIPTOR_CONFIGURATION            :: 0x02    // bDescriptorType for a Configuration Descriptor.
USB_DESCRIPTOR_STRING                   :: 0x03    // bDescriptorType for a String Descriptor.
USB_DESCRIPTOR_INTERFACE                :: 0x04    // bDescriptorType for an Interface Descriptor.
USB_DESCRIPTOR_ENDPOINT                 :: 0x05    // bDescriptorType for an Endpoint Descriptor.

USB_DESCRIPTOR_DEVICE_QUALIFIER         :: 0x06    // bDescriptorType for a Device Qualifier.
USB_DESCRIPTOR_OTHER_SPEED              :: 0x07    // bDescriptorType for a Other Speed Configuration.
USB_DESCRIPTOR_INTERFACE_POWER          :: 0x08    // bDescriptorType for Interface Power.
USB_DESCRIPTOR_OTG                      :: 0x09    // bDescriptorType for an OTG Descriptor.

SCE_USBD_DEVICE_SPEED_LS :: 0
SCE_USBD_DEVICE_SPEED_FS :: 1
SCE_USBD_DEVICE_SPEED_HS :: 2

SceUsbdErrorCode :: enum c.uint {
	ERROR_NOT_INITIALIZED     = 0x80240001,
	ERROR_ALREADY_INITIALIZED = 0x80240002,
	ERROR_INVALID_PARAM       = 0x80240003,
	ERROR_PIPE_NOT_FOUND      = 0x80240004,
	ERROR_NO_MEMORY           = 0x80240005,
	ERROR_DEVICE_NOT_FOUND    = 0x80240006,
	ERROR_80240007            = 0x80240007,
	ERROR_80240009            = 0x80240009,
	ERROR_8024000A            = 0x8024000A,
	ERROR_FATAL               = 0x802400FF
}

SceUsbdDescriptorType :: enum c.int {
	DEVICE            = 0x01,    // bDescriptorType for a Device Descriptor.
	CONFIGURATION     = 0x02,    // bDescriptorType for a Configuration Descriptor.
	STRING            = 0x03,    // bDescriptorType for a String Descriptor.
	INTERFACE         = 0x04,    // bDescriptorType for an Interface Descriptor.
	ENDPOINT          = 0x05,    // bDescriptorType for an Endpoint Descriptor.

	DEVICE_QUALIFIER  = 0x06,    // bDescriptorType for a Device Qualifier.
	OTHER_SPEED       = 0x07,    // bDescriptorType for a Other Speed Configuration.
	INTERFACE_POWER   = 0x08,    // bDescriptorType for Interface Power.
	OTG               = 0x09,    // bDescriptorType for an OTG Descriptor.
	HID               = 0x21,    // bDescriptorType for an HID descriptor.
	REPORT            = 0x22     // bDescriptorType for an HID report descriptor.
}

SceUsbdDeviceDescriptor :: struct {
  bLength: c.uint8_t,
	bDescriptorType: c.uint8_t,
	bcdUSB: c.uint16_t,
	bDeviceClass: c.uint8_t,
	bDeviceSubclass: c.uint8_t,
	bDeviceProtocol: c.uint8_t,
	bMaxPacketSize0: c.uint8_t,
	idVendor: c.uint16_t,
	idProduct: c.uint16_t,
	bcdDevice: c.uint16_t,
	iManufacturer: c.uint8_t,
	iProduct: c.uint8_t,
	iSerialNumber: c.uint8_t,
	bNumConfigurations: c.uint8_t,
}
#assert(size_of(SceUsbdDeviceDescriptor) == 0x12)

SceUsbdConfigurationDescriptor :: struct {
  bLength: c.uint8_t,
	bDescriptorType: c.uint8_t,
	wTotalLength: c.uint16_t,
	bNumInterfaces: c.uint8_t,
	bConfigurationValue: c.uint8_t,
	iConfiguration: c.uint8_t,
	bmAttributes: c.uint8_t,
	MaxPower: c.uint8_t,
}
#assert(size_of(SceUsbdConfigurationDescriptor) == 0xA)

SceUsbdInterfaceDescriptor :: struct {
  bLength: c.uint8_t,
	bDescriptorType: c.uint8_t,
	bInterfaceNumber: c.uint8_t,
	bAlternateSetting: c.uint8_t,
	bNumEndpoints: c.uint8_t,
	bInterfaceClass: c.uint8_t,
	bInterfaceSubclass: c.uint8_t,
	bInterfaceProtocol: c.uint8_t,
	iInterface: c.uint8_t,
}
#assert(size_of(SceUsbdInterfaceDescriptor) == 9)

SceUsbdEndpointDescriptor :: struct {
  bLength: c.uint8_t,
	bDescriptorType: c.uint8_t,
	bEndpointAddress: c.uint8_t,
	bmAttributes: c.uint8_t,
	wMaxPacketSize: c.uint16_t,
	bInterval: c.uint8_t,
}
#assert(size_of(SceUsbdEndpointDescriptor) == 8)

SceUsbdStringDescriptor :: struct {
  bLength: c.uint8_t,
	bDescriptorType: c.uint8_t,
	bString: [0]c.uint8_t,
}
#assert(size_of(SceUsbdStringDescriptor) == 2)

SceUsbdHidSubDescriptorInfo :: struct {
  bDescriptorType: c.uint8_t,
	wDescriptorLength0: c.uint8_t,
	wDescriptorLength1: c.uint8_t,
}
#assert(size_of(SceUsbdHidSubDescriptorInfo) == 3)

SceUsbdHidDescriptor :: struct {
  bLength: c.uint8_t,
	bDescriptorType: c.uint8_t,
	bcdHID0: c.uint8_t,
	bcdHID1: c.uint8_t,
	bCountryCode: c.uint8_t,
	bNumDescriptors: c.uint8_t,  /* SubDescriptor count */
	SubDescriptorInfo: [0]SceUsbdHidSubDescriptorInfo,
}
#assert(size_of(SceUsbdHidDescriptor) == 6)

SceUsbdDeviceAddress :: struct #packed {
  unk0: c.uint,
	unk1: c.ushort,
}
#assert(size_of(SceUsbdDeviceAddress) == 6)


SceUsbdDeviceInfo :: struct {
	port: c.uint,
	device_num: c.uint,
	unk3: c.uint, // handled? 0, 1, 2
}
#assert(size_of(SceUsbdDeviceInfo) == 0xC)

SceUsbdTransferData :: struct {
	pipe: c.uint, // 0x00
	data: rawptr, // 0x04
	data_size: c.uint,  // 0x08
	transferred: rawptr, //  // 0x0C // ptr to 8 bytes?
	timeout: c.uint,  // 0x10 // size of above ptr? only 8 allowed?
}

SceUsbdReceiveEvent :: struct {
	unk0: c.uint, // 0
	unk1: c.uint, // next ptr?
	unk2: c.uint, // != 8, set to 1, 2, 4? // transfer flags? type?
	unk3: c.uint,
	unk4: c.uint,
	unk5: c.uint,
	transfer_id: c.uint,
}
#assert(size_of(SceUsbdReceiveEvent) == 0x1C)

SceUsbdAttachCompositeParam :: struct {
	driver_id: c.uint32_t,
	bus: c.uint32_t,
	device: c.uint32_t,
	unk3: c.uint32_t, // num devices?
	unk4: c.uint32_t,
}
#assert(size_of(SceUsbdAttachCompositeParam) == 0x14)

SceUsbdIsochTransfer :: struct {
	unk0: c.uint, // array of num_packets? ptrs to 4
	unk1: c.uint, // num packets?
	unk2: c.uint,
	unk3: c.uint,

	unk4: c.uint,
	unk5: c.uint,
	unk6: c.uint,
	unk7: c.uint,

	unk8: c.uint,
	unk9: c.uint,
}
#assert(size_of(SceUsbdIsochTransfer) == 0x28)

SceUsbdDevicePipe :: struct {
	device_id: c.uint,
	unk1: c.uint,
	unk2: c.uint,
	unk3: c.uint,
	unk4: c.uint,
	unk5: c.uint,
}
#assert(size_of(SceUsbdDevicePipe) == 0x18)

SceUsbdTransferStatus :: struct {
	unk0: c.uint32_t, // < 0x40 - transfer id (result of sceUsbdTransferData)
	unk1: c.uint32_t, // unused
	unk2: c.uint32_t, // ret 4. ptr? // status?
	unk3: c.uint32_t, // ret 4. ptr? // transferred?
}
#assert(size_of(SceUsbdTransferStatus) == 0x10)

SceUsbdIsochTransferStatus :: struct {
	unk0: c.uint32_t, // < 0x40 - size? pipe? transfer id?
	unk1: c.uint32_t, // unused
	unk2: ^c.uintptr_t, // ret up to 0x28 buff. 10 * 4 bytes. or 8*5 bytes
	unk3: c.uint32_t, // ret 4. ptr?
}

SCE_USBD_PROBE_SUCCEEDED     ::  (0)
SCE_USBD_PROBE_FAILED        ::  (-1)
SCE_USBD_ATTACH_SUCCEEDED    ::  (0)
SCE_USBD_ATTACH_FAILED       ::  (-1)
SCE_USBD_DETACH_SUCCEEDED    ::  (0)
SCE_USBD_DETACH_FAILED       ::  (-1)

SCE_USBD_MAX_LS_CONTROL_PACKET_SIZE     :: 8
SCE_USBD_MAX_FS_CONTROL_PACKET_SIZE     :: 64
SCE_USBD_MAX_ISOCHRONOUS_PACKET_SIZE    :: 1023
SCE_USBD_MAX_LS_INTERRUPT_PACKET_SIZE   :: 8
SCE_USBD_MAX_FS_INTERRUPT_PACKET_SIZE   :: 64
SCE_USBD_MAX_BULK_PACKET_SIZE           :: 64

SCE_USBD_FEATURE_ENDPOINT_HALT          ::     0x00
SCE_USBD_FEATURE_DEVICE_REMOTE_WAKEUP   ::     0x01

SceUsbdDriver :: struct {
	name: cstring,
	probe: #type ^proc "c" (device_id: c.int) -> c.int,
	attach: #type ^proc "c" (device_id: c.int) -> c.int,
	detach: #type ^proc "c" (device_id: c.int) -> c.int,
}

SceUsbdCompositeDriver :: struct {
	name: cstring,
	probe: #type ^proc "c" (device_id: c.int, desc: ^SceUsbdEndpointDescriptor) -> c.int, // endpoint descriptor should be interface one
	attach: #type ^proc "c" (device_id: c.int) -> c.int,
	detach: #type ^proc "c" (device_id: c.int) -> c.int,
}

SceUsbdDeviceRequest :: struct {
	bmRequestType: c.uint8_t,
	bRequest: c.uint8_t,
	wValue: c.uint16_t,
	wIndex: c.uint16_t,
	wLength: c.uint16_t,
}
#assert(size_of(SceUsbdDeviceRequest) == 8)

SceUsbdReqtype :: enum c.int {
	DIR_BITS                  = 0x80,
	DIR_TO_DEVICE             = 0x00,
	DIR_TO_HOST               = 0x80,
	TYPE_BITS                 = 0x60,
	TYPE_STANDARD             = 0x00,
	TYPE_CLASS                = 0x20,
	TYPE_VENDOR               = 0x40,
	TYPE_RESERVED             = 0x60,
	RECIP_BITS                = 0x1f,
	RECIP_DEVICE              = 0x00,
	RECIP_INTERFACE           = 0x01,
	RECIP_ENDPOINT            = 0x02,
	RECIP_OTHER               = 0x03,
}

SceUsbdRequest :: enum c.int {
	GET_STATUS                = 0x00,
	CLEAR_FEATURE             = 0x01,
	SET_FEATURE               = 0x03,
	SET_ADDRESS               = 0x05,
	GET_DESCRIPTOR            = 0x06,
	SET_DESCRIPTOR            = 0x07,
	GET_CONFIGURATION         = 0x08,
	SET_CONFIGURATION         = 0x09,
	GET_INTERFACE             = 0x0a,
	SET_INTERFACE             = 0x0b,
	SYNCH_FRAME               = 0x0c
}

ksceUsbdIsochPswLen :: bit_field c.uint16_t {
	len: c.uint16_t | 12,
	PSW: c.uint16_t | 4,
}
#assert(size_of(ksceUsbdIsochPswLen) == 2)

ksceUsbdIsochTransfer :: struct {
	buffer_base: rawptr,
	relative_start_frame: c.int32_t,
	num_packets: c.int32_t,
	packets: [8]ksceUsbdIsochPswLen,
}

ksceUsbdDoneCallback :: #type ^proc "c" (result: c.int32_t, count: c.int32_t, arg: rawptr)
ksceUsbdIsochDoneCallback :: #type ^proc "c" (result: c.int32_t, req: ^ksceUsbdIsochTransfer, arg: rawptr)

// OHCI/EHCI completion codes
OHCI_CC_NO_ERROR                    ::  0x0
OHCI_CC_CRC                         ::  0x1
OHCI_CC_BIT_STUFFING                ::  0x2
OHCI_CC_DATA_TOGGLE_MISMATCH        ::  0x3
OHCI_CC_STALL                       ::  0x4
OHCI_CC_DEVICE_NOT_RESPONDING       ::  0x5
OHCI_CC_PID_CHECK_FAILURE           ::  0x6
OHCI_CC_UNEXPECTED_PID              ::  0x7
OHCI_CC_DATA_OVERRUN                ::  0x8
OHCI_CC_DATA_UNDERRUN               ::  0x9
OHCI_CC_BUFFER_OVERRUN              ::  0xc
OHCI_CC_BUFFER_UNDERRUN             ::  0xd
OHCI_CC_NOT_ACCESSED1               ::  0xe
OHCI_CC_NOT_ACCESSED2               ::  0xf
EHCI_CC_MISSED_MICRO_FRAME          ::  0x10
EHCI_CC_XACT                        ::  0x20
EHCI_CC_BABBLE                      ::  0x30
EHCI_CC_DATABUF                     ::  0x40
EHCI_CC_HALTED                      ::  0x50

// Isochronous transfer(PSW) completion codes
USBD_CC_NOERR              :: 0x0
USBD_CC_MISSED_MICRO_FRAME :: 0x1
USBD_CC_XACTERR            :: 0x2
USBD_CC_BABBLE             :: 0x4
USBD_CC_DATABUF            :: 0x8

foreign usbd {
	/**
	* Init usb subsystem
	*
	* @return 0 on success, < 0 on error
	*
	* @param[out] uid Pointer to uid
	*
	*/
	sceUsbdInit :: proc(uid: ^SceUID) -> c.int ---

	/**
	* Stop usb subsystem
	*
	* @return 0 on success, < 0 on error
	*
	* @param uid uid
	*
	*/
	sceUsbdEnd :: proc(uid: SceUID) -> c.int ---

	/**
	* Get usb devices list
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] num max number of devices to return (8 max)
	* @param[out] info pointer to receive device info
	*
	*/
	sceUsbdGetDeviceList :: proc(uid: SceUID, num: SceSize, info: ^SceUsbdDeviceInfo) -> c.int --- // 8 devices max


	/**
	* Get usb device descriptors data size
	*
	* @return size on success, < 0 on error
	*
	* @param uid uid
	* @param device_id device id
	*
	*/
	sceUsbdGetDescriptorSize :: proc(uid: SceUID, device_id: c.uint) -> c.int ---

	/**
	* Get usb device descriptors (all)
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] device_id device id
	* @param[out] descriptor buffer for descriptor data
	* @param[in] size buffer size
	*
	*/
	sceUsbdGetDescriptor :: proc(uid: SceUID, device_id: SceUID, descriptor: ^c.uint, size: SceSize) -> c.int ---


	/**
	* Get usb device speed
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] device_id device id
	* @param[out] speed device speed
	*
	*/
	sceUsbdGetDeviceSpeed :: proc(uid: SceUID, device_id: SceUID, speed: ^c.uint) -> c.int ---

	/**
	* Register callback to usb event
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] cbid callback uid
	* @param[in] flag if 1 - trigger events immediately
	*
	* @note there may be only one callback registered through whole system.
	*       And it's currently taken up by shell.
	*
	*/
	sceUsbdRegisterCallback :: proc(cbid: SceUID, flag: c.int) -> c.int ---

	/**
	* Remove callback to usb event
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] cbid callback uid
	*
	* @note this checks process id
	*
	*/
	sceUsbdUnregisterCallback :: proc(cbid: SceUID) -> c.int ---

	/**
	* Reset usb device
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] device_id device id
	*
	*/
	sceUsbdResetDevice :: proc(uid: SceUID, device_id: SceUID) -> c.int ---

	/**
	* Attach specified driver to device
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] driver_id driver id (result of Register(Composite)Ldd)
	* @param[in] bus usb port number
	* @param[in] device usb device number
	*
	* @note device_id = (bus << 16) + device
	*/
	sceUsbdAttach :: proc(uid: SceUID, driver_id: SceUID, bus: SceUInt, device: SceUInt) -> c.int ---

	/**
	* Get device address
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] device_id device id
	* @param[out] addr buffer for return value
	*
	* @note it is unknown what that function actually returns in addr, observed only 0
	*/
	sceUsbdGetDeviceAddress :: proc(uid: SceUID, device_id: SceUID, addr: ^SceUsbdDeviceAddress) -> c.int ---

	/**
	* Get transfer status
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] transfer_id transfer uid
	* @param[out] status buffer for return value
	*
	* @note it is unknown what that function actually returns in addr, observed only 0
	*/
	sceUsbdGetTransferStatus :: proc(transfer_id: SceUID, status: ^SceUsbdTransferStatus) -> c.int ---

	/**
	* Get isochronous transfer status
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] transfer_id transfer uid
	* @param[out] status buffer for return value
	*
	* @note it is unknown what that function actually returns in addr, observed only 0
	*/
	sceUsbdGetIsochTransferStatus :: proc(transfer_id: SceUID, status: ^SceUsbdIsochTransferStatus) -> c.int ---


	/**
	* Open endpoint communication pipe
	*
	* @return pipe_id on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] pipe endpoint to open
	*
	*/
	sceUsbdOpenPipe :: proc(uid: SceUID, pipe: ^SceUsbdDevicePipe) -> SceUID ---

	/**
	* Open endpoint communication pipe for default config endpoint
	*
	* @return pipe_id on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] device_id device id
	*
	*/
	sceUsbdOpenDefaultPipe :: proc(uid: SceUID, device_id: SceUID) -> SceUID ---

	/**
	* Close endpoint communication pipe
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] pipe_id pipe uid
	*
	*/
	sceUsbdClosePipe :: proc(uid: SceUID, pipe_id: SceUID) -> c.int ---

	/**
	* Transfer data to/from endpoint
	*
	* @return transfer_id on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] data data to transfer
	*
	*/
	sceUsbdTransferData :: proc(uid: SceUID, data: ^SceUsbdTransferData) -> SceUID ---

	/**
	* Transfer data to/from endpoint isochronously
	*
	* @return transfer_id on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] pipe_id pipe uid
	* @param[in] transfer data to transfer
	*
	*/
	sceUsbdIsochTransferData :: proc(uid: SceUID, pipe_id: SceUID, transfer: ^SceUsbdIsochTransfer) -> c.int ---

	/**
	* Receive usb event
	*
	* @return transfer_id on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[out] event
	*
	*/
	sceUsbdReceiveEvent :: proc(uid: SceUID, event: ^SceUsbdReceiveEvent) -> c.int ---

	/**
	* Register logical device driver
	*
	* @return driver_id on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] name driver name, 255 max
	*
	*/
	sceUsbdRegisterLdd :: proc(uid: SceUID, name: cstring) -> SceUID ---

	/**
	* Register logical device driver for composite devices
	*
	* @return driver_id on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] name driver name, 255 max
	*
	*/
	sceUsbdRegisterCompositeLdd :: proc(uid: SceUID, name: cstring) -> SceUID ---

	/**
	* De-register logical device driver
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] name driver name, 255 max
	*
	*/
	sceUsbdUnregisterLdd :: proc(uid: SceUID, name: cstring) -> c.int ---

	/**
	* Attach composite driver to device
	*
	* @return 0 on success, < 0 on error
	*
	* @param[in] uid uid
	* @param[in] param parameters
	*
	*/
	sceUsbdAttachCompositeLdd :: proc(uid: SceUID, param: ^SceUsbdAttachCompositeParam) -> c.int ---
}

foreign usbdkern {
	/**
	* Register USB driver
	*
	* @return 0 on success, < 0 on error
	*
	* @param driver driver struct
	*
	*/
	ksceUsbdRegisterDriver :: proc(#by_ptr driver: SceUsbdDriver) -> c.int ---

	/**
	* Register USB driver for composite devices
	*
	* @return 0 on success, < 0 on error
	*
	* @param driver driver struct
	*
	*/
	ksceUsbdRegisterCompositeLdd :: proc(#by_ptr driver: SceUsbdCompositeDriver) -> c.int ---

	/**
	* De-register USB driver
	*
	* @return 0 on success, < 0 on error
	*
	* @param driver driver struct
	*
	*/
	ksceUsbdUnregisterDriver :: proc(#by_ptr driver: SceUsbdDriver) -> c.int ---

	/**
	* De-register USB driver for composite devices
	*
	* @return 0 on success, < 0 on error
	*
	* @param driver driver struct
	*
	*/
	ksceUsbdUnregisterCompositeLdd :: proc(#by_ptr driver: SceUsbdCompositeDriver) -> c.int ---


	/**
	* Return usb descriptor
	*
	* @return descriptor data on success, NULL on error
	*
	* @param device_id device id
	* @param start pointer to descriptor to start scanning from (may be NULL)
	* @param type descriptor type
	*
	*/
	ksceUsbdScanStaticDescriptor :: proc(device_id: SceUID, start: rawptr, type: SceUsbdDescriptorType) -> rawptr ---

	/**
	* Open communication pipe to endpoint
	*
	* @return pipe uid on success, < 0 on error
	*
	* @param device_id device id
	* @param endpoint endpoint (may be null for default configuration endpoint)
	*
	*/
	ksceUsbdOpenPipe :: proc(device_id: c.int, endpoint: ^SceUsbdEndpointDescriptor) -> SceUID ---

	/**
	* Close communication pipe to endpoint
	*
	* @return 0 on success, < 0 on error
	*
	* @param pipe_id pipe id
	*
	*/
	ksceUsbdClosePipe :: proc(pipe_id: SceUID) -> c.int ---

	/**
	* Transfer data to/from endpoint
	*
	* @return 0 on success, < 0 on error
	*
	* @param pipe_id pipe id
	* @param req transfer request
	* @param buffer data
	* @param cb transfer callback
	* @param user_data userdata to pass to callback
	*
	*/
	ksceUsbdControlTransfer :: proc(pipe_id: SceUID, #by_ptr req: SceUsbdDeviceRequest, buffer: [^]c.uchar, cb: ksceUsbdDoneCallback, user_data: rawptr) -> c.int ---

	/**
	* Transfer data to/from interrupt endpoint
	*
	* @return 0 on success, < 0 on error
	*
	* @param pipe_id pipe id
	* @param buffer data
	* @param length data length
	* @param cb transfer callback
	* @param user_data userdata to pass to callback
	*
	*/
	ksceUsbdInterruptTransfer :: proc(pipe_id: SceUID, buffer: [^]c.uchar, length: SceSize, cb: ksceUsbdDoneCallback, user_data: rawptr) -> c.int ---

	/**
	* Transfer isochronous data to/from endpoint
	*
	* @return 0 on success, < 0 on error
	*
	* @param pipe_id pipe id
	* @param transfer transfer request
	* @param cb transfer callback
	* @param user_data userdata to pass to callback
	*
	*/
	ksceUsbdIsochronousTransfer :: proc(pipe_id: SceUID, transfer: ^ksceUsbdIsochTransfer, cb: ksceUsbdIsochDoneCallback, user_data: rawptr) -> c.int ---

	/**
	* Transfer data to/from endpoint
	*
	* @return 0 on success, < 0 on error
	*
	* @param pipe_id pipe id
	* @param buffer data
	* @param length data length
	* @param cb transfer callback
	* @param user_data userdata to pass to callback
	*
	* @note buffer pointer must be 64b aligned
	*/
	ksceUsbdBulkTransfer :: proc(pipe_id: SceUID, buffer: [^]c.uchar, length: c.uint, cb: ksceUsbdDoneCallback, user_data: rawptr) -> c.int ---

	/**
	* Transfer data to/from endpoint
	*
	* @return 0 on success, < 0 on error
	*
	* @param pipe_id pipe id
	* @param buffer data
	* @param length data length
	* @param cb transfer callback
	* @param user_data userdata to pass to callback
	*
	* @note buffer pointer must be 64b aligned
	*/
	ksceUsbdBulkTransfer2 :: proc(pipe_id: c.int, buffer: [^]c.uchar, length: c.uint, cb: ksceUsbdDoneCallback, user_data: rawptr) -> c.int ---


	/**
	* Get device location
	*
	* @return 0 on success, < 0 on error
	*
	* @param device_id device id
	* @param[out] location device location data (port)
	*
	*/
	ksceUsbdGetDeviceLocation :: proc(device_id: SceUID, location: ^c.uint8_t) -> c.int ---

	ksceUsbdSuspend :: proc(port: c.int) -> c.int ---
	ksceUsbdSuspendPhase2 :: proc(port: c.int, flag: c.int) -> c.int ---
	ksceUsbdResume :: proc(port: c.int) -> c.int ---

	ksceUsbdHostStop :: proc(port: c.int) -> c.int ---
	ksceUsbdHostStart :: proc(port: c.int) -> c.int ---

	/**
	* Get device speed
	*
	* @return 0 on success, < 0 on error
	*
	* @param device_id device id
	* @param[out] speed device speed
	*
	*/
	ksceUsbdGetDeviceSpeed :: proc(device_id: c.int, speed: ^c.uint8_t) -> c.int ---

	ksceUsbd_05073925 :: proc(device_id: SceUID, unk1: ^c.int, unk2: ^c.int) -> c.int ---
	ksceUsbd_7938DAC7 :: proc(pipe_id: SceUID) -> c.int --- // clear halt?
}

