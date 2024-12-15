#+build vita
package vita

import "core:c"

foreign import net "system:SceNet_stub"
foreign import netps "system:SceNetPsForDriver_stub"

/** Resolver specific error codes */
SceNetResolverErrorCode :: enum c.int {
	EINTERNAL	= 220,
	EBUSY,
	ENOSPACE,
	EPACKET,
	ERESERVED224,
	ENODNS,
	ETIMEDOUT,
	ENOSUPPORT,
	EFORMAT,
	ESERVERFAILURE,
	ENOHOST,
	ENOTIMPLEMENTED,
	ESERVERREFUSED,
	ENORECORD,
	EALIGNMENT
}

/** Flags to specify as argument to ::sceNetDumpRead() */
SceNetDumpReadFlag :: enum c.int {
	PEEK                    = 0x00000010,
	DONTWAIT                = 0x00000020,
	OVERFLOW                = 0x00000040,
}

SceNetDumpAbortFlag :: enum c.int {
	PRESERVATION = 0x00000001
}

/** Events for ::SceNetEpollEvent */
SceNetEpollEventType :: enum c.int {
	EPOLLIN       = 0x00000001,
	EPOLLOUT      = 0x00000002,
	EPOLLERR      = 0x00000008,
	EPOLLHUP      = 0x00000010,
	EPOLLDESCID   = 0x00010000
}

/** Flags to specify as argument to ::sceNetEpollControl() */
SceNetEpollControlFlag :: enum c.int {
	ADD = 1,
	MOD,
	DEL
}

/** Flags to specify as argument to ::sceNetEmulationGet() / ::sceNetEmulationSet() */
SceNetEmulationFlag :: enum c.int {
	ETH0	= 1,
	WLAN0
}

/** Flags to specify as argument to ::sceNetResolverStartNtoa() / ::sceNetResolverStartAton() */
SceNetResolverFlag :: enum c.int {
	ASYNC                          = 0x00000001,
	START_NTOA_DISABLE_IPADDRESS   = 0x00010000
}

/** Flags to specify as argument to ::sceNetResolverAbort() */
SceNetResolverAbortFlag :: enum c.int {
	NTOA_PRESERVATION = 0x00000001,
	ATON_PRESERVATION = 0x00000002
}

/** Flags to specify as argument to ::sceNetSocketAbort() */
SceNetSocketAbortFlag :: enum c.int {
	RCV_PRESERVATION	= 0x00000001,
	SND_PRESERVATION	= 0x00000002
}

/** Flags to specify as argument to ::sceNetShutdown */
SceNetShutdownFlag :: enum c.int {
	RD,
	WR,
	RDWR
}

/* Defines */
SceNetEpollAbortFlag :: enum c.int {
	PRESERVATION = 0x00000001,
}

SCE_NET_RESOLVER_PORT             :: 53
SCE_NET_RESOLVER_HOSTNAME_LEN_MAX :: 255

/* callback */

SceNetResolverFunctionAllocate :: #type ^proc(
	size: c.uint,
	rid: c.int,
	name: cstring,
	user: rawptr,
) -> rawptr

SceNetResolverFunctionFree :: #type ^proc(
	ptr: rawptr,
	rid: c.int,
	name: cstring,
	user: rawptr,
)

/* struct */

SceNetInitParam :: struct {
    memory: rawptr,
    size: c.int,
    flags: c.int,
}

SceNetEmulationData :: struct {
    drop_rate: c.ushort,
    drop_duration: c.ushort,
    pass_duration: c.ushort,
    delay_time: c.ushort,
    delay_jitter: c.ushort,
    order_rate: c.ushort,
    order_delay_time: c.ushort,
    duplication_rate: c.ushort,
    bps_limit: c.uint,
    lower_size_limit: c.ushort,
    upper_size_limit: c.ushort,
    system_policy_pattern: c.uint,
    game_policy_pattern: c.uint,
    policy_flags: [64]c.ushort,
    reserved: [64]c.uchar,
}
#assert(size_of(SceNetEmulationData) == 0xE0)

SceNetEmulationParam :: struct {
    version: c.ushort,
    option_number: c.ushort,
    current_version: c.ushort,
    result: c.ushort,
    flags: c.uint,
    reserved1: c.uint,
    send: SceNetEmulationData,
    recv: SceNetEmulationData,
    seed: c.uint,
    reserved: [44]c.uchar,
}
#assert(size_of(SceNetEmulationParam) == 0x200)

