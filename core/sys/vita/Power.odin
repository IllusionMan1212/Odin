#+build vita
package vita

import "core:c"

foreign import power "system:ScePower_stub"
foreign import powerkern "system:ScePowerForDriver_stub"

ScePowerErrorCode :: enum c.uint {
	INVALID_VALUE           = 0x802B0000,
	ALREADY_REGISTERED      = 0x802B0001,
	CALLBACK_NOT_REGISTERED = 0x802B0002,
	CANT_SUSPEND            = 0x802B0003,
	NO_BATTERY              = 0x802B0100,
	DETECTING               = 0x802B0101
}
#assert(size_of(ScePowerErrorCode) == 4)

ScePowerCallbackType :: enum c.uint {
	AFTER_SYSTEM_RESUME   = 0x00000080,
	BATTERY_ONLINE        = 0x00000100,
	THERMAL_SUSPEND       = 0x00000200,
	LOW_BATTERY_SUSPEND   = 0x00000400,
	LOW_BATTERY           = 0x00000800,
	POWER_ONLINE          = 0x00001000,
	SYSTEM_SUSPEND        = 0x00010000,
	SYSTEM_RESUMING       = 0x00020000,
	SYSTEM_RESUME         = 0x00040000,
	UNK_0x100000          = 0x00100000, /* Related to proc_event::display_switch */
	APP_RESUME            = 0x00200000,
	APP_SUSPEND           = 0x00400000,
	APP_RESUMING          = 0x00800000,
	BUTTON_PS_START_PRESS = 0x04000000,
	BUTTON_PS_POWER_PRESS = 0x08000000,
	BUTTON_PS_HOLD        = 0x10000000,
	BUTTON_PS_PRESS       = 0x20000000,
	BUTTON_POWER_HOLD     = 0x40000000,
	BUTTON_POWER_PRESS    = 0x80000000,
	VALID_MASK_KERNEL     = 0xFCF71F80,
	VALID_MASK_SYSTEM     = 0xFCF71F80,
	VALID_MASK_NON_SYSTEM = 0x00361180
}
#assert(size_of(ScePowerCallbackType) == 4)

/* GPU, WLAN/COM configuration setting */
ScePowerConfigurationMode :: enum c.uint {
	SCE_POWER_CONFIGURATION_MODE_A = 0x00000080, /* GPU clock normal, WLAN/COM enabled */
	SCE_POWER_CONFIGURATION_MODE_B = 0x00000800, /* GPU clock high, WLAN/COM disabled */
	SCE_POWER_CONFIGURATION_MODE_C = 0x00010880, /* GPU clock high, WLAN/COM enabled (drains battery faster) */
	__SCE_POWER_CONFIGURATION_MODE = 0xFFFFFFFF
}
#assert(size_of(ScePowerConfigurationMode) == 4)

/* Callbacks */

/** Callback function prototype */
ScePowerCallback :: #type ^proc "c" (notifyId: c.int, notifyCount: c.int, powerInfo: c.int, userData: rawptr)

