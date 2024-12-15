#+build vita
package vita

import "core:c"

foreign import videoexport "system:SceVideoExport_stub"

VideoExportInputParam :: struct {
  path: [1024]c.char, //!< Path of file to be exported
	reserved: [64]c.char, //!< Reserved data
}
#assert(size_of(VideoExportInputParam) == 0x440)

VideoExportOutputParam :: struct {
  path: [1024]c.char, //!< Path of exported file
	reserved: [8]c.char, //!< Reserved data
}
#assert(size_of(VideoExportOutputParam) == 0x408)

foreign videoexport {
  /**
  * Export video file
  *
  * @param[in] in_param - Input param
  * @param[in] unk - Unknown, pass 1
  * @param[in] workingMemory - Working memory
  * @param[in] cancelCb - Cancel callback
  * @param[in] progress - Progress callback
  * @param[in] user - User data passed to the callbacks
  * @param[in] unk2 - Unknown, pass 0
  * @param[out] out_param - Output param
  *
  * @return 0 on success, < 0 on error.
  */
  sceVideoExportFromFile :: proc(
    #by_ptr in_param: VideoExportInputParam,
    unk: c.int,
    workingMemory: rawptr,
    cancelCb: rawptr,
    progress: #type ^proc "c" (_: rawptr, __: c.int),
    user: rawptr,
    unk2: c.int,
    out_param: ^VideoExportOutputParam) -> c.int ---
}