SceNetEpollDataExt :: struct {
    id: c.int,
    u32: c.uint,
}
#assert(size_of(SceNetEpollDataExt) == 8)

SceNetEpollData :: struct #raw_union {
    ptr: rawptr,
    fd: c.int,
    u32: c.uint,
    u64: c.ulonglong,
    ext: SceNetEpollDataExt,
}
#assert(size_of(SceNetEpollData) == 8)

SceNetEpollSystemData :: struct {
    system: [4]c.uint,
}
#assert(size_of(SceNetEpollSystemData) == 0x10)

SceNetEpollEvent :: struct {
		events: c.uint,
    reserved: c.uint,
    system: SceNetEpollSystemData,
    data: SceNetEpollData,
}
#assert(size_of(SceNetEpollEvent) == 0x20)

SceNetResolverParam :: struct {
    allocate: SceNetResolverFunctionAllocate,
    free: SceNetResolverFunctionFree,
    user: rawptr,
}

/** Net Error Codes */
SceNetErrorCode :: enum c.uint {
	EPERM                     = 0x80410101,
	ENOENT                    = 0x80410102,
	ESRCH                     = 0x80410103,
	EINTR                     = 0x80410104,
	EIO                       = 0x80410105,
	ENXIO                     = 0x80410106,
	E2BIG                     = 0x80410107,
	ENOEXEC                   = 0x80410108,
	EBADF                     = 0x80410109,
	ECHILD                    = 0x8041010A,
	EDEADLK                   = 0x8041010B,
	ENOMEM                    = 0x8041010C,
	EACCES                    = 0x8041010D,
	EFAULT                    = 0x8041010E,
	ENOTBLK                   = 0x8041010F,
	EBUSY                     = 0x80410110,
	EEXIST                    = 0x80410111,
	EXDEV                     = 0x80410112,
	ENODEV                    = 0x80410113,
	ENOTDIR                   = 0x80410114,
	EISDIR                    = 0x80410115,
	EINVAL                    = 0x80410116,
	ENFILE                    = 0x80410117,
	EMFILE                    = 0x80410118,
	ENOTTY                    = 0x80410119,
	ETXTBSY                   = 0x8041011A,
	EFBIG                     = 0x8041011B,
	ENOSPC                    = 0x8041011C,
	ESPIPE                    = 0x8041011D,
	EROFS                     = 0x8041011E,
	EMLINK                    = 0x8041011F,
	EPIPE                     = 0x80410120,
	EDOM                      = 0x80410121,
	ERANGE                    = 0x80410122,
	EAGAIN                    = 0x80410123,
	EWOULDBLOCK               = 0x80410123,
	EINPROGRESS               = 0x80410124,
	EALREADY                  = 0x80410125,
	ENOTSOCK                  = 0x80410126,
	EDESTADDRREQ              = 0x80410127,
	EMSGSIZE                  = 0x80410128,
	EPROTOTYPE                = 0x80410129,
	ENOPROTOOPT               = 0x8041012A,
	EPROTONOSUPPORT           = 0x8041012B,
	ESOCKTNOSUPPORT           = 0x8041012C,
	EOPNOTSUPP                = 0x8041012D,
	EPFNOSUPPORT              = 0x8041012E,
	EAFNOSUPPORT              = 0x8041012F,
	EADDRINUSE                = 0x80410130,
	EADDRNOTAVAIL             = 0x80410131,
	ENETDOWN                  = 0x80410132,
	ENETUNREACH               = 0x80410133,
	ENETRESET                 = 0x80410134,
	ECONNABORTED              = 0x80410135,
	ECONNRESET                = 0x80410136,
	ENOBUFS                   = 0x80410137,
	EISCONN                   = 0x80410138,
	ENOTCONN                  = 0x80410139,
	ESHUTDOWN                 = 0x8041013A,
	ETOOMANYREFS              = 0x8041013B,
	ETIMEDOUT                 = 0x8041013C,
	ECONNREFUSED              = 0x8041013D,
	ELOOP                     = 0x8041013E,
	ENAMETOOLONG              = 0x8041013F,
	EHOSTDOWN                 = 0x80410140,
	EHOSTUNREACH              = 0x80410141,
	ENOTEMPTY                 = 0x80410142,
	EPROCLIM                  = 0x80410143,
	EUSERS                    = 0x80410144,
	EDQUOT                    = 0x80410145,
	ESTALE                    = 0x80410146,
	EREMOTE                   = 0x80410147,
	EBADRPC                   = 0x80410148,
	ERPCMISMATCH              = 0x80410149,
	EPROGUNAVAIL              = 0x8041014A,
	EPROGMISMATCH             = 0x8041014B,
	EPROCUNAVAIL              = 0x8041014C,
	ENOLCK                    = 0x8041014D,
	ENOSYS                    = 0x8041014E,
	EFTYPE                    = 0x8041014F,
	EAUTH                     = 0x80410150,
	ENEEDAUTH                 = 0x80410151,
	EIDRM                     = 0x80410152,
	ENOMS                     = 0x80410153,
	EOVERFLOW                 = 0x80410154,
	EILSEQ                    = 0x80410155,
	ENOTSUP                   = 0x80410156,
	ECANCELED                 = 0x80410157,
	EBADMSG                   = 0x80410158,
	ENODATA                   = 0x80410159,
	ENOSR                     = 0x8041015A,
	ENOSTR                    = 0x8041015B,
	ETIME                     = 0x8041015C,
	EADHOC                    = 0x804101A0,
	EDISABLEDIF               = 0x804101A1,
	ERESUME                   = 0x804101A2,
	ENOTINIT                  = 0x804101C8,
	ENOLIBMEM                 = 0x804101C9,
	ERESERVED202              = 0x804101CA,
	ECALLBACK                 = 0x804101CB,
	EINTERNAL                 = 0x804101CC,
	ERETURN                   = 0x804101CD,
	RESOLVER_EINTERNAL        = 0x804101DC,
	RESOLVER_EBUSY            = 0x804101DD,
	RESOLVER_ENOSPACE         = 0x804101DE,
	RESOLVER_EPACKET          = 0x804101DF,
	RESOLVER_ERESERVED22      = 0x804101E0,
	RESOLVER_ENODNS           = 0x804101E1,
	RESOLVER_ETIMEDOUT        = 0x804101E2,
	RESOLVER_ENOSUPPORT       = 0x804101E3,
	RESOLVER_EFORMAT          = 0x804101E4,
	RESOLVER_ESERVERFAILURE   = 0x804101E5,
	RESOLVER_ENOHOST          = 0x804101E6,
	RESOLVER_ENOTIMPLEMENTED  = 0x804101E7,
	RESOLVER_ESERVERREFUSED   = 0x804101E8,
	RESOLVER_ENORECORD        = 0x804101E9,
	RESOLVER_EALIGNMENT       = 0x804101EA
}

