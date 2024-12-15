#+build vita
package vita

import "core:c"

foreign import notificationutil "system:SceNotificationUtil_stub"

/**
 * Constants
 */
SCE_NOTIFICATIONUTIL_TEXT_MAX :: 0x3F

/**
 * Error Codes
 */
SceNotificationUitlErrorCode :: enum c.uint {
	INTERNAL = 0x80106300
}

/**
 * BGDL-type notification event handler function
 */
SceNotificationUtilProgressEventHandler :: #type ^proc "c" (eventId: c.int)

SceNotificationUtilProgressInitParam :: struct {
  notificationText: [SCE_NOTIFICATIONUTIL_TEXT_MAX]SceWChar16,
	separator0: SceInt16,						//must be 0
	notificationSubText: [SCE_NOTIFICATIONUTIL_TEXT_MAX]SceWChar16,
	separator1: SceInt16,						//must be 0
	unk: [0x3E6]SceChar8,
	unk_4EC: SceInt32,						//can be set to 0
	eventHandler: SceNotificationUtilProgressEventHandler,
}

SceNotificationUtilProgressUpdateParam :: struct {
  notificationText: [SCE_NOTIFICATIONUTIL_TEXT_MAX]SceWChar16,
	separator0: SceInt16,						//must be 0
	notificationSubText: [SCE_NOTIFICATIONUTIL_TEXT_MAX]SceWChar16,
	separator1: SceInt16,						//must be 0
	targetProgress: SceFloat,
	reserved: [0x38]SceChar8,
}
#assert(size_of(SceNotificationUtilProgressUpdateParam) == 0x13C)

SceNotificationUtilProgressFinishParam :: struct {
  notificationText: [SCE_NOTIFICATIONUTIL_TEXT_MAX]SceWChar16,
	separator0: SceInt16,						//must be 0
	notificationSubText: [SCE_NOTIFICATIONUTIL_TEXT_MAX]SceWChar16,
	separator1: SceInt16,						//must be 0
	path: [0x3E8]SceChar8,
}
#assert(size_of(SceNotificationUtilProgressFinishParam) == 0x4E8)


foreign notificationutil {
	/**
	* Initialize notification util for use with BG application.
	*
	* Does not need to be called for normal applications.
	*/
	sceNotificationUtilBgAppInitialize :: proc() -> SceInt32 ---

	/**
	* Send notification.
	*
	* Text buffer size must be 0x410.
	*/
	sceNotificationUtilSendNotification :: proc(text: [^]SceWChar16) -> SceInt32 ---

	/**
	* Clean notifications for calling app from notification history.
	*/
	sceNotificationUtilCleanHistory :: proc() -> SceInt32 ---

	/**
	* Start BGDL-type notification.
	*/
	sceNotificationUtilProgressBegin :: proc(initParams: ^SceNotificationUtilProgressInitParam) -> SceInt32 ---

	/**
	* Update BGDL-type notification.
	*/
	sceNotificationUtilProgressUpdate :: proc(updateParams: ^SceNotificationUtilProgressUpdateParam) -> SceInt32 ---

	/**
	* Finish BGDL-type notification.
	*/
	sceNotificationUtilProgressFinish :: proc(finishParams: ^SceNotificationUtilProgressFinishParam) -> SceInt32 ---
}

