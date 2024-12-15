#+build vita
package vita

import "core:c"

foreign import apputil "system:SceAppUtil_stub"

SceAppUtilSaveDataRemoveMode :: enum c.int {
	DEFAULT = 0,
	NO_SLOT = 1,
}

SceAppUtilSaveDataSaveMode :: enum c.int {
	FILE = 0,
	DIRECTORY = 2,
}

SceAppUtilErrorCode :: enum c.uint {
	PARAMETER                   = 0x80100600,
	NOT_INITIALIZED             = 0x80100601,
	NO_MEMORY                   = 0x80100602,
	BUSY                        = 0x80100603,
	NOT_MOUNTED                 = 0x80100604,
	NO_PERMISSION               = 0x80100605,
	PASSCODE_MISMATCH           = 0x80100606,
	APPEVENT_PARSE_INVALID_DATA = 0x80100620,
	SAVEDATA_SLOT_EXISTS        = 0x80100640,
	SAVEDATA_SLOT_NOT_FOUND     = 0x80100641,
	SAVEDATA_NO_SPACE_QUOTA     = 0x80100642,
	SAVEDATA_NO_SPACE_FS        = 0x80100643,
	DRM_NO_ENTITLEMENT          = 0x80100660,
	PHOTO_DEVICE_NOT_FOUND      = 0x80100680,
	MUSIC_DEVICE_NOT_FOUND      = 0x80100685,
	MOUNT_LIMIT_OVER            = 0x80100686,
	STACKSIZE_TOO_SHORT         = 0x801006A0,
}

SceAppUtilBootAttribute :: distinct c.uint
SceAppUtilAppEventType :: distinct c.uint
SceAppUtilSaveDataSlotId :: distinct c.uint
SceAppUtilSaveDataSlotStatus :: distinct c.uint
SceAppUtilAppParamId :: distinct c.uint
SceAppUtilBgdlStatusType :: distinct c.uint

SceAppUtilBgdlStatus :: struct {
  type: SceAppUtilBgdlStatusType,
	addcontNumReady: SceUInt32,
	addcontNumNotReady: SceUInt32,
	licenseReady: SceUInt32,
	reserved: [28]SceChar8,
}
#assert(size_of(SceAppUtilBgdlStatus) == 0x2C)

SceAppUtilInitParam :: struct {
  workBufSize: SceSize,  //!< Buffer size
	reserved: [60]c.uint8_t, //!< Reserved range
}
#assert(size_of(SceAppUtilInitParam) == 0x40)

SceAppUtilBootParam :: struct {
  attr: SceAppUtilBootAttribute,   //!< Boot attribute
	appVersion: c.uint,        //!< App version
	reserved: [32]c.uint8_t,           //!< Reserved range
}
#assert(size_of(SceAppUtilBootParam) == 0x28)

SceAppUtilSaveDataMountPoint :: struct {
  data: [16]c.uint8_t,
}
#assert(size_of(SceAppUtilSaveDataMountPoint) == 0x10)

SceAppUtilAppEventParam :: struct {
  type: SceAppUtilAppEventType, //!< Event type
	dat: [1024]c.uint8_t,           //!< Event parameter
}
#assert(size_of(SceAppUtilAppEventParam) == 0x404)

SceAppUtilMountPoint :: struct {
  data: [16]c.int8_t, //!< Mount point
}
#assert(size_of(SceAppUtilMountPoint) == 0x10)

SceAppUtilSaveDataSlotEmptyParam :: struct {
	title: [^]SceWChar16,     //!< Title string
	iconPath: cstring,        //!< Path to icon
	iconBuf: rawptr,         //!< Icon buffer
	iconBufSize: SceSize,   //!< Icon buffer size
	reserved: [32]c.uint8_t,  //!< Reserved range
}

SceAppUtilSaveDataSlot :: struct {
	id: SceAppUtilSaveDataSlotId,                  //!< Slot id
	status: SceAppUtilSaveDataSlotStatus,          //!< Slot status
	userParam: c.int,                                //!< Param for free usage
	emptyParam: ^SceAppUtilSaveDataSlotEmptyParam, //!< Settings for empty slot
}

SceAppUtilSaveDataSlotParam :: struct {
	status: SceAppUtilSaveDataSlotStatus, //!< Status
	title: [32]SceWChar16,                //!< Title name
	subTitle: [64]SceWChar16,             //!< Subtitle
	detail: [256]SceWChar16,              //!< Detail info
	iconPath: [64]c.char,                   //!< Icon path
	userParam: c.int,                       //!< User param
	sizeKB: SceSize,                      //!< Data size (In KB)
	modifiedTime: SceDateTime,            //!< Last modified time
	reserved: [48]c.uint8_t,                //!< Reserved range
}
#assert(size_of(SceAppUtilSaveDataSlotParam) == 0x34C)

SceAppUtilSaveDataSaveItem :: struct {
	dataPath: cstring,             //!< Path to savedata
	buf: rawptr,                  //!< Buffer of savedata file
	pad: c.uint32_t,                     //!< Padding
	offset: SceOff,                    //!< Offset of savedata file
	mode: c.int,                         //!< Savedata save mode (One of ::SceAppUtilSaveDataSaveMode)
	reserved: [36]c.uint8_t,             //!< Reserved range
}

SceAppUtilSaveDataFile :: struct {
	filePath: cstring,
	buf: rawptr,
	bufSize: SceSize,
	offset: SceOff,
	mode: c.uint,
	progDelta: c.uint,
	reserved: [32]c.uint8_t,
}