/** Specific kernel and libnet error codes */
SceNetKernelErrorCode :: enum c.int {
	EPERM               = 1,
	ENOENT              = 2,
	ESRCH               = 3,
	EINTR               = 4,
	EIO                 = 5,
	ENXIO               = 6,
	E2BIG               = 7,
	ENOEXEC             = 8,
	EBADF               = 9,
	ECHILD              = 10,
	EDEADLK             = 11,
	ENOMEM              = 12,
	EACCES              = 13,
	EFAULT              = 14,
	ENOTBLK             = 15,
	EBUSY               = 16,
	EEXIST              = 17,
	EXDEV               = 18,
	ENODEV              = 19,
	ENOTDIR             = 20,
	EISDIR              = 21,
	EINVAL              = 22,
	ENFILE              = 23,
	EMFILE              = 24,
	ENOTTY              = 25,
	ETXTBSY             = 26,
	EFBIG               = 27,
	ENOSPC              = 28,
	ESPIPE              = 29,
	EROFS               = 30,
	EMLINK              = 31,
	EPIPE               = 32,
	EDOM                = 33,
	ERANGE              = 34,
	EAGAIN              = 35,
	EWOULDBLOCK         = 35,
	EINPROGRESS         = 36,
	EALREADY            = 37,
	ENOTSOCK            = 38,
	EDESTADDRREQ        = 39,
	EMSGSIZE            = 40,
	EPROTOTYPE          = 41,
	ENOPROTOOPT         = 42,
	EPROTONOSUPPORT     = 43,
	ESOCKTNOSUPPORT     = 44,
	EOPNOTSUPP          = 45,
	EPFNOSUPPORT        = 46,
	EAFNOSUPPORT        = 47,
	EADDRINUSE          = 48,
	EADDRNOTAVAIL       = 49,
	ENETDOWN            = 50,
	ENETUNREACH         = 51,
	ENETRESET           = 52,
	ECONNABORTED        = 53,
	ECONNRESET          = 54,
	ENOBUFS             = 55,
	EISCONN             = 56,
	ENOTCONN            = 57,
	ESHUTDOWN           = 58,
	ETOOMANYREFS        = 59,
	ETIMEDOUT           = 60,
	ECONNREFUSED        = 61,
	ELOOP               = 62,
	ENAMETOOLONG        = 63,
	EHOSTDOWN           = 64,
	EHOSTUNREACH        = 65,
	ENOTEMPTY           = 66,
	EPROCLIM            = 67,
	EUSERS              = 68,
	EDQUOT              = 69,
	ESTALE              = 70,
	EREMOTE             = 71,
	EBADRPC             = 72,
	ERPCMISMATCH        = 73,
	EPROGUNAVAIL        = 74,
	EPROGMISMATCH       = 75,
	EPROCUNAVAIL        = 76,
	ENOLCK              = 77,
	ENOSYS              = 78,
	EFTYPE              = 79,
	EAUTH               = 80,
	ENEEDAUTH           = 81,
	EIDRM               = 82,
	ENOMSG              = 83,
	EOVERFLOW           = 84,
	EILSEQ              = 85,
	ENOTSUP             = 86,
	ECANCELED           = 87,
	EBADMSG             = 88,
	ENODATA             = 89,
	ENOSR               = 90,
	ENOSTR              = 91,
	ETIME               = 92,
	EADHOC              = 160,
	EDISABLEDIF         = 161,
	ERESUME             = 162
}

