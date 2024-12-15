#+build vita
package vita

import "core:c"

foreign import ctrl "system:SceCtrl_stub"
foreign import ctrlkern "system:SceCtrlForDriver_stub"

SceCtrlErrorCode :: enum c.uint {
	INVALID_ARG   = 0x80340001,
	PRIV_REQUIRED = 0x80340002,
	NO_DEVICE     = 0x80340020,
	NOT_SUPPORTED = 0x80340021,
	INVALID_MODE  = 0x80340022,
	FATAL         = 0x803400FF,
}

/** Enumeration for the digital controller buttons.
 * @note - L1/R1/L3/R3 only can bind using ::sceCtrlPeekBufferPositiveExt2 and ::sceCtrlReadBufferPositiveExt2
 * @note - Values bigger than 0x00010000 can be intercepted only with shell privileges
 * @note - Vita's L Trigger and R Trigger are mapped to L1 and R1 when using ::sceCtrlPeekBufferPositiveExt2 and ::sceCtrlReadBufferPositiveExt2
 */
SceCtrlButtons :: enum c.int {
	SELECT      = 0x00000001,            //!< Select button.
	L3          = 0x00000002,            //!< L3 button.
	R3          = 0x00000004,            //!< R3 button.
	START       = 0x00000008,            //!< Start button.
	UP          = 0x00000010,            //!< Up D-Pad button.
	RIGHT       = 0x00000020,            //!< Right D-Pad button.
	DOWN        = 0x00000040,            //!< Down D-Pad button.
	LEFT        = 0x00000080,            //!< Left D-Pad button.
	LTRIGGER    = 0x00000100,            //!< Left trigger.
	L2          = LTRIGGER,     //!< L2 button.
	RTRIGGER    = 0x00000200,            //!< Right trigger.
	R2          = RTRIGGER,     //!< R2 button.
	L1          = 0x00000400,            //!< L1 button.
	R1          = 0x00000800,            //!< R1 button.
	TRIANGLE    = 0x00001000,            //!< Triangle button.
	CIRCLE      = 0x00002000,            //!< Circle button.
	CROSS       = 0x00004000,            //!< Cross button.
	SQUARE      = 0x00008000,            //!< Square button.
	INTERCEPTED = 0x00010000,            //!< Input not available because intercepted by another application
	PSBUTTON    = INTERCEPTED,  //!< Playstation (Home) button.
	HEADPHONE   = 0x00080000,            //!< Headphone plugged in.
	VOLUP       = 0x00100000,            //!< Volume up button.
	VOLDOWN     = 0x00200000,            //!< Volume down button.
	POWER       = 0x40000000,            //!< Power button.
}

/** Enumeration for the controller types. */
SceCtrlExternalInputMode :: enum c.int {
	UNPAIRED  = 0, //!< Unpaired controller
	PHY       = 1, //!< Physical controller for VITA
	VIRT      = 2, //!< Virtual controller for PSTV
	DS3       = 4, //!< DualShock 3
	DS4       = 8  //!< DualShock 4
}

/** Controller mode. */
SceCtrlPadInputMode :: enum c.int {
	/** Digital buttons only. */
	DIGITAL     = 0,
	/** Digital buttons + Analog support. */
	ANALOG      = 1,
	/** Same as ::SCE_CTRL_MODE_ANALOG, but with larger range for analog sticks. */
	ANALOG_WIDE = 2
}

/** Returned controller data */
SceCtrlData :: struct {
	/** The current read frame. */
	timeStamp: c.uint64_t,
	/** Bit mask containing zero or more of ::SceCtrlButtons. */
	buttons: c.uint,
	/** Left analogue stick, X axis. */
	lx: c.uchar,
	/** Left analogue stick, Y axis. */
	ly: c.uchar,
	/** Right analogue stick, X axis. */
	rx: c.uchar,
	/** Right analogue stick, Y axis. */
	ry: c.uchar,
	/** Up button */
	up: c.uint8_t,
	/** Right button */
	right: c.uint8_t,
	/** Down button */
	down: c.uint8_t,
	/** Left button */
	left: c.uint8_t,
	/** Left trigger (L2) */
	lt: c.uint8_t,
	/** Right trigger (R2) */
	rt: c.uint8_t,
	/** Left button (L1) */
	l1: c.uint8_t,
	/** Right button (R1) */
	r1: c.uint8_t,
	/** Triangle button */
	triangle: c.uint8_t,
	/** Circle button */
	circle: c.uint8_t,
	/** Cross button */
	cross: c.uint8_t,
	/** Square button */
	square: c.uint8_t,
	/** Reserved. */
	reserved: [4]c.uint8_t,
}
#assert(size_of(SceCtrlData) == 0x20)

