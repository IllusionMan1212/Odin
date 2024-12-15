#+build vita
package vita

import "core:c"

foreign import rtc "system:SceRtc_stub"

/* Aliases */
sceRtcGetCurrentTickUtc :: sceRtcGetCurrentTick
sceRtcGetCurrentClockUtc :: proc(_p: ^SceDateTime) -> c.int {
  return sceRtcGetCurrentClock(_p,0)
}                           
sceRtcGetCurrentNetworkTickUtc :: sceRtcGetCurrentNetworkTick
sceRtcConvertTime_tToDateTime :: sceRtcSetTime_t
sceRtcConvertTime64_tToDateTime :: sceRtcSetTime64_t
sceRtcConvertDateTimeToTime_t :: sceRtcGetTime_t
sceRtcConvertDateTimeToTime64_t :: sceRtcGetTime64_t
sceRtcConvertDosTimeToDateTime :: sceRtcSetDosTime
sceRtcConvertDateTimeToDosTime :: sceRtcGetDosTime
sceRtcConvertWin32TimeToDateTime :: sceRtcSetWin32FileTime
sceRtcConvertDateTimeToWin32Time :: sceRtcGetWin32FileTime
sceRtcConvertTickToDateTime :: sceRtcSetTick
sceRtcConvertDateTimeToTick :: sceRtcGetTick

/* Inline SceDateTime Getters */

/**
* Get current year.
*
* @param[in] time - see ::SceDateTime.
*
* @return Current year.
*/
sceRtcGetYear :: #force_inline proc "c" (#by_ptr time: SceDateTime) -> c.int {
  return auto_cast time.year
}

/**
* Get current month.
*
* @param[in] time - see ::SceDateTime.
*
* @return Current month.
*/
sceRtcGetMonth :: #force_inline proc "c" (#by_ptr time: SceDateTime) -> c.int {
  return auto_cast time.month
}

/**
* Get current day.
*
* @param[in] time - see ::SceDateTime.
*
* @return Current day.
*/
sceRtcGetDay :: #force_inline proc "c" (#by_ptr time: SceDateTime) -> c.int {
  return auto_cast time.day
}

/**
* Get current hour.
*
* @param[in] time - see ::SceDateTime.
*
* @return Current hour.
*/
sceRtcGetHour :: #force_inline proc "c" (#by_ptr time: SceDateTime) -> c.int {
  return auto_cast time.hour
}

/**
* Get current minute.
*
* @param[in] time - see ::SceDateTime.
*
* @return Current minute.
*/
sceRtcGetMinute :: #force_inline proc "c" (#by_ptr time: SceDateTime) -> c.int {
  return auto_cast time.minute
}

/**
* Get current second.
*
* @param[in] time - see ::SceDateTime.
*
* @return Current second.
*/
sceRtcGetSecond :: #force_inline proc "c" (#by_ptr time: SceDateTime) -> c.int {
  return auto_cast time.second
}

/**
* Get current microsecond.
*
* @param[in] time - see ::SceDateTime.
*
* @return Current microsecond.
*/
sceRtcGetMicrosecond :: #force_inline proc "c" (#by_ptr time: SceDateTime) -> c.int {
  return cast(c.int)time.microsecond
}

/* Inline SceDateTime Setters */

sceRtcSetYear :: #force_inline proc "c" (time: ^SceDateTime, year: c.int) -> c.uint {
  if (year<1 || year>9999) {
    return auto_cast SceRtcErrorCode.INVALID_YEAR
  }
  time.year = cast(c.ushort)year
  return 0
}

sceRtcSetMonth :: #force_inline proc "c" (time: ^SceDateTime, month: c.int) -> c.uint {
  if (month<1 || month>12) {
    return auto_cast SceRtcErrorCode.INVALID_MONTH
  }
  time.month = cast(c.ushort)month
  return 0
}

sceRtcSetDay :: #force_inline proc "c" (time: ^SceDateTime, day: c.int) -> c.uint {
  if (day<1 || day>31) {
    return auto_cast SceRtcErrorCode.INVALID_DAY
  }
  time.day = cast(c.ushort)day
  return 0
}

sceRtcSetHour :: #force_inline proc "c" (time: ^SceDateTime, hour: c.int) -> c.uint {
  if (hour<0 || hour>23) {
    return auto_cast SceRtcErrorCode.INVALID_HOUR
  }
  time.hour = cast(c.ushort)hour
  return 0
}

sceRtcSetMinute :: #force_inline proc "c" (time: ^SceDateTime, minute: c.int) -> c.uint {
  if (minute<0 || minute>59) {
    return auto_cast SceRtcErrorCode.INVALID_MINUTE
  }
  time.minute = cast(c.ushort)minute
  return 0
}

