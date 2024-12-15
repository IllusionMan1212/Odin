#+build vita
package vita

import "core:c"

foreign import sqlite "system:SceSqlite_stub"

SceSqliteMallocMethods :: struct {
  xMalloc: #type ^proc "c" (_: c.int) -> rawptr,
  xRealloc: #type ^proc "c" (_: rawptr, __: c.int) -> rawptr,
  xFree: #type ^proc "c" (_: rawptr),
}

foreign sqlite {
  /**
  * Wrapper for sqlite3_config(SQLITE_CONFIG_MALLOC)
  *
  * @param[in] methods - A proper set of memory allocation methods
  *
  * @return 0 on success, < 0 on error.
  */
  sceSqliteConfigMallocMethods :: proc(methods: ^SceSqliteMallocMethods) -> c.int ---
}

