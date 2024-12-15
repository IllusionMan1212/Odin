#+build vita
package vita

import "core:c"

/**
 * @note Last two params in all of the functions are never used,
 * 		 probably callbacks since all sceTriggerUtil functions are non-blocking
 */

/**
 * @note Max number of events (eventId) per application is 6
 */

foreign import triggerutil "system:SceTriggerUtil_stub"

SCE_TRIGGER_UTIL_VERSION :: 0x3200000

/**
 * Days of the week for use in repeatDays member of ::SceTriggerUtilEventParamDaily
 */
SceTriggerUtilDays :: enum c.int {
	SUNDAY     = 0x1,
	MONDAY     = 0x2,
	TUESDAY    = 0x4,
	WEDNESDAY  = 0x8,
	THURSDAY   = 0x10,
	FRIDAY     = 0x20,
	SATURDAY   = 0x40,
}

/**
 * Error Codes
 */
SceTriggerUtilErrorCode :: enum c.uint {
	BUSY                     = 0x80103600,
	NOT_FOUND_USER           = 0x80103611,
	NOT_FOUND_SYSTEM         = 0x80103614,
	NOT_REGISTERED           = 0x80103621,
	EVENT_TYPE_MISMATCH      = 0x80103624,
	INVALID_ARG              = 0x80103660
}

SceTriggerUtilEventParamDaily :: struct { // size is 0x50
	ver: SceUInt32,
	extraParam1: SceInt16,                      // set to 1
	extraParam2: SceInt16,                      // set to 0
	triggerTime: SceInt32,                      // POSIX time
	repeatDays: SceUInt16,                      // bitwise
	reserved: [0x40]SceChar8,
}
#assert(size_of(SceTriggerUtilEventParamDaily) == 0x50)

SceTriggerUtilEventParamOneTime :: struct { // size is 0x54
	ver: SceUInt32,
	triggerTime: SceRtcTick,                      // SceRtcTick, UTC
	extraParam1: SceUInt8,                        // set to 1
	extraParam2: SceUInt8,                        // set to 0
	reserved: [0x44]SceChar8,
}
#assert(size_of(SceTriggerUtilEventParamOneTime) == 0x54)

SceTriggerUtilUserAppInfo :: struct { // size is 0x46A
	name: [0x34]SceWChar16,
	iconPath: [0x400]SceChar8,
	unk: c.short,
}
#assert(size_of(SceTriggerUtilUserAppInfo) == 0x46A)

SceTriggerUtilSystemAppInfo :: struct { // size is 0x602
	name: [0x100]SceWChar16,
	iconPath: [0x400]SceChar8,
	reserved: [2]c.char,
}
#assert(size_of(SceTriggerUtilSystemAppInfo) == 0x602)

foreign triggerutil {
	/**
	* Register application start event that will be repeated on certain days
	*
	* @param[in] titleid - title ID of application to register event for.
	* @param[in] param - event parameters.
	* @param[in] eventId - ID number of event.
	* @param[in] a4 - Unknown, set to 0.
	* @param[in] a5 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilRegisterDailyEvent :: proc(titleid: cstring, #by_ptr param: SceTriggerUtilEventParamDaily, eventId: c.int, a4: c.int, a5: c.int) -> c.int ---

	/**
	* Register one time application start event
	*
	* @param[in] titleid - title ID of application to register event for.
	* @param[in] param - event parameters.
	* @param[in] eventId - ID number of event.
	* @param[in] a4 - Unknown, set to 0.
	* @param[in] a5 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilRegisterOneTimeEvent :: proc(titleid: cstring, #by_ptr param: SceTriggerUtilEventParamOneTime, eventId: c.int, a4: c.int, a5: c.int) -> c.int ---

	/**
	* Unregister daily event for caller application
	*
	* @param[in] eventId - ID number of event to unregister.
	* @param[in] a2 - Unknown, set to 0.
	* @param[in] a3 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilUnregisterDailyEvent :: proc(eventId: c.int, a2: c.int, a3: c.int) -> c.int ---

	/**
	* Unregister one time event for caller application
	*
	* @param[in] eventId - ID number of event to unregister.
	* @param[in] a2 - Unknown, set to 0.
	* @param[in] a3 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilUnregisterOneTimeEvent :: proc(eventId: c.int, a2: c.int, a3: c.int) -> c.int ---

	/**
	* Get value from "Settings->System->Auto-Start Settings" for caller application. Required to be 1 to use 
	*
	* @param[out] status - auto-start status. Required to be 1 to use .
	* @param[in] a2 - Unknown, set to 0.
	* @param[in] a3 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilGetAutoStartStatus :: proc(status: ^c.int, a2: c.int, a3: c.int) -> c.int ---

	/**
	* Get one time event info for caller application
	*
	* @param[in] eventId - ID number of event to get information for.
	* @param[out] triggerTime - SceRtcTick, UTC
	* @param[in] a4 - Unknown, set to 0.
	* @param[in] a5 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilGetOneTimeEventInfo :: proc(eventId: c.int, triggerTime: ^SceRtcTick, a4: c.int, a5: c.int) -> c.int ---

	/**
	* Get daily event info for caller application
	*
	* @param[in] eventId - ID number of event to get information for.
	* @param[out] param - event parameters.
	* @param[in] a5 - Unknown, set to 0.
	* @param[in] a6 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilGetDailyEventInfo :: proc(eventId: c.int, param: ^SceTriggerUtilEventParamDaily, a5: c.int, a6: c.int) -> c.int ---

	/**
	* Get info for user application that has registered  events
	*
	* @param[in] titleid - title ID of application to get info for.
	* @param[out] appInfo - application information
	* @param[in] a4 - Unknown, set to 0.
	* @param[in] a5 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilGetUserAppInfo :: proc(titleid: cstring, appInfo: ^SceTriggerUtilUserAppInfo, a4: c.int, a5: c.int) -> c.int ---

	/**
	* Get list of user applications that has registered  events. List contains null-separated title IDs
	*
	* @param[out] titleIdBuffer - pointer to buffer to recieve title ID list. Max size is 0x1000, min size is unlimited
	* @param[out] numOfIds - number of title IDs stored in the list
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilGetRegisteredUserTitleIdList :: proc(titleIdBuffer: [^]c.char, numOfIds: c.int) -> c.int ---

	/**
	* Get info for system application that has registered  events
	*
	* @param[in] titleid - title ID of application to get info for.
	* @param[out] appInfo - application information
	* @param[in] a4 - Unknown, set to 0.
	* @param[in] a5 - Unknown, set to 0.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilGetSystemAppInfo :: proc(titleid: cstring, appInfo: ^SceTriggerUtilSystemAppInfo, a4: c.int, a5: c.int) -> c.int ---

	/**
	* Get list of system applications that has registered  events. List contains null-separated fake title IDs
	*
	* @param[out] titleIdBuffer - pointer to buffer to recieve fake title ID list. Max size is 0x140, min size is unlimited
	* @param[out] numOfIds - number of fake title IDs stored in the list
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceTriggerUtilGetRegisteredSystemTitleIdList :: proc(buffer: [^]c.char, numOfIds: c.int) -> c.int ---
}