/** libnet specific error codes */
SceNetLibnetErrorCode :: enum c.int {
	ENOTINIT	= 200,
	ENOLIBMEM,
	ETLS,
	ECALLBACK,
	EINTERNAL,
	ERETURN
}

/** state for ::SceNetSockInfo structure */
SceNetSockInfoState :: enum c.int {
	UNKNOWN,
	CLOSED,
	OPENED,
	LISTEN,
	SYN_SENT,
	SYN_RECEIVED,
	ESTABLISHED,
	FIN_WAIT_1,
	FIN_WAIT_2,
	CLOSE_WAIT,
	CLOSING,
	LAST_ACK,
	TIME_WAIT
}

/** flags for ::SceNetSockInfo structure */
SceNetSockInfoFlag :: enum c.int {
	SELF           = 0x00000001,
	KERNEL         = 0x00000002,
	OTHERS         = 0x00000004,
	RECV_WAIT      = 0x00010000,
	SEND_WAIT      = 0x00020000,
	RECV_EWAIT     = 0x00040000,
	SEND_EWAIT     = 0x00080000,
	WAKEUP_SIGNAL  = 0x00100000,
	ALL            = 0x001F0007
}

/** Net Protocols */
SceNetProtocol :: enum c.int {
	IPPROTO_IP      = 0,
	IPPROTO_ICMP    = 1,
	IPPROTO_IGMP    = 2,
	IPPROTO_TCP     = 6,
	IPPROTO_UDP     = 17,
	SOL_SOCKET      = 0xFFFF
}

/** Socket Options */
SceNetSocketOption :: enum c.int {
	/* IP */
	IP_HDRINCL              = 2,
	IP_TOS                  = 3,
	IP_TTL                  = 4,
	IP_MULTICAST_IF         = 9,
	IP_MULTICAST_TTL        = 10,
	IP_MULTICAST_LOOP       = 11,
	IP_ADD_MEMBERSHIP       = 12,
	IP_DROP_MEMBERSHIP      = 13,
	IP_TTLCHK               = 23,
	IP_MAXTTL               = 24,
	/* TCP */
	TCP_NODELAY             = 1,
	TCP_MAXSEG              = 2,
	TCP_MSS_TO_ADVERTISE    = 3,
	/* SOCKET */
	SO_REUSEADDR            = 0x00000004,
	SO_KEEPALIVE            = 0x00000008,
	SO_BROADCAST            = 0x00000020,
	SO_LINGER               = 0x00000080,
	SO_OOBINLINE            = 0x00000100,
	SO_REUSEPORT            = 0x00000200,
	SO_ONESBCAST            = 0x00000800,
	SO_USECRYPTO            = 0x00001000,
	SO_USESIGNATURE         = 0x00002000,
	SO_SNDBUF               = 0x1001,
	SO_RCVBUF               = 0x1002,
	SO_SNDLOWAT             = 0x1003,
	SO_RCVLOWAT             = 0x1004,
	SO_SNDTIMEO             = 0x1005,
	SO_RCVTIMEO             = 0x1006,
	SO_ERROR                = 0x1007,
	SO_TYPE                 = 0x1008,
	SO_NBIO                 = 0x1100,
	SO_TPPOLICY             = 0x1101,
	SO_NAME                 = 0x1102
}

