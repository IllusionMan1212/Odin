#+build vita
package vita

import "core:c"

foreign import commondialog "system:SceCommonDialog_stub"

SCE_COMMON_DIALOG_MAGIC_NUMBER :: 0xC0D1A109

/* Errors */
SceCommonDialogErrorCode :: enum c.uint {
	BUSY                            = 0x80020401,
	NULL                            = 0x80020402,
	INVALID_ARGUMENT                = 0x80020403,
	NOT_RUNNING                     = 0x80020404,
	NOT_SUPPORTED                   = 0x80020405,
	ILLEGAL_CALLER_THREAD           = 0x80020406,
	NOT_CONFIGURED                  = 0x80020407,
	NOT_AVAILABLE                   = 0x80020408,
	NOT_FINISHED                    = 0x80020410,
	NOT_IN_USE                      = 0x80020411,
	INVALID_COLOR_FORMAT            = 0x80020420,
	INVALID_SURFACE_RESOLUTION      = 0x80020421,
	INVALID_SURFACE_STRIDE          = 0x80020422,
	INVALID_SURFACE_TYPE            = 0x80020423,
	WITHIN_SCENE                    = 0x80020424,
	IME_IN_USE                      = 0x80020430,
	INVALID_LANGUAGE                = 0x80020431,
	INVALID_ENTER_BUTTON_ASSIGN     = 0x80020432,
	INVALID_INFOBAR_PARAM           = 0x80020433,
	INVALID_BG_COLOR                = 0x80020434,
	INVALID_DIMMER_COLOR            = 0x80020435,
	GXM_IS_UNINITIALIZED            = 0x80020436,
	UNEXPECTED_FATAL                = 0x8002047F
}

SceCommonDialogConfigParam :: struct {
  sdkVersion: SceUInt32,
	language: SceSystemParamLang,
	enterButtonAssign: SceSystemParamEnterButtonAssign,
	reserved: [32]SceUInt8,
}
#assert(size_of(SceCommonDialogConfigParam) == 0x2C)

SceCommonDialogStatus :: enum c.int {
	NONE       = 0,
	RUNNING    = 1,
	FINISHED   = 2
}

SceCommonDialogResult :: enum c.int {
	OK,
	USER_CANCELED,
	ABORTED
}

SceCommonDialogRenderTargetInfo :: struct {
  depthSurfaceData: ScePVoid,
  colorSurfaceData: ScePVoid,
  surfaceType: SceGxmColorSurfaceType,
	colorFormat: SceGxmColorFormat,
	width: SceUInt32,
	height: SceUInt32,
	strideInPixels: SceUInt32,
	reserved: [32]SceUInt8,
}

SceCommonDialogUpdateParam :: struct {
  renderTarget: SceCommonDialogRenderTargetInfo,
	displaySyncObject: ^SceGxmSyncObject,
	reserved: [32]SceUInt8,
}

SceCommonDialogInfobarParam :: struct {
  visibility: SceInt32,
	color: SceInt32,
	transparency: SceInt32,
	reserved: [32]SceUInt8,
}
#assert(size_of(SceCommonDialogInfobarParam) == 0x2C)

SceCommonDialogColor :: struct {
  r: SceUInt8,
	g: SceUInt8,
	b: SceUInt8,
	a: SceUInt8,
}
#assert(size_of(SceCommonDialogColor) == 4)

SceCommonDialogBgColor :: SceCommonDialogColor
#assert(size_of(SceCommonDialogBgColor) == 4)

SceCommonDialogParam :: struct {
	infobarParam: ^SceCommonDialogInfobarParam,
	bgColor: ^SceCommonDialogColor,
	dimmerColor: ^SceCommonDialogColor,
	reserved: [60]SceUInt8,
	magic: SceUInt32,
}


SceMsgDialogErrorCode :: enum c.uint {
	//! Illegal parameter
	SCE_MSG_DIALOG_ERROR_PARAM	= 0x80100A01
}

//! Max length of a user message
SCE_MSG_DIALOG_USER_MSG_SIZE :: 512

SceMsgDialogMode :: enum c.int {
	INVALID      = 0,
	USER_MSG     = 1,
	SYSTEM_MSG   = 2,
	ERROR_CODE   = 3,
	PROGRESS_BAR = 4
}

