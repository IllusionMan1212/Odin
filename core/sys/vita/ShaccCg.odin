#+build vita
package vita

import "core:c"

foreign import shacccg "system:SceShaccCg_stub"

SceShaccCgParameter :: rawptr

SceShaccCgCallbackOpenFile :: #type ^proc "c" (
	fileName: cstring,
	#by_ptr includedFrom: SceShaccCgSourceLocation,
	#by_ptr compileOptions: SceShaccCgCompileOptions,
	errorString: ^cstring) -> ^SceShaccCgSourceFile

SceShaccCgCallbackReleaseFile :: #type ^proc "c" (
	#by_ptr file: SceShaccCgSourceFile,
	#by_ptr compileOptions: SceShaccCgCompileOptions)

SceShaccCgCallbackLocateFile :: #type ^proc "c" (
	fileName: cstring,
	#by_ptr includedFrom: SceShaccCgSourceLocation,
	searchPathCount: SceUInt32,
	searchPaths: [^]cstring,
	#by_ptr compileOptions: SceShaccCgCompileOptions,
	errorString: ^cstring) -> cstring

SceShaccCgCallbackAbsolutePath :: #type ^proc "c" (
	fileName: cstring,
	#by_ptr includedFrom: SceShaccCgSourceLocation,
	#by_ptr compileOptions: SceShaccCgCompileOptions) -> cstring

SceShaccCgCallbackReleaseFileName :: #type ^proc "c" (
	fileName: cstring,
	#by_ptr compileOptions: SceShaccCgCompileOptions)

SceShaccCgCallbackFileDate :: #type ^proc "c" (
	#by_ptr file: SceShaccCgSourceFile,
	#by_ptr includedFrom: SceShaccCgSourceLocation,
	#by_ptr compileOptions: SceShaccCgCompileOptions,
	timeLastStatusChange: ^c.int64_t,
	timeLastModified: ^c.int64_t) -> SceInt32

SceShaccCgDiagnosticLevel :: enum c.int {
	INFO,
	WARNING,
	ERROR
}

SceShaccCgTargetProfile :: enum c.int {
	VP,
	FP
}

SceShaccCgCallbackDefaults :: enum c.int {
	SYSTEM_FILES,
	TRIVIAL
}

SceShaccCgLocale :: enum c.int {
	ENGLISH,
	JAPANESE
}

SceShaccCgSourceFile :: struct {
  fileName: cstring,
	text: cstring,
	size: SceUInt32,
}

SceShaccCgSourceLocation :: struct {
	file: ^SceShaccCgSourceFile,
	lineNumber: SceUInt32,
	columnNumber: SceUInt32,
}

SceShaccCgCallbackList :: struct {
  openFile: SceShaccCgCallbackOpenFile,
	releaseFile: SceShaccCgCallbackReleaseFile,
	locateFile: SceShaccCgCallbackLocateFile,
	absolutePath: SceShaccCgCallbackAbsolutePath,
	releaseFileName: SceShaccCgCallbackReleaseFileName,
	fileDate: SceShaccCgCallbackFileDate,
}

SceShaccCgCompileOptions :: struct {
	mainSourceFile: cstring,
	targetProfile: SceShaccCgTargetProfile,
	entryFunctionName: cstring,
	searchPathCount: SceUInt32,
	searchPaths: [^]cstring,
	macroDefinitionCount: SceUInt32,
	macroDefinitions: [^]cstring,
	includeFileCount: SceUInt32,
	includeFiles: [^]cstring,
	suppressedWarningsCount: SceUInt32,
	suppressedWarnings: [^]SceUInt32,
	locale: SceShaccCgLocale,
	useFx: SceInt32,
	noStdlib: SceInt32,
	optimizationLevel: SceInt32,
	useFastmath: SceInt32,
	useFastprecision: SceInt32,
	useFastint: SceInt32,
	field_48: c.int,
	warningsAsErrors: SceInt32,
	performanceWarnings: SceInt32,
	warningLevel: SceInt32,
	pedantic: SceInt32,
	pedanticError: SceInt32,
	field_60: c.int,
	field_64: c.int,
}

SceShaccCgDiagnosticMessage :: struct {
  level: SceShaccCgDiagnosticLevel,
	code: SceUInt32,
	location: ^SceShaccCgSourceLocation,
	message: cstring,
}

SceShaccCgCompileOutput :: struct {
	programData: [^]c.uint8_t,
	programSize: SceUInt32,
	diagnosticCount: SceInt32,
	diagnostics: ^SceShaccCgDiagnosticMessage,
}

foreign shacccg {
	sceShaccCgInitializeCompileOptions :: proc(options: ^SceShaccCgCompileOptions) -> c.int ---

	sceShaccCgCompileProgram :: proc(#by_ptr options: SceShaccCgCompileOptions, #by_ptr callbacks: SceShaccCgCallbackList, unk: c.int) -> ^SceShaccCgCompileOutput ---

	sceShaccCgSetDefaultAllocator :: proc(malloc_cb: #type ^proc "c" (_: c.uint) -> rawptr, free_cb: #type ^proc "c" (_: rawptr)) -> c.int ---

	sceShaccCgInitializeCallbackList :: proc(callbacks: ^SceShaccCgCallbackList, defaults: SceShaccCgCallbackDefaults) ---

	sceShaccCgDestroyCompileOutput :: proc(output: ^SceShaccCgCompileOutput) ---

	sceShaccCgReleaseCompiler :: proc() ---

	sceShaccCgGetVersionString :: proc() -> cstring ---
}

