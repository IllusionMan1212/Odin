#+build vita
package vita

import "core:c"

foreign import gpues4 "system:SceGpuEs4ForDriver_stub"

foreign gpues4 {
  PVRSRVGetMiscInfoKM :: proc(info: rawptr) -> c.int ---

  ksceGpuGetRegisterDump :: proc(dst: rawptr, size: SceSize) -> c.int ---

  ksceGpuMmuMapMemory :: proc(mmuContext: rawptr, vaddr: c.uint32_t, base: rawptr, size: c.uint32_t, flags: c.uint32_t) -> c.int ---
  ksceGpuMmuUnmapMemory :: proc(mmuContext: rawptr, vaddr: c.uint32_t, size: c.uint32_t) -> c.int ---
}

