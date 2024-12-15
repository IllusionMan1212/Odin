#+build vita
package vita

foreign import sblacmgr "system:SceSblACMgr_stub"

foreign sblacmgr {
  sceSblACMgrIsGameProgram :: proc(result: ^SceBool) -> SceInt32 ---
}