SceAppUtilSaveDataFileSlot :: struct {
	id: c.uint,
	slotParam: ^SceAppUtilSaveDataSlotParam,
	reserved: [32]c.uint8_t,
}

SceAppUtilSaveDataRemoveItem :: struct {
	dataPath: cstring,               //!< Path to savedata data
	mode: c.int,                           //!< Savedata remove mode (One of ::SceAppUtilSaveDataRemoveMode)
	reserved: [36]c.uint8_t,               //!< Reserved range
}

SceAppUtilStoreBrowseParam :: struct {
	type: c.uint,          //!< Store browse type
	id: cstring,             //!< Target id
}

SceAppUtilWebBrowserParam :: struct {
	str: cstring,            //!< String that's passed to command specified by launchMode
	strlen: SceSize,	            //!< Length of str
	launchMode: c.uint,    //!< Browser mode
	reserved: c.uint,      //!< Reserved area
}

foreign apputil {
	/**
	* Initializes the AppUtil library. Call this before any of the other functions.
	*
	* @param[out] initParam - App init info. Must be initialized with zeros.
	* @param[out] bootParam - App boot info. Must be initialized with zeros.
	*
	* @return 0 on success, < 0 on error.
	*/
	sceAppUtilInit :: proc(initParam: ^SceAppUtilInitParam, bootParam: ^SceAppUtilBootParam) -> c.int ---

	//! Shutdown AppUtil library
	sceAppUtilShutdown :: proc() -> c.int ---

	//! Receive app event
	sceAppUtilReceiveAppEvent :: proc(eventParam: ^SceAppUtilAppEventParam) -> c.int ---

	//! Parse received app event from LiveArea
	sceAppUtilAppEventParseLiveArea :: proc(#by_ptr eventParam: SceAppUtilAppEventParam, buffer: [^]c.char) -> c.int ---

	//! Create savedata slot
	sceAppUtilSaveDataSlotCreate :: proc(slotId: c.uint, param: ^SceAppUtilSaveDataSlotParam, mountPoint: ^SceAppUtilSaveDataMountPoint) -> c.int ---

	//! Delete savedata slot
	sceAppUtilSaveDataSlotDelete :: proc(slotId: c.uint, mountPoint: ^SceAppUtilSaveDataMountPoint) -> c.int ---

	//! Set savedata slot param
	sceAppUtilSaveDataSlotSetParam :: proc(slotId: c.uint, param: ^SceAppUtilSaveDataSlotParam, mountPoint: ^SceAppUtilSaveDataMountPoint) -> c.int ---

	//! Get savedata slot param
	sceAppUtilSaveDataSlotGetParam :: proc(slotId: c.uint, param: ^SceAppUtilSaveDataSlotParam, mountPoint: ^SceAppUtilSaveDataMountPoint) -> c.int ---

	//!< Write savedata files and directories
	sceAppUtilSaveDataDataSave :: proc(slot: ^SceAppUtilSaveDataFileSlot, files: ^SceAppUtilSaveDataFile, fileNum: c.uint, mountPoint: ^SceAppUtilSaveDataMountPoint, requiredSizeKB: ^SceSize) -> c.int ---

	//!< Delete savedata files
	sceAppUtilSaveDataDataRemove :: proc(slot: ^SceAppUtilSaveDataFileSlot, files: ^SceAppUtilSaveDataRemoveItem, fileNum: c.uint, mountPoint: ^SceAppUtilSaveDataMountPoint) -> c.int ---

	//! Mount music data
	sceAppUtilMusicMount :: proc() -> c.int ---

	//! Unmount music data
	sceAppUtilMusicUmount :: proc() -> c.int ---

	//! Mount photo data
	sceAppUtilPhotoMount :: proc() -> c.int ---

	//! Unmount photo data
	sceAppUtilPhotoUmount :: proc() -> c.int ---

	//! Mount cache data
	sceAppUtilCacheMount :: proc() -> c.int ---

	//! Unmount cache data
	sceAppUtilCacheUmount :: proc() -> c.int ---

	//! Get system parameters for int type
	sceAppUtilSystemParamGetInt :: proc(paramId: c.uint, value: ^c.int) -> c.int ---

	//! Get application parameters for string type
	sceAppUtilSystemParamGetString :: proc(paramId: c.uint, buf: [^]SceChar8, bufSize: SceSize) -> c.int ---

	//! Get application parameters for int type
	sceAppUtilAppParamGetInt :: proc(paramId: SceAppUtilAppParamId, value: ^c.int) -> c.int ---

	//! Save safe memory
	sceAppUtilSaveSafeMemory :: proc(buf: rawptr, bufSize: SceSize, offset: SceOff) -> c.int ---

	//! Load safe memory
	sceAppUtilLoadSafeMemory :: proc(buf: rawptr, bufSize: SceSize, offset: SceOff) -> c.int ---

	//! Launch PSN Store
	sceAppUtilStoreBrowse :: proc(param: ^SceAppUtilStoreBrowseParam) -> c.int ---

	//! Get background download status
	sceAppUtilBgdlGetStatus :: proc(stat: ^SceAppUtilBgdlStatus) -> c.int ---

	//! Launch web browser app
	sceAppUtilLaunchWebBrowser :: proc(param: ^SceAppUtilWebBrowserParam) -> c.int ---
}