/** Structure to pass as argument to ::sceCtrlSetRapidFire */
SceCtrlRapidFireRule :: struct {
	Mask: c.uint,
	Trigger: c.uint,
	Target: c.uint,
	Delay: c.uint,
	Make: c.uint,
	Break: c.uint,
}
#assert(size_of(SceCtrlRapidFireRule) == 0x18)

/** Structure to pass as argument to ::sceCtrlSetActuator */
SceCtrlActuator :: struct {
	small: c.uchar, //!< Vibration strength of the small motor
	large: c.uchar, //!< Vibration strength of the large motor
	unk: [6]c.uint8_t ,      //!< Unknown
}
#assert(size_of(SceCtrlActuator) == 8)

/** Structure to pass as argument to ::sceCtrlGetControllerPortInfo */
SceCtrlPortInfo :: struct {
	port: [5]c.uint8_t,  //!< Controller type of each port (See ::SceCtrlExternalInputMode)
	unk: [11]c.uint8_t,  //!< Unknown
}
#assert(size_of(SceCtrlPortInfo) == 0x10)

/** Structure to pass as argument to ::ksceCtrlRegisterVirtualControllerDriver */
SceCtrlVirtualControllerDriver :: struct {
	readButtons: #type ^proc "c" (port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int,
	setActuator: #type ^proc "c" (port: c.int, #by_ptr pState: SceCtrlActuator) -> c.int,
	getBatteryInfo: #type ^proc "c" (port: c.int, batt: ^SceUInt8) -> c.int,
	disconnect: #type ^proc "c" (port: c.int) -> c.int,
	setTurnOffInterval: #type ^proc "c" (port: c.int) -> c.int,
	getActiveControllerPort: #type ^proc "c" () -> c.int,
	changePortAssign: #type ^proc "c" (port1: c.int, port2: c.int) -> c.int,
	unk0: #type ^proc "c" () -> c.int,
	getControllerPortInfo: #type ^proc "c" (info: ^SceCtrlPortInfo) -> c.int,
	setLightBar: #type ^proc "c" (port: c.int, r: SceUInt8, g: SceUInt8, b: SceUInt8) -> c.int,
	resetLightBar: #type ^proc "c" (port: c.int) -> c.int,
	unk1: #type ^proc "c" (port: c.int) -> c.int,
	singleControllerMode: #type ^proc "c" (port: c.int) -> c.int,
}

