#+build vita
package vita

import "core:c"

foreign import motiondev "system:SceMotionDev_stub"

// missing structs
SceMotionDevAccCalibData :: struct{}
SceMotionDevCalibrationData :: struct{}
SceMotionDevCalibrationHeader :: struct{}
SceMotionDevMagnCalibData :: struct{}
SceMotionDevDeviceInfo :: struct{}
SceMotionDevDeviceLocation :: struct{}
SceMotionDevGyroBiasData :: struct{}
SceMotionDevGyroCalibData :: struct{}
SceMotionDevModeInfo :: struct{}
SceMotionDevData :: struct{}

foreign motiondev {
  sceMotionDevGetAccCalibData :: proc(data: ^SceMotionDevAccCalibData) -> c.int ---
  sceMotionDevGetAccCalibData2 :: proc(port: c.int, data: ^SceMotionDevAccCalibData) -> c.int ---
  sceMotionDevGetCalibrationData :: proc(block_id: SceUInt32, data: ^SceMotionDevCalibrationData, data_num: SceUInt32) -> c.int ---
  sceMotionDevGetCalibrationHeader :: proc(block_id: SceUInt32, calib_header: ^SceMotionDevCalibrationHeader) -> c.int ---
  sceMotionDevGetCurrentMagnCalibData :: proc(data: ^SceMotionDevMagnCalibData) -> c.int ---
  sceMotionDevGetCurrentMagnStabilityLevel :: proc(level: ^SceUInt32) -> c.int ---
  sceMotionDevGetDeviceInfo :: proc(device_info: ^SceMotionDevDeviceInfo) -> c.int ---
  sceMotionDevGetDeviceLocation :: proc(location: ^SceMotionDevDeviceLocation) -> c.int ---
  sceMotionDevGetFactoryMagnCalibData :: proc(data: ^SceMotionDevMagnCalibData) -> c.int ---
  sceMotionDevGetGyroBias :: proc(bias: ^SceMotionDevGyroBiasData) -> c.int ---
  sceMotionDevGetGyroBias2 :: proc(port: c.int, bias: ^SceMotionDevGyroBiasData) -> c.int ---
  sceMotionDevGetGyroCalibData :: proc(data: ^SceMotionDevGyroCalibData) -> c.int ---
  sceMotionDevGetGyroCalibData2 :: proc(port: c.int, data: ^SceMotionDevGyroCalibData) -> c.int ---
  sceMotionDevGetMeasMode :: proc(mode_info: ^SceMotionDevModeInfo) -> c.int ---
  sceMotionDevIsReady :: proc() -> c.int ---
  sceMotionDevMagnSamplingStart :: proc() -> c.int ---
  sceMotionDevMagnSamplingStop :: proc() -> c.int ---
  sceMotionDevRead :: proc(data: ^SceMotionDevData, data_num: c.int, info: ^SceUInt32) -> c.int ---
  sceMotionDevRead2 :: proc(port: c.int, data: ^SceMotionDevData, data_num: c.int, info: ^SceUInt32) -> c.int ---
  sceMotionDevReadForMagnCalib :: proc(data: ^SceMotionDevData, data_num: c.int) -> c.int ---
  sceMotionDevSamplingStart :: proc() -> c.int ---
  sceMotionDevSamplingStart2 :: proc(port: c.int) -> c.int ---
  sceMotionDevSamplingStop :: proc() -> c.int ---
  sceMotionDevSamplingStop2 :: proc(port: c.int) -> c.int ---
  sceMotionDevSetSamplingMode :: proc(mode: SceUInt32) -> c.int ---
  sceMotionDevUpdateMagnCalibData :: proc(#by_ptr data: SceMotionDevMagnCalibData, tag: ^SceUInt32) -> c.int ---
  sceMotionDevUpdateMagnStabilityLevel :: proc(level: SceUInt32) -> c.int ---
}

