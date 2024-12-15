#+build vita
package vita

import "core:c"

foreign import libkernel "system:SceLibKernel_stub"
foreign import iofilemgr "system:SceIofilemgr_stub"
foreign import iofilemgrkern "system:SceIofilemgrForDriver_stub"

SceIoDevInfo :: struct {
  max_size: SceOff,
	free_size: SceOff,
	cluster_size: SceSize,
	unk: rawptr,
}

/* Note: Not all of these sceIoOpen() flags are not compatible with the
   open() flags found in sys/unistd.h. */
SceIoMode :: enum c.int {
	O_RDONLY    = 0x0001,                         //!< Read-only
	O_WRONLY    = 0x0002,                         //!< Write-only
	O_RDWR      = (O_RDONLY | O_WRONLY),  //!< Read/Write
	O_NBLOCK    = 0x0004,                         //!< Non blocking
	O_DIROPEN   = 0x0008,                         //!< Internal use for ::sceIoDopen
	O_RDLOCK    = 0x0010,                         //!< Read locked (non-shared)
	O_WRLOCK    = 0x0020,                         //!< Write locked (non-shared)
	O_APPEND    = 0x0100,                         //!< Append
	O_CREAT     = 0x0200,                         //!< Create
	O_TRUNC     = 0x0400,                         //!< Truncate
	O_EXCL      = 0x0800,                         //!< Exclusive create
	O_SCAN      = 0x1000,                         //!< Scan type
	O_RCOM      = 0x2000,                         //!< Remote command entry
	O_NOBUF     = 0x4000,                         //!< Number device buffer
	O_NOWAIT    = 0x8000,                         //!< Asynchronous I/O
	O_FDEXCL    = 0x01000000,                     //!< Exclusive access
	O_PWLOCK    = 0x02000000,                     //!< Power control lock
	O_FGAMEDATA = 0x40000000,                     //!< Gamedata access
}

SceIoSeekMode :: enum c.int {
	SET,   //!< Starts from the begin of the file
	CUR,   //!< Starts from current position
	END    //!< Starts from the end of the file
}

SceIoDevType :: enum c.int {
	NULL     = 0x00, //!< Dummy device
	CHAR     = 0x01, //!< Character device
	BLOCK    = 0x04, //!< Block device
	FS       = 0x10, //!< File system device
	ALIAS    = 0x20, //!< Alias name
	MOUNTPT  = 0x40  //!< Mount point
}


/**
  * Access modes for st_mode in ::SceIoStat.
  *
  * @note
  * System always requires RW access.
  * For safe homebrew system software will force system permission field to RW.
  * For unsafe homebrew, you need to set it yourself `( mode | SCE_S_IWSYS | SCE_S_IRSYS)`
  *
  */
SceIoAccessMode :: enum c.int {
	S_IXUSR		= 000100, //!< User execute permission
	S_IWUSR		= 000200, //!< User write permission
	S_IRUSR		= 000400, //!< User read permission
	S_IRWXU		= 000700, //!< User access rights mask

	S_IXGRP		= 000000, //!< Group execute permission. Ignored and reset to 0 by system
	S_IWGRP		= 000000, //!< Group write permission. Ignored and reset to 0 by system
	S_IRGRP		= 000000, //!< Group read permission. Ignored and reset to 0 by system
	S_IRWXG		= 000000, //!< Group access rights mask. Ignored and reset to 0 by system

	S_IXSYS		= 000001, //!< System execute permission
	S_IWSYS		= 000002, //!< System write permission
	S_IRSYS		= 000004, //!< System read permission
	S_IRWXS		= 000007, //!< System access rights mask

  // Deprecated
	S_IXOTH		= 000001, //!< Others execute permission. Deprecated, use ::SCE_S_IXSYS
  // Deprecated
	S_IWOTH		= 000002, //!< Others write permission. Deprecated, use ::SCE_S_IXSYS
  // Deprecated
	S_IROTH		= 000004, //!< Others read permission. Deprecated, use ::SCE_S_IXSYS
  // Deprecated
	S_IRWXO		= 000007, //!< Others access rights mask. Deprecated, use ::SCE_S_IRWXS

  // Deprecated
	S_ISVTX		= 000000, //!< Sticky. Deprecated
  // Deprecated
	S_ISGID		= 000000, //!< Set GID. Deprecated
  // Deprecated
	S_ISUID		= 000000, //!< Set UID. Deprecated

	S_IFDIR		= 0010000, //!< Directory
	S_IFREG		= 0020000, //!< Regular file
	S_IFLNK		= 0040000, //!< Symbolic link
	S_IFMT		= 0170000, //!< Format bits mask
}

