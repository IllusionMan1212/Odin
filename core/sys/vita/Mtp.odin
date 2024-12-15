#+build vita
package vita

import "core:c"

foreign import mtp "system:SceMtpIfDriver_stub"

foreign mtp {
  /**
  * Start MTP driver
  *
  * @param[in] flags - Set to 1
  *
  * @return 0 on success, < 0 on error.
  */
  sceMtpIfStartDriver :: proc(flags: c.int) -> c.int ---

  /**
  * Stop MTP driver
  *
  * @param[in] flags - Set to 1
  *
  * @return 0 on success, < 0 on error.
  */
  sceMtpIfStopDriver :: proc(flags: c.int) -> c.int ---
}

