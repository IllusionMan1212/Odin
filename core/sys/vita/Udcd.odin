#+build vita
package vita

import "core:c"

foreign import udcd "system:SceUdcd_stub"
foreign import udcdkern "system:SceUdcdForDriver_stub"

SceUdcdStatus :: enum c.int {
	CONNECTION_NEW          = 0x0001,
	CONNECTION_ESTABLISHED  = 0x0002,
	CONNECTION_SUSPENDED    = 0x0004,
	CABLE_DISCONNECTED      = 0x0010,
	CABLE_CONNECTED         = 0x0020,
	DEACTIVATED             = 0x0100,
	ACTIVATED               = 0x0200,
	IS_CHARGING             = 0x0400,
	USE_USB_CHARGING        = 0x0800,
	UNKNOWN_1000            = 0x1000,
	UNKNOWN_2000            = 0x2000
}

SceUdcdStatusDriver :: enum c.int {
	STARTED         = 0x01,
	REGISTERED      = 0x02,
}

SceUdcdDeviceInfo :: struct {
  info: [64]c.uchar,
}
#assert(size_of(SceUdcdDeviceInfo) == 0x40)

SceUdcdWaitParam :: struct {
  unk_00: c.int,
	status: c.int,
	unk_08: c.int,
	unk_0C: c.int,
	unk_10: c.int,
	driverName: cstring,
}

SceUdcdDeviceState :: struct {
	unk_00: c.int,
	state: c.int,
	cable: c.int,
	connection: c.int,
	use_usb_charging: c.int,
	unk_14: c.int,
}
#assert(size_of(SceUdcdDeviceState) == 0x18)


/** Enumeration for Device and/or Interface Class codes
 */
SceUdcdUsbClass :: enum c.int {
	PER_INTERFACE       = 0x00,  //!< for DeviceClass
	AUDIO               = 0x01,
	COMM                = 0x02,
	HID                 = 0x03,
	PTP                 = 0x06,
	PRINTER             = 0x07,
	MASS_STORAGE        = 0x08,
	HUB                 = 0x09,
	DATA                = 0x0A,
	VIDEO               = 0x0E,
	VENDOR_SPEC         = 0xFF
}

/** Enumeration for descriptor types
 */
SceUdcdUsbDt :: enum c.int {
	DEVICE         = 0x01,
	CONFIG         = 0x02,
	STRING         = 0x03,
	INTERFACE      = 0x04,
	ENDPOINT       = 0x05
}

/** Enumeration for standard requests
 */
SceUdcdUsbReq :: enum c.int {
	GET_STATUS      = 0x00,
	CLEAR_FEATURE   = 0x01,
	SET_FEATURE     = 0x03,
	SET_ADDRESS     = 0x05,
	GET_DESCRIPTOR  = 0x06,
	SET_DESCRIPTOR  = 0x07,
	GET_CONFIG      = 0x08,
	SET_CONFIG      = 0x09,
	GET_INTERFACE   = 0x0A,
	SET_INTERFACE   = 0x0B,
	SYNC_FRAME      = 0x0C
}

/**
 * Descriptor sizes per descriptor type
 */
USB_DT_DEVICE_SIZE :: 18
USB_DT_CONFIG_SIZE :: 9
USB_DT_INTERFACE_SIZE :: 9
USB_DT_ENDPOINT_SIZE :: 7
USB_DT_ENDPOINT_AUDIO_SIZE :: 9	//!< Audio extension
USB_DT_HUB_NONVAR_SIZE :: 7

/** Control message request type bitmask
 */
USB_CTRLTYPE_DIR_MASK :: 0x80
USB_CTRLTYPE_DIR_HOST2DEVICE :: (0 << 7)
USB_CTRLTYPE_DIR_DEVICE2HOST :: (1 << 7)
USB_CTRLTYPE_TYPE_MASK :: 0x60
USB_CTRLTYPE_TYPE_STANDARD :: (0 << 5)
USB_CTRLTYPE_TYPE_CLASS :: (1 << 5)
USB_CTRLTYPE_TYPE_VENDOR :: (2 << 5)
USB_CTRLTYPE_TYPE_RESERVED :: (3 << 5)
USB_CTRLTYPE_REC_MASK :: 0x1f
USB_CTRLTYPE_REC_DEVICE :: 0
USB_CTRLTYPE_REC_INTERFACE :: 1
USB_CTRLTYPE_REC_ENDPOINT :: 2
USB_CTRLTYPE_REC_OTHER :: 3

