package os

import "base:runtime"
import "core:c"
import "core:strings"
import vita "core:sys/vita"

Handle :: distinct i32
Errno :: distinct i32

//dev_t :: u32 // ???
//ino_t :: u16 // ???
//
//OS_Stat :: struct {
//	st_dev: dev_t,
//  ino_t		st_ino,
//  mode_t	st_mode,
//  nlink_t	st_nlink,
//  uid_t		st_uid,
//  gid_t		st_gid,
//  dev_t		st_rdev,
//  off_t		st_size,
//#if defined(__svr4__) && !defined(__PPC__) && !defined(__sun__) || defined(__vita__)
//  time_t	st_atime,
//  time_t	st_mtime,
//  time_t	st_ctime,
//#if defined(__vita__)
//  blksize_t     st_blksize,
//  blkcnt_t	st_blocks,
//#endif
//#else
//  struct timespec st_atim,
//  struct timespec st_mtim,
//  struct timespec st_ctim,
//  blksize_t     st_blksize,
//  blkcnt_t	st_blocks,
//#if !defined(__rtems__)
//  long		st_spare4[2],
//#endif
//#endif
//}

INVALID_HANDLE :: ~Handle(0)

ERROR_NONE: Errno: 0
ENOSYS: Errno: -2147352573

O_RDONLY    :: 0x0001                         //!< Read-only
O_WRONLY    :: 0x0002                         //!< Write-only
O_RDWR      :: (O_RDONLY | O_WRONLY)  				//!< Read/Write
O_NBLOCK    :: 0x0004                         //!< Non blocking
O_DIROPEN   :: 0x0008                         //!< Internal use for ::sceIoDopen
O_RDLOCK    :: 0x0010                         //!< Read locked (non-shared)
O_WRLOCK    :: 0x0020                         //!< Write locked (non-shared)
O_APPEND    :: 0x0100                         //!< Append
O_CREATE    :: 0x0200                         //!< Create
O_TRUNC     :: 0x0400                         //!< Truncate
O_EXCL      :: 0x0800                         //!< Exclusive create
O_SCAN      :: 0x1000                         //!< Scan type
O_RCOM      :: 0x2000                         //!< Remote command entry
O_NOBUF     :: 0x4000                         //!< Number device buffer
O_NOWAIT    :: 0x8000                         //!< Asynchronous I/O
O_FDEXCL    :: 0x01000000                     //!< Exclusive access
O_PWLOCK    :: 0x02000000                     //!< Power control lock
O_FGAMEDATA :: 0x40000000                      //!< Gamedata access

stdin := Handle(vita.sceKernelGetStdin())
stdout := Handle(vita.sceKernelGetStdout())
stderr := Handle(vita.sceKernelGetStderr())

//foreign libc {
//	@(link_name="__error")	__errno_location		:: proc() -> ^c.int ---
//
//	@(link_name="stat")             _unix_stat          :: proc(path: cstring, stat: ^OS_Stat) -> c.int ---
//	@(link_name="lstat")            _unix_lstat         :: proc(path: cstring, sb: ^OS_Stat) -> c.int ---
//	@(link_name="fstat")            _unix_fstat         :: proc(fd: Handle, stat: ^OS_Stat) -> c.int ---
//}

is_path_separator :: proc(r: rune) -> bool {
	return r == '/'
}

// NOTE(illusion): mode has to be 0o777, otherwise sceIoOpen errors
open :: proc(path: string, flags: int = O_RDONLY, mode: int = 0o777) -> (Handle, Errno) {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
	cstr := strings.clone_to_cstring(path, context.temp_allocator)
	handle := vita.sceIoOpen(cstr, cast(vita.SceIoMode)flags, auto_cast mode)
	if handle < 0 {
		return INVALID_HANDLE, auto_cast handle
	}
	return Handle(handle), ERROR_NONE
}

close :: proc(fd: Handle) -> Errno {
	return auto_cast vita.sceIoClose(vita.SceUID(fd))
}

// If you read or write more than `SSIZE_MAX` bytes, result is implementation defined (probably an error).
// `SSIZE_MAX` is also implementation defined but usually the max of a `ssize_t` which is `max(int)` in Odin.
// In practice a read/write call would probably never read/write these big buffers all at once,
// which is why the number of bytes is returned and why there are procs that will call this in a
// loop for you.
// We set a max of 1GB to keep alignment and to be safe.
@(private)
MAX_RW :: 1 << 30

