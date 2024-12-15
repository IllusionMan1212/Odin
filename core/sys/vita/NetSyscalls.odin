#+build vita
package vita

import "core:c"

foreign import net_syscalls "system:SceNetPsForSyscalls_stub"

SceNetSyscallParameter :: struct{} // missing struct

foreign net_syscalls {
  sceNetSyscallAccept :: proc(s: c.int, addr: rawptr, addrlen: rawptr) -> c.int ---
  sceNetSyscallBind :: proc(s: c.int, addr: rawptr, addrlen: c.int) -> c.int ---
  sceNetSyscallClose :: proc(s: c.int) -> c.int ---
  sceNetSyscallConnect :: proc(s: c.int, name: rawptr, namelen: c.int) -> c.int ---
  sceNetSyscallControl :: proc(if_index: c.int, code: c.int, ptr: rawptr, len: c.int) -> c.int ---
  sceNetSyscallDescriptorClose :: proc(id: c.int) -> c.int ---
  sceNetSyscallDescriptorCreate :: proc(name: cstring, flags: c.int) -> c.int ---
  sceNetSyscallDescriptorCtl :: proc(id: c.int, op: c.int, s: c.int, info: rawptr) -> c.int ---
  sceNetSyscallDumpAbort :: proc(id: c.int, flags: c.int) -> c.int ---
  sceNetSyscallDumpClose :: proc(id: c.int) -> c.int ---
  sceNetSyscallDumpCreate :: proc(name: cstring, len: c.int, flags: c.int) -> c.int ---
  sceNetSyscallDumpRead :: proc(id: c.int, buf: rawptr, len: c.int, pflags: rawptr) -> c.int ---
  sceNetSyscallEpollAbort :: proc(eid: c.int, flags: c.int) -> c.int ---
  sceNetSyscallEpollClose :: proc(eid: c.int) -> c.int ---
  sceNetSyscallEpollCreate :: proc(name: cstring, flags: c.int) -> c.int ---
  sceNetSyscallEpollCtl :: proc(eid: c.int, op: c.int, id: c.int, event: rawptr) -> c.int ---
  sceNetSyscallEpollWait :: proc(param: ^SceNetSyscallParameter) -> c.int ---

  /**
  * @brief Get net if list
  *
  * @param[out] list - The output buffer list. size is (0x140 * n)
  * @param[in]  n    - The output size number.
  *
  * @return 0 on success, < 0 on error.
  */
  sceNetSyscallGetIfList :: proc(list: rawptr, n: c.int) -> c.int ---

  sceNetSyscallGetSockinfo :: proc(s: c.int, ptr: rawptr, n: c.int, flags: c.int) -> c.int ---
  sceNetSyscallGetpeername :: proc(s: c.int, name: rawptr, namelen: rawptr) -> c.int ---
  sceNetSyscallGetsockname :: proc(s: c.int, name: rawptr, namelen: rawptr) -> c.int ---
  sceNetSyscallGetsockopt :: proc(param: ^SceNetSyscallParameter) -> c.int ---
  sceNetSyscallIcmConnect :: proc(s: c.int, flags: c.int) -> c.int ---
  sceNetSyscallIoctl :: proc(s: c.int, com: c.uint, data: rawptr) -> c.int ---
  sceNetSyscallListen :: proc(s: c.int, backlog: c.int) -> c.int ---
  sceNetSyscallRecvfrom :: proc(param: ^SceNetSyscallParameter) -> c.int ---
  sceNetSyscallRecvmsg :: proc(s: c.int, msg: rawptr, flags: c.int) -> c.int ---
  sceNetSyscallSendmsg :: proc(s: c.int, msg: rawptr, flags: c.int) -> c.int ---
  sceNetSyscallSendto :: proc(param: ^SceNetSyscallParameter) -> c.int ---
  sceNetSyscallSetsockopt :: proc(param: ^SceNetSyscallParameter) -> c.int ---
  sceNetSyscallShutdown :: proc(s: c.int, how: c.int) -> c.int ---
  sceNetSyscallSocket :: proc(name: cstring, domain: c.int, type: c.int, protocol: c.int) -> c.int ---
  sceNetSyscallSocketAbort :: proc(s: c.int, flags: c.int) -> c.int ---
  sceNetSyscallSysctl :: proc(param: ^SceNetSyscallParameter) -> c.int ---
}