/** Endpoint types and masks
 */
USB_ENDPOINT_ADDRESS_MASK    ::   0x0f    /* in bEndpointAddress */
USB_ENDPOINT_DIR_MASK        ::   0x80

USB_FEATURE_ENDPOINT_HALT :: 0

USB_ENDPOINT_IN :: 0x80
USB_ENDPOINT_OUT :: 0x00

USB_ENDPOINT_TYPE_MASK        ::  0x03    /* in bmAttributes */
USB_ENDPOINT_TYPE_CONTROL     ::  0
USB_ENDPOINT_TYPE_ISOCHRONOUS ::  1
USB_ENDPOINT_TYPE_BULK        ::  2
USB_ENDPOINT_TYPE_INTERRUPT   ::  3

/* HID constants. Not part of chapter 9 */

/** Class-Specific Requests
 */
SceUdcdHidRequest :: enum c.int {
	GET_REPORT     = 0x01,
	GET_IDLE       = 0x02,
	GET_PROTOCOL   = 0x03,
	SET_REPORT     = 0x09,
	SET_IDLE       = 0x0A,
	SET_PROTOCOL   = 0x0B
}

/** Class Descriptor Types
 */
SceUdcdHidDescriptor :: enum c.int {
	HID     = 0x21,
	REPORT  = 0x22,
	PHY      = 0x23
}

/** Protocol Selection
 */
SceUdcdProtocol :: enum c.int {
	BOOT_PROTOCOL  = 0x00,
	RPT_PROTOCOL   = 0x01
}

/** HID Interface Class Code
 */
HID_INTF :: 0x03

/** HID Interface Class SubClass Codes
 */
BOOT_INTF_SUBCLASS :: 0x01

/** HID Interface Class Protocol Codes
 */
SceUdcdHidProtocol :: enum c.int {
	NONE      = 0x00,
	KEYBOARD  = 0x01,
	MOUSE     = 0x02
}

/** USB limits
 */
SCE_UDCD_MAX_INTERFACES   ::  8
SCE_UDCD_MAX_ENDPOINTS    ::  9
SCE_UDCD_MAX_ALTERNATE    ::  2

SceUdcdRetcode :: enum c.int {
	CANCEL              = -1,
	CANCEL_ALL          = -2,
	CANCEL_TRANSMISSION = -3,
	SUCCESS             =  0,
	SEND                =  1,
	RECV                =  2
}

/** Error codes
 */
SceUdcdErrorCode :: enum c.uint {
	ILLEGAL_CONTEXT          = 0x80000030,
	INVALID_POINTER          = 0x80000103,
	INVALID_FLAG             = 0x80000105,
	INVALID_VALUE            = 0x800001FE,
	ALREADY_DONE             = 0x80243001,
	INVALID_ARGUMENT         = 0x80243002,
	ARGUMENT_EXCEEDED_LIMIT  = 0x80243003,
	MEMORY_EXHAUSTED         = 0x80243004,
	DRIVER_NOT_FOUND         = 0x80243005,
	DRIVER_IN_PROGRESS       = 0x80243006,
	BUS_DRIVER_NOT_STARTED   = 0x80243007,
	WAIT_TIMEOUT             = 0x80243008,
	WAIT_CANCEL              = 0x80243009,
	USBDRIVER_INVALID_DRIVER = 0x80243200,
	USBDRIVER_INVALID_NAME   = 0x80243201,
	USBDRIVER_INVALID_FUNCS  = 0x80243202
}

/** SceUdcdDeviceRequest Flags
 */
SceUdcdDeviceRequestAttr :: enum c.int {
	PHYCONT = 0x00000001
}

/**  USB string descriptor
 */
SceUdcdStringDescriptor :: struct {
	bLength: c.uchar,
	bDescriptorType: c.uchar,
	bString: [31]c.short,
}
#assert(size_of(SceUdcdStringDescriptor) == 0x40)

/**  USB device descriptor
 */
SceUdcdDeviceDescriptor :: struct #align(4) {
	bLength: c.uchar,
	bDescriptorType: c.uchar,
	bcdUSB: c.ushort,
	bDeviceClass: c.uchar,
	bDeviceSubClass: c.uchar,
	bDeviceProtocol: c.uchar,
	bMaxPacketSize0: c.uchar,
	idVendor: c.ushort,
	idProduct: c.ushort,
	bcdDevice: c.ushort,
	iManufacturer: c.uchar,
	iProduct: c.uchar,
	iSerialNumber: c.uchar,
	bNumConfigurations: c.uchar,
}
#assert(size_of(SceUdcdDeviceDescriptor) == 0x14)