/** Socket types */
SceNetSocketType :: enum c.int {
	STREAM      = 1,
	DGRAM       = 2,
	RAW         = 3,
	DGRAM_P2P   = 6,
	STREAM_P2P  = 10
}

/** MSG Flags */
SceNetMsgFlag :: enum c.int {
	PEEK            = 0x00000002,
	WAITALL         = 0x00000040,
	DONTWAIT        = 0x00000080,
	USECRYPTO       = 0x00000400,
	USESIGNATURE    = 0x00000800
}

/** Types to specify to ::SceNetIcmpHeader structure */
SceNetIcmpType :: enum c.int {
	ECHO_REPLY            = 0,
	DEST_UNREACH          = 3,
	SOURCE_QUENCH         = 4,
	REDIRECT              = 5,
	ECHO_REQUEST          = 8,
	TIME_EXCEEDED         = 11,
	PARAMETER_PROBLEM     = 12,
	TIMESTAMP_REQUEST     = 13,
	TIMESTAMP_REPLY       = 14,
	INFORMATION_REQUEST   = 15,
	INFORMATION_REPLY     = 16,
	ADDRESS_MASK_REQUEST  = 17,
	ADDRESS_MASK_REPLY    = 18
}

/** Codes to specify to ::SceNetIcmpHeader structure */
SceNetIcmpCode :: enum c.int {
	DEST_UNREACH_NET_UNREACH              = 0,
	DEST_UNREACH_HOST_UNREACH             = 1,
	DEST_UNREACH_PROTO_UNREACH            = 2,
	DEST_UNREACH_PORT_UNREACH             = 3,
	DEST_UNREACH_FRAG_AND_DF              = 4,
	DEST_UNREACH_SRC_HOST_FAILED          = 5,
	DEST_UNREACH_DST_NET_UNKNOWN          = 6,
	DEST_UNREACH_DST_HOST_UNKNOWN         = 7,
	DEST_UNREACH_SRC_HOST_ISOLATED        = 8,
	DEST_UNREACH_NET_ADMIN_PROHIBITED     = 9,
	DEST_UNREACH_NET_HOST_PROHIBITED      = 10,
	DEST_UNREACH_NET_TOS                  = 11,
	DEST_UNREACH_HOST_TOS                 = 12,
	TIME_EXCEEDED_TTL_EXCEEDED            = 0,
	TIME_EXCEEDED_FRT_EXCEEDED            = 1
}

SCE_NET_IP_DEFAULT_MULTICAST_TTL  :: 1
SCE_NET_IP_DEFAULT_MULTICAST_LOOP :: 1

SCE_NET_IPVERSION  :: 4

SCE_NET_IP_RF      :: 0x8000
SCE_NET_IP_DF      :: 0x4000
SCE_NET_IP_MF      :: 0x2000
SCE_NET_IP_OFFMASK :: 0x1FFF

SCE_NET_INADDR_ANY          :: 0x00000000
SCE_NET_INADDR_LOOPBACK     :: 0x7F000001
SCE_NET_INADDR_BROADCAST    :: 0xFFFFFFFF
SCE_NET_INADDR_UNSPEC_GROUP :: 0xE0000000
SCE_NET_INADDR_AUTOIP       :: 0xA9FE0000

SCE_NET_IN_CLASSD_NET       :: 0xF0000000
SCE_NET_IN_AUTOIP_NET       :: 0xFFFF0000

SCE_NET_ADHOC_PORT          :: 3658

SCE_NET_AF_INET             :: 2

SCE_NET_DEBUG_NAME_LEN_MAX  :: 31

SCE_NET_ID_SOCKET_MIN       :: 0
SCE_NET_ID_SOCKET_MAX       :: 1023

SceNetFdSet :: struct {
	bits: [32]c.uint,
}
#assert(size_of(SceNetFdSet) == 0x80)

