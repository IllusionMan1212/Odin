#+build vita
package vita

import "core:c"

foreign import motion "system:SceMotion_stub"

SceMotionMagFieldStability :: enum c.int {
	UNSTABLE    = 0,
	UNUSED      = 1,
	STABLE      = 2
}

SceMotionErrorCode :: enum c.uint {
	DATA_INVALID       = 0x80360200,
	READING            = 0x80360201,
	NON_INIT_ERR       = 0x80360202,
	STATE_INVALID      = 0x80360203,
	CALIB_READ_FAIL    = 0x80360204,
	OUT_OF_BOUNDS      = 0x80360205,
	NOT_SAMPLING       = 0x80360206,
	ALREADY_SAMPLING   = 0x80360207,
	MEM_IN_USE         = 0x80360208
}


/* struct */

/** Returned motion state */
SceMotionState :: struct {
  timestamp: c.uint,         //!< Local timestamp of the device
	acceleration: SceFVector3,       //!< Accelerometer data
	angularVelocity: SceFVector3,    //!< Angular velocity data
	reserved1: [12]c.uint8_t,          //!< Reserved data
	deviceQuat: SceFQuaternion,      //!< Orientation data as a Quaternion
	rotationMatrix: SceFMatrix4,     //!< Orientation data as a rotation matrix
	nedMatrix: SceFMatrix4,          //!< Magnetometer orientation matrix
	reserved2: [4]c.uint8_t,           //!< Reserved data
	basicOrientation: SceFVector3,   //!< Orientation of the device in reference to gravity
	hostTimestamp: SceULong64,       //!< Timestamp of the data in microseconds
	reserved3: [36]c.uint8_t,          //!< Reserved data
	magFieldStability: c.uint8_t,      //!< One of ::SceMotionMagFieldStability
	unknown: c.uint8_t,                //!< Unknown
	reserved4: [2]c.uint8_t,           //!< Reserved data
}
#assert(size_of(SceMotionState) == 0xF8)

/** Returned motion sensor state 
* @note - ::SceMotionSensorState holds actual sensor data as opposed to ::SceMotionState which uses a calculated state
*/
SceMotionSensorState :: struct {
  accelerometer: SceFVector3,      //!< Accelerometer data
	gyro: SceFVector3,               //!< Angular velocity data
	reserved1: [12]c.uint8_t,          //!< Reserved data
	timestamp: c.uint,         //!< Timestamp of the data in microseconds
	counter: c.uint,           //!< Number of requested state
	reserved2: [4]c.uint8_t,           //!< Reserved data
	hostTimestamp: SceULong64,       //!< Timestamp of the data in microseconds
	unknown: c.uint8_t,                //!< Unknown
	reserved3: [7]c.uint8_t,           //!< Reserved data
}
#assert(size_of(SceMotionSensorState) == 0x40)

/** Returned location of both the accelerometer and gyroscope in mm
* @note - Axies are fixed with z axis being straight perpendicular through the screen and x axis being parallel to the screen's bottom and top edge
* @note - Direction of the z axis is as if the device were laying on a flat surface, oled/lcd side facing upwards
* @note - OLED models should return the following values:
* @note - Accelerometer: x == -32; y == 12; z == -8
* @note - Gyroscope: x == -33; y == 6; z == -8
* @note - LCD models should return the following values:
* @note - Accelerometer: x == 13; y == 19; z == -8
* @note - Gyroscope: x == 13; y == 19; z == -8
*/
SceMotionDeviceLocation :: struct {
  accelerometer: SceFVector3,      //!< Location of te accelerometer in relation to the center of the device (in mm)
	gyro: SceFVector3,               //!< Location of te gyroscope in relation to the center of the device (in mm)
	reserved: [24]c.uint8_t,           //!< Reserved data
}
#assert(size_of(SceMotionDeviceLocation) == 0x30)