SceMsgDialogSystemMessageType :: enum c.int {
	INVALID                        = 0,
	//! Displays "Please wait."
	WAIT                           = 1,
	//! Displays "There is not enough free space on the memory card."
	NOSPACE                        = 2,
	//! Displays "Move away from the source of interference, or adjust the compass by moving your PS Vita system as shown below."
	MAGNETIC_CALIBRATION           = 3,
	//! Displays "Please wait." in a small message dialog
	WAIT_SMALL                     = 5,
	//! Displays "Please wait..." with a cancel button
	WAIT_CANCEL                    = 6,
	//! Displays "Cannot continue the application. No memory card is inserted."
	NEED_MC_CONTINUE               = 7,
	//! Displays "Cannot perform this operation. No memory card is inserted."
	NEED_MC_OPERATION              = 8,
	//! Displays "You must enable the microphone."
	TRC_MIC_DISABLED               = 100,
	//! Displays "You must use Wi-Fi to do this."
	TRC_WIFI_REQUIRED_OPERATION    = 101,
	//! Displays "You must use Wi-Fi to use this application."
	TRC_WIFI_REQUIRED_APPLICATION  = 102,
	//! Displays "No content is available yet."
	TRC_EMPTY_STORE                = 103
}

SceMsgDialogButtonType :: enum c.int {
	TYPE_OK          = 0,
	TYPE_YESNO       = 1,
	TYPE_NONE        = 2,
	TYPE_OK_CANCEL   = 3,
	TYPE_CANCEL      = 4,
	TYPE_3BUTTONS    = 5
}

SceMsgDialogButtonId :: enum c.int {
	INVALID    = 0,
	OK         = 1,
	YES        = 1,
	NO         = 2,
	RETRY      = 3,
	BUTTON1    = 1,
	BUTTON2    = 2,
	BUTTON3    = 3
}

SceMsgDialogProgressBarType :: enum c.int {
	PERCENTAGE   = 0
}

SceMsgDialogProgressBarTarget :: enum c.int {
	DEFAULT   = 0
}

SceMsgDialogEnvFlag :: enum c.int {
	DEFAULT		= 0
}

SceMsgDialogFontSize :: enum c.int {
	DEFAULT = 0,
	SMALL   = 1
}

SceMsgDialogButtonsParam :: struct {
	msg1: cstring,          //!< Text of the first button
	fontSize1: SceInt32,        //!< Font size of the first button (one of ::SceMsgDialogFontSize)
	msg2: cstring,          //!< Text of the second button
	fontSize2: SceInt32,        //!< Font size of the second button (one of ::SceMsgDialogFontSize)
	msg3: cstring,          //!< Text of the third button
	fontSize3: SceInt32,        //!< Font size of the third button (one of ::SceMsgDialogFontSize)
	reserved: [32]SceChar8,     //!< Reserved range
}

SceMsgDialogUserMessageParam :: struct {
	buttonType: SceInt32,                    //!< Type of button set (one of ::SceMsgDialogButtonType)
	msg: cstring,                    //!< Displayed message
	buttonParam: ^SceMsgDialogButtonsParam,  //!< Buttons parameters
	reserved: [28]SceChar8,                  //!< Reserved range
}

SceMsgDialogSystemMessageParam :: struct {
	sysMsgType: SceInt32,                    //!< System message type (one of ::SceMsgDialogSystemMessageType)
	value: SceInt32,                         //!< Additional value
	reserved: [32]SceChar8,                  //!< Reserved range
}
#assert(size_of(SceMsgDialogSystemMessageParam) == 0x28)

SceMsgDialogErrorCodeParam :: struct {
	errorCode: SceInt32,     //!< Displayed error code
	reserved: [32]SceChar8,  //!< Reserved range
}
#assert(size_of(SceMsgDialogErrorCodeParam) == 0x24)

SceMsgDialogProgressBarParam :: struct {
	barType: SceInt32,                           //!< Progress bar type (one of ::SceMsgDialogProgressBarType)
	sysMsgParam: SceMsgDialogSystemMessageParam, //!< Displayed system message
	msg: cstring,                        //!< Displayed user message
	reserved: [8]SceInt32,                       //!< Reserved range
}