/**  USB device qualifier descriptor
 */
SceUdcdDeviceQualifierDescriptor :: struct #align(4) {
	bLength: c.uchar,
	bDescriptorType: c.uchar,
	bcdUSB: c.ushort,
	bDeviceClass: c.uchar,
	bDeviceSubClass: c.uchar,
	bDeviceProtocol: c.uchar,
	bMaxPacketSize0: c.uchar,
	bNumConfigurations: c.uchar,
	bReserved: c.uchar,
}
#assert(size_of(SceUdcdDeviceQualifierDescriptor) == 0xC)

/**  USB configuration descriptor
 */
SceUdcdConfigDescriptor :: struct {
	bLength: c.uchar,
	bDescriptorType: c.uchar,
	wTotalLength: c.ushort,
	bNumInterfaces: c.uchar,
	bConfigurationValue: c.uchar,
	iConfiguration: c.uchar,
	bmAttributes: c.uchar,
	bMaxPower: c.uchar,
	settings: ^SceUdcdInterfaceSettings,
	extra: [^]c.char,                       //!< Extra descriptors
	extraLength: c.int,
}

/**  USB driver interfaces structure
 */
SceUdcdInterfaceSettings :: struct {
	descriptors: [^]SceUdcdInterfaceDescriptor, //!< Pointers to the individual interface descriptors
	alternateSetting: c.uint,
	numDescriptors: c.uint,                    //!< Number of interface descriptors
}

/**  USB Interface descriptor
 */
SceUdcdInterfaceDescriptor :: struct {
	bLength: c.uchar,
	bDescriptorType: c.uchar,
	bInterfaceNumber: c.uchar,
	bAlternateSetting: c.uchar,
	bNumEndpoints: c.uchar,
	bInterfaceClass: c.uchar,
	bInterfaceSubClass: c.uchar,
	bInterfaceProtocol: c.uchar,
	iInterface: c.uchar,
	endpoints: [^]SceUdcdEndpointDescriptor,
	extra: [^]c.char,                         //!< Extra descriptors
	extraLength: c.int,
}

/**  USB endpoint descriptor
 */
SceUdcdEndpointDescriptor :: struct {
	bLength: c.uchar,
	bDescriptorType: c.uchar,
	bEndpointAddress: c.uchar,
	bmAttributes: c.uchar,
	wMaxPacketSize: c.ushort,
	bInterval: c.uchar,
	extra: [^]c.char,              //!< Extra descriptors
	extraLength: c.int,
}

/**  USB driver interface
 */
SceUdcdInterface :: struct {
	expectNumber: c.int,     //!< Expectant interface number (interface number or -1)
	interfaceNumber: c.int,  //!< End interface
	numInterfaces: c.int,    //!< Number of interfaces
}
#assert(size_of(SceUdcdInterface) == 0xC)

/**  USB driver endpoint
 */
SceUdcdEndpoint :: struct {
	direction: c.int,            //!< USB_ENDPOINT_IN /  USB_ENDPOINT_OUT
	driverEndpointNumber: c.int, //!< Driver Endpoint number (must be filled in sequentially)
	endpointNumber: c.int,       //!< Endpoint number (Filled in by the bus driver)
	transmittedBytes: c.int,     //!< Number of transmitted bytes
}
#assert(size_of(SceUdcdEndpoint) == 0x10)

/**  USB driver configuration
 */
SceUdcdConfiguration :: struct {
	configDescriptors: ^SceUdcdConfigDescriptor,     //!< Pointer to the configuration descriptors
	settings: ^SceUdcdInterfaceSettings,              //!< USB driver interface settings
	interfaceDescriptors: ^SceUdcdInterfaceDescriptor,  //!< Pointer to the first interface descriptor
	endpointDescriptors: ^SceUdcdEndpointDescriptor,   //!< Pointer to the first endpoint descriptor
}

/**  USB EP0 Device Request
 */
SceUdcdEP0DeviceRequest :: struct {
	bmRequestType: c.uchar,
	bRequest: c.uchar,
	wValue: c.ushort,
	wIndex: c.ushort,
	wLength: c.ushort,
}
#assert(size_of(SceUdcdEP0DeviceRequest) == 8)

