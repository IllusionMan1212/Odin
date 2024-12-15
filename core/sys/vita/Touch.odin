#+build vita
package vita

import "core:c"

foreign import touch "system:SceTouch_stub"
foreign import touchkern "system:SceTouchForDriver_stub"

SCE_TOUCH_MAX_REPORT :: 8

/** Touch error codes */
SceTouchErrorCode :: enum c.uint {
	INVALID_ARG   = 0x80350001,
	PRIV_REQUIRED = 0x80350002,
	FATAL         = 0x803500FF
}


/**
 * Port numbers of touch panels
 *
 * @see ::sceTouchRead
 * @see ::sceTouchPeek
 */
SceTouchPortType :: enum c.int {
	FRONT   = 0, //!< Front touch panel id
	BACK    = 1, //!< Back touch panel id
	MAX_NUM = 2  //!< Number of touch panels
}

/**
 * Sampling port setting of the touch panel
 *
 * @see ::sceTouchSetSamplingState
 */
SceTouchSamplingState :: enum c.int {
	STOP   = 0,
	START  = 1
}

/**
 * Info field of ::SceTouchReport structure
 *
 * @see ::SceTouchReport
 */
SceTouchReportInfo :: enum c.int {
	HIDE_UPPER_LAYER = 0x0001
}

SceTouchPanelInfo :: struct {
  minAaX: SceInt16,        //!< Min active area X position
	minAaY: SceInt16,        //!< Min active area Y position
	maxAaX: SceInt16,        //!< Max active area X position
	maxAaY: SceInt16,        //!< Max active area Y position
	minDispX: SceInt16,      //!< Min display X origin (top left)
	minDispY: SceInt16,      //!< Min display Y origin (top left)
	maxDispX: SceInt16,      //!< Max display X origin (bottom right)
	maxDispY: SceInt16,      //!< Max display Y origin (bottom right)
	minForce: SceUInt8,      //!< Min touch force value
	maxForce: SceUInt8,      //!< Max touch force value
	reserved: [30]SceUInt8,  //!< Reserved
}
#assert(size_of(SceTouchPanelInfo) == 0x30)

SceTouchReport :: struct {
  id: SceUInt8,          //!< Touch ID
	force: SceUInt8,       //!< Touch force
	x: SceInt16,           //!< X position
	y: SceInt16,           //!< Y position
	reserved: [8]SceUInt8, //!< Reserved
	info: SceUInt16,        //!< Information of this touch
}
#assert(size_of(SceTouchReport) == 0x10)

SceTouchData :: struct {
  timeStamp: SceUInt64,                    //!< Data timestamp
	status: SceUInt32,                       //!< Unused
	reportNum: SceUInt32,                    //!< Number of touch reports
	report: [SCE_TOUCH_MAX_REPORT]SceTouchReport, //!< Touch reports
}
#assert(size_of(SceTouchData) == 0x90)

foreign touch {
  /**
  * Get Touch Panel information
  *
  * @param[in]	port		Port number.
  * @param[out]	pPanelInfo	The buffer to get the Touch Panel information.
  */
  sceTouchGetPanelInfo :: proc(port: SceUInt32, pPanelInfo: ^SceTouchPanelInfo) -> c.int ---

  /**
  * Get touch data (Blocking)
  *
  * @param[in]	port	Port Number.
  * @param[out]	pData	Buffer to receive touch data.
  * @param[in]	nBufs	Number of buffers to receive touch data.
  *
  * @return Buffers count, between 1 and 'nBufs'. <0 on error.
  */
  sceTouchRead :: proc(port: SceUInt32, pData: ^SceTouchData, nBufs: SceUInt32) -> c.int ---

  /**
  * Get touch data (Polling)
  *
  * @param[in]	port	port number.
  * @param[out]	pData	Buffer to receive touch data.
  * @param[in]	nBufs	Number of buffers to receive touch data.
  *
  * @return Buffers count, between 1 and 'nBufs'. <0 on error.
  */
  sceTouchPeek :: proc(port: SceUInt32, pData: ^SceTouchData, nBufs: SceUInt32) -> c.int ---

  /**
  * Set sampling state of touch panel.
  *
  * @param[in]	port	Port number.
  * @param[in]	state	Sampling state.
  */
  sceTouchSetSamplingState :: proc(port: SceUInt32, state: SceTouchSamplingState) -> c.int ---

  /**
  * Get sampling state of touch panel.
  *
  * @param[in]	port	Port number.
  * @param[out]	pState	The buffer to receive sampling state.
  */
  sceTouchGetSamplingState :: proc(port: SceUInt32, pState: ^SceTouchSamplingState) -> c.int ---

  /**
  * Enable touch force output.
  *
  * @param[in]	port	Port number.
  */
  sceTouchEnableTouchForce :: proc(port: SceUInt32) -> c.int ---

  /**
  * Disable touch force output.
  *
  * @param[in]	port	Port number.
  */
  sceTouchDisableTouchForce :: proc(port: SceUInt32) -> c.int ---
}

foreign touchkern {
  /**
  * Set touch enable flag
  *
  * @param[in] port   - The port number.
  * @param[in] enable - The enable flag.
  *
  * @return 0 on success. < 0 on error.
  */
  ksceTouchSetEnableFlag :: proc(port: SceUInt32, enable: SceBool) -> c.int ---
}

