#+build vita
package vita

import "core:c"

foreign import libkernel "system:SceLibKernel_stub"
foreign import libc "system:c"

SceClibMspace :: distinct rawptr

SceClibMspaceStats :: struct {
    capacity:       SceSize, //!< Capacity of the Mspace
    unk:            SceSize, //!< Unknown, value is equal to capacity
    peak_in_use:    SceSize, //!< Peak memory allocated
    current_in_use: SceSize, //!< Current memory allocated
}
#assert(size_of(SceClibMspaceStats) == 0x10)

@(default_calling_convention="c")
foreign libkernel {
    sceClibAbort :: proc() ---

    sceClibLookCtypeTable :: proc(ch: c.char) -> c.char ---

    sceClibTolower :: proc(ch: c.char) -> c.int ---
    sceClibToupper :: proc(ch: c.char) -> c.int ---

    sceClibPrintf :: proc(fmt: cstring, #c_vararg args: ..any) -> c.int ---
    sceClibDprintf :: proc(fd: SceUID, fmt: cstring, #c_vararg args: ..any) -> c.int ---

    sceClibSnprintf :: proc(dst: cstring, dst_max_size: SceSize, fmt: cstring, #c_vararg args: ..any) -> c.int ---
    sceClibVsnprintf :: proc(dst: cstring, dst_max_size: SceSize, fmt: cstring, args: c.va_list) -> c.int ---

    sceClibStrncpy :: proc(dst: cstring, src: cstring, len: SceSize) -> cstring ---
    sceClibStrncat :: proc(dst: cstring, src: cstring, len: SceSize) -> cstring ---

    sceClibStrchr :: proc(s: cstring, ch: c.int) -> cstring ---
    sceClibStrrchr :: proc(src: cstring, ch: c.int) -> cstring ---
    sceClibStrstr :: proc(s1, s2: cstring) -> cstring ---

    sceClibStrcmp :: proc(s1, s2: cstring) -> c.int ---
    sceClibStrncmp :: proc(s1, s2: cstring, len: SceSize) -> c.int ---
    sceClibStrncasecmp :: proc(s1, s2: cstring, len: SceSize) -> c.int ---

    sceClibStrnlen :: proc(s1: cstring, max_len: SceSize) -> SceSize ---

    sceClibMemset :: proc(dst: rawptr, ch: c.int, len: SceSize) -> rawptr ---
    sceClibMemcpy :: proc(dst: rawptr, src: rawptr, len: SceSize) -> rawptr ---
    sceClibMemcpy_safe :: proc(dst: rawptr, src: rawptr, len: SceSize) -> rawptr ---
    sceClibMemmove :: proc(dst: rawptr, src: rawptr, len: SceSize) -> rawptr ---

    sceClibMemcmp :: proc(s1: rawptr, s2: rawptr, len: SceSize) -> c.int ---

    sceClibMemchr :: proc(src: rawptr, ch: c.int, len: SceSize) -> rawptr ---

    sceClibMspaceCreate :: proc(memblock: rawptr, size: SceSize) -> SceClibMspace ---
    sceClibMspaceDestroy :: proc(mspace: SceClibMspace) ---

    sceClibMspaceMallocUsableSize :: proc(ptr: rawptr) -> SceSize ---
    sceClibMspaceIsHeapEmpty :: proc(mspace: SceClibMspace) -> SceBool ---

    sceClibMspaceMallocStats :: proc(mspace: SceClibMspace, stats: ^SceClibMspaceStats) ---
    sceClibMspaceMallocStatsFast :: proc(mspace: SceClibMspace, stats: ^SceClibMspaceStats) ---

    sceClibMspaceMalloc :: proc(mspace: SceClibMspace, size: SceSize) -> rawptr ---
    sceClibMspaceCalloc :: proc(mspace: SceClibMspace, num: SceSize , size: SceSize) -> rawptr ---
    sceClibMspaceRealloc :: proc(mspace: SceClibMspace, ptr: rawptr, size: SceSize) -> rawptr ---
    sceClibMspaceReallocalign :: proc(mspace: SceClibMspace, ptr: rawptr, size: SceSize, alignment: SceSize) -> rawptr ---
    sceClibMspaceMemalign :: proc(mspace: SceClibMspace, alignment: SceSize, size: SceSize) -> rawptr ---
    sceClibMspaceFree :: proc(mspace: SceClibMspace, ptr: rawptr) ---
}