/** File modes, used for the st_attr parameter in ::SceIoStat. */
SceIoFileMode :: enum c.int {
	SO_IXOTH            = 0x0001,               //!< Hidden execute permission
	SO_IWOTH            = 0x0002,               //!< Hidden write permission
	SO_IROTH            = 0x0004,               //!< Hidden read permission
	SO_IFLNK            = 0x0008,               //!< Symbolic link
	SO_IFDIR            = 0x0010,               //!< Directory
	SO_IFREG            = 0x0020,               //!< Regular file
	SO_IFMT             = 0x0038,               //!< Format mask
}

/** Structure to hold the status information about a file */
SceIoStat :: struct {
  st_mode: SceMode,             //!< One or more ::SceIoAccessMode
	st_attr: c.uint,        //!< One or more ::SceIoFileMode
	st_size: SceOff,              //!< Size of the file in bytes
	st_ctime: SceDateTime,        //!< Creation time
	st_atime: SceDateTime,        //!< Last access time
	st_mtime: SceDateTime,        //!< Last modification time
	st_private: [6]c.uint,  //!< Device-specific data
}
#assert(size_of(SceIoStat) == 0x58)

/** Defines for `sceIoChstat` and `sceIoChstatByFd` **/
SCE_CST_MODE :: 0x0001
SCE_CST_SIZE :: 0x0004
SCE_CST_CT   :: 0x0008
SCE_CST_AT   :: 0x0010
SCE_CST_MT   :: 0x0020


/** Describes a single directory entry */
SceIoDirent :: struct {
  d_stat: SceIoStat, //!< File status
	d_name: [256]c.char, //!< File name
	d_private: rawptr,  //!< Device-specific data
	dummy: c.int,        //!< Dummy data
}