SceMsgDialogParam :: struct {
	sdkVersion: SceUInt32,                         //!< Required to use MsgDialog. Just use NULL
	commonParam: SceCommonDialogParam,             //!< Common parameter
	mode: SceInt32,                                //!< Mode of function (one of ::SceMsgDialogMode)
	userMsgParam: ^SceMsgDialogUserMessageParam,   //!< Parameter for user message
	sysMsgParam: ^SceMsgDialogSystemMessageParam,  //!< Parameter for system prepared message
	errorCodeParam: ^SceMsgDialogErrorCodeParam,   //!< Parameter for display error code
	progBarParam: ^SceMsgDialogProgressBarParam,   //!< Parameter for progress bar
	flag: SceInt32,                                //!< Settings for dialog environment (one of ::SceMsgDialogEnvFlag)
	reserved: [32]SceChar8,                        //!< Reserved range
}

SceMsgDialogResult :: struct {
	mode: SceInt32,                       //!< Mode of function (one of ::SceMsgDialogMode)
	result: SceInt32,                     //!< Result of executing function
	buttonId: SceInt32,                   //!< Id of button user selected (one of ::SceMsgDialogButtonId)
	reserved: [32]SceChar8,               //!< Reserved range
}
#assert(size_of(SceMsgDialogResult) == 0x2C)


SceNetCheckDialogErrorCode :: enum c.uint {
	PARAM                       = 0x80100C01,
	INVALID_MODE                = 0x80100C02,
	LACK_OF_LIBHTTP_POOL_SIZE   = 0x80100C03,
	LACK_OF_LIBSSL_POOL_SIZE    = 0x80100C04,
	LATEST_PATCH_PKG_EXIST      = 0x80100C05,
	SIGN_OUT                    = 0x80100C06,
	INVALID_PSPADHOC_PARAM      = 0x80100C07,
	INVALID_TIMEOUT_PARAM       = 0x80100C08,
	PSN_AGE_RESTRICTION         = 0x80100C09
}

SCE_NETCHECK_DIALOG_LEAST_HTTP_POOL_SIZE      :: (36 * 1024)
SCE_NETCHECK_DIALOG_LEAST_SSL_POOL_SIZE       :: (96 * 1024)
SCE_NETCHECK_DIALOG_INITIAL_AGE_RESTRICTION   :: (-1)
SCE_NETCHECK_DIALOG_COUNTRY_CODE_LEN          :: (2)
SCE_NETCHECK_DIALOG_AGE_RESTRICTION_COUNT_MAX :: (200)

SceNetCheckDialogMode :: enum c.int {
	INVALID           = 0,
	ADHOC_CONN        = 1,
	PSN               = 2,
	PSN_ONLINE        = 3,
	PS3_CONNECT       = 4,
	PSP_ADHOC_CONN    = 5,
	PSP_ADHOC_CREATE  = 6,
	PSP_ADHOC_JOIN    = 7
}

SceNetCheckDialogPS3ConnectAction :: enum c.int {
	ENTER  = 0,
	LEAVE  = 1
}

SceNpCommunicationId :: struct {
	data: [9]c.char,
	term: c.char,
	num: SceUChar8,
	dummy: c.char,
}
#assert(size_of(SceNpCommunicationId) == 0xC)

SceNetCheckDialogPS3ConnectParam :: struct {
	action: SceInt32,
	ssid: [32 + 1]c.char,
	wpaKey: [64 + 1]c.char,
	titleId: [9 + 1]c.char,
}
#assert(size_of(SceNetCheckDialogPS3ConnectParam) == 0x70)

SceNetCheckDialogAgeRestriction :: struct {
	countryCode: [SCE_NETCHECK_DIALOG_COUNTRY_CODE_LEN]c.char,
	age: SceInt8,
	padding: SceInt8,
}
#assert(size_of(SceNetCheckDialogAgeRestriction) == 4)

SceNetCheckDialogParam :: struct {
	sdkVersion: SceUInt32,
	commonParam: SceCommonDialogParam,
	mode: SceInt32,
	npCommunicationId: SceNpCommunicationId,
	ps3ConnectParam: ^SceNetCheckDialogPS3ConnectParam,
	groupName: ^SceNetAdhocctlGroupName,
	timeoutUs: SceUInt32,
	defaultAgeRestriction: SceInt8,
	padding: [3]SceInt8,
	ageRestrictionCount: SceInt32,
	ageRestriction: ^SceNetCheckDialogAgeRestriction,
	reserved: [104]SceUInt8,
}

SceNetCheckDialogResult :: struct {
	result: SceInt32,
	psnModeSucceeded: SceBool,
	reserved: [124]SceUInt8,
}
#assert(size_of(SceNetCheckDialogResult) == 0x84)

