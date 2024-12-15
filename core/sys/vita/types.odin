#+build vita
package vita

import "core:c"

PSP2_SDK_VERSION :: 0x03570011

SCE_KERNEL_THREAD_ID_SELF  :: 0  //!< Current thread's UID - pass to APIs expecting a thread ID to operate on calling thread
SCE_KERNEL_PROCESS_ID_SELF :: 0  //!< Current process's UID - pass to APIs expecting a process ID to operate on calling process
SCE_UID_NAMELEN            :: 31 //!< Maximum length for kernel object names
SCE_OK :: 0

SceUID :: distinct c.int
ScePID :: distinct c.int
SceNID :: distinct c.uint

SceBool :: c.int
SceChar8 :: c.int8_t
SceUChar8 :: c.int8_t
SceInt8 :: c.int8_t
SceUInt8 :: c.uint8_t
SceShort16 :: c.int16_t
SceUShort16 :: c.uint16_t
SceInt16 :: c.int16_t
SceUInt16 :: c.uint16_t
SceInt32 :: c.int32_t
SceUInt32 :: c.uint32_t
SceInt :: c.int
SceUInt :: c.uint
SceInt64 :: c.int64_t
SceUInt64 :: c.uint64_t
SceLong64 :: c.int64_t
SceULong64 :: c.uint64_t
SceSize :: distinct c.uint
SceSSize :: distinct c.int

SceFloat :: c.float
SceFloat32 :: c.float

SceDouble :: c.double
SceDouble64 :: c.double

SceWChar16 :: c.uint16_t
SceWChar32 :: c.uint32_t

SceIntPtr :: distinct c.int
SceUIntPtr :: distinct c.uint
SceUIntVAddr :: SceUIntPtr

ScePVoid :: rawptr

SceMode :: distinct c.int
SceOff :: SceInt64
SceKernelSysClock :: SceUInt64

SceDateTime :: struct {
  year: c.ushort,
  month: c.ushort,
  day: c.ushort,
  hour: c.ushort,
  minute: c.ushort,
  second: c.ushort,
  microsecond: c.uint,
}
#assert(size_of(SceDateTime) == 0x10)

SceFVector3 :: struct {
  x: SceFloat,
  y: SceFloat,
  z: SceFloat,
}
#assert(size_of(SceFVector3) == 0xC)

SceFVector4 :: struct {
	x: SceFloat,
	y: SceFloat,
	z: SceFloat,
	w: SceFloat,
}
#assert(size_of(SceFVector4) == 0x10)

SceFMatrix4 :: struct {
	x: SceFVector4,
	y: SceFVector4,
	z: SceFVector4,
	w: SceFVector4,
}
#assert(size_of(SceFMatrix4) == 0x40)

SceFQuaternion :: struct {
	x: SceFloat,
	y: SceFloat,
	z: SceFloat,
	w: SceFloat,
}
#assert(size_of(SceFQuaternion) == 0x10)


//
// system_param.h start
//

/** System param id */
SceSystemParamId :: enum c.int {
	//!< Language settings
	LANG = 1,
	//!< Enter button assignment
	ENTER_BUTTON,
	//!< Username string
	USERNAME,
	//!< Date format
	DATE_FORMAT,
	//!< Time format
	TIME_FORMAT,
	//!< Time zone
	TIME_ZONE,
	//!< Daylight savings time (0 = Disabled, 1 = Enabled)
	DAYLIGHT_SAVINGS,
	//!< Max allowed value
	MAX_VALUE = -1 // 0xFFFFFFFF
}

/** Language settings */
SceSystemParamLang :: enum c.int {
	//! Japanese
	JAPANESE,
	//! American English
	ENGLISH_US,
	//! French
	FRENCH,
	//! Spanish
	SPANISH,
	//! German
	G_GERMAN,
	//! Italian
	ITALIAN,
	//! Dutch
	DUTCH,
	//! Portugal Portuguese
	PORTUGUESE_PT,
	//! Russian
	RUSSIAN,
	//! Korean
	KOREAN,
	//! Traditional Chinese
	CHINESE_T,
	//! Simplified Chinese
	CHINESE_S,
	//! Finnish
	FINNISH,
	//! Swedish
	SWEDISH,
	//! Danish
	DANISH,
	//! Norwegian
	NORWEGIAN,
	//! Polish
	POLISH,
	//! Brazil Portuguese
	PORTUGUESE_BR,
	//! British English
	ENGLISH_GB,
	//! Turkish
	TURKISH,
	//! Max allowed value
	MAX_VALUE = -1 // 0xFFFFFFFF
}

