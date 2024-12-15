#+build vita
package vita

import "core:c"

foreign import screenshot "system:SceScreenShot_stub"

//! Max size of path strings (includes device name and NULL terminator)
SCE_SCREENSHOT_MAX_FS_PATH :: (1024)

//! Max length of photo title
SCE_SCREENSHOT_MAX_PHOTO_TITLE_LEN :: (64)

//! Max size of photo title (includes NULL terminator)
SCE_SCREENSHOT_MAX_PHOTO_TITLE_SIZE :: (SCE_SCREENSHOT_MAX_PHOTO_TITLE_LEN * 4)

//! Max length of game title
SCE_SCREENSHOT_MAX_GAME_TITLE_LEN :: (64)

//! Max size of game title (includes NUL terminator)
SCE_SCREENSHOT_MAX_GAME_TITLE_SIZE :: (SCE_SCREENSHOT_MAX_GAME_TITLE_LEN * 4)

//! Max length of comment (description)
SCE_SCREENSHOT_MAX_GAME_COMMENT_LEN :: (128)

//! Max size of comment (description) (includes NUL terminator)
SCE_SCREENSHOT_MAX_GAME_COMMENT_SIZE :: (SCE_SCREENSHOT_MAX_GAME_COMMENT_LEN * 4)

SceScreenshotErrorCode :: enum c.uint {
	INVALID_ARGUMENT       = 0x80102F01,
	NO_MEMORY              = 0x80102F02,
	FILE_NOT_FOUND         = 0x80102F03,
	NOT_SUPPORTED_FORMAT   = 0x80102F04,
	MEDIA_FULL             = 0x80102F05,
	INTERNAL               = 0x80102F06
}

SceScreenShotParam :: struct {
	photoTitle: [^]SceWChar32,   //!< Photo title
	gameTitle: [^]SceWChar32,    //!< Game title
	gameComment: [^]SceWChar32,  //!< Game description
	reserved: rawptr,                 //!< Reserved range (Must be NULL)
}

foreign screenshot {
	//! Set screenshot params
	sceScreenShotSetParam :: proc(#by_ptr param: SceScreenShotParam) -> c.int ---

	//! Set overlay image
	sceScreenShotSetOverlayImage :: proc(filepath: cstring, offsetX: c.int, offsetY: c.int) -> c.int ---

	//! Disable screenshot
	sceScreenShotDisable :: proc() -> c.int ---

	//! Enable screenshot
	sceScreenShotEnable :: proc() -> c.int ---
}