foreign ctrl {
	/**
	* Set the controller mode.
	*
	* @param[in] mode - One of ::SceCtrlPadInputMode.
	*
	* @return The previous mode, <0 on error.
	*/
	sceCtrlSetSamplingMode :: proc(mode: SceCtrlPadInputMode) -> c.int ---

	/**
	* Set the controller extend mode.
	*
	* @param[in] mode - One of ::SceCtrlPadInputMode.
	*
	* @return The previous mode, <0 on error.
	*/
	sceCtrlSetSamplingModeExt :: proc(mode: SceCtrlPadInputMode) -> c.int ---

	/**
	* Get the current controller mode.
	*
	* @param[out] pMode - Return value, see ::SceCtrlPadInputMode.
	*
	* @return The current mode, <0 on error.
	*/
	sceCtrlGetSamplingMode :: proc(pMode: ^SceCtrlPadInputMode) -> c.int ---

	/**
	* Get the controller state information (polling, positive logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlPeekBufferPositive :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the wireless controller state information (polling, positive logic).
	*
	* This function will bind L/R trigger value to L1/R1 instead of LTRIGGER/RTRIGGER
	*
	* @param[in] port - use 0 - 5.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlPeekBufferPositive2 :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller state information (polling, positive logic).
	*
	* This function will return button presses, even if they're intercepted by common dialog/IME.
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlPeekBufferPositiveExt :: proc(port: c.int, pad_data: ^SceCtrlData, count: int) -> c.int ---

	/**
	* Get the wireless controller state information (polling, positive logic).
	*
	* This function will bind L/R trigger value to L1/R1 instead of LTRIGGER/RTRIGGER
	* This function will return button presses, even if they're intercepted by common dialog/IME.
	*
	* @param[in] port - use 0 - 5.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlPeekBufferPositiveExt2 :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller state information (polling, negative logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlPeekBufferNegative :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the wireless controller state information (polling, negative logic).
	*
	* This function will bind L/R trigger value to L1/R1 instead of LTRIGGER/RTRIGGER
	*
	* @param[in] port - use 0-5.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlPeekBufferNegative2 :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller state information (blocking, positive logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlReadBufferPositive :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the wireless controller state information (blocking, positive logic).
	*
	* This function will bind L/R trigger value to L1/R1 instead of LTRIGGER/RTRIGGER
	*
	* @param[in] port - use 0-5.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlReadBufferPositive2 :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller extended state information (blocking, positive logic).
	*
	* This function will return button presses, even if they're intercepted by common dialog/IME.
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlReadBufferPositiveExt :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the wireless controller extended state information (blocking, positive logic).
	*
	* This function will bind L/R trigger value to L1/R1 instead of LTRIGGER/RTRIGGER
	* This function will return button presses, even if they're intercepted by common dialog/IME.
	*
	* @param[in] port - use 0-5.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlReadBufferPositiveExt2 :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller state information (blocking, negative logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlReadBufferNegative :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the wireless controller state information (blocking, negative logic).
	*
	* This function will bind L/R trigger value to L1/R1 instead of LTRIGGER/RTRIGGER
	*
	* @param[in] port - use 0-5.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count. Up to 64 buffers can be requested.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	sceCtrlReadBufferNegative2 :: proc(port: c.int, pad_data: ^SceCtrlData , count: c.int) -> c.int ---

	/**
	* Set rules for button rapid fire
	*
	* @param[in] port - use 0.
	* @param[in] idx - rule index between 0-15
	* @param[in] pRule - structure ::SceCtrlRapidFireRule.
	*
	* @return 0, <0 on error.
	*/
	sceCtrlSetRapidFire :: proc(port: c.int, idx: c.int, #by_ptr pRule: SceCtrlRapidFireRule) -> c.int ---

	/**
	* Clear rules for button rapid fire
	*
	* @param[in] port - use 0.
	* @param[in] idx - rule index between 0-15
	*
	* @return 0, <0 on error.
	*/
	sceCtrlClearRapidFire :: proc(port: c.int, idx: c.int) -> c.int ---

	/**
	* Control the actuator (vibrate) on paired controllers.
	*
	* @param[in] port - use 1 for the first paired controller, etc.
	* @param[in] state - see ::SceCtrlActuator
	*
	* @return 0, <0 on error.
	*/
	sceCtrlSetActuator :: proc(port: c.int, #by_ptr pState: SceCtrlActuator) -> c.int ---

	/**
	* Control the light bar on paired controllers.
	*
	* @param[in] port - use 1 for the first paired controller, etc.
	* @param[in] r - red intensity
	* @param[in] g - green intensity
	* @param[in] b - blue intensity
	*
	* @return 0, <0 on error.
	*/
	sceCtrlSetLightBar :: proc(port: c.int, r: SceUInt8, g: SceUInt8, b: SceUInt8) -> c.int ---

	/**
	* Get controller port information.
	*
	* @param[out] info - see ::SceCtrlPortInfo
	* @return 0, <0 on error
	*/
	sceCtrlGetControllerPortInfo :: proc(info: ^SceCtrlPortInfo) -> c.int ---

	/**
	* Get controller battery information.
	*
	* @param[in] port - use 1 for the first paired controller, etc.
	* @param[out] batt - battery level, between 0-5, 0xEE charging, 0xEF charged
	*
	* @return 0, <0 on error.
	*/
	sceCtrlGetBatteryInfo :: proc(port: c.int, batt: ^SceUInt8) -> c.int ---

	/**
	* Sets intercept
	*
	* If true, allows the current thread to intercept controls. The use case
	* might be, for example, a game plugin that wishes to capture input without
	* having the input sent to the game thread.
	* @param[in]  intercept  Boolean value
	*
	* @return 0, < 0 on error
	*/
	sceCtrlSetButtonIntercept :: proc(intercept: c.int) -> c.int ---

	/**
	* Gets intercept
	*
	* @param[out]  intercept  Boolean value
	*
	* @return 0, < 0 on error
	*/
	sceCtrlGetButtonIntercept :: proc(intercept: ^int) -> c.int ---

	/**
	* Check if multi controller is supported
	*
	* @return 1 if yes, 0 if no
	*/
	sceCtrlIsMultiControllerSupported :: proc() -> c.int ---
}

foreign ctrlkern {
	/**
	* Set the controller mode.
	*
	* @param[in] mode - One of ::SceCtrlPadInputMode.
	*
	* @return The previous mode, <0 on error.
	*/
	ksceCtrlSetSamplingMode :: proc(mode: c.int) -> c.int ---

	/**
	* Get the current controller mode.
	*
	* @param[out] pMode - Return value, see ::SceCtrlPadInputMode.
	*
	* @return The current mode, <0 on error.
	*/
	ksceCtrlGetSamplingMode :: proc(pMode: ^c.int) -> c.int ---

	/**
	* Get the controller state information (polling, positive logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	ksceCtrlPeekBufferPositive :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller state information (polling, negative logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	ksceCtrlPeekBufferNegative :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller state information (blocking, positive logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	ksceCtrlReadBufferPositive :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Get the controller state information (blocking, negative logic).
	*
	* @param[in] port - use 0.
	* @param[out] *pad_data - see ::SceCtrlData.
	* @param[in] count - Buffers count.
	*
	* @return Buffers count, between 1 and 'count'. <0 on error.
	*/
	ksceCtrlReadBufferNegative :: proc(port: c.int, pad_data: ^SceCtrlData, count: c.int) -> c.int ---

	/**
	* Set rules for button rapid fire
	*
	* @param[in] port - use 0.
	* @param[in] idx - rule index between 0-15
	* @param[in] pRule - structure ::SceCtrlRapidFireRule.
	*
	* @return 0, <0 on error.
	*/
	ksceCtrlSetRapidFire :: proc(port: c.int, idx: c.int, #by_ptr pRule: SceCtrlRapidFireRule) -> c.int ---

	/**
	* Clear rules for button rapid fire
	*
	* @param[in] port - use 0.
	* @param[in] idx - rule index between 0-15
	*
	* @return 0, <0 on error.
	*/
	ksceCtrlClearRapidFire :: proc(port: c.int, idx: c.int) -> c.int ---

	/**
	* Get controller port information.
	*
	* @param[out] info - see ::SceCtrlPortInfo
	* @return 0, <0 on error
	*/
	ksceCtrlGetControllerPortInfo :: proc(info: ^SceCtrlPortInfo) -> c.int ---

	/**
	* Sets intercept
	*
	* If true, allows the current thread to intercept controls. The use case
	* might be, for example, a game plugin that wishes to capture input without
	* having the input sent to the game thread.
	* @param[in]  intercept  Boolean value
	*
	* @return     0, < 0 on error
	*/
	ksceCtrlSetButtonIntercept :: proc(intercept: c.int) -> c.int ---

	/**
	* Gets intercept
	*
	* @param[out]  intercept  Boolean value
	*
	* @return     0, < 0 on error
	*/
	ksceCtrlGetButtonIntercept :: proc(intercept: ^c.int) -> c.int ---

	/**
	* Emulate buttons for the digital pad.
	* @param port Use 0
	* @param slot The slot used to set the custom values. Between 0 - 3. If multiple slots are used,
	*             their settings are combined.
	* @param userButtons Emulated user buttons of ::SceCtrlButtons. You cannot emulate kernel
	*                    buttons and the emulated buttons will only be applied for applications
	*                    running in user mode.
	* @param kernelButtons Emulated buttons of ::SceCtrlButtons (you can emulate both user and
	*                      kernel buttons). The emulated buttons will only be applied for applications
	*                      running in kernel mode.
	* @param uiMake Specifies the duration of the emulation. Measured in sampling counts.
	*
	* @return 0 on success.
	*/
	ksceCtrlSetButtonEmulation :: proc(port: c.uint, slot: c.uchar, userButtons: c.uint, kernelButtons: c.uint, uiMake: c.uint) -> c.int ---

	/**
	* Emulate values for the analog pad's X- and Y-axis.
	*
	* @param port Use 0
	* @param slot The slot used to set the custom values. Between 0 - 3. If multiple slots are used,
	*             their settings are combined.
	* @param user_lX New emulated value for the left joystick's X-axis (userspace). Between 0 - 0xFF.
	* @param user_lY New emulate value for the left joystick's Y-axis (userspace). Between 0 - 0xFF.
	* @param user_rX New emulated value for the right joystick's X-axis (userspace). Between 0 - 0xFF.
	* @param user_rY New emulate value for the right joystick's Y-axis (userspace). Between 0 - 0xFF.
	* @param kernel_lX New emulated value for the left joystick's X-axis (kernelspace). Between 0 - 0xFF.
	* @param kernel_lY New emulate value for the left joystick's Y-axis (kernelspace). Between 0 - 0xFF.
	* @param kernel_rX New emulated value for the right joystick's X-axis (kernelspace). Between 0 - 0xFF.
	* @param kernel_rY New emulate value for the right joystick's Y-axis (kernelspace). Between 0 - 0xFF.
	* @param uiMake Specifies the duration of the emulation. Measured in sampling counts.
	*
	* @return 0 on success.
	*/
	ksceCtrlSetAnalogEmulation :: proc(port: c.uint, slot: c.uchar, user_lX: c.uchar, user_lY: c.uchar, user_rX: c.uchar, user_rY: c.uchar, kernel_lX: c.uchar, kernel_lY: c.uchar, kernel_rX: c.uchar, kernel_rY: c.uchar, uiMake: c.uint) -> c.int ---

	/**
	* Register virtual controller driver.
	*
	* This function always overwrites global settings and not exist unregister method.
	*
	* @param[in] driver - See ::SceCtrlVirtualControllerDriver
	*
	* @return 0 on success. <0 on error
	*/
	ksceCtrlRegisterVirtualControllerDriver :: proc(driver: ^SceCtrlVirtualControllerDriver) -> c.int ---

	/**
	* Update ctrl mask for non shell process
	*
	* @param[in] clear_mask - The SceCtrlButtons type value
	* @param[in] set_mask   - The SceCtrlButtons type value
	*
	* @return always 0.
	*
	* note - Some values cannot be clear/set.
	*/
	ksceCtrlUpdateMaskForNonShell :: proc(clear_mask: c.int, set_mask: c.int) -> c.int ---

	/**
	* Update ctrl mask for all process
	*
	* @param[in] clear_mask - The SceCtrlButtons type value
	* @param[in] set_mask   - The SceCtrlButtons type value
	*
	* @return always 0.
	*
	* note - Some values cannot be clear/set.
	*/
	ksceCtrlUpdateMaskForAll :: proc(clear_mask: c.int, set_mask: c.int) -> c.int ---

	/**
	* Get ctrl mask for non shell process
	*
	* @param[out] mask - The pointer of SceCtrlButtons type value output
	*
	* @return 0 on success. < 0 on error.
	*/
	ksceCtrlGetMaskForNonShell :: proc(mask: ^c.uint32_t) -> c.int ---

	/**
	* Get ctrl mask for all process
	*
	* @param[out] mask - The pointer of SceCtrlButtons type value output
	*
	* @return 0 on success. < 0 on error.
	*/
	ksceCtrlGetMaskForAll :: proc(mask: ^c.uint32_t) -> c.int ---
}