foreign libkernel {
  /**
  * Send a devctl command to a device.
  *
  * @par Example: Sending a simple command to a device
  * @code
  * SceIoDevInfo info
  * sceIoDevctl :: proc("ux00x3001: :",, NULL, 0, &info, sizeof(SceIoDevInfo))
  * @endcode
  *
  * @ :: procparam dev- String:  for the device to send the devctl to (e.g. "ux0:")
  * @param cmd - The command to send to the device
  * @param indata - A data block to send to the device, if NULL sends no data
  * @param inlen - Length of indata, if 0 sends no data
  * @param outdata - A data block to receive the result of a command, if NULL receives no  -> c.int ---
  * @param outlen - Length of outdata, if 0 receives no data
  * @return 0 on success, < 0 on error
  */
  sceIoDevctl :: proc(dev: cstring, cmd: c.uint, indata: rawptr, inlen: c.int, outdata: rawptr, outlen: c.int) -> c.int ---

  /**
  * Perform an ioctl on a device.
  *
  * @param fd - Opened file descriptor to ioctl to
  * @param cmd - The command to send to the device
  * @param indata - A data block to send to the device, if NULL :: procno: ^sends data
  * @param - Length of indata, if 0 sends no data -> c.int ---
  * @param outdata - A data block to receive the result of a command, if NULL receives no data
  * @param outlen - Length of outdata, if 0 receives no data
  * @return 0 on success, < 0 on error
  */
  sceIoIoctl :: proc(fd: SceUID, cmd: c.uint, indata: rawptr, inlen: c.int, outdata: rawptr, outlen: c.int) -> c.int ---

  /**
  * Perform an ioctl :: proc a device: c.in. asynchronous: ^)
  -> c.int ---
  * @param fd - Opened file descriptor to ioctl to
  * @param cmd - The command to send to the device
  * @param indata - A data block to send to the device, if NULL sends no data
  * @param inlen - Length of indata, if 0 sends no data
  * @param outdata - A data block to receive the result of a command, if NULL receives no data
  * @param outlen - Length of outdata, if 0 receives no data
  * @return 0 on success, < 0 on error
  */
  sceIoIoctlAsync :: proc(fd: SceUID, cmd: c.uint, indata: rawptr, inlen: c.int, outdata: rawptr, outlen: c.int) -> c.int ---

  /**
  * Open a directory
  *
  * @par Example:
  * @code
  * int dfd
  * dfd = sceIoDopen("device:/")
  * if(dfd >= 0)
  * { Do something with the file descriptor }
  * @endcode
  * @param dirname - The directory to open for reading.
  * @return If >= 0 then a valid file descriptor, otherwise a Sony error code.
  */
  sceIoDopen :: proc(dirname: cstring) -> SceUID ---

  /**
  * Reads an entry from an opened file descriptor.
  *
  * @param fd - Already opened file descriptor (using ::sceIoDopen)
  * @param dir - Pointer to a ::SceIoDirent structure to hold the file information
  *
  * @return Read status
  * -   0 - No more directory entries left
  * - > 0 - More directory entries to go
  * - < 0 - Error
  */
  sceIoDread :: proc(fd: SceUID, dir: ^SceIoDirent) -> c.int ---

  /**
  * Close an opened directory file descriptor
  *
  * @param fd - Already opened file descriptor (using ::sceIoDopen)
  * @return < 0 on error
  */
  sceIoDclose :: proc(fd: SceUID) -> c.int ---

  /**
  * Make a directory file
  *
  * @param dir - The path to the directory
  * @param mode - Access mode (One or more ::SceIoAccessMode).
  * @return Returns the value 0 if it's successful, otherwise -1
  */
  sceIoMkdir :: proc(dir: cstring, mode: SceMode) -> c.int ---

  /**
  * Remove a directory file
  *
  * @param path - Removes a directory file pointed by the string path
  * @return Returns the value 0 if it's successful, otherwise -1
  */
  sceIoRmdir :: proc(path: cstring) -> c.int ---

  /**
  * Get the status of a file.
  *
  * @param file - The path to the file.
  * @param stat - A pointer to a ::SceIoStat structure.
  *
  * @return < 0 on error.
  */
  sceIoGetstat :: proc(file: cstring, stat: ^SceIoStat) -> c.int ---

  /**
  * Get the status of a file descriptor.
  *
  * @param fd - The file descriptor.
  * @param stat - A pointer to a ::SceIoStat structure.
  *
  * @return < 0 on error.
  */
  sceIoGetstatByFd :: proc(fd: SceUID, stat: ^SceIoStat) -> c.int ---

  /**
  * Change the status of a file.
  *
  * @param file - The path to the file.
  * @param stat - A pointer to a ::SceIoStat structure.
  * @param bits - Bitmask defining which bits to change.
  *
  * @return < 0 on error.
  */
  sceIoChstat :: proc(file: cstring, stat: ^SceIoStat, bits: c.int) -> c.int ---

  /**
  * Change the status of a file descriptor.
  *
  * @param fd - The file descriptor.
  * @param stat - A pointer to an io_stat_t structure.
  * @param bits - Bitmask defining which bits to change.
  *
  * @return < 0 on error.
  */
  sceIoChstatByFd :: proc(fd: SceUID, buf: ^SceIoStat, cbit: c.uint) -> c.int ---
}