read :: proc(fd: Handle, data: []byte) -> (int, Errno) {
	if len(data) == 0 {
		return 0, ERROR_NONE
	}

	to_read := min(uint(len(data)), MAX_RW)

	bytes_read := vita.sceIoRead(vita.SceUID(fd), raw_data(data), auto_cast to_read)
	if bytes_read < 0 {
		return -1, auto_cast bytes_read
	}
	return auto_cast bytes_read, ERROR_NONE
}

write :: proc(fd: Handle, data: []byte) -> (int, Errno) {
	if len(data) == 0 {
		return 0, ERROR_NONE
	}

	to_write := min(uint(len(data)), MAX_RW)

	bytes_written := vita.sceIoWrite(vita.SceUID(fd), raw_data(data), auto_cast to_write)
	if bytes_written < 0 {
		return -1, auto_cast bytes_written
	}
	return auto_cast bytes_written, ERROR_NONE
}

read_at :: proc(fd: Handle, data: []byte, offset: i64) -> (int, Errno) {
	if len(data) == 0 {
		return 0, ERROR_NONE
	}

	to_read := min(uint(len(data)), MAX_RW)

	bytes_read := vita.sceIoPread(vita.SceUID(fd), raw_data(data), auto_cast to_read, auto_cast offset)
	if bytes_read < 0 {
		return -1, auto_cast bytes_read
	}
	return auto_cast bytes_read, ERROR_NONE
}

write_at :: proc(fd: Handle, data: []byte, offset: i64) -> (int, Errno) {
	if len(data) == 0 {
		return 0, ERROR_NONE
	}

	to_write := min(uint(len(data)), MAX_RW)

	bytes_written := vita.sceIoPwrite(vita.SceUID(fd), raw_data(data), auto_cast to_write, auto_cast offset)
	if bytes_written < 0 {
		return -1, auto_cast bytes_written
	}
	return auto_cast bytes_written, ERROR_NONE
}

seek :: proc(fd: Handle, offset: i64, whence: int) -> (i64, Errno) {
	res := vita.sceIoLseek(vita.SceUID(fd), auto_cast offset, auto_cast whence)
	if res < 0 {
		return -1, auto_cast res
	}
	return i64(res), ERROR_NONE
}

file_size :: proc(fd: Handle) -> (i64, Errno) {
	s: vita.SceIoStat = ---
	err := vita.sceIoGetstatByFd(vita.SceUID(fd), &s)
	if err < 0 {
		return -1, auto_cast err
	}
	return s.st_size, ERROR_NONE
}

@(private)
_processor_core_count :: proc() -> int {
	return 4
}

exit :: proc "contextless" (code: int) -> ! {
	context = runtime.default_context()
	runtime._cleanup_runtime_contextless()
	vita.sceKernelExitProcess(auto_cast code)
	unreachable()
}

current_thread_id :: proc "contextless" () -> int {
	return cast(int)vita.sceKernelGetThreadId()
}

// NOTE(illusion): mode has to be 0o777, otherwise sceIoMkdir errors
// NOTE(illusion): the vita implementation cannot recursively create directories and WILL fail if a parent dir doesn't exist.
make_directory :: proc(path: string, mode: u32 = 0o777) -> Errno {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
	path_cstr := strings.clone_to_cstring(path, context.temp_allocator)
	return Errno(vita.sceIoMkdir(path_cstr, vita.SceMode(mode)))
}

exists :: proc(path: string) -> bool {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
	cpath := strings.clone_to_cstring(path, context.temp_allocator)
	stat: vita.SceIoStat
	res := vita.sceIoGetstat(cpath, &stat)
	return res == 0
}

//get_last_error :: proc "contextless" () -> int {
//	return int(__errno_location()^)
//}

//@private
//_stat :: proc(path: string) -> (OS_Stat, Errno) {
//	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
//	cstr := strings.clone_to_cstring(path, context.temp_allocator)
//	s: OS_Stat = ---
//	result := _unix_lstat(cstr, &s)
//	if result == -1 {
//		return s, Errno(get_last_error())
//	}
//	return s, ERROR_NONE
//}
//
//@private
//_lstat :: proc(path: string) -> (OS_Stat, Errno) {
//	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
//	cstr := strings.clone_to_cstring(path, context.temp_allocator)
//	
//	// deliberately uninitialized
//	s: OS_Stat = ---
//	res := _unix_lstat(cstr, &s)
//	if res == -1 {
//		return s, Errno(get_last_error())
//	}
//	return s, ERROR_NONE
//}
//
//@private
//_fstat :: proc(fd: Handle) -> (OS_Stat, Errno) {
//	s: OS_Stat = ---
//	result := _unix_fstat(fd, &s)
//	if result == -1 {
//		return s, Errno(get_last_error())
//	}
//	return s, ERROR_NONE
//}

