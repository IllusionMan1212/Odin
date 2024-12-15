#+build vita
package vita

import "core:c"

foreign import razorcapture "system:SceRazorCapture_stub"

foreign razorcapture {
  /**
  * Sets a trigger for a gpu capture in next frame from Razor debugger
  *
  * @param[in] filename - Filename of the file where to save capture results
  */
  sceRazorGpuCaptureSetTriggerNextFrame :: proc(filename: cstring) ---

  /**
  * Enables collecting of GPU captures when a gpucrash happens
  *
  * @param[in] filename - Filename of the file where to save capture results
  */
  sceRazorGpuCaptureEnableSalvage :: proc(filename: cstring) ---
}

