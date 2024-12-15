#+build vita
package vita

import "core:c"

foreign import pspnetadhoc "system:ScePspnetAdhoc_stub"

SCE_NET_ADHOC_PDP_MFS  :: 1444
SCE_NET_ADHOC_PDP_MTU  :: 65523
SCE_NET_ADHOC_PTP_MSS  :: 1444
SCE_NET_ADHOCCTL_ADHOCID_LEN :: 9
SCE_NET_ADHOCCTL_GROUPNAME_LEN :: 8
SCE_NET_ADHOCCTL_NICKNAME_LEN :: 128
SCE_NET_ADHOCCTL_BSSID_LEN  :: 6

ScePspnetAdhocErrorCode :: enum c.uint {
	INVALID_SOCKET_ID      = 0x80410701,
	INVALID_ADDR           = 0x80410702,
	INVALID_PORT           = 0x80410703,
	INVALID_BUFLEN         = 0x80410704,
	INVALID_DATALEN        = 0x80410705,
	NOT_ENOUGH_SPACE       = 0x80410706,
	SOCKET_DELETED         = 0x80410707,
	SOCKET_ALERTED         = 0x80410708,
	WOULD_BLOCK            = 0x80410709,
	PORT_IN_USE            = 0x8041070A,
	NOT_CONNECTED          = 0x8041070B,
	DISCONNECTED           = 0x8041070C,
	NOT_OPENED             = 0x8041070D,
	NOT_LISTENED           = 0x8041070E,
	SOCKET_ID_NOT_AVAIL    = 0x8041070F,
	PORT_NOT_AVAIL         = 0x80410710,
	INVALID_ARG            = 0x80410711,
	NOT_INITIALIZED        = 0x80410712,
	ALREADY_INITIALIZED    = 0x80410713,
	BUSY                   = 0x80410714,
	TIMEOUT                = 0x80410715,
	NO_ENTRY               = 0x80410716,
	EXCEPTION_EVENT        = 0x80410717,
	CONNECTION_REFUSED     = 0x80410718,
	THREAD_ABORTED         = 0x80410719,
	ALREADY_CREATED        = 0x8041071A,
	NOT_IN_GAMEMODE        = 0x8041071B,
	NOT_CREATED            = 0x8041071C,
	INVALID_ALIGNMENT      = 0x8041071D,
}

SceNetAdhocPollSd :: struct {
  id: c.int,
	events: c.int,
	revents: c.int,
}
#assert(size_of(SceNetAdhocPollSd) == 0xC)

ScePspnetAdhocEvent :: enum c.int {
	SEND        = 0x0001,
	RECV        = 0x0002,
	CONNECT     = 0x0004,
	ACCEPT      = 0x0008,
	FLUSH       = 0x0010,
	INVALID     = 0x0100,
	DELETE      = 0x0200,
	ALERT       = 0x0400,
	DISCONNECT  = 0x0800,
}

SceNetAdhocPdpStat :: struct {
	next: ^SceNetAdhocPdpStat,
	id: c.int,
	laddr: SceNetEtherAddr,
	lport: SceUShort16,
	rcv_sb_cc: c.uint,
}

ScePspnetAdhocPtpState :: enum c.int {
	CLOSED       = 0,
	LISTEN       = 1,
	SYN_SENT     = 2,
	SYN_RCVD     = 3,
	ESTABLISHED  = 4,
}

SceNetAdhocPtpStat :: struct {
	next: ^SceNetAdhocPtpStat,
	id: c.int,
	laddr: SceNetEtherAddr,
	paddr: SceNetEtherAddr,
	lport: SceUShort16,
	pport: SceUShort16,
	snd_sb_cc: c.uint,
	rcv_sb_cc: c.uint,
	state: c.int,
}

ScePspnetAdhocFlags :: enum c.int {
	NONBLOCK      = 0x0001,
	ALERTSEND     = 0x0010,
	ALERTRECV     = 0x0020,
	ALERTPOLL     = 0x0040,
	ALERTCONNECT  = 0x0080,
	ALERTACCEPT   = 0x0100,
	ALERTFLUSH    = 0x0200,
  ALERTALL = ALERTSEND | ALERTRECV | ALERTPOLL | ALERTCONNECT | ALERTACCEPT | ALERTFLUSH,
}

ScePspnetAdhocctlErrorCode :: enum c.uint {
	INVALID_ARG             = 0x80410B04,
	ALREADY_INITIALIZED     = 0x80410B07,
	NOT_INITIALIZED         = 0x80410B08,
}

ScePspnetAdhocctlAdhocType :: enum c.int {
	PRODUCT_ID  = 0,
	RESERVED    = 1,
	SYSTEM      = 2
}

SceNetAdhocctlAdhocId :: struct {
  type: c.int,
	data: [SCE_NET_ADHOCCTL_ADHOCID_LEN]SceChar8,
	padding: [3]SceUChar8,
}
#assert(size_of(SceNetAdhocctlAdhocId) == 0x10)