/**  USB driver structure
 */
SceUdcdDriver :: struct {
	driverName: cstring,                         //!< Name of the USB driver
	numEndpoints: c.int,                               //!< Number of endpoints in this driver (including default control)
	endpoints: ^SceUdcdEndpoint,                     //!< List of endpoint structures (used when calling other functions)
	interface: ^SceUdcdInterface,                    //!< Interface list
	descriptor_hi: ^SceUdcdDeviceDescriptor,         //!< Pointer to hi-speed device descriptor
	configuration_hi: ^SceUdcdConfiguration,         //!< Pointer to hi-speed device configuration
	descriptor: ^SceUdcdDeviceDescriptor,            //!< Pointer to full-speed device descriptor
	configuration: ^SceUdcdConfiguration,            //!< Pointer to full-speed device configuration
	stringDescriptors: ^SceUdcdStringDescriptor, //!< Default string descriptors
	stringDescriptorProduct: ^SceUdcdStringDescriptor, //!< Product string descriptor (iProduct has to be 2)
	stringDescriptorSerial: ^SceUdcdStringDescriptor, //!< Serial string descriptor (iSerial has to be 3)
	processRequest: #type ^proc "c" (recipient: c.int, arg: c.int, req: ^SceUdcdEP0DeviceRequest, user_data: rawptr) -> c.int,//!< Received a control request
	changeSetting: #type ^proc "c" (interfaceNumber: c.int, alternateSetting: c.int, bus: c.int) -> c.int,//!< Change alternate setting
	attach: #type ^proc "c" (usb_version: c.int, user_data: rawptr) -> c.int,//!< Configuration set (attach) function
	detach: #type ^proc "c" (user_data: rawptr),//!< Configuration unset (detach) function
	configure: #type ^proc "c" (usb_version: c.int, desc_count: c.int, settings: ^SceUdcdInterfaceSettings, user_data: rawptr), //!< Configure the device
	start: #type ^proc "c" (size: c.int, args: rawptr, user_data: rawptr) -> c.int, //!< Function called when the driver is started
	stop: #type ^proc "c" (size: c.int, args: rawptr, user_data: rawptr) -> c.int,//!< Function called when the driver is stopped
	user_data: rawptr,                   //!< User data
	bus: c.int,                   //!< USB bus
	link: ^SceUdcdDriver,          //!< Link to next USB driver in the chain, set to NULL
}

/**  USB device request
 */
SceUdcdDeviceRequest :: struct {
	endpoint: ^SceUdcdEndpoint,                            //!< Pointer to the endpoint to queue request on
	data: rawptr,                                           //!< Pointer to the data buffer to use in the request
	attributes: c.uint,                              //!< Request attributes (See ::SceUdcdDeviceRequestAttr)
	size: c.int,                                            //!< Size of the data buffer
	isControlRequest: c.int,                                //!< Is a control request?
	onComplete: #type ^proc "c" (req: ^SceUdcdDeviceRequest), //!< Pointer to the function to call on completion
	transmitted: c.int,                                     //!< Number of transmitted bytes
	returnCode: c.int,                                      //!< Return code of the request (See ::SceUdcdRetcode)
	next: ^SceUdcdDeviceRequest,                    //!< Link pointer to next request used by the driver, set it to NULL
	unused: rawptr,                                         //!< An unused value (maybe an argument)
	physicalAddress: rawptr,                                //!< Physical address
}

/**  USB driver name
 */
SceUdcdDriverName :: struct #align(16) {
	size: c.int,
	name: [32]c.char,
	flags: c.int,
}

