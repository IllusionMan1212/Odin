#+build vita
package vita

foreign import deci4p "system:SceDeci4pUserp_stub"

foreign deci4p {
  sceKernelDeci4pOpen :: proc(protoname: cstring, protonum: SceUInt32, bufsize: SceSize) -> SceUID ---
  sceKernelDeci4pClose :: proc(socketid: SceUID) -> SceInt32 ---
  sceKernelDeci4pDisableWatchpoint :: proc() -> SceInt32 ---
  sceKernelDeci4pEnableWatchpoint :: proc() -> SceInt32 ---
  sceKernelDeci4pIsProcessAttached :: proc() -> SceInt32 ---
  sceKernelDeci4pRead :: proc(socketid: SceUID, buffer: rawptr, size: SceSize, reserved: SceUInt32) -> SceInt32 ---
  sceKernelDeci4pRegisterCallback :: proc(socketid: SceUID, cbid: SceUID) -> SceInt32 ---
  sceKernelDeci4pWrite :: proc(socketid: SceUID, buffer: rawptr, size: SceSize, reserved: SceUInt32) -> SceInt32 ---
}