foreign power {
	/**
	* Registers a ScePower Callback
	*
	* @param cbid - The UID of the specified callback
	*
	* @return 0 on success, < 0 on error
	*/
	scePowerRegisterCallback :: proc(cbid: SceUID) -> c.int ---

	/**
	* Unregister a callback
	*
	* @param cbid - The UID of the specified callback
	*
	* @return 0 on success, < 0 on error
	*/
	scePowerUnregisterCallback :: proc(cbid: SceUID) -> c.int ---

	/**
	* Returns battery charging status
	*
	* @return SCE_TRUE if under charge, SCE_FALSE otherwise
	*/
	scePowerIsBatteryCharging :: proc() -> SceBool ---

	/**
	* Returns battery life percentage
	*
	* @return Battery life percentage
	*/
	scePowerGetBatteryLifePercent :: proc() -> c.int ---

	/**
	* Set power configuration mode between:
	*
	* Mode A - This is the normal mode at process start-up. The clock frequency of the GPU core is the "normal" clock frequency. The WLAN/COM can be used.
	* Mode B - This mode accelerates the GPU clock frequency. The clock frequency of the GPU core is the "high" clock frequency. The WLAN/COM cannot be used.
	* Mode C - This mode accelerates the GPU clock frequency, and also uses the WLAN/COM. The clock frequency of the GPU core is the "high" clock frequency, and use of the WLAN/COM is possible. The screen (touchscreen) brightness, however, is limited. Also, camera cannot be used.
	*
	* @param conf One of ::ScePowerConfigurationMode
	*
	* @return 0 on success
	*/
	scePowerSetConfigurationMode :: proc(conf: c.int) -> c.int ---

	/**
	* Check if a suspend is required
	*
	* @return SCE_TRUE if suspend is required, SCE_FALSE otherwise
	*/
	scePowerIsSuspendRequired :: proc() -> SceBool ---

	/**
	* Check if AC is plugged in
	*
	* @return SCE_TRUE if plugged in, SCE_FALSE otherwise
	*/
	scePowerIsPowerOnline :: proc() -> SceBool ---

	/**
	* Returns battery life time
	*
	* @return Battery life time in minutes
	*/
	scePowerGetBatteryLifeTime :: proc() -> c.int ---

	/**
	* Returns battery remaining capacity
	*
	* @return battery remaining capacity in mAh (milliampere hour)
	*/
	scePowerGetBatteryRemainCapacity :: proc() -> c.int ---

	/**
	* Returns battery state
	*
	* @return SCE_TRUE if battery is low, SCE_FALSE otherwise
	*/
	scePowerIsLowBattery :: proc() -> SceBool ---

	/**
	* Returns battery full capacity
	*
	* @return battery full capacity in mAh (milliampere hour)
	*/
	scePowerGetBatteryFullCapacity :: proc() -> c.int ---

	/**
	* Returns battery temperature
	*
	* @return temperature in degrees celcius * 100
	*/
	scePowerGetBatteryTemp :: proc() -> c.int ---

	/**
	* Returns battery voltage
	*
	* @return battery voltage in mV (millivolts)
	*/
	scePowerGetBatteryVolt :: proc() -> c.int ---

	/**
	* Returns battery state of health
	*
	* @return battery state of health percent
	*/
	scePowerGetBatterySOH :: proc() -> c.int ---

	/**
	* Returns battery cycle count
	*
	* @return battery cycle count
	*/
	scePowerGetBatteryCycleCount :: proc() -> c.int ---

	/**
	* Returns CPU clock frequency
	*
	* @return CPU clock frequency in Mhz
	*/
	scePowerGetArmClockFrequency :: proc() -> c.int ---

	/**
	* Returns BUS clock frequency
	*
	* @return BUS clock frequency in Mhz
	*/
	scePowerGetBusClockFrequency :: proc() -> c.int ---

	/**
	* Returns GPU clock frequency
	*
	* @return GPU clock frequency in Mhz
	*/
	scePowerGetGpuClockFrequency :: proc() -> c.int ---

	/**
	* Returns GPU crossbar clock frequency
	*
	* @return GPU crossbar clock frequency in Mhz
	*/
	scePowerGetGpuXbarClockFrequency :: proc() -> c.int ---

	/**
	* Requests PS Vita to do a cold reset
	*
	* @return always 0
	*/
	scePowerRequestColdReset :: proc() -> c.int ---

	/**
	* Requests PS Vita to go into standby
	*
	* @return always 0
	*/
	scePowerRequestStandby :: proc() -> c.int ---

	/**
	* Requests PS Vita to suspend
	*
	* @return always 0
	*/
	scePowerRequestSuspend :: proc() -> c.int ---

	/**
	* Request display on
	*
	* @return always 0
	*/
	scePowerRequestDisplayOn :: proc() -> c.int ---

	/**
	* Request display off
	*
	* @return always 0
	*/
	scePowerRequestDisplayOff :: proc() -> c.int ---

	/**
	* Sets CPU clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	scePowerSetArmClockFrequency :: proc(freq: c.int) -> c.int ---

	/**
	* Sets BUS clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	scePowerSetBusClockFrequency :: proc(freq: c.int) -> c.int ---

	/**
	* Sets GPU clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	scePowerSetGpuClockFrequency :: proc(freq: c.int) -> c.int ---

	/**
	* Sets GPU crossbar clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	scePowerSetGpuXbarClockFrequency :: proc(freq: c.int) -> c.int ---

	/**
	* Sets wireless features usage
	*
	* @param enabled - SCE_TRUE to enable, SCE_FALSE to disable
	*
	* @return 0 on success, < 0 on error
	*/
	scePowerSetUsingWireless :: proc(enabled: SceBool) -> c.int ---

	/**
	* Gets wireless features usage
	*
	* @return SCE_TRUE if enabled, SCE_FALSE otherwise
	*/
	scePowerGetUsingWireless :: proc() -> c.int ---
}

