#+build vita
package vita

import "core:c"

foreign import perf "system:ScePerf_stub"

SCE_PERF_ARM_PMON_THREAD_ID_SELF :: (SCE_KERNEL_THREAD_ID_SELF)

_ScePerfArmPmonEventCode :: enum c.int {
	SOFT_INCREMENT         = 0x00,
	ICACHE_MISS            = 0x01,
	ITLB_MISS              = 0x02,
	DCACHE_MISS            = 0x03,
	DCACHE_ACCESS          = 0x04,
	DTLB_MISS              = 0x05,
	DATA_READ              = 0x06,
	DATA_WRITE             = 0x07,
	EXCEPTION_TAKEN        = 0x09,
	EXCEPTION_RETURN       = 0x0A,
	WRITE_CONTEXTID        = 0x0B,
	SOFT_CHANGEPC          = 0x0C,
	IMMEDIATE_BRANCH       = 0x0D,
	UNALIGNED              = 0x0F,
	BRANCH_MISPREDICT      = 0x10,
	CYCLE_COUNT            = 0x11,
	PREDICT_BRANCH         = 0x12,
	COHERENT_LF_MISS       = 0x50,
	COHERENT_LF_HIT        = 0x51,
	ICACHE_STALL           = 0x60,
	DCACHE_STALL           = 0x61,
	MAINTLB_STALL          = 0x62,
	STREX_PASSED           = 0x63,
	STREX_FAILED           = 0x64,
	DATA_EVICTION          = 0x65,
	ISSUE_NO_DISPATCH      = 0x66,
	ISSUE_EMPTY            = 0x67,
	INST_RENAME            = 0x68,
	PREDICT_FUNC_RET       = 0x6E,
	MAIN_PIPE              = 0x70,
	SECOND_PIPE            = 0x71,
	LS_PIPE                = 0x72,
	FPU_RENAME             = 0x73,
	NEON_RENAME            = 0x74,
	PLD_STALL              = 0x80,
	WRITE_STALL            = 0x81,
	INST_MAINTLB_STALL     = 0x82,
	DATA_MAINTLB_STALL     = 0x83,
	INST_UTLB_STALL        = 0x84,
	DATA_UTLB_STALL        = 0x85,
	DMB_STALL              = 0x86,
	INTEGER_CLOCK          = 0x8A,
	DATAENGINE_CLOCK       = 0x8B,
	ISB                    = 0x90,
	DSB                    = 0x91,
	DMB                    = 0x92,
	EXT_INTERRUPT          = 0x93,
	PLE_LINE_REQ_COMPLETED = 0xA0,
	PLE_CHANNEL_SKIPPED    = 0xA1,
	PLE_FIFO_FLUSH         = 0xA2,
	PLE_REQ_COMPLETED      = 0xA3,
	PLE_FIFO_OVERFLOW      = 0xA4,
	PLE_REQ_PROGRAMMED     = 0xA5
}

foreign perf {
  scePerfArmPmonReset :: proc(thid: SceUID) -> c.int ---
  scePerfArmPmonSelectEvent :: proc(thid: SceUID, counter: SceUInt32, event_code: SceUInt8) -> c.int ---
  scePerfArmPmonStart :: proc(thid: SceUID) -> c.int ---
  scePerfArmPmonStop :: proc(thid: SceUID) -> c.int ---
  scePerfArmPmonGetCounterValue :: proc(thid: SceUID, counter: SceUInt32, value: ^SceUInt32) -> c.int ---
  scePerfArmPmonSetCounterValue :: proc(thid: SceUID, counter: SceUInt32, value: SceUInt32) -> c.int ---
  scePerfArmPmonSoftwareIncrement :: proc(mask: SceUInt32) -> c.int ---

  scePerfGetTimebaseValue :: proc() -> SceUInt64 ---
  scePerfGetTimebaseFrequency :: proc() -> SceUInt32 ---
}