foreign motion {
	/**
	* Gets the current motion state.
	*
	* @param[out] *motionState - See ::SceMotionState
	*
	* @return 0, <0 on error.
	*/
	sceMotionGetState :: proc(motionState: ^SceMotionState) -> c.int ---

	/**
	* Gets the current motion sensor state
	*
	* @param[in] numRecords - Amount of records to get
	* @param[out] *motionSensorState - See ::SceMotionSensorState
	*
	* @return 0, <0 on error
	*/
	sceMotionGetSensorState :: proc(sensorState: ^SceMotionSensorState, numRecords: c.int) -> c.int ---

	/**
	* Gets the location of the device's sensors in relation to its center point (in mm).
	*
	* @param[out] *deviceLocation - See ::SceMotionDeviceLocation
	*
	* @return 0, <0 on error
	*/
	sceMotionGetDeviceLocation :: proc(deviceLocation: ^SceMotionDeviceLocation) -> c.int ---

	/**
	* Gets the basic orientation of the device in relation to gravity
	* @note - Possible values in the output vector are -1, 0 and 1
	* @note - Using the same coordinate system as ::SceMotionDeviceLocation  these values are set in the vector depending on if the axies' positive or negative directions are facing away from gravitational pull
	* @note - For example if the vita is laying on a flat and level surface, with the OLED/LCD side facing upwards, the Z part of the vector will be 1
	* @note - Now flipping the device upwards, taking hold of the right joystick's side, until it forms a 90 degree angle to the surface will result in the X part of the vector being 1 instead
	* @note - Both examples would result in the returned value being -1 if flipped 180 degrees, swapping their top and bottom sides in correlation to gravity
	* @note - The angle of rotation in relation to being in a centered state on an axis (returned as 0) after which the device will change the value is determined by ::SceMotionSetAngleThreshold
	* @note - In order for this function to return up to date data, ::GetState must be called prior to call this function.
	* @param[out] *basicOrientation
	*
	* @return 0, <0 on error
	*/
	sceMotionGetBasicOrientation :: proc(basicOrientation: ^SceFVector3) -> c.int ---

	/**
	* Rotate the yaw axis
	*
	* @param[in] radians - Rotation angle in radians
	*
	* @return 0
	*/
	sceMotionRotateYaw :: proc(radians: c.float) -> c.int ---

	/**
	* Get Status of tilt correction
	* @note - With tilt correction enabled the data for roll and pitch movements of the device get recalculated to not distort the yaw movements in relation to gravity
	* @note - Enabled by default
	* @return 1 if enabled, 0 if disabled
	*/
	sceMotionGetTiltCorrection :: proc() -> c.int ---

	/**
	* Activate/deactivate tilt correction
	* @note - For more information see ::GetTiltCorrection
	* @param[in] setValue - 1 to enable, 0 to disable
	*
	* @return 0
	*/
	sceMotionSetTiltCorrection :: proc(setValue: c.int) -> c.int ---

	/**
	* Get status of deadbanding
	* @note - With deadbanding enabled the device will filter out small movements to reduce jitter
	* @note - Potentially decreaces accuracy of fine movements
	* @note - Enabled by default
	* @return 1 if enabled, 0 if disabled
	*/
	sceMotionGetDeadband :: proc() -> c.int ---

	/**
	* Activate/deactivate deadbanding
	* @note - For more information see ::GetDeadbanding
	* @param[in] setValue - 1 to enable, 0 to disable
	*
	* @return 0
	*/
	sceMotionSetDeadband :: proc(setValue: c.int) -> c.int ---

	/**
	* Get status of gyroscope bias correction
	* @note - With gyroscope bias correction enabled the device will attempt to adjust for outside influences that could impact calibration
	* @note - Enabled by default
	* @return 1 if enabled, 0 if disabled
	*/
	sceMotionGetGyroBiasCorrection :: proc() -> c.int ---

	/**
	* Activate/deactivate gyroscope bias correction
	* @note - For more information see ::GetGyroBiasCorrection
	* @param[in] setValue - 1 to enable, 0 to disable
	*
	* @return 0
	*/
	sceMotionSetGyroBiasCorrection :: proc(setValue: c.int) -> c.int ---

	/**
	* Define the angle threshold for basic orientation
	*
	* @param[in] angle - range of 0 to 45 degrees
	*
	* @return 0
	*/
	sceMotionSetAngleThreshold :: proc(angle: c.float) -> c.int ---

	/**
	* Get the angle threshold for basic orientation
	*
	* @return angle in degrees
	*/
	sceMotionGetAngleThreshold :: proc() -> c.float ---

	/**
	* Set current orientation as origin
	*
	* @return 0, <0 on error
	*/
	sceMotionReset :: proc() -> c.int ---

	/**
	* Start magnetometer sampling
	*
	* @return 0, <0 on error
	*/
	sceMotionMagnetometerOn :: proc() -> c.int ---

	/**
	* Stop magnetometer sampling
	*
	* @return 0, <0 on error
	*/
	sceMotionMagnetometerOff :: proc() -> c.int ---

	/**
	* Get status of magnetometer sampling
	*
	* @return 1 if enabled, 0 if disabled
	*/
	sceMotionGetMagnetometerState :: proc() -> c.int ---

	/**
	* Start sampling
	*
	* @return 0, <0 on error
	*/
	sceMotionStartSampling :: proc() -> c.int ---

	/**
	* Stop sampling
	*
	* @return 0, <0 on error
	*/
	sceMotionStopSampling :: proc() -> c.int ---
}