foreign powerkern {
	/**
	* Registers a ScePower Callback
	*
	* @param cbid - The UID of the specified callback
	*
	* @return 0 on success, < 0 on error
	*/
	kscePowerRegisterCallback :: proc(cbid: SceUID) -> c.int ---

	/**
	* Unregister a callback
	*
	* @param cbid - The UID of the specified callback
	*
	* @return 0 on success, < 0 on error
	*/
	kscePowerUnregisterCallback :: proc(cbid: SceUID) -> c.int ---

	/**
	* Returns battery charging status
	*
	* @return SCE_TRUE if under charge, SCE_FALSE otherwise
	*/
	kscePowerIsBatteryCharging :: proc() -> SceBool ---

	/**
	* Returns battery life percentage
	*
	* @return Battery life percentage
	*/
	kscePowerGetBatteryLifePercent :: proc() -> c.int ---

	/**
	* Check if a suspend is required
	*
	* @return SCE_TRUE if suspend is required, SCE_FALSE otherwise
	*/
	kscePowerIsSuspendRequired :: proc() -> SceBool ---

	/**
	* Check if AC is plugged in
	*
	* @return SCE_TRUE if plugged in, SCE_FALSE otherwise
	*/
	kscePowerIsPowerOnline :: proc() -> SceBool ---

	/**
	* Returns battery life time
	*
	* @return Battery life time in minutes
	*/
	kscePowerGetBatteryLifeTime :: proc() -> c.int ---

	/**
	* Returns battery remaining capacity
	*
	* @return battery remaining capacity in mAh (milliampere hour)
	*/
	kscePowerGetBatteryRemainCapacity :: proc() -> c.int ---

	/**
	* Returns battery state
	*
	* @return SCE_TRUE if battery is low, SCE_FALSE otherwise
	*/
	kscePowerIsLowBattery :: proc() -> SceBool ---

	/**
	* Returns battery full capacity
	*
	* @return battery full capacity in mAh (milliampere hour)
	*/
	kscePowerGetBatteryFullCapacity :: proc() -> c.int ---

	/**
	* Returns battery temperature
	*
	* @return temperature in degrees celcius * 100
	*/
	kscePowerGetBatteryTemp :: proc() -> c.int ---

	/**
	* Returns battery voltage
	*
	* @return battery voltage in mV (millivolts)
	*/
	kscePowerGetBatteryVolt :: proc() -> c.int ---

	/**
	* Returns battery state of health
	*
	* @return battery state of health percent
	*/
	kscePowerGetBatterySOH :: proc() -> c.int ---

	/**
	* Returns battery cycle count
	*
	* @return battery cycle count
	*/
	kscePowerGetBatteryCycleCount :: proc() -> c.int ---

	/**
	* Returns CPU clock frequency
	*
	* @return CPU clock frequency in Mhz
	*/
	kscePowerGetArmClockFrequency :: proc() -> c.int ---

	/**
	* Returns BUS clock frequency
	*
	* @return BUS clock frequency in Mhz
	*/
	kscePowerGetBusClockFrequency :: proc() -> c.int ---

	/**
	* Returns Sys clock frequency
	*
	* @return Sys clock frequency in Mhz
	*/
	kscePowerGetSysClockFrequency :: proc() -> c.int ---

	/**
	* Returns GPU crossbar clock frequency
	*
	* @return GPU crossbar clock frequency in Mhz
	*/
	kscePowerGetGpuXbarClockFrequency :: proc() -> c.int ---

	/**
	* Requests PS Vita to do a soft reset
	*
	* @return always 0
	*/
	kscePowerRequestSoftReset :: proc() -> c.int ---

	/**
	* Requests PS Vita to do a cold reset
	*
	* @return always 0
	*/
	kscePowerRequestColdReset :: proc() -> c.int ---

	/**
	* Requests PS Vita to go into standby
	*
	* @return always 0
	*/
	kscePowerRequestStandby :: proc() -> c.int ---

	/**
	* Requests PS Vita to suspend
	*
	* @return always 0
	*/
	kscePowerRequestSuspend :: proc() -> c.int ---

	/**
	* Request display off
	*
	* @return always 0
	*/
	kscePowerRequestDisplayOff :: proc() -> c.int ---

	/**
	* Set the screen brightness.
	* @see ::sceAVConfigSetDisplayBrightness for userland counterpart.
	*
	* @param brightness Brightness that the screen will be set to (range 21-65536, 0 turns off the screen).
	*
	* @return ?
	*/
	kscePowerSetDisplayBrightness :: proc(brightness: c.int) -> c.int ---

	/**
	* Sets CPU clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	kscePowerSetArmClockFrequency :: proc(freq: c.int) -> c.int ---

	/**
	* Sets BUS clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	kscePowerSetBusClockFrequency :: proc(freq: c.int) -> c.int ---

	/**
	* Sets GPU clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	kscePowerSetGpuClockFrequency :: proc(freq: c.int) -> c.int ---

	/**
	* Sets GPU crossbar clock frequency
	*
	* @param freq - Frequency to set in Mhz
	*
	* @return 0 on success, < 0 on error
	*/
	kscePowerSetGpuXbarClockFrequency :: proc(freq: c.int) -> c.int ---
}

