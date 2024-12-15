#+build vita
package vita

import "core:c"

foreign import location "system:SceLibLocation_stub"

SCE_LOCATION_DATA_INVALID :: -9999.0

/** Location error codes */
SceLocationErrorCode :: enum c.uint {
	SUCCESS                            = 0,

	INFO_UNDETERMINED_LOCATION         = 0x80101200,
	INFO_INSUFFICIENT_INFORMATION      = 0x80101201,
	INFO_GET_LOCATION_CANCELED         = 0x80101202,
	INFO_DENIED_BY_USER                = 0x80101203,

	INVALID_ADDRESS              = 0x80101204,
	INVALID_HANDLE               = 0x80101205,
	NO_MEMORY                    = 0x80101206,
	TOO_MANY_HANDLES             = 0x80101207,
	INVALID_LOCATION_METHOD      = 0x80101208,
	INVALID_HEADING_METHOD       = 0x80101209,
	MULTIPLE_CALLBACK            = 0x8010120A,
	NOT_RUNNING_CALLBACK         = 0x8010120B,
	DIALOG_RESULT_NONE           = 0x8010120C,
	DISABLE_APPLICATION          = 0x8010120D,
	MULTIPLE_CONFIRM             = 0x8010120E,

	UNAUTHORIZED                 = 0x80101280,
	PROVIDER_UNAVAILABLE         = 0x80101281,
	FILE_IO                      = 0x80101282,
	INVALID_FILE_FORMAT          = 0x80101283,
	TIME_OUT                     = 0x80101284,
	NO_SERVER_MEMORY             = 0x80101285,
	INVALID_TITLE_ID             = 0x80101286,
	FATAL_ERROR                  = 0x801012FF,
}

//TO DO: further comment each struct and function (i.e. parameters)

/** Location handle datatype */
SceLocationHandle :: SceUInt32
#assert(size_of(SceLocationHandle) == 4)

/** Usage permission dialog display status */
SceLocationDialogStatus :: enum c.int {
	SCE_LOCATION_DIALOG_STATUS_IDLE     = 0, //!< Dialog initial idle status
	SCE_LOCATION_DIALOG_STATUS_RUNNING  = 1, //!< Dialog running
	SCE_LOCATION_DIALOG_STATUS_FINISHED = 2, //!< Dialog operation finished
	__SCE_LOCATION_DIALOG_STATUS = -1 // 0xFFFFFFFF
}

/** Usage permission dialog result */
SceLocationDialogResult :: enum c.int {
	SCE_LOCATION_DIALOG_RESULT_NONE    = 0, //!< Result is not stored
	SCE_LOCATION_DIALOG_RESULT_DISABLE = 1, //!< Negative result is stored
	SCE_LOCATION_DIALOG_RESULT_ENABLE  = 2, //!< Positive result is stored
	__SCE_LOCATION_DIALOG_RESULT = -1 // 0xFFFFFFFF
}

/** location usage permission status for individual application */
SceLocationPermissionApplicationStatus :: enum c.int {
	SCE_LOCATION_PERMISSION_APPLICATION_NONE  = 0, //!< liblocation not used
	SCE_LOCATION_PERMISSION_APPLICATION_INIT  = 1, //!< liblocation not accessed
	SCE_LOCATION_PERMISSION_APPLICATION_DENY  = 2, //!< liblocation access denied status
	SCE_LOCATION_PERMISSION_APPLICATION_ALLOW = 3, //!< liblocation access allowed status
	__SCE_LOCATION_PERMISSION_APPLICATION = -1 // 0xFFFFFFFF
}

/** location usage permission status */
SceLocationPermissionStatus :: enum c.int {
	SCE_LOCATION_PERMISSION_DENY  = 0, //!< liblocation access denied status
	SCE_LOCATION_PERMISSION_ALLOW = 1, //!< liblocation access allowed status
	__SCE_LOCATION_PERMISSION = -1 // 0xFFFFFFFF
}