SceNetInAddr :: struct {
	s_addr: c.uint,
}
#assert(size_of(SceNetInAddr) == 4)

SceNetSockaddrIn :: struct {
	sin_len: c.uchar,
	sin_family: c.uchar,
	sin_port: c.ushort,
	sin_addr: SceNetInAddr,
	sin_vport: c.ushort,
	sin_zero: [6]c.char,
}
#assert(size_of(SceNetSockaddrIn) == 0x10)

SceNetIpMreq :: struct {
	imr_multiaddr: SceNetInAddr,
	imr_interface: SceNetInAddr,
}
#assert(size_of(SceNetIpMreq) == 8)

SceNetEtherAddr :: struct {
	data: [6]c.uchar,
}
#assert(size_of(SceNetEtherAddr) == 6)

SceNetDnsInfo :: struct {
	dns_addr: [2]SceNetInAddr,
}
#assert(size_of(SceNetDnsInfo) == 8)

SceNetLinger :: struct {
	l_onoff: c.int,
	l_linger: c.int,
}
#assert(size_of(SceNetLinger) == 8)

SceNetSockaddr :: struct {
	sa_len: c.uchar,
	sa_family: c.uchar,
	sa_data: [14]c.char,
}
#assert(size_of(SceNetSockaddr) == 0x10)

SceNetIovec :: struct {
	iov_base: rawptr,
	iov_len: c.uint,
}

SceNetMsghdr :: struct {
	msg_name: rawptr,
	msg_namelen: c.uint,
	msg_iov: ^SceNetIovec,
	msg_iovlen: c.int,
	msg_control: rawptr,
	msg_controllen: c.uint,
	msg_flags: c.int,
}

SceNetSockInfo :: struct {
	name: [SCE_NET_DEBUG_NAME_LEN_MAX + 1]c.char,
	pid: c.int,
	s: c.int,
	socket_type: c.char,
	policy: c.char,
	reserved16: c.short,
	recv_queue_length: c.int,
	send_queue_length: c.int,
	local_adr: SceNetInAddr,
	remote_adr: SceNetInAddr,
	local_port: c.ushort,
	remote_port: c.ushort,
	local_vport: c.ushort,
	remote_vport: c.ushort,
	state: c.int,
	flags: c.int,
	reserved: [8]c.int,
}
#assert(size_of(SceNetSockInfo) == 0x6C)

SceNetStatisticsInfo :: struct {
	kernel_mem_free_size: c.int,
	kernel_mem_free_min: c.int,
	packet_count: c.int,
	packet_qos_count: c.int,

	libnet_mem_free_size: c.int,
	libnet_mem_free_min: c.int,
}
#assert(size_of(SceNetStatisticsInfo) == 0x18)

SceNetIpHeaderIpVerHl :: struct {
	hl: c.char,
	ver: c.char,
}
#assert(size_of(SceNetIpHeaderIpVerHl) == 2)

SceNetIpHeaderUnion :: struct #raw_union {
	ip_ver_hl: SceNetIpHeaderIpVerHl ,
	ver_hl: c.uchar,
}
#assert(size_of(SceNetIpHeaderUnion) == 2)

SceNetIpHeader :: struct {
	un: SceNetIpHeaderUnion,
	ip_tos: c.uchar,
	ip_len: c.ushort,
	ip_id: c.ushort,
	ip_off: c.ushort,
	ip_ttl: c.uchar,
	ip_p: c.uchar,
	ip_sum: c.ushort,
	ip_src: SceNetInAddr,
	ip_dst: SceNetInAddr,
}
#assert(size_of(SceNetIpHeader) == 0x18)

SceNetIcmpHeaderEcho :: struct {
	id: c.ushort,
	sequence: c.ushort,
}
#assert(size_of(SceNetIcmpHeaderEcho) == 4)

SceNetIcmpHeaderFrag :: struct {
	unused: c.ushort,
	mtu: c.ushort,
}
#assert(size_of(SceNetIcmpHeaderFrag) == 4)

SceNetIcmpHeaderUnion :: struct #raw_union {
	echo: SceNetIcmpHeaderEcho,
	gateway: c.uint,
	frag: SceNetIcmpHeaderFrag,
}
#assert(size_of(SceNetIcmpHeaderUnion) == 4)