foreign iofilemgr {
  /**
   * Open or create a file for reading or writing
   *
   * @par Example1: Open a file for reading
   * @code
   * if((fd = sceIoOpen("device:/path/to/file", SCE_O_RDONLY, 0777) < 0) {
   * // error code in fd, for example no open filehandle left (0x80010018)
   * }
   * @endcode
   * @par Example2: Open a file for writing, creating it if it doesn't exist
   * @code
   * if((fd = sceIoOpen("device:/path/to/file", SCE_O_WRONLY|SCE_O_CREAT, 0777) < 0) {
   * // error code in fd, for example no open filehandle left (0x80010018)
   * }
   * @endcode
   *
   * @param file - Pointer to a string holding the name of the file to open.
   * @param flags - Libc styled flags that are or'ed together (One or more ::SceIoMode).
   * @param mode - One or more ::SceIoAccessMode flags or'ed together. Can also use Unix absolute permissions.
   * @return > 0 is a valid file handle, < 0 on error.
   */
   sceIoOpen :: proc(file: cstring, flags: SceIoMode, mode: SceMode) -> SceUID ---

  /**
   * Delete a descriptor
   *
   * @code
   * sceIoClose(fd)
   * @endcode
   *
   * @param fd - File descriptor to close
   * @return < 0 on error
   */
  sceIoClose :: proc(fd: SceUID) -> c.int ---

  /**
   * Read input
   *
   * @par Example:
   * @code
   * bytes_read = sceIoRead(fd, data, 100)
   * @endcode
   *
   * @param fd    - Opened file descriptor to read from
   * @param buf   - Pointer to the buffer where the read data will be placed
   * @param nbyte - Size of the read in bytes
   *
   * @return The number of bytes read
   */
  sceIoRead :: proc(fd: SceUID, buf: rawptr, nbyte: SceSize) -> SceSSize ---

  /**
   * Read input at offset
   *
   * @par Example:
   * @code
   * bytes_read = sceIoPread(fd, data, 100, 0x1000)
   * @endcode
   *
   * @param fd - Opened file descriptor to read from
   * @param data - Pointer to the buffer where the read data will be placed
   * @param size - Size of the read in bytes
   * @param offset - Offset to read
   *
   * @return < 0 on error.
   */
  sceIoPread :: proc(fd: SceUID, data: rawptr, size: SceSize, offset: SceOff) -> c.int ---

  /**
   * Write output
   *
   * @par Example:
   * @code
   * bytes_written = sceIoWrite(fd, data, 100)
   * @endcode
   *
   * @param fd    - Opened file descriptor to write to
   * @param buf   - Pointer to the data to write
   * @param nbyte - Size of data to write
   *
   * @return The number of bytes written
   */
  sceIoWrite :: proc(fd: SceUID, buf: rawptr, nbyte: SceSize) -> SceSSize ---

  /**
   * Write output at offset
   *
   * @par Example:
   * @code
   * bytes_written = sceIoPwrite(fd, data, 100, 0x1000)
   * @endcode
   *
   * @param fd - Opened file descriptor to write to
   * @param data - Pointer to the data to write
   * @param size - Size of data to write
   * @param offset - Offset to write
   *
   * @return The number of bytes written
   */
  sceIoPwrite :: proc(fd: SceUID, data: rawptr, size: SceSize, offset: SceOff) -> c.int ---

  /**
   * Reposition read/write file descriptor offset
   *
   * @par Example:
   * @code
   * pos = sceIoLseek(fd, -10, SCE_SEEK_END)
   * @endcode
   *
   * @param fd - Opened file descriptor with which to seek
   * @param offset - Relative offset from the start position given by whence
   * @param whence - One of ::SceIoSeekMode.
   *
   * @return The position in the file after the seek.
   */
  sceIoLseek :: proc(fd: SceUID, offset: SceOff, whence: SceIoSeekMode) -> SceOff ---

  /**
   * Reposition read/write file descriptor offset (32bit mode)
   *
   * @par Example:
   * @code
   * pos = sceIoLseek32(fd, -10, SCE_SEEK_END)
   * @endcode
   *
   * @param fd - Opened file descriptor with which to seek
   * @param offset - Relative offset from the start position given by whence
   * @param whence - One of ::SceIoSeekMode.
   *
   * @return The position in the file after the seek.
   */
  sceIoLseek32 :: proc(fd: SceUID, offset: c.long, whence: SceIoSeekMode) -> c.long ---

  /**
   * Remove directory entry
   *
   * @param file - Path to the file to remove
   * @return < 0 on error
   */
  sceIoRemove :: proc(file: cstring) -> c.int ---

  /**
   * Change the name of a file
   *
   * @param oldname - The old filename
   * @param newname - The new filename
   * @return < 0 on error.
   */
  sceIoRename :: proc(oldname: cstring, newname: cstring) -> c.int ---

  /**
    * Synchronize the file data on the device.
    *
    * @param device - The device to synchronize (e.g. msfat0:)
    * @param unk - Unknown
    */
  sceIoSync :: proc(device: cstring, flag: c.int) -> c.int ---

  /**
   * Synchronize the file data for one file
   *
   * @param fd   - Opened file descriptor to sync
   * @param flag - unknown
   *
   * @return < 0 on error.
   */
  sceIoSyncByFd :: proc(fd: SceUID, flag: c.int) -> c.int ---

  /**
    * Cancel an asynchronous operation on a file descriptor.
    *
    * @param fd - The file descriptor to perform cancel on.
    *
    * @return < 0 on error.
    */
  sceIoCancel :: proc(fd: SceUID) -> c.int ---

  sceIoGetPriority :: proc(fd: SceUID) -> c.int ---
  sceIoGetProcessDefaultPriority :: proc() -> c.int ---
  sceIoGetThreadDefaultPriority :: proc() -> c.int ---
  sceIoSetPriority :: proc(fd: SceUID, priority: c.int) -> c.int ---
  sceIoSetProcessDefaultPriority :: proc(priority: c.int) -> c.int ---
  sceIoSetThreadDefaultPriority :: proc(priority: c.int) -> c.int ---
}