/** Location measurement method */
SceLocationLocationMethod :: enum c.int {
	SCE_LOCATION_LMETHOD_NONE                 = 0,  //!< Do not perform location measurement
	SCE_LOCATION_LMETHOD_AGPS_AND_3G_AND_WIFI = 1,  //!< Perform measurement by switching between AGPS, Wi-Fi, and 3G
	SCE_LOCATION_LMETHOD_GPS_AND_WIFI         = 2,  //!< Perform measurement by switching between GPS and Wi-Fi
	SCE_LOCATION_LMETHOD_WIFI                 = 3,  //!< Use only Wi-Fi
	SCE_LOCATION_LMETHOD_3G                   = 4,  //!< Use only 3G
	SCE_LOCATION_LMETHOD_GPS                  = 5,  //!< Use only GPS
	__SCE_LOCATION_LMETHOD = -1 // 0xFFFFFFFF
}

/** Direction measurement method */
SceLocationHeadingMethod :: enum c.int {
	SCE_LOCATION_HMETHOD_NONE       = 0,    //!< Don't perform heading measurement
	SCE_LOCATION_HMETHOD_AUTO       = 1,    //!< Automatically determine hold orientation and outputs its value
	SCE_LOCATION_HMETHOD_VERTICAL   = 2,    //!< Output value in vertical hold reference system
	SCE_LOCATION_HMETHOD_HORIZONTAL = 3,    //!< Output value in horizontal hold reference system
	SCE_LOCATION_HMETHOD_CAMERA     = 4,    //!< Output value in camera axis reference system
	__SCE_LOCATION_HMETHOD = -1 // 0xFFFFFFFF
}

/** Structure of location information */
SceLocationLocationInfo :: struct {
	latitude: SceDouble64,   //!< Latitude (deg). Valid range: -90 to + 90. If cannot be obtained, SCE_LOCATION_DATA_INVALID
	longitude: SceDouble64,  //!< Longitude (deg). Valid range: -180 to +180. If cannot be obtained, SCE_LOCATION_DATA_INVALID
	altitude: SceDouble64,   //!< Altitude (m). If cannot be obtained, SCE_LOCATION_DATA_INVALID
	accuracy: SceFloat32,    //!< Horizontal error (m). If cannot be obtained, SCE_LOCATION_DATA_INVALID
	reserve: SceFloat32,     //!< Reserve
	direction: SceFloat32,   //!< Travel direction. If cannot be obtained, SCE_LOCATION_DATA_INVALID
	speed: SceFloat32,       //!< Travel speed (m/s). If cannot be obtained, SCE_LOCATION_DATA_INVALID
	timestamp: SceRtcTick,   //!< Time of data acquisition, in μsec (UTC)
}
#assert(size_of(SceLocationLocationInfo) == 0x30)


/** Structure of heading information */
SceLocationHeadingInfo :: struct {
	trueHeading: SceFloat32,     //!< Clockwise angle from true north (0 to 360 degrees). If cannot be acquired, SCE_LOCATION_INVALID_DATA
	headingVectorX: SceFloat32,  //!< Direction vector X coordinates element of true north. If cannot be acquired, SCE_LOCATION_INVALID_DATA
	headingVectorY: SceFloat32,  //!< Direction vector Y coordinates element of true north. If cannot be acquired, SCE_LOCATION_INVALID_DATA
	headingVectorZ: SceFloat32,  //!< Direction vector Z coordinates element of true north. If cannot be acquired, SCE_LOCATION_INVALID_DATA
	reserve: SceFloat32,         //!< Reserve
	reserve2: SceFloat32,        //!< Reserve
	timestamp: SceRtcTick,       //!< Time acquired in unit of 1 usec (UTC)
}
#assert(size_of(SceLocationHeadingInfo) == 0x20)

/** Location information callback notification function */
SceLocationLocationInfoCallback :: #type ^proc "c" (result: SceInt32, handle: SceLocationHandle, #by_ptr location: SceLocationLocationInfo, userdata: rawptr)