foreign udcd {
	/**
	* Get device state
	*
	* @param[out] state - Device state
	*
	* @return 0 on success, < 0 on error.
	*/
	sceUdcdGetDeviceState :: proc(state: ^SceUdcdDeviceState) -> c.int ---

	/**
	* Get device information
	*
	* @param[out] devInfo - Device information
	*
	* @return 0 on success, < 0 on error.
	*/
	sceUdcdGetDeviceInfo :: proc(devInfo: ^SceUdcdDeviceInfo) -> c.int ---

	/**
	* Get state of a specific USB driver
	*
	* @param driverName - name of USB driver to get status from
	*
	* @return SCE_UDCD_STATUS_DRIVER_STARTED if the driver has been started, SCE_UDCD_STATUS_DRIVER_REGISTERED if it is stopped
	*/
	sceUdcdGetDrvState :: proc(driverName: cstring) -> c.int ---

	/**
	* Register callback
	*
	* @param[in] cbid - Callback UID
	* @param[in] state - State
	*
	* @return 0 on success, < 0 on error.
	*/
	sceUdcdRegisterCallback :: proc(cbid: SceUID, state: c.int) -> c.int ---

	/**
	* Unregister callback
	*
	* @param[in] cbid - Callback UID
	*
	* @return 0 on success, < 0 on error.
	*/
	sceUdcdUnregisterCallback :: proc(cbid: SceUID) -> c.int ---

	/**
	* Wait for state
	*
	* @param[in] waitParam - Wait parameter
	* @param[in] timeout - Timeout
	*
	* @return 0 on success, < 0 on error.
	*/
	sceUdcdWaitState :: proc(waitParam: ^SceUdcdWaitParam, timeout: c.uint) -> c.int ---
}

