#+build vita
package vita

import "core:c"

foreign import gps "system:SceGps_stub"

// missing structs
SceGpsDeviceInfo :: struct{}
SceGpsSatelliteData :: struct{}
SceGpsPositionData :: struct{}
SceGpsStatus :: struct{}

foreign gps {
  _sceGpsClose :: proc() -> c.int ---
  _sceGpsGetData :: proc(pos: ^SceGpsPositionData, sat: ^SceGpsSatelliteData) -> c.int ---
  _sceGpsGetDeviceInfo :: proc(dev_info: ^SceGpsDeviceInfo) -> c.int ---
  _sceGpsGetState :: proc(state: ^SceGpsStatus) -> c.int ---
  _sceGpsIoctl :: proc(ioctl_command: SceUInt32, arg: rawptr, arg_size: SceSize, a4: ^SceSize) -> c.int ---
  _sceGpsIsDevice :: proc() -> c.int ---
  _sceGpsOpen :: proc(cbid: SceUID) -> c.int ---
  _sceGpsResumeCallback :: proc() -> c.int ---
  _sceGpsSelectDevice :: proc(device_type: SceUInt32) -> c.int ---
  _sceGpsStart :: proc(mode: c.uint) -> c.int ---
  _sceGpsStop :: proc() -> c.int ---
}

