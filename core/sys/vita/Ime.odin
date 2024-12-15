#+build vita
package vita

import "core:c"

foreign import ime "system:SceIme_stub"

SCE_IME_DIALOG_MAX_TITLE_LENGTH   :: 128
SCE_IME_DIALOG_MAX_TEXT_LENGTH    :: 2048

SCE_IME_WORK_BUFFER_SIZE          :: (20*1024)

SCE_IME_MAX_PREEDIT_LENGTH        :: (30)
SCE_IME_MAX_TEXT_LENGTH           :: (2048)

SceImeDialogErrorCode :: enum c.uint {
	PARAM                      = 0x80102001,
	INTERNAL                   = 0x80102002,
	INVALID_DIALOG_MODE        = 0x80102003,
	INVALID_TEXT_BOX_MODE      = 0x80102004,
	INVALID_TITLE              = 0x80102005
}

SceImeDialogDialogMode :: enum c.int {
	DEFAULT      = 0,
	WITH_CANCEL  = 1
}

SceImeDialogTextboxMode :: enum c.int {
	DEFAULT     = 0,
	PASSWORD    = 1,
	WITH_CLEAR	= 2
}

SceImeDialogButton :: enum c.int {
	NONE  = 0,
	CLOSE = 1,
	ENTER = 2
}

SceImeDialogParam :: struct {
  sdkVersion: SceUInt32,

	inputMethod: SceUInt32,
	supportedLanguages: SceUInt64,         //!< Dialog languages (One or more ::SceImeLanguage)
	languagesForced: SceBool,
	type: SceUInt32,                       //!< Dialog type (One of ::SceImeType)
	option: SceUInt32,                     //!< Dialog options (One or more ::SceImeOption)
	filter: SceImeTextFilter,

	dialogMode: SceUInt32,                 //!< Dialog mode (One of ::SceImeDialogDialogMode)
	textBoxMode: SceUInt32,                //!< Textbox mode (One of ::SceImeDialogTextboxMode)
	title: [^]SceWChar16,
	maxTextLength: SceUInt32,
	initialText: [^]SceWChar16,
	inputTextBuffer: [^]SceWChar16,

	commonParam: SceCommonDialogParam,

	enterLabel: SceUChar8,
	reserved: [35]SceChar8,
}

SceImeDialogResult :: struct {
  result: SceInt32,
	button: SceInt32,
	reserved: [28]SceChar8,
}
#assert(size_of(SceImeDialogResult) == 0x24)

SceImeErrorCode :: enum c.uint {
	ALREADY_OPENED               = 0x80100700,
	NOT_OPENED                   = 0x80100701,
	INVALID_POINTER              = 0x80100702,
	INVALID_PARAM                = 0x80100703,
	NO_MEMORY                    = 0x80100704,
	CONNECTION_FAILED            = 0x80100705,
	INVALID_TEXT                 = 0x80100706,
	TOO_MANY_REQUESTS            = 0x80100707,
	INVALID_SIZE                 = 0x80100710,
	INVALID_INPUT_METHOD         = 0x80100712,
	INVALID_SUPPORTED_LANGUAGES  = 0x80100713,
	INVALID_TYPE                 = 0x80100714,
	INVALID_OPTION               = 0x80100715,
	INVALID_WORK                 = 0x80100716,
	INVALID_ARG                  = 0x80100717,
	INVALID_HANDLER              = 0x80100718,
	INVALID_MAX_TEXT_LENGTH      = 0x80100719,
	INVALID_INPUT_TEXT_BUFFER    = 0x8010071a,
	INVALID_RESERVED             = 0x8010071b,
	INVALID_ENTER_LABEL          = 0x8010071c,
	INTERNAL                     = 0x80100750
}

SceImeLanguage :: enum c.ulonglong {
	DANISH              = 0x00000001,
	GERMAN              = 0x00000002,
	ENGLISH             = 0x00000004,
	SPANISH             = 0x00000008,
	FRENCH              = 0x00000010,
	ITALIAN             = 0x00000020,
	DUTCH               = 0x00000040,
	NORWEGIAN           = 0x00000080,
	POLISH              = 0x00000100,
	PORTUGUESE          = 0x00000200,
	RUSSIAN             = 0x00000400,
	FINNISH             = 0x00000800,
	SWEDISH             = 0x00001000,
	JAPANESE            = 0x00002000,
	KOREAN              = 0x00004000,
	SIMPLIFIED_CHINESE  = 0x00008000,
	TRADITIONAL_CHINESE = 0x00010000,
	PORTUGUESE_BR       = 0x00020000,
	ENGLISH_GB          = 0x00040000,
	TURKISH             = 0x00080000,
}