foreign iofilemgrkern {
  /**
  * Send a devctl command to a device.
  *
  * @par Example: Sending a simple command to a device
  * @code
  * SceIoDevInfo info
  * ksceIoDevctl("ux0:", 0x3001, NULL, 0, &info, sizeof(SceIoDevInfo))
  * @endcode
  *
  * @param dev - String for the device to send the devctl to (e.g. "ux0:")
  * @param cmd - The command to send to the device
  * @param indata - A data block to send to the device, if NULL sends no data
  * @param inlen - Length of indata, if 0 sends no data
  * @param outdata - A data block to receive the result of a command, if NULL receives no data
  * @param outlen - Length of outdata, if 0 receives no data
  * @return 0 on success, < 0 on error
  */
  ksceIoDevctl :: proc(dev: cstring, cmd: c.uint, indata: rawptr, inlen: c.int, outdata: rawptr, outlen: c.int) -> c.int ---

  /**
  * Open a directory
  *
  * @par Example:
  * @code
  * int dfd
  * dfd = ksceIoDopen("device:/")
  * if(dfd >= 0)
  * { Do something with the file descriptor }
  * @endcode
  * @param dirname - The directory to open for reading.
  * @return If >= 0 then a valid file descriptor, otherwise a Sony error code.
  */
  ksceIoDopen :: proc(dirname: cstring) -> SceUID ---

  /**
  * Reads an entry from an opened file descriptor.
  *
  * @param fd - Already opened file descriptor (using ::ksceIoDopen)
  * @param dir - Pointer to an ::SceIoDirent structure to hold the file information
  *
  * @return Read status
  * -   0 - No more directory entries left
  * - > 0 - More directory entries to go
  * - < 0 - Error
  */
  ksceIoDread :: proc(fd: SceUID, dir: ^SceIoDirent) -> c.int ---

  /**
  * Close an opened directory file descriptor
  *
  * @param fd - Already opened file descriptor (using ::ksceIoDopen)
  * @return < 0 on error
  */
  ksceIoDclose :: proc(fd: SceUID) -> c.int ---

  /**
   * Open or create a file for reading or writing
   *
   * @par Example1: Open a file for reading
   * @code
   * if(!(fd = ksceIoOpen("device:/path/to/file", SCE_O_RDONLY, 0777)) {
   *	// error
   * }
   * @endcode
   * @par Example2: Open a file for writing, creating it if it doesn't exist
   * @code
   * if(!(fd = ksceIoOpen("device:/path/to/file", SCE_O_WRONLY|SCE_O_CREAT, 0777)) {
   *	// error
   * }
   * @endcode
   *
   * @param file - Pointer to a string holding the name of the file to open
   * @param flags - Libc styled flags that are or'ed together
   * @param mode - File access mode (One or more ::SceIoMode).
   * @return A non-negative integer is a valid fd, anything else an error
   */
  ksceIoOpen :: proc(file: cstring, flags: c.int, mode: SceMode) -> SceUID ---

  /**
   * Delete a descriptor
   *
   * @code
   * ksceIoClose(fd)
   * @endcode
   *
   * @param fd - File descriptor to close
   * @return < 0 on error
   */
  ksceIoClose :: proc(fd: SceUID) -> c.int ---

  /**
   * Read input
   *
   * @par Example:
   * @code
   * bytes_read = ksceIoRead(fd, data, 100)
   * @endcode
   *
   * @param fd - Opened file descriptor to read from
   * @param data - Pointer to the buffer where the read data will be placed
   * @param size - Size of the read in bytes
   *
   * @return The number of bytes read
   */
  ksceIoRead :: proc(fd: SceUID, data: rawptr, size: SceSize) -> c.int ---

  /**
   * Read input at offset
   *
   * @par Example:
   * @code
   * bytes_read = ksceIoPread(fd, data, 100, 0x1000)
   * @endcode
   *
   * @param fd - Opened file descriptor to read from
   * @param data - Pointer to the buffer where the read data will be placed
   * @param size - Size of the read in bytes
   * @param offset - Offset to read
   *
   * @return < 0 on error.
   */
  ksceIoPread :: proc(fd: SceUID, data: rawptr, size: SceSize, offset: SceOff) -> c.int ---

  /**
   * Write output
   *
   * @par Example:
   * @code
   * bytes_written = ksceIoWrite(fd, data, 100)
   * @endcode
   *
   * @param fd - Opened file descriptor to write to
   * @param data - Pointer to the data to write
   * @param size - Size of data to write
   *
   * @return The number of bytes written
   */
  ksceIoWrite :: proc(fd: SceUID, data: rawptr, size: SceSize) -> c.int ---

  /**
   * Write output at offset
   *
   * @par Example:
   * @code
   * bytes_written = ksceIoPwrite(fd, data, 100, 0x1000)
   * @endcode
   *
   * @param fd - Opened file descriptor to write to
   * @param data - Pointer to the data to write
   * @param size - Size of data to write
   * @param offset - Offset to write
   *
   * @return The number of bytes written
   */
  ksceIoPwrite :: proc(fd: SceUID, data: rawptr, size: SceSize, offset: SceOff) -> c.int ---

  /**
   * Reposition read/write file descriptor offset
   *
   * @par Example:
   * @code
   * pos = ksceIoLseek(fd, -10, SCE_SEEK_END)
   * @endcode
   *
   * @param fd - Opened file descriptor with which to seek
   * @param offset - Relative offset from the start position given by whence
   * @param whence - One of ::SceIoSeekMode.
   *
   * @return The position in the file after the seek.
   */
  ksceIoLseek :: proc(fd: SceUID, offset: SceOff, whence: c.int) -> SceOff ---

  /**
   * Remove directory entry
   *
   * @param file - Path to the file to remove
   * @return < 0 on error
   */
  ksceIoRemove :: proc(file: cstring) -> c.int ---

  /**
   * Change the name of a file
   *
   * @param oldname - The old filename
   * @param newname - The new filename
   * @return < 0 on error.
   */
  ksceIoRename :: proc(oldname: cstring, newname: cstring) -> c.int ---

  /**
    * Synchronize the file data on the device.
    *
    * @param device - The device to synchronize (e.g. msfat0:)
    * @param unk - Unknown
    */
  ksceIoSync :: proc(device: cstring, unk: c.uint) -> c.int ---

  /**
   * Synchronize the file data for one file
   *
   * @param fd - Opened file descriptor to sync
   *
   * @return < 0 on error.
   */
  ksceIoSyncByFd :: proc(fd: SceUID) -> c.int ---

  /**
   * Make a directory file
   *
   * @param dir - The path to the directory
   * @param mode - Access mode (One or more ::SceIoAccessMode).
   * @return Returns the value 0 if it's successful, otherwise -1
   */
  ksceIoMkdir :: proc(dir: cstring, mode: SceMode) -> c.int ---

  /**
   * Remove a directory file
   *
   * @param path - Removes a directory file pointed by the string path
   * @return Returns the value 0 if it's successful, otherwise -1
   */
  ksceIoRmdir :: proc(path: cstring) -> c.int ---

  /**
    * Get the status of a file.
    *
    * @param file - The path to the file.
    * @param stat - A pointer to a ::SceIoStat structure.
    *
    * @return < 0 on error.
    */
  ksceIoGetstat :: proc(file: cstring, stat: SceIoStat) -> c.int ---

  /**
    * Get the status of a file descriptor.
    *
    * @param fd - The file descriptor.
    * @param stat - A pointer to a ::SceIoStat structure.
    *
    * @return < 0 on error.
    */
  ksceIoGetstatByFd :: proc(fd: SceUID, stat: ^SceIoStat) -> c.int ---

  /**
    * Change the status of a file.
    *
    * @param file - The path to the file.
    * @param stat - A pointer to a ::SceIoStat structure.
    * @param bits - Bitmask defining which bits to change.
    *
    * @return < 0 on error.
    */
  ksceIoChstat :: proc(file: cstring, stat: ^SceIoStat, bits: c.int) -> c.int ---

  /**
    * Change the status of a file descriptor.
    *
    * @param fd - The file descriptor.
    * @param stat - A pointer to an io_stat_t structure.
    * @param bits - Bitmask defining which bits to change.
    *
    * @return < 0 on error.
    */
  ksceIoChstatByFd :: proc(fd: SceUID, stat: ^SceIoStat, bits: c.int) -> c.int ---
}

