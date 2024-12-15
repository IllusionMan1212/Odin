#+build vita
package vita

import "core:c"

foreign import incomingdialog "system:SceIncomingDialog_stub"

/**
 * Dialog status
 */
SceIncomingDialogStatus :: enum c.int {
	NOT_RUNNING,
	ACCEPTED,
	RUNNING,
	REJECTED,
	CLOSED,
	BUSY,
	TIMEOUT
}

/**
 * Error Codes
 */
SceIncomingDialogErrorCode :: enum c.uint {
	INVALID_ARG = 0x80106201
}

SceIncomingDialogParam :: struct {
  sdkVersion: SceInt32,
	audioPath: [0x80]SceChar8,           //Path to audio file that will be played during dialog, .mp3, .at9, m4a. Can be NULL
	titleid: [0x10]SceChar8,             //TitleId of the application to open when "accept" button has been pressed. Can be NULL
	unk_BC: SceInt32,                    //Can be set to 0
	dialogTimer: SceUInt32,              //Time to show dialog in seconds
	reserved1: [0x3E]SceChar8,
	buttonRightText: [0x1F]SceWChar16,   //Text for "accept" button
	separator0: SceInt16,                //must be 0
	buttonLeftText: [0x1F]SceWChar16,    //Text for "reject" button. If NULL, only "accept" button will be created
	separator1: SceInt16,                //must be 0
	dialogText: [0x80]SceWChar16,        //Text for dialog window, also shared with notification
	separator2: SceInt16,                //must be 0
}
#assert(size_of(SceIncomingDialogParam) == 0x25C)

sceIncomingDialogParamInit :: #force_inline proc(dialogParam: ^SceIncomingDialogParam) {
	sceClibMemset(dialogParam, 0x0, size_of(SceIncomingDialogParam))
	dialogParam.sdkVersion = PSP2_SDK_VERSION
}

foreign incomingdialog {
	/**
	* Initialize incoming dialog library, init_type must be 1.
	*/
	sceIncomingDialogInitialize :: proc(init_type: c.int) -> SceInt32 ---

	/**
	* Open incoming dialog.
	*/
	sceIncomingDialogOpen :: proc(dialogParam: ^SceIncomingDialogParam) -> SceInt32 ---

	/**
	* Returns current status of incoming dialog.
	*/
	sceIncomingDialogGetStatus :: proc() -> SceInt32 ---

	/**
	* Force exit to LiveArea and show dialog window
	*/
	sceIncomingDialogSwitchToDialog :: proc() -> SceInt32 ---

	/**
	* Close incoming dialog.
	*/
	sceIncomingDialogClose :: proc() -> SceInt32 ---

	/**
	* Finish incoming dialog library
	*/
	sceIncomingDialogFinish :: proc() -> SceInt32 ---
}

