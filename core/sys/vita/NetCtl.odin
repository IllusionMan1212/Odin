#+build vita
package vita

import "core:c"

foreign import netctl "system:SceNetCtl_stub"

SCE_NETCTL_INFO_CONFIG_NAME_LEN_MAX :: 64
SCE_NETCTL_INFO_SSID_LEN_MAX        :: 32

SceNetCtlInfoType :: enum c.int {
	GET_CNF_NAME = 1,
	GET_DEVICE,
	GET_ETHER_ADDR,
	GET_MTU,
	GET_LINK,
	GET_BSSID,
	GET_SSID,
	GET_WIFI_SECURITY,
	GET_RSSI_DBM,
	GET_RSSI_PERCENTAGE,
	GET_CHANNEL,
	GET_IP_CONFIG,
	GET_DHCP_HOSTNAME,
	GET_PPPOE_AUTH_NAME,
	GET_IP_ADDRESS,
	GET_NETMASK,
	GET_DEFAULT_ROUTE,
	GET_PRIMARY_DNS,
	GET_SECONDARY_DNS,
	GET_HTTP_PROXY_CONFIG,
	GET_HTTP_PROXY_SERVER,
	GET_HTTP_PROXY_PORT,
}

SceNetCtlState :: enum c.int {
	DISCONNECTED,
	CONNECTING,
	FINALIZING,
	CONNECTED
}

/* callback */

SceNetCtlCallback :: #type ^proc(
	event_type: c.int,
	arg: rawptr,
) -> rawptr

/* struct/union */

SceNetCtlInfo :: struct #raw_union {
  cnf_name: [SCE_NETCTL_INFO_CONFIG_NAME_LEN_MAX + 1]c.char,
	device: c.uint,
	ether_addr: SceNetEtherAddr,
	mtu: c.uint,
	link: c.uint,
	bssid: SceNetEtherAddr,
	ssid: [SCE_NETCTL_INFO_SSID_LEN_MAX + 1]c.char,
	wifi_security: c.uint,
	rssi_dbm: c.uint,
	rssi_percentage: c.uint,
	channel: c.uint,
	ip_config: c.uint,
	dhcp_hostname: [256]c.char,
	pppoe_auth_name: [128]c.char,
	ip_address: [16]c.char,
	netmask: [16]c.char,
	default_route: [16]c.char,
	primary_dns: [16]c.char,
	secondary_dns: [16]c.char,
	http_proxy_config: c.uint,
	http_proxy_server: [256]c.char,
	http_proxy_port: c.uint,
}
#assert(size_of(SceNetCtlInfo) == 0x100)


SceNetCtlNatInfo :: struct {
  size: c.uint,
	stun_status: c.int,
	nat_type: c.int,
	mapped_addr: SceNetInAddr,
}
#assert(size_of(SceNetCtlNatInfo) == 0x10)

SceNetCtlAdhocPeerInfo :: struct {
	next: ^SceNetCtlAdhocPeerInfo,
	inet_addr: SceNetInAddr,
}

foreign netctl {
	sceNetCtlInit :: proc() -> c.int ---
	sceNetCtlTerm :: proc() ---

	sceNetCtlCheckCallback :: proc() -> c.int ---

	sceNetCtlInetGetResult :: proc(eventType: c.int, errorCode: ^c.int) -> c.int ---
	sceNetCtlAdhocGetResult :: proc(eventType: c.int, errorCode: ^c.int) -> c.int ---

	sceNetCtlInetGetInfo :: proc(code: c.int, info: ^SceNetCtlInfo) -> c.int ---
	sceNetCtlInetGetState :: proc(state: ^c.int) -> c.int ---
	sceNetCtlGetNatInfo :: proc(natinfo: ^SceNetCtlNatInfo) -> c.int ---

	sceNetCtlInetRegisterCallback :: proc(func: SceNetCtlCallback, arg: rawptr, cid: ^c.int) -> c.int ---
	sceNetCtlInetUnregisterCallback :: proc(cid: c.int) -> c.int ---

	sceNetCtlAdhocRegisterCallback :: proc(func: SceNetCtlCallback, arg: rawptr, cid: ^c.int) -> c.int ---
	sceNetCtlAdhocUnregisterCallback :: proc(cid: c.int) -> c.int ---
	sceNetCtlAdhocGetState :: proc(state: ^c.int) -> c.int ---
	sceNetCtlAdhocDisconnect :: proc() -> c.int ---
	sceNetCtlAdhocGetPeerList :: proc(buflen: ^c.uint, buf: rawptr) -> c.int ---
	sceNetCtlAdhocGetInAddr :: proc(inaddr: ^SceNetInAddr) -> c.int ---
}