/** Assignment of enter button */
SceSystemParamEnterButtonAssign :: enum c.int {
	CIRCLE,
	CROSS,
	MAX_VALUE = -1 // 0xFFFFFFFF
}

/* Username */
SCE_SYSTEM_PARAM_USERNAME_MAXSIZE ::	17 //!< Max size of username

/** Date display format */
SceSystemParamDateFormat :: enum c.int {
	YYYYMMDD, //!< Year/Month/Day
	DDMMYYYY, //!< Day/Month/Year
	MMDDYYYY //!< Month/Day/Year
}

/** Time display format */
SceSystemParamTimeFormat :: enum c.int {
	FORMAT_12HR, //!< 12-hour clock
	FORMAT_24HR //!< 24-hour clock
}

//
// system_param.h end
//


//
// rtc.h start
//

SceRtcErrorCode :: enum c.uint {
	INVALID_VALUE        = 0x80251000,
	INVALID_POINTER      = 0x80251001,
	NOT_INITIALIZED      = 0x80251002,
	ALREADY_REGISTERD    = 0x80251003,
	NOT_FOUND            = 0x80251004,
	BAD_PARSE            = 0x80251080,
	INVALID_YEAR         = 0x80251081,
	INVALID_MONTH        = 0x80251082,
	INVALID_DAY          = 0x80251083,
	INVALID_HOUR         = 0x80251084,
	INVALID_MINUTE       = 0x80251085,
	INVALID_SECOND       = 0x80251086,
	INVALID_MICROSECOND  = 0x80251087
}
#assert(size_of(SceRtcErrorCode) == 4)

/* As returned by sceRtcGetDayOfWeek */
SceRtcDayOfWeek :: enum c.int {
	SCE_RTC_DAYOFWEEK_SUNDAY    = 0,
	SCE_RTC_DAYOFWEEK_MONDAY    = 1,
	SCE_RTC_DAYOFWEEK_TUESDAY   = 2,
	SCE_RTC_DAYOFWEEK_WEDNESDAY = 3,
	SCE_RTC_DAYOFWEEK_THURSDAY  = 4,
	SCE_RTC_DAYOFWEEK_FRIDAY    = 5,
	SCE_RTC_DAYOFWEEK_SATURDAY  = 6,
	__SCE_RTC_DAYOFWEEK = -1 // 0xFFFFFFFF
}
#assert(size_of(SceRtcDayOfWeek) == 4)

SceRtcTick :: struct {
	tick: SceUInt64,
}
#assert(size_of(SceRtcTick) == 8)

//
// rtc.h end
//

SceMsInfo :: struct {
	unk_0x00: c.int,
	unk_0x04: c.int,
	nbytes: SceUInt64,
	nbytes2: SceUInt64,
	sector_size: SceUInt32,
	unk_0x1C: c.int,
	fs_offset: SceUInt32,
	unk_0x24: SceUInt32,
	unk_0x28: SceUInt32,
	unk_0x2C: SceUInt32,
	id: [0x10]SceUInt8,
}
#assert(size_of(SceMsInfo) == 0x40)

SceCoredumpTriggerParam :: struct {
  size: SceSize,
	data_0x04: c.int,
	data_0x08: c.int,
	data_0x0C: c.int,
	data_0x10: c.int,
	titleid_len: SceSize,
	titleid: cstring,
	app_name_len: SceSize,
	app_name: cstring,
	data_0x24: c.int, // ex: 100. maybe progress max number.
	data_0x28: c.int,
	crash_thid: SceUID,
	data_0x30: c.int,
}

SceKernelCoredumpStateUpdateCallback :: #type ^proc "c" (task_id: c.int, pid: SceUID, progress: c.int) -> c.int
SceKernelCoredumpStateFinishCallback :: #type ^proc "c" (task_id: c.int, pid: SceUID, result: c.int, path: cstring, path_len: SceSize, unk: c.int) -> c.int

