#+build vita
package vita

import "core:c"

foreign import hid "system:SceHid_stub"

SCE_HID_MAX_REPORT :: 16
SCE_HID_MAX_DEVICE_COUNT ::  8

SceHidKeyboardReport :: struct {
  reserved: SceUInt8,
	modifiers: [2]SceUInt8, //modifiers[0] Standard modifiers Ctrl Shift Alt, modifiers[1] Caps Lock, ..?
	keycodes: [6]SceUInt8,
	reserved2: [7]SceUInt8,
	timestamp: SceUInt64, // microseconds
}
#assert(size_of(SceHidKeyboardReport) == 0x18)

SceHidMouseReport :: struct {
  buttons: SceUInt8,
	reserved: SceUInt8,
	rel_x: SceInt16,
	rel_y: SceInt16,
	wheel: SceInt8,
	tilt: SceInt8,
	timestamp: SceUInt64, // microseconds
}
#assert(size_of(SceHidMouseReport) == 0x10)

foreign hid {
	/**
	* Enumerate hid keyboards.
	*
	* @param[out]	handle	Buffer to receive keyboard hid handles.
	* @param[int]	count   Number of keyboards to enumerate
	*/
	sceHidKeyboardEnumerate :: proc(handle: [^]c.int, count: c.int) -> c.int ---

	/**
	* Get hid keyboard reports (blocking).
	*
	* @param[in]	handle		Hid handle.
	* @param[in]	reports		Buffer to receive reports.
	* @param[in]	nReports	Number of reports to receive.
	*/
	sceHidKeyboardRead :: proc(handle: SceUInt32, reports: []^SceHidKeyboardReport, nReports: c.int) -> c.int ---

	/**
	* Get hid keyboard reports (non-blocking).
	*
	* @param[in]	handle		Hid handle.
	* @param[in]	reports		Buffer to receive reports.
	* @param[in]	nReports	Number of reports to receive.
	*/
	sceHidKeyboardPeek :: proc(handle: SceUInt32, reports: [^]SceHidKeyboardReport, nReports: c.int) -> c.int ---

	/**
	* Enumerate hid mice.
	*
	* @param[out]	handle	Buffer to receive mouse hid handles.
	* @param[int]	count   Number of mice to enumerate
	*/
	sceHidMouseEnumerate :: proc(handle: [^]c.int, count: c.int) -> c.int ---


	/**
	* Get hid mouse reports.
	*
	* @param[in]	handle		Hid handle.
	* @param[in]	reports		Buffer to receive reports.
	* @param[in]	nReports	Number of reports to receive.
	*/
	sceHidMouseRead :: proc(handle: SceUInt32, reports: []^SceHidMouseReport, nReports: c.int) -> c.int ---
}