SceNetCheckDialogPS3ConnectInfo :: struct {
	inaddr: SceNetInAddr,
	nickname: [128]SceUInt8,
	macAddress: [6]SceUInt8,
	reserved: [6]SceUInt8,
}
#assert(size_of(SceNetCheckDialogPS3ConnectInfo) == 0x90)

_sceCommonDialogSetMagicNumber :: #force_inline proc "c" (param: ^SceCommonDialogParam) {
	param := param
	param.magic = SCE_COMMON_DIALOG_MAGIC_NUMBER + (cast(^SceUInt32)&param)^
}

sceCommonDialogConfigParamInit :: #force_inline proc "c" (param: ^SceCommonDialogConfigParam) {
	sceClibMemset(param, 0x0, size_of(SceCommonDialogConfigParam))
	param.language = SceSystemParamLang.MAX_VALUE
	param.enterButtonAssign = SceSystemParamEnterButtonAssign.MAX_VALUE
	param.sdkVersion = PSP2_SDK_VERSION
}

sceMsgDialogParamInit :: #force_inline proc "c" (param: ^SceMsgDialogParam) {
	sceClibMemset(param, 0x0, size_of(SceMsgDialogParam))
	_sceCommonDialogSetMagicNumber(&param.commonParam)
	param.sdkVersion = PSP2_SDK_VERSION
}

sceNetCheckDialogParamInit :: #force_inline proc "c" (param: ^SceNetCheckDialogParam) {
	sceClibMemset(param, 0x0, size_of(SceNetCheckDialogParam))
	_sceCommonDialogSetMagicNumber(&param.commonParam)
	param.sdkVersion = PSP2_SDK_VERSION
	param.defaultAgeRestriction = SCE_NETCHECK_DIALOG_INITIAL_AGE_RESTRICTION
}

foreign commondialog {
	sceCommonDialogSetConfigParam :: proc(#by_ptr configParam: SceCommonDialogConfigParam) -> c.int ---
	sceCommonDialogUpdate :: proc(#by_ptr updateParam: SceCommonDialogUpdateParam) -> c.int ---

	sceMsgDialogInit :: proc(#by_ptr param: SceMsgDialogParam) -> c.int ---
	sceMsgDialogGetStatus :: proc() -> SceCommonDialogStatus ---
	sceMsgDialogAbort :: proc() -> c.int ---
	sceMsgDialogGetResult :: proc(result: ^SceMsgDialogResult) -> c.int ---
	sceMsgDialogTerm :: proc() -> c.int ---
	sceMsgDialogClose :: proc() -> c.int ---

	/**
	* Increases the rate of the progress bar in the message dialog
	*
	* @param target - Target progress bar
	* @param delta - Progress rate to increase (%)
	*
	* @return 0 on success, < 0 on error.
	* @note - If NULL is provided as FrameBuf pointer, output is blacked out.
	*/
	sceMsgDialogProgressBarInc :: proc(target: SceMsgDialogProgressBarTarget, delta: SceUInt32) -> c.int ---

	/**
	* Set the progress rate of the progress bar in the message dialog immediately
	*
	* @param target - Target progress bar
	* @param delta - Progress rate to increase (%)
	*
	* @return 0 on success, < 0 on error.
	* @note - If NULL is provided as FrameBuf pointer, output is blacked out.
	*/
	sceMsgDialogProgressBarSetValue :: proc(target: SceMsgDialogProgressBarTarget, rate: SceUInt32) -> c.int ---

	/**
	* Set the string displayed in the progress bar of the message dialog immediately
	*
	* @param target - Target progress bar
	* @param barMsg - The string displayed in the progress bar
	*
	* @return 0 on success, < 0 on error.
	* @note - If NULL is provided as FrameBuf pointer, output is blacked out.
	*/
	sceMsgDialogProgressBarSetMsg :: proc(target: SceMsgDialogProgressBarTarget, barMsg: cstring) -> c.int ---

	sceNetCheckDialogInit :: proc(param: ^SceNetCheckDialogParam) -> SceInt32 ---
	sceNetCheckDialogGetStatus :: proc() -> SceCommonDialogStatus ---
	sceNetCheckDialogAbort :: proc() -> SceInt32 ---
	sceNetCheckDialogGetResult :: proc(result: ^SceNetCheckDialogResult) -> SceInt32 ---
	sceNetCheckDialogGetPS3ConnectInfo :: proc(info: ^SceNetCheckDialogPS3ConnectInfo) -> SceInt32 ---
	sceNetCheckDialogTerm :: proc() -> SceInt32 ---
}

