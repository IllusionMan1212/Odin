#+build vita
package vita

import "core:c"

foreign import bgapputil "system:SceBgAppUtil_stub"

/**
 * Error Codes
 */
SceBgAppUtilErrorCode :: enum c.uint {
	SCE_BGAPP_UTIL_ERROR_INVALID_ARG = 0x80106502,
}

foreign bgapputil {
  /**
  * Start BG application (eboot2.bin)
  *
  * @param[in] mode - must be 1
  *
  * @return 0 on success, <0 otherwise.
  */
  sceBgAppUtilStartBgApp :: proc(mode: c.int) -> c.int ---
}