SceNetIcmpHeader :: struct {
	type: c.uchar,
	code: c.uchar,
	checksum: c.ushort,
	un: SceNetIcmpHeaderUnion,
}
#assert(size_of(SceNetIcmpHeader) == 8)

foreign net {
    sceNetInit :: proc(param: ^SceNetInitParam) -> c.int ---
    sceNetTerm :: proc() -> c.int ---

    sceNetShowIfconfig :: proc(p: rawptr, b: c.int) -> c.int ---
    sceNetShowRoute :: proc() -> c.int ---
    sceNetShowNetstat :: proc() -> c.int ---

    sceNetEmulationSet :: proc(param: ^SceNetEmulationParam, flags: SceNetEmulationFlag) -> c.int ---
    sceNetEmulationGet :: proc(param: ^SceNetEmulationParam, flags: SceNetEmulationFlag) -> c.int ---

    // flags is always 0
    sceNetResolverCreate :: proc(name: cstring, param: ^SceNetResolverParam, flags: c.int) -> c.int ---
    sceNetResolverStartNtoa :: proc(rid: c.int, hostname: cstring, addr: ^SceNetInAddr, timeout: c.int, retry: c.int, flags: SceNetResolverFlag) -> c.int ---
    sceNetResolverStartAton :: proc(rid: c.int, addr: ^SceNetInAddr, hostname: cstring, len: c.int, timeout: c.int, retry: c.int, flags: SceNetResolverFlag) -> c.int ---
    sceNetResolverGetError :: proc(rid: c.int, result: ^c.int) -> SceNetResolverErrorCode ---
    sceNetResolverDestroy :: proc(rid: c.int) -> c.int ---
    sceNetResolverAbort :: proc(rid: c.int, flags: SceNetResolverAbortFlag) -> c.int ---

    // flags is always 0
    sceNetDumpCreate :: proc(name: cstring, len: c.int, flags: c.int) -> c.int ---
    sceNetDumpRead :: proc(id: c.int, buf: rawptr, len: c.int, pflags: ^SceNetDumpReadFlag) -> c.int ---
    sceNetDumpDestroy :: proc(id: c.int) -> c.int ---
    sceNetDumpAbort :: proc(id: c.int, flags: SceNetDumpAbortFlag) -> c.int ---
    // flags is always 0
    sceNetEpollCreate :: proc(name: cstring, flags: c.int) -> c.int ---
    sceNetEpollControl :: proc(eid: c.int, op: SceNetEpollControlFlag, id: c.int, event: ^SceNetEpollEvent) -> c.int ---
    sceNetEpollWait :: proc(eid: c.int, events: ^SceNetEpollEvent, maxevents: c.int, timeout: c.int) -> c.int ---
    sceNetEpollWaitCB :: proc(eid: c.int, events: ^SceNetEpollEvent, maxevents: c.int, timeout: c.int) -> c.int ---
    sceNetEpollDestroy :: proc(eid: c.int) -> c.int ---
    sceNetEpollAbort :: proc(eid: c.int, flags: SceNetEpollAbortFlag) -> c.int ---

    sceNetEtherStrton :: proc(str: cstring, n: ^SceNetEtherAddr) -> c.int ---
    sceNetEtherNtostr :: proc(n: ^SceNetEtherAddr, str: cstring, len: c.uint) -> c.int ---
    // flags is always 0
    sceNetGetMacAddress :: proc(addr: ^SceNetEtherAddr, flags: ^c.int) -> c.int ---

    sceNetSocket :: proc(name: cstring, domain: c.int, type: SceNetSocketType, protocol: c.int) -> c.int ---
    sceNetAccept :: proc(s: c.int, addr: ^SceNetSockaddr, addrlen: ^c.uint) -> c.int ---
    sceNetBind :: proc(s: c.int, addr: ^SceNetSockaddr, addrlen: c.uint) -> c.int ---
    sceNetConnect :: proc(s: c.int, name: ^SceNetSockaddr, namelen: c.uint) -> c.int ---
    sceNetGetpeername :: proc(s: c.int, name: ^SceNetSockaddr, namelen: ^c.uint) -> c.int ---
    sceNetGetsockname :: proc(s: c.int, name: ^SceNetSockaddr, namelen: ^c.uint) -> c.int ---
    sceNetGetsockopt :: proc(s: c.int, level: c.int, optname: c.int, optval: rawptr, optlen: ^c.uint) -> c.int ---
    sceNetListen :: proc(s: c.int, backlog: c.int) -> c.int ---
    sceNetRecv :: proc(s: c.int, buf: rawptr, len: c.uint, flags: SceNetMsgFlag) -> c.int ---
    sceNetRecvfrom :: proc(s: c.int, buf: rawptr, len: c.uint, flags: SceNetMsgFlag, from: ^SceNetSockaddr, fromlen: ^c.uint) -> c.int ---
    sceNetRecvmsg :: proc(s: c.int, msg: ^SceNetMsghdr, flags: SceNetMsgFlag) -> c.int ---
    sceNetSend :: proc(s: c.int, msg: rawptr, len: c.uint, flags: SceNetMsgFlag) -> c.int ---
    sceNetSendto :: proc(s: c.int, msg: rawptr, len: c.uint, flags: SceNetMsgFlag, to: ^SceNetSockaddr, tolen: c.uint) -> c.int ---
    sceNetSendmsg :: proc(s: c.int, msg: ^SceNetMsghdr, flags: SceNetMsgFlag) -> c.int ---
    sceNetSetsockopt :: proc(s: c.int, level: c.int, optname: c.int, optval: rawptr, optlen: c.uint) -> c.int ---
    sceNetShutdown :: proc(s: c.int, how: SceNetShutdownFlag) -> c.int ---
    sceNetSocketClose :: proc(s: c.int) -> c.int ---
    sceNetSocketAbort :: proc(s: c.int, flags: SceNetSocketAbortFlag) -> c.int ---
    // flags is always 0
    sceNetGetSockInfo :: proc(s: c.int, info: ^SceNetSockInfo, n: c.int, flags: c.int) -> c.int ---
    // flags is always 0
    sceNetGetSockIdInfo :: proc(fds: ^SceNetFdSet, sockinfoflags: c.int, flags: c.int) -> c.int ---
    // flags is always 0
    sceNetGetStatisticsInfo :: proc(info: ^SceNetStatisticsInfo, flags: c.int) -> c.int ---

    // flags is always 0
    sceNetSetDnsInfo :: proc(info: ^SceNetDnsInfo, flags: c.int) -> c.int ---
    // flags is always 0
    sceNetClearDnsCache :: proc(flags: c.int) -> c.int ---

    sceNetInetNtop :: proc(af: c.int, src: rawptr, dst: cstring, size: c.uint) -> cstring ---
    sceNetInetPton :: proc(af: c.int, src: cstring, dst: rawptr) -> c.int ---

    sceNetHtonll :: proc(host64: c.ulonglong) -> c.ulonglong ---
    sceNetHtonl :: proc(host32: c.uint) -> c.uint ---
    sceNetHtons :: proc(host16: c.ushort) -> c.ushort ---
    sceNetNtohll :: proc(net64: c.ulonglong) -> c.ulonglong ---
    sceNetNtohl :: proc(net32: c.uint) -> c.uint ---
    sceNetNtohs :: proc(net16: c.ushort) -> c.ushort ---

    /**
    * Get pointer to last network errno.
    *
    * @return pointer to int.
    */
    sceNetErrnoLoc :: proc() -> ^c.int ---
}

foreign netps {
  ksceNetSocket :: proc(name: cstring, domain: c.int, type: c.int, protocol: c.int) -> c.int ---
  ksceNetAccept :: proc(s: c.int, addr: ^SceNetSockaddr, addrlen: ^c.uint) -> c.int ---
  ksceNetBind :: proc(s: c.int, #by_ptr addr: SceNetSockaddr, addrlen: c.uint) -> c.int ---
  ksceNetConnect :: proc(s: c.int, #by_ptr name: SceNetSockaddr, namelen: c.uint) -> c.int ---
  ksceNetListen :: proc(s: c.int, backlog: c.int) -> c.int ---
  ksceNetRecvfrom :: proc(s: c.int, buf: rawptr, len: c.uint, flags: c.int, from: ^SceNetSockaddr, fromlen: ^c.uint) -> c.int ---
  ksceNetSendto :: proc(s: c.int, msg: rawptr, len: c.uint, flags: c.int, #by_ptr to: SceNetSockaddr, tolen: c.uint) -> c.int ---
  ksceNetSetsockopt :: proc(s: c.int, level: c.int, optname: c.int, optval: rawptr, optlen: c.uint) -> c.int ---
  ksceNetClose :: proc(s: c.int) -> c.int ---
}

