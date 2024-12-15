#+build vita
package vita

import "core:c"

foreign import ssl "system:SceSsl_stub"

SceSslErrorCode :: enum c.uint {
	BEFORE_INIT    = 0x80435001,
	ALREADY_INITED = 0x80435020,
	OUT_OF_MEMORY  = 0x80435022,
	NOT_FOUND      = 0x80435025,
	INTERNAL       = 0x80435026,
	INVALID_FORMAT = 0x80435108,
	INVALID_VALUE  = 0x804351FE
}

SceSslMemoryPoolStats :: struct {
  poolSize: c.uint,
	maxInuseSize: c.uint,
	currentInuseSize: c.uint,
	reserved: c.int,
}
#assert(size_of(SceSslMemoryPoolStats) == 0x10)

foreign ssl {
  sceSslInit :: proc(poolSize: c.uint) -> c.int ---
  sceSslTerm :: proc() -> c.int ---
  sceSslGetMemoryPoolStats :: proc(currentStat: ^SceSslMemoryPoolStats) -> c.int ---
  sceSslGetSerialNumber :: proc(sslCert: rawptr, sboData: ^cstring, sboLen: ^c.uint) -> c.int ---
  sceSslGetNotBefore :: proc(sslCert: rawptr, begin: ^SceRtcTick) -> c.int ---
  sceSslGetNotAfter :: proc(sslCert: rawptr, limit: ^SceRtcTick) -> c.int ---
  sceSslGetNameEntryCount :: proc(certName: rawptr) -> c.int ---
  sceSslGetNameEntryInfo :: proc(certName: rawptr, entryNum: c.int, oidname: cstring, maxOidnameLen: c.uint, value: cstring, maxValueLen: c.uint, valueLen: ^c.uint) -> c.int ---
  sceSslGetSubjectName :: proc(sslCert: rawptr) -> rawptr ---
  sceSslGetIssuerName  :: proc(sslCert: rawptr) -> rawptr ---
  sceSslFreeSslCertName :: proc(certName: rawptr) -> c.int ---
}

