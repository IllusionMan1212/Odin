#+build vita
package vita

import "core:c"

foreign import musicexport "system:SceMusicExport_stub"

MusicExportParam :: struct {
  reserved: [128]c.char,  //!< Reserved data
}
#assert(size_of(MusicExportParam) == 0x80)

foreign musicexport {
  sceMusicExportFromFile :: proc(
    path: cstring,
    #by_ptr param: MusicExportParam,
    workingMemory: rawptr,
    cancelCb: rawptr,
    progress: #type ^proc "c" (_: rawptr, __: c.int),
    user: rawptr,
    outPath: cstring,
    outPathSize: SceSize) -> c.int ---
}