foreign udcdkern {
	/**
	* Waits until an UDCD bus is initialized
	*
	* @param[in] timeout - Timeout
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdWaitBusInitialized :: proc(timeout: c.uint, bus: c.int) -> c.int ---

	/**
	* Start a USB driver.
	*
	* @param driverName - Name of the USB driver to start
	* @param size - Size of arguments to pass to USB driver start
	* @param args - Arguments to pass to USB driver start
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdStart :: proc(driverName: cstring, size: c.int, args: rawptr) -> c.int ---

	/**
	* Start a USB driver for an UDCD bus.
	*
	* @param driverName - Name of the USB driver to start
	* @param size - Size of arguments to pass to USB driver start
	* @param args - Arguments to pass to USB driver start
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdStartInternal :: proc(driverName: cstring, size: c.int, args: rawptr, bus: c.int) -> c.int ---

	/**
	* Starts the current USB driver for an UDCD bus.
	*
	* @param[in] unused - Unused
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdStartCurrentInternal :: proc(unused: c.int, bus: c.int) -> c.int ---

	/**
	* Stop a USB driver.
	*
	* @param driverName - Name of the USB driver to stop
	* @param size - Size of arguments to pass to USB driver start
	* @param args - Arguments to pass to USB driver start
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdStop :: proc(driverName: cstring, size: c.int, args: rawptr) -> c.int ---

	/**
	* Stop a USB driver for an UDCD bus.
	*
	* @param driverName - Name of the USB driver to stop
	* @param size - Size of arguments to pass to USB driver start
	* @param args - Arguments to pass to USB driver start
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdStopInternal :: proc(driverName: cstring, size: c.int, args: rawptr, bus: c.int) -> c.int ---

	/**
	* Stops the current USB driver for an UDCD bus.
	*
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdStopCurrentInternal :: proc(bus: c.int) -> c.int ---

	/**
	* Activate a USB driver.
	*
	* @param pid - Product ID for the default USB Driver
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdActivate :: proc(productId: c.uint) -> c.int ---

	/**
	* Activate a USB driver for an UDCD bus.
	*
	* @param pid - Product ID for the default USB Driver
	* @param[in] bus_powered - Enable USB bus power
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdActivateInternal :: proc(productId: c.uint, bus_powered: c.uint, bus: c.int) -> c.int ---

	/**
	* Deactivate USB driver.
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdDeactivate :: proc() -> c.int ---

	/**
	* Deactivate USB driver for an UDCD bus.
	*
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdDeactivateInternal :: proc(bus: c.int) -> c.int ---

	/**
	* Get USB state
	*
	* @return One or more ::SceUdcdStatus.
	*/
	ksceUdcdGetDeviceState :: proc() -> c.int ---

	/**
	* Get USB state for an UDCD bus
	*
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return One or more ::SceUdcdStatus.
	*/
	ksceUdcdGetDeviceStateInternal :: proc(bus: c.int) -> c.int ---

	/**
	* Get device information
	*
	* @param[out] devInfo - Device information
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdGetDeviceInfo :: proc(devInfo: ^SceUdcdDeviceInfo) -> c.int ---

	/**
	* Get device information for an UDCD bus
	*
	* @param[out] devInfo - Device information
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdGetDeviceInfoInternal :: proc(devInfo: ^SceUdcdDeviceInfo, bus: c.int) -> c.int ---

	/**
	* Get state of a specific USB driver
	*
	* @param driverName - name of USB driver to get status from
	*
	* @return SCE_UDCD_STATUS_DRIVER_STARTED if the driver has been started, SCE_UDCD_STATUS_DRIVER_REGISTERED if it is stopped
	*/
	ksceUdcdGetDrvState :: proc(driverName: cstring) -> c.int ---

	/**
	* Get state of a specific USB driver for an UDCD bus
	*
	* @param driverName - name of USB driver to get status from
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return SCE_UDCD_STATUS_DRIVER_STARTED if the driver has been started, SCE_UDCD_STATUS_DRIVER_REGISTERED if it is stopped
	*/
	ksceUdcdGetDrvStateInternal :: proc(driverName: cstring, bus: c.int) -> c.int ---

	/**
	* Wait for state
	*
	* @param[in] waitParam - Wait parameter
	* @param[in] timeout - Timeout
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdWaitState :: proc(waitParam: ^SceUdcdWaitParam, timeout: c.uint) -> c.int ---

	/**
	* Wait for state for an UDCD bus
	*
	* @param[in] waitParam - Wait parameter
	* @param[in] timeout - Timeout
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error.
	*/
	ksceUdcdWaitStateInternal :: proc(waitParam: ^SceUdcdWaitParam, timeout: c.uint, bus: c.int) -> c.int ---

	/**
	* Register a USB driver.
	*
	* @param drv - Pointer to a filled out USB driver
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdRegister :: proc(drv: ^SceUdcdDriver) -> c.int ---

	/**
	* Register a USB driver to a specific USB bus.
	*
	* @param drv - Pointer to a filled out USB driver
	* @param bus - The USB bus index (usually 2)
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdRegisterInternal :: proc(drv: ^SceUdcdDriver, bus: c.int) -> c.int ---

	/**
	* Unregister a USB driver
	*
	* @param drv - Pointer to a filled out USB driver
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdUnregister :: proc(drv: ^SceUdcdDriver) -> c.int ---

	/**
	* Unregister a USB driver for an UDCD bus
	*
	* @param drv - Pointer to a filled out USB driver
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdUnregisterInternal :: proc(drv: ^SceUdcdDriver, bus: c.int) -> c.int ---

	/**
	* Clear the FIFO on an endpoint
	*
	* @param endp - The endpoint to clear
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdClearFIFO :: proc(endp: ^SceUdcdEndpoint) -> c.int ---

	/**
	* Clear the FIFO on an endpoint for an UDCD bus
	*
	* @param endp - The endpoint to clear
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdClearFIFOInternal :: proc(endp: ^SceUdcdEndpoint, bus: c.int) -> c.int ---

	/**
	* Cancel any pending requests on an endpoint.
	*
	* @param endp - The endpoint to cancel
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdReqCancelAll :: proc(endp: ^SceUdcdEndpoint) -> c.int ---

	/**
	* Stall an endpoint
	*
	* @param endp - The endpoint to stall
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdStall :: proc(endp: ^SceUdcdEndpoint) -> c.int ---

	/**
	* Stall an endpoint for an UDCD bus
	*
	* @param endp - The endpoint to stall
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdStallInternal :: proc(endp: ^SceUdcdEndpoint, bus: c.int) -> c.int ---

	/**
	* Queue a send request (IN from host pov)
	*
	* @param req - Pointer to a filled out ::SceUdcdDeviceRequest structure.
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdReqSend :: proc(req: ^SceUdcdDeviceRequest) -> c.int ---

	/**
	* Queue a send request (IN from host pov) for an UDCD bus
	*
	* @param req - Pointer to a filled out ::SceUdcdDeviceRequest structure.
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdReqSendInternal :: proc(req: ^SceUdcdDeviceRequest, bus: c.int) -> c.int ---

	/**
	* Queue a receive request (OUT from host pov)
	*
	* @param req - Pointer to a filled out ::SceUdcdDeviceRequest structure
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdReqRecv :: proc(req: ^SceUdcdDeviceRequest) -> c.int ---

	/**
	* Queue a receive request (OUT from host pov) for an UDCD bus
	*
	* @param req - Pointer to a filled out ::SceUdcdDeviceRequest structure
	* @param[in] bus - UDCD bus (default is 2)
	*
	* @return 0 on success, < 0 on error
	*/
	ksceUdcdReqRecvInternal :: proc(req: ^SceUdcdDeviceRequest, bus: c.int) -> c.int ---
}

