#+build vita
package vita

import "core:c"

PhotoExportParam :: struct {
  version: c.int,                    //!< Version
	photoTitle: [^]SceWChar32,   //!< Photo title
	gameTitle: [^]SceWChar32,    //!< Game title
	gameComment: [^]SceWChar32,  //!< Game description
	reserved: [8]c.int,                //!< Reserved data
}

foreign import photoexport "system:ScePhotoExport_stub"

foreign photoexport {
  scePhotoExportFromData :: proc(data: rawptr, size: SceSize, #by_ptr param: PhotoExportParam, workingMemory: rawptr, cancelCb: rawptr, user: rawptr, outPath: cstring, outPathSize: SceSize) -> c.int ---
  scePhotoExportFromFile :: proc(path: cstring, #by_ptr param: PhotoExportParam, workingMemory: rawptr, cancelCb: rawptr, user: rawptr, outPath: cstring, outPathSize: SceSize) -> c.int ---
}

