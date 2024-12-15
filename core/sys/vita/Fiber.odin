#+build vita
package vita

import "core:c"

foreign import _fiber "system:SceFiber_stub"

// Error Codes
SceFiberErrorCode :: enum c.uint {
	NULL       = 0x80590001,
	ALIGNMENT  = 0x80590002,
	RANGE      = 0x80590003,
	INVALID    = 0x80590004,
	PERMISSION = 0x80590005,
	STATE      = 0x80590006,
	BUSY       = 0x80590007,
	AGAIN      = 0x80590008,
	FATAL      = 0x80590009
}

SceFiber :: struct #align(8) {
  reserved: [128]c.char,
}
#assert(size_of(SceFiber) == 0x80)

SceFiberOptParam :: struct #align(8) {
	reserved: [128]c.char,
}
#assert(size_of(SceFiberOptParam) == 0x80)

SceFiberEntry :: #type proc(argOnInitialize: SceUInt32, argOnRun: SceUInt32)

SceFiberInfo :: struct #align(8) {
	entry: ^SceFiberEntry,
	argOnInitialize: SceUInt32,
  addrContext: rawptr,
	sizeContext: SceSize,
	name: [32]c.char,
	padding: [80]c.uint,
}

foreign _fiber {
	_sceFiberInitializeImpl :: proc(
		fiber: ^SceFiber,
		name: cstring,
		entry: ^SceFiberEntry,
		argOnInitialize: SceUInt32,
		addrContext: rawptr,
		sizeContext: SceSize,
		params: ^SceFiberOptParam) -> SceInt32 ---
	sceFiberOptParamInitialize :: proc(optParam: ^SceFiberOptParam) -> SceInt32 ---
	sceFiberFinalize :: proc(fiber: ^SceFiber) -> SceInt32 ---
	sceFiberRun :: proc(fiber: ^SceFiber, argOnRunTo: SceUInt32, argOnRun: ^SceUInt32) -> SceInt32 ---
	sceFiberSwitch :: proc(fiber: ^SceFiber, argOnRunTo: SceUInt32, argOnRun: ^SceUInt32) -> SceInt32 ---
	sceFiberGetSelf :: proc(fiber: SceFiber) -> SceInt32 ---
	sceFiberReturnToThread :: proc(argOnReturn: SceUInt32, argOnRun: ^SceUInt32) -> SceInt32 ---
	sceFiberGetInfo :: proc(fiber: ^SceFiber, fiberInfo: ^SceFiberInfo) -> SceInt32 ---
}


