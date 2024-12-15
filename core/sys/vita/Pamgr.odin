#+build vita
package vita

import "core:c"

foreign import pamgr "system:ScePamgr_stub"

// missing structs
SceKernelPaTraceBufferParam :: struct{}
SceKernelPaGpuSampledData :: struct{}
SceKernelPaGpuTraceParam :: struct{}
SceKernelPaCounterTraceParam :: struct{}
SceKernelPaArmTraceParam :: struct{}

foreign pamgr {
  sceKernelPaGetTraceBufferSize :: proc(type: SceUInt32) -> SceSize ---
  sceKernelPaGetIoBaseAddress :: proc() -> SceUInt32 ---
  sceKernelPaGetTimebaseFrequency :: proc() -> SceUInt32 ---
  sceKernelPaGetTraceBufferStatus :: proc() -> SceUInt32 ---
  sceKernelPaGetWritePointer :: proc() -> SceUInt32 ---
  sceKernelPaGetTimebaseValue :: proc() -> SceUInt64 ---
  _sceKernelPaAddArmTraceByKey :: proc(key: c.int, #by_ptr param: SceKernelPaArmTraceParam) -> c.int ---
  _sceKernelPaAddCounterTraceByKey :: proc(key: c.int, #by_ptr param: SceKernelPaCounterTraceParam) -> c.int ---
  _sceKernelPaAddGpuTraceByKey :: proc(key: c.int, #by_ptr param: SceKernelPaGpuTraceParam) -> c.int ---
  _sceKernelPaGetGpuSampledData :: proc(data: ^SceKernelPaGpuSampledData) -> c.int ---
  _sceKernelPaSetupTraceBufferByKey :: proc(key: c.int, #by_ptr param: SceKernelPaTraceBufferParam) -> c.int ---
  sceKernelPaInsertBookmark :: proc(fifo: SceUInt32, channel: SceUInt32, data: SceUInt32) -> c.int ---
  sceKernelPaRegister :: proc() -> c.int ---
  sceKernelPaRemoveArmTraceByKey :: proc(key: c.int) -> c.int ---
  sceKernelPaRemoveCounterTraceByKey :: proc(key: c.int) -> c.int ---
  sceKernelPaRemoveGpuTraceByKey :: proc(key: c.int) -> c.int ---
  sceKernelPaSetBookmarkChannelEnableByKey :: proc(key: c.int, fifo: SceUInt32, mask: SceUInt32) -> c.int ---
  sceKernelPaStartByKey :: proc(key: c.int) -> c.int ---
  sceKernelPaStopByKey :: proc(key: c.int) -> c.int ---
  sceKernelPaUnregister :: proc(key: c.int) -> c.int ---
  sceKernelPerfArmPmonClose :: proc() -> c.int ---
  sceKernelPerfArmPmonOpen :: proc() -> c.int ---
  sceKernelPerfArmPmonReset :: proc(threadId: SceUID) -> c.int ---
  sceKernelPerfArmPmonSelectEvent :: proc(threadId: SceUID, counter: SceUInt32, eventCode: SceUInt8) -> c.int ---
  sceKernelPerfArmPmonSetCounterValue :: proc(threadId: SceUID, counter: SceUInt32, value: SceUInt32) -> c.int ---
  sceKernelPerfArmPmonStart :: proc(threadId: SceUID) -> c.int ---
  sceKernelPerfArmPmonStop :: proc(threadId: SceUID) -> c.int ---
}