SceImeType :: enum c.int {
	DEFAULT             = 0,
	BASIC_LATIN         = 1,
	NUMBER              = 2,
	EXTENDED_NUMBER     = 3,
	URL                 = 4,
	MAIL                = 5
}

SceImeEnterLabel :: enum c.int {
	DEFAULT = 0,
	SEND    = 1,
	SEARCH  = 2,
	GO      = 3
}

SceImeOption :: enum c.int {
	MULTILINE               = 0x01,
	NO_AUTO_CAPITALIZATION  = 0x02,
	NO_ASSISTANCE           = 0x04
}

SceImeEvent :: enum c.int {
	OPEN              = 0,
	UPDATE_TEXT       = 1,
	UPDATE_CARET      = 2,
	CHANGE_SIZE       = 3,
	PRESS_CLOSE       = 4,
	PRESS_ENTER       = 5
}

SceImeRect :: struct {
  x: SceUInt32,
	y: SceUInt32,
	width: SceUInt32,
	height: SceUInt32,
}
#assert(size_of(SceImeRect) == 0x10)

SceImeEditText :: struct {
  preeditIndex: SceUInt32,
	preeditLength: SceUInt32,
	caretIndex: SceUInt32,
	str: [^]SceWChar16,
	editIndex: SceUInt32,
	editLengthChange: SceInt32,
}
	
SceImeEventParam :: struct #raw_union {
  rect: SceImeRect,
	text: SceImeEditText,
	caretIndex: SceUInt32,
	reserved: [40]SceUChar8,
}
#assert(size_of(SceImeEventParam) == 0x28)

SceImeEventData :: struct #packed {
  id: SceUInt32,
	param: SceImeEventParam,
}
#assert(size_of(SceImeEventData) == 0x2C)

SceImeCaret :: struct {
  x: SceUInt32,
	y: SceUInt32,
	height: SceUInt32,
	index: SceUInt32,
}
#assert(size_of(SceImeCaret) == 0x10)

SceImePreeditGeometry :: struct {
  x: SceUInt32,
	y: SceUInt32,
	height: SceUInt32,
}
#assert(size_of(SceImePreeditGeometry) == 0xC)

SceImeTextFilter :: #type ^proc(
  outText: [^]SceWChar16,
  outTextLength: ^SceUInt32,
  srcText: [^]SceWChar16,
  srcTextLength: SceUInt32) -> SceUInt32
SceImeEventHandler :: #type ^proc(arg: rawptr, #by_ptr e: SceImeEventData)

SceImeParam :: struct {
  sdkVersion: SceUInt32,

	inputMethod: SceUInt32,
	supportedLanguages: SceUInt64,	//!< Dialog languages (One or more ::SceImeLanguage)
	languagesForced: SceBool,
	type: SceUInt32,					//!< Dialog type (One of ::SceImeType)
	option: SceUInt32,				//!< Dialog options (One or more ::SceImeOption)

	work: rawptr,
	arg: rawptr,
	handler: SceImeEventHandler,
	filter: SceImeTextFilter,

	initialText: [^]SceWChar16,
	maxTextLength: SceUInt32,
	inputTextBuffer: [^]SceWChar16,

	enterLabel: SceUChar8,
	reserved: [7]SceUChar8,
}

sceImeDialogParamInit :: #force_inline proc(param: ^SceImeDialogParam) {
	sceClibMemset(param, 0x0, size_of(SceImeDialogParam))
	_sceCommonDialogSetMagicNumber(&param.commonParam)
	param.sdkVersion = PSP2_SDK_VERSION
}

sceImeParamInit :: #force_inline proc(param: ^SceImeParam) {
	sceClibMemset(param, 0x0, size_of(SceImeParam))
	param.sdkVersion = PSP2_SDK_VERSION
}

foreign ime {
	sceImeDialogInit :: proc(#by_ptr param: SceImeDialogParam) -> SceInt32 ---
	sceImeDialogGetStatus :: proc() -> SceCommonDialogStatus ---
	sceImeDialogAbort :: proc() -> SceInt32 ---
	sceImeDialogGetResult :: proc(result: ^SceImeDialogResult) -> SceInt32 ---
	sceImeDialogTerm :: proc() -> SceInt32 ---

	sceImeOpen :: proc(#by_ptr param: SceImeParam) -> SceInt32 ---
	sceImeUpdate :: proc() -> SceInt32 ---
	sceImeSetText :: proc(text: [^]SceWChar16, length: SceUInt32) -> SceInt32 ---
	sceImeSetCaret :: proc(#by_ptr caret: SceImeCaret) -> SceInt32 ---
	sceImeSetPreeditGeometry :: proc(#by_ptr preedit: SceImePreeditGeometry) -> SceInt32 ---
	sceImeClose :: proc() -> SceInt32 ---
}

