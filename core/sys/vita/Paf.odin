#+build vita
package vita

import "core:c"

foreign import paf "system:ScePaf_stub"

scePafGraphicsCurrentWave :: SceUInt32

ScePafDateTime :: struct {
    data:      SceDateTime,
    data_0x10: c.int,
    data_0x14: c.int,
}
#assert(size_of(ScePafDateTime) == 0x18)

ScePafSha1Context :: struct {
    // size is 0x68
    h:   [5]c.uint32_t,
    unk: [0x54]c.char,
}
#assert(size_of(ScePafSha1Context) == 0x68)

ScePafHeapContext :: struct {
    // size is 0x60-bytes
    vtable:            rawptr,
    heap:              rawptr,
    membase:           rawptr,
    size:              SceSize,
    name:              [0x20]c.char,
    is_import_membase: SceChar8,
    is_skip_debug_msg: SceChar8,
    data_0x32:         c.char,
    data_0x33:         c.char, // maybe unused. just for align.
    data_0x34:         c.int, // maybe unused. just for align.
    lw_mtx:            SceKernelLwMutexWork,
    memblk_id:         SceUID,

    /*
	 * !1 : Game
	 *  1 : CDialog
	 */
    mode:              SceInt32,
}

ScePafHeapOpt :: struct {
    // size is 0x14-bytes
    a1:                c.int,
    a2:                c.int,
    is_skip_debug_msg: SceChar8,
    a3:                [3]c.char,
    mode:              SceInt32,
    a5:                c.int,
}
#assert(size_of(ScePafHeapOpt) == 0x14)

foreign paf {

    /**
    * Update the current wave
    *
    * @param[in] index           - The index from 0 to 0x1F within range.
    * @param[in] update_interval - The update interval. 0.0f to it will change soon. 1.0f will slowly turn into an updated wave after 1 second, just like when you change it the normal way.
    *
    * @return 0 on success, <0 otherwise.
    */
    scePafGraphicsUpdateCurrentWave :: proc(index: SceUInt32, update_interval: SceFloat32) -> c.int ---

    scePafGetCurrentClockLocalTime :: proc(data: ^ScePafDateTime) -> c.int ---

    scePafSha1Init :: proc(_context: ^ScePafSha1Context) -> c.int ---
    scePafSha1Update :: proc(_context: ^ScePafSha1Context, data: rawptr, length: SceSize) -> c.int ---
    scePafSha1Result :: proc(_context: ^ScePafSha1Context, dst: rawptr) -> c.int ---

    scePafCreateHeap :: proc(_context: ^ScePafHeapContext, membase: rawptr, size: SceSize, name: cstring, opt: ^ScePafHeapOpt) ---
    scePafDeleteHeap :: proc(_context: ^ScePafHeapContext) ---

    scePafMallocWithContext :: proc(_context: ^ScePafHeapContext, len: SceSize) -> rawptr ---
    scePafFreeWithContext :: proc(_context: ^ScePafHeapContext, ptr: rawptr) ---

    scePafMallocAlignWithContext :: proc(_context: ^ScePafHeapContext, align: SceUInt32, len: SceSize) -> rawptr ---
    scePafReallocWithContext :: proc(_context: ^ScePafHeapContext, ptr: rawptr, len: SceSize) -> rawptr ---

    sce_paf_malloc :: proc(size: SceSize) -> rawptr ---
    sce_paf_free :: proc(ptr: rawptr) ---

    /**
    * @brief Alloc memory with align
    *
    * @param[in] align  The align size
    * @param[in] length The alloc length
    *
    * @return memory pointer or NULL
    */
    sce_paf_memalign :: proc(align: SceSize, length: SceSize) -> rawptr ---

    sce_paf_memchr :: proc(src: rawptr, ch: c.int, length: SceSize) -> rawptr ---
    sce_paf_memcmp :: proc(s1: rawptr, s2: rawptr, n: SceSize) -> c.int ---

    sce_paf_memcpy :: proc(dst: rawptr, src: rawptr, len: SceSize) -> rawptr ---
    sce_paf_memset :: proc(dst: rawptr, ch: c.int, len: SceSize) -> rawptr ---
    sce_paf_memmove :: proc(dst: rawptr, src: rawptr, len: SceSize) -> rawptr ---

    sce_paf_snprintf :: proc(dst: cstring, max: c.uint, fmt: cstring, #c_vararg args: ..any) -> c.int ---
    sce_paf_vsnprintf :: proc(dst: cstring, max: c.uint, fmt: cstring, arg: c.va_list) -> c.int ---

    sce_paf_bcmp :: proc(ptr1: rawptr, ptr2: rawptr, num: SceSize) -> c.int ---
    sce_paf_bcopy :: proc(dst: rawptr, src: rawptr, n: SceSize) -> rawptr ---
    sce_paf_bzero :: proc(dst: rawptr, n: SceSize) -> rawptr ---

    sce_paf_strchr :: proc(s: cstring, ch: c.int) -> ^c.char ---
    sce_paf_strcmp :: proc(s1: cstring, s2: cstring) -> c.int ---
    sce_paf_strlen :: proc(s: cstring) -> c.size_t ---
    sce_paf_strcasecmp :: proc(s1: cstring, s2: cstring) -> c.int ---
    sce_paf_strncasecmp :: proc(s1: cstring, s2: cstring, len: SceSize) -> c.int ---
    sce_paf_strncmp :: proc(s1: cstring, s2: cstring, len: SceSize) -> c.int ---
    sce_paf_strncpy :: proc(dst: cstring, src: cstring, len: SceSize) -> cstring ---
    sce_paf_strrchr :: proc(s: cstring, ch: c.int) -> ^c.char ---

    /**
    * @brief string to double
    *
    * @param[in]  nptr   The input float string
    * @param[out] endptr The float string endpoint
    *
    * @return parsed value
    */
    sce_paf_strtod :: proc(nptr: cstring, endptr: ^^c.char) -> c.double ---
}