SceNetAdhocctlGroupName :: struct {
  data: [SCE_NET_ADHOCCTL_GROUPNAME_LEN]SceChar8,
}
#assert(size_of(SceNetAdhocctlGroupName) == 8)

SceNetAdhocctlNickname :: struct {
  data: [SCE_NET_ADHOCCTL_NICKNAME_LEN]SceChar8,
}
#assert(size_of(SceNetAdhocctlNickname) == 0x80)

SceNetAdhocctlPeerInfo :: struct {
	next: ^SceNetAdhocctlPeerInfo,
	nickname: SceNetAdhocctlNickname,
	macAddr: SceNetEtherAddr,
	padding: [6]SceUChar8,
	lastRecv: SceUInt64,
}

SceNetAdhocctlBSSId :: struct {
  data: [SCE_NET_ADHOCCTL_BSSID_LEN]SceUChar8,
	padding: [2]SceUChar8,
}
#assert(size_of(SceNetAdhocctlBSSId) == 8)

SceNetAdhocctlParameter :: struct {
  channel: c.int,
	groupName: SceNetAdhocctlGroupName,
	nickname: SceNetAdhocctlNickname,
	bssid: SceNetAdhocctlBSSId,
}
#assert(size_of(SceNetAdhocctlParameter) == 0x94)

foreign pspnetadhoc {
	sceNetAdhocInit :: proc() -> c.int ---
	sceNetAdhocTerm :: proc() -> c.int ---

	sceNetAdhocPollSocket :: proc(sds: ^SceNetAdhocPollSd, nsds: c.int, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocSetSocketAlert :: proc(id: c.int, flag: c.int) -> c.int ---
	sceNetAdhocGetSocketAlert :: proc(id: c.int, flag: ^c.int) -> c.int ---

	sceNetAdhocPdpCreate :: proc(#by_ptr saddr: SceNetEtherAddr, sport: SceUShort16, bufsize: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPdpSend :: proc(id: c.int, #by_ptr daddr: SceNetEtherAddr, dport: SceUShort16, data: rawptr, len: c.int, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPdpRecv :: proc(id: c.int, saddr: ^SceNetEtherAddr, sport: ^SceUShort16, buf: rawptr, len: ^c.int, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPdpDelete :: proc(id: c.int, flag: c.int) -> c.int ---
	sceNetAdhocGetPdpStat :: proc(buflen: ^c.int, buf: rawptr) -> c.int ---

	sceNetAdhocPtpOpen :: proc(#by_ptr saddr: SceNetEtherAddr, sport: SceUShort16, #by_ptr daddr: SceNetEtherAddr, dport: SceUShort16, bufsize: c.uint, rexmt_int: c.uint, rexmt_cnt: c.int, flag: c.int) -> c.int ---
	sceNetAdhocPtpConnect :: proc(id: c.int, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPtpListen :: proc(#by_ptr saddr: SceNetEtherAddr, sport: SceUShort16, bufsize: c.uint, rexmt_int: c.uint, rexmt_cnt: c.int, backlog: c.int, flag: c.int) -> c.int ---
	sceNetAdhocPtpAccept :: proc(id: c.int, addr: ^SceNetEtherAddr, port: ^SceUShort16, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPtpSend :: proc(id: c.int, data: rawptr, len: ^c.int, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPtpRecv :: proc(id: c.int, buf: rawptr, len: ^c.int, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPtpFlush :: proc(id: c.int, timeout: c.uint, flag: c.int) -> c.int ---
	sceNetAdhocPtpClose :: proc(id: c.int, flag: c.int)  -> c.int ---
	sceNetAdhocGetPtpStat :: proc(buflen: ^c.int, buf: rawptr) -> c.int ---

	sceNetAdhocctlInit :: proc(#by_ptr adhocId: SceNetAdhocctlAdhocId) -> c.int ---
	sceNetAdhocctlTerm :: proc() -> c.int ---
	sceNetAdhocctlGetAdhocId :: proc(adhocId: ^SceNetAdhocctlAdhocId) -> c.int ---
	sceNetAdhocctlGetPeerList :: proc(buflen: ^c.int, buf: rawptr) -> c.int ---
	sceNetAdhocctlGetPeerInfo :: proc(#by_ptr addr: SceNetEtherAddr, size: c.int, peerInfo: ^SceNetAdhocctlPeerInfo) -> c.int ---
	sceNetAdhocctlGetAddrByName :: proc(#by_ptr nickname: SceNetAdhocctlNickname, buflen: ^c.int, buf: rawptr) -> c.int ---
	sceNetAdhocctlGetNameByAddr :: proc(#by_ptr addr: SceNetEtherAddr, nickname: ^SceNetAdhocctlNickname) -> c.int ---
	sceNetAdhocctlGetParameter :: proc(parameter: ^SceNetAdhocctlParameter) -> c.int ---
	sceNetAdhocctlGetEtherAddr :: proc(addr: ^SceNetEtherAddr) -> c.int ---
}

