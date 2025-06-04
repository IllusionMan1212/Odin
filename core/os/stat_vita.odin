#+build vita
package os

import "core:sys/vita"
import "core:time"

lstat :: proc(name: string, allocator := context.allocator) -> (File_Info, Error) {
	return File_Info{}, .ENOSYS
}

stat :: proc(name: string, allocator := context.allocator) -> (File_Info, Error) {
	return File_Info{}, .ENOSYS
}

fstat :: proc(fd: Handle, allocator := context.allocator) -> (fi: File_Info, errno: Error) {
	return fi, .ENOSYS
	//stat: vita.SceIoStat
	//ret := vita.sceIoGetstatByFd(vita.SceUID(fd), &stat)

	//context.allocator = allocator

	//atime: vita.SceUInt64
	//ctime: vita.SceUInt64
	//mtime: vita.SceUInt64
	//vita.sceRtcGetTime64_t(stat.st_atime, &atime)
	//vita.sceRtcGetTime64_t(stat.st_ctime, &ctime)
	//vita.sceRtcGetTime64_t(stat.st_mtime, &mtime)

	//fi.size = auto_cast stat.st_size
	//fi.mode = auto_cast stat.st_mode
	////fi.fullpath
	////fi.name
	//fi.is_dir = (stat.st_attr & cast(u32)vita.SceIoFileMode.SO_IFDIR) == cast(u32)vita.SceIoFileMode.SO_IFDIR
	//fi.access_time = time.unix(0, i64(atime))
	//fi.creation_time = time.unix(0, i64(ctime))
	//fi.modification_time = time.unix(0, i64(mtime))

	//return fi, ERROR_NONE
}