sceRtcSetSecond :: #force_inline proc "c" (time: ^SceDateTime, second: c.int) -> c.uint {
  if (second<0 || second>59) {
    return auto_cast SceRtcErrorCode.INVALID_SECOND
  }
  time.second = cast(c.ushort)second
  return 0
}

sceRtcSetMicrosecond :: #force_inline proc "c" (time: ^SceDateTime, microsecond: c.int) -> c.uint {
  if (microsecond<0 || microsecond>999999) {
    return auto_cast SceRtcErrorCode.INVALID_MICROSECOND
  }
  time.microsecond = cast(c.uint)microsecond
  return 0
}

foreign rtc {
  sceRtcGetTickResolution :: proc() -> c.uint ---

  sceRtcGetCurrentTick :: proc(tick: ^SceRtcTick) -> c.int ---

  /**
  * Get current real time clock time.
  *
  * @param[out] time - see ::SceDateTime.
  * @param[in] time_zone - The time zone the return value will be.
  *
  * @return 0 on success, < 0 on error.
  */
  sceRtcGetCurrentClock :: proc(time: ^SceDateTime, time_zone: c.int) -> c.int ---

  /**
  * Get current real time clock time with system time zone.
  *
  * @param[out] time - see ::SceDateTime.
  *
  * @return 0 on success, < 0 on error.
  */
  sceRtcGetCurrentClockLocalTime :: proc(time: SceDateTime) -> c.int ---

  sceRtcGetCurrentNetworkTick :: proc(tick: ^SceRtcTick) -> c.int ---
  sceRtcConvertUtcToLocalTime :: proc(#by_ptr utc: SceRtcTick, local_time: ^SceRtcTick) -> c.int ---
  sceRtcConvertLocalTimeToUtc :: proc(#by_ptr local_time: SceRtcTick, utc: ^SceRtcTick) -> c.int ---
  sceRtcIsLeapYear :: proc(year: c.int) -> c.int ---
  sceRtcCheckValid :: proc(#by_ptr time: SceDateTime) -> c.int ---
  sceRtcGetDaysInMonth :: proc(year: c.int, month: c.int) -> c.int ---
  sceRtcGetDayOfWeek :: proc(year: c.int, month: c.int, day: c.int) -> c.int ---

  /* Win/POSIX compliant function */
  sceRtcSetTime_t :: proc(time: ^SceDateTime, iTime: c.long) -> c.int ---
  sceRtcSetTime64_t :: proc(time: ^SceDateTime, ullTime: SceUInt64) -> c.int ---
  sceRtcGetTime_t :: proc(#by_ptr time: SceDateTime, piTime: ^c.long) -> c.int ---
  sceRtcGetTime64_t :: proc(#by_ptr time: SceDateTime, pullTime: ^SceUInt64) -> c.int ---
  sceRtcSetDosTime :: proc(time: ^SceDateTime, uiDosTime: c.uint) -> c.int ---
  sceRtcGetDosTime :: proc(#by_ptr time: SceDateTime, puiDosTime: ^c.uint) -> c.int ---
  sceRtcSetWin32FileTime :: proc(time: ^SceDateTime, ulWin32Time: SceUInt64) -> c.int ---
  sceRtcGetWin32FileTime :: proc(#by_ptr time: SceDateTime, ulWin32Time: ^SceUInt64) -> c.int ---
  sceRtcSetTick :: proc(time: ^SceDateTime, #by_ptr tick: SceRtcTick) -> c.int ---
  sceRtcGetTick :: proc(#by_ptr time: SceDateTime, tick: ^SceRtcTick) -> c.int ---

  /* Arithmetic function */
  sceRtcCompareTick :: proc(#by_ptr pTick1: SceRtcTick, #by_ptr pTick2: SceRtcTick) -> c.int ---
  sceRtcTickAddTicks :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: SceLong64) -> c.int ---
  sceRtcTickAddMicroseconds :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: SceLong64) -> c.int ---
  sceRtcTickAddSeconds :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: SceLong64) -> c.int ---
  sceRtcTickAddMinutes :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: SceLong64) -> c.int ---
  sceRtcTickAddHours :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: c.int) -> c.int ---
  sceRtcTickAddDays :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: c.int) -> c.int ---
  sceRtcTickAddWeeks :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: c.int) -> c.int ---
  sceRtcTickAddMonths :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: c.int) -> c.int ---
  sceRtcTickAddYears :: proc(pTick0: ^SceRtcTick, #by_ptr pTick1: SceRtcTick, lAdd: c.int) -> c.int ---

  /* Formating function */
  sceRtcFormatRFC2822 :: proc(pszDateTime: [^]c.char, #by_ptr utc: SceRtcTick, iTimeZoneMinutes: c.int) -> c.int ---
  sceRtcFormatRFC2822LocalTime :: proc(pszDateTime: [^]c.char, #by_ptr utc: SceRtcTick) -> c.int ---
  sceRtcFormatRFC3339 :: proc(pszDateTime: [^]c.char, #by_ptr utc: SceRtcTick, iTimeZoneMinutes: c.int) -> c.int ---
  sceRtcFormatRFC3339LocalTime :: proc(pszDateTime: [^]c.char, #by_ptr utc: SceRtcTick) -> c.int ---
  sceRtcParseDateTime :: proc(utc: ^SceRtcTick, pszDateTime: cstring) -> c.int ---
  sceRtcParseRFC3339 :: proc(utc: ^SceRtcTick, pszDateTime: cstring) -> c.int ---



  /**
  * Convert localtime to UTC
  *
  * @param[in]  localtime - The localtime buffer pointer
  * @param[out] utc       - The UTC buffer pointer
  *
  * @return 0 on success, < 0 on error.
  */
  _sceRtcConvertLocalTimeToUtc :: proc(#by_ptr localtime: SceRtcTick, utc: ^SceRtcTick) -> c.int ---

  /**
  * Convert UTC to localtime
  *
  * @param[in]  utc       - The UTC buffer pointer
  * @param[out] localtime - The localtime buffer pointer
  *
  * @return 0 on success, < 0 on error.
  */
  _sceRtcConvertUtcToLocalTime :: proc(#by_ptr utc: SceRtcTick, localtime: ^SceRtcTick) -> c.int ---

  /**
  * Convert RFC2822 time string from UTC
  *
  * @param[out] datetime - The datetime string buffer
  * @param[in]  utc      - The UTC time tick pointer
  * @param[in]  offset   - A timezone offset. this value have to minute value
  * @param[in]  a4       - The Syscall validity buffer
  *
  * @return 0 on success, < 0 on error.
  */
  _sceRtcFormatRFC2822 :: proc(datetime: [^]c.char, #by_ptr utc: SceRtcTick, offset: c.int, a4: ^SceUInt64) -> c.int ---

  /**
  * Convert RFC2822 time string from UTC with localtime
  *
  * @param[out] datetime - The datetime string buffer
  * @param[in]  utc      - The UTC time tick pointer
  * @param[in]  a3       - The Syscall validity buffer
  *
  * @return 0 on success, < 0 on error.
  */
  _sceRtcFormatRFC2822LocalTime :: proc(datetime: [^]c.char, #by_ptr utc: SceRtcTick, a3: ^SceUInt64) -> c.int ---

  /**
  * Convert RFC3339 time string from UTC
  *
  * @param[out] datetime - The datetime string buffer
  * @param[in]  utc      - The UTC time tick pointer
  * @param[in]  offset   - A timezone offset. this value have to minute value
  * @param[in]  a4       - The Syscall validity buffer
  *
  * @return 0 on success, < 0 on error.
  */
  _sceRtcFormatRFC3339 :: proc(datetime: [^]c.char, #by_ptr utc: SceRtcTick, offset: c.int, a4: ^SceUInt64) -> c.int ---

  /**
  * Convert RFC3339 time string from UTC with localtime
  *
  * @param[out] datetime - The datetime string buffer
  * @param[in]  utc      - The UTC time tick pointer
  * @param[in]  a3       - The Syscall validity buffer
  *
  * @return 0 on success, < 0 on error.
  */
  _sceRtcFormatRFC3339LocalTime :: proc(datetime: [^]c.char, #by_ptr utc: SceRtcTick, a3: ^SceUInt64) -> c.int ---

  sceRtcGetCurrentAdNetworkTick :: proc(tick: ^SceRtcTick) -> c.int ---
  sceRtcGetCurrentDebugNetworkTick :: proc(tick: ^SceRtcTick) -> c.int ---
  sceRtcGetCurrentGpsTick :: proc(tick: ^SceRtcTick) -> c.int ---
  sceRtcGetCurrentRetainedNetworkTick :: proc(tick: ^SceRtcTick) -> c.int ---
  sceRtcGetLastAdjustedTick :: proc(tick: ^SceRtcTick) -> c.int ---
  sceRtcGetLastReincarnatedTick :: proc(tick: ^SceRtcTick) -> c.int ---
  sceRtcGetAccumulativeTime :: proc() -> SceULong64 ---
}

