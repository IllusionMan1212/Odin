#+build vita
#+private
package mem_virtual

import "base:runtime"
import "core:sys/vita"

@(private="file", require_results)
align_formula :: #force_inline proc "contextless" (size, align: uint) -> uint {
	result := size + align-1
	return result - result%align
}

_reserve :: proc "contextless" (size: uint) -> (data: []byte, err: Allocator_Error) {
	// TODO: aligning the memory here causes there to be "unreachable" bytes when using arenas
	// the correct solution would be to align the memory to 4096 (or DEFAULT_PAGE_SIZE) in memory_block_alloc in virtual.odin.
	// That function already does the alignment but it does it BEFORE adding the size_of(Platform_Memory_Block) to total_size,
	// the alignment should happen to total_size too imo.
	// The Vita requires that the allocated memory is a multiple of 4096
	size := align_formula(size, 4096)
	blkid := vita.sceKernelAllocMemBlock("virtual", vita.SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_RW, auto_cast size, nil)
	if blkid == transmute(vita.SceUID)vita.SceKernelErrorCode.NO_MEMORY {
		return nil, .Out_Of_Memory
	} else if blkid == transmute(vita.SceUID)vita.SceKernelErrorCode.ILLEGAL_MEMBLOCK_SIZE {
		return nil, .Invalid_Argument
	}

	addr: rawptr
	vita.sceKernelGetMemBlockBase(blkid, &addr)

	return (cast([^]byte)addr)[:size], nil
}

_commit :: proc "contextless" (data: rawptr, size: uint) -> Allocator_Error {
	return nil
}

_decommit :: proc "contextless" (data: rawptr, size: uint) {
}

_release :: proc "contextless" (data: rawptr, size: uint) {
	blkid := vita.sceKernelFindMemBlockByAddr(data, auto_cast size)
	vita.sceKernelFreeMemBlock(blkid)
}

_protect :: proc "contextless" (data: rawptr, size: uint, flags: Protect_Flags) -> bool {
	return false
}

_platform_memory_init :: proc() {
	DEFAULT_PAGE_SIZE = 4096
	// is power of two
	//assert(DEFAULT_PAGE_SIZE != 0 && (DEFAULT_PAGE_SIZE & (DEFAULT_PAGE_SIZE-1)) == 0)
}

_map_file :: proc "contextless" (fd: uintptr, size: i64, flags: Map_File_Flags) -> (data: []byte, error: Map_File_Error) {
	return nil, .Map_Failure
}