/** Callback notification function for direction information */
SceLocationHeadingInfoCallback :: #type ^proc "c" (result: SceInt32, handle: SceLocationHandle, #by_ptr heading: SceLocationHeadingInfo, userdata: rawptr)

/** Location information acquisition permission information */
SceLocationPermissionInfo :: struct {
	parentalstatus: SceLocationPermissionStatus,                //!< Status of usage permission through parental control
	mainstatus: SceLocationPermissionStatus,                    //!< Status of usage permission through location data item of system settings
	applicationstatus: SceLocationPermissionApplicationStatus,  //!< Status of usage permission through location data item for each application in system settings
	unk_0x0C: c.int,
	unk_0x10: c.int,
}
#assert(size_of(SceLocationPermissionInfo) == 0x14)

foreign location {
	/** Library start */
	sceLocationOpen :: proc(handle: ^SceLocationHandle, locateMethod: SceLocationLocationMethod, headingMethod: SceLocationHeadingMethod) -> SceInt32 ---

	/** Close library */
	sceLocationClose :: proc(handle: SceLocationHandle) -> SceInt32 ---

	/** Reopen library */
	sceLocationReopen :: proc(handle: SceLocationHandle, locateMethod: SceLocationLocationMethod, headingMethod: SceLocationHeadingMethod) -> SceInt32 ---

	/** Get location measurement method */
	sceLocationGetMethod :: proc(handle: SceLocationHandle, locateMethod: ^SceLocationLocationMethod, headingMethod: ^SceLocationHeadingMethod) -> SceInt32 ---

	/** Get location information */
	sceLocationGetLocation :: proc(handle: SceLocationHandle, locationInfo: ^SceLocationLocationInfo) -> SceInt32 ---

	/** Cancel location information acquisition operation */
	sceLocationCancelGetLocation :: proc(handle: SceLocationHandle) -> SceInt32 ---

	/** Start continuous acquisition of location information */
	sceLocationStartLocationCallback :: proc(handle: SceLocationHandle, distance: SceUInt32, callback: SceLocationLocationInfoCallback, userdata: rawptr) -> SceInt32 ---

	/** Stop continuous acquisition of location information */
	sceLocationStopLocationCallback :: proc(handle: SceLocationHandle) -> SceInt32 ---

	/** Get direction information */
	sceLocationGetHeading :: proc(handle: SceLocationHandle, headingInfo: ^SceLocationHeadingInfo) -> SceInt32 ---

	/** Start continuous acquisition of direction information */
	sceLocationStartHeadingCallback :: proc(handle: SceLocationHandle, difference: SceUInt32, callback: SceLocationHeadingInfoCallback, userdata: rawptr) -> SceInt32 ---

	/** Stop continuous acquisition of direction information */
	sceLocationStopHeadingCallback :: proc(handle: SceLocationHandle) -> SceInt32 ---

	/** Allow acquisition of location information */
	sceLocationConfirm :: proc(handle: SceLocationHandle) -> SceInt32 ---

	/** Get status of location information acquisition permission dialog */
	sceLocationConfirmGetStatus :: proc(handle: SceLocationHandle, status: ^SceLocationDialogStatus) -> SceInt32 ---

	/** Get result of location information acquisition permission dialog */
	sceLocationConfirmGetResult :: proc(handle: SceLocationHandle, result: ^SceLocationDialogResult) -> SceInt32 ---

	/** Abort location information acquisition permission dialog */
	sceLocationConfirmAbort :: proc(handle: SceLocationHandle) -> SceInt32 ---

	/** Get location information acquisition permission/refusal information */
	sceLocationGetPermission :: proc(handle: SceLocationHandle, info: ^SceLocationPermissionInfo) -> SceInt32 ---

	/** Get location information acquisition permission information */
	sceLocationSetGpsEmulationFile :: proc(filename: cstring) -> SceInt32 ---
}

