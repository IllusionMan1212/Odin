#+build vita
package vita

import "core:c"

foreign import sysmodule "system:SceSysmodule_stub"

/** Errorcodes for SceSysmodule */
SceSysmoduleErrorCode :: enum c.uint {
	LOADED                = 0,          //!< Module is already loaded
	ERROR_INVALID_VALUE   = 0x805A1000, //!< Invalid value
	ERROR_UNLOADED        = 0x805A1001, //!< Module is not loaded
	ERROR_FATAL           = 0x805A10FF  //!< Fatal error
}

/** Available modules ID for ::sceSysmoduleLoadModule */
SceSysmoduleModuleId :: enum c.int {
	INVALID               = 0x0000, //!< Invalid module
	NET                   = 0x0001, //!< Net module
	HTTP                  = 0x0002, //!< HTTP module
	SSL                   = 0x0003, //!< SSL module
	HTTPS                 = 0x0004, //!< HTTPS module
	PERF                  = 0x0005, //!< Perf module
	FIBER                 = 0x0006, //!< Fiber module
	ULT                   = 0x0007, //!< Ult module
	DBG                   = 0x0008, //!< DBG module
	RAZOR_CAPTURE         = 0x0009, //!< Razor Capture module
	RAZOR_HUD             = 0x000A, //!< Razor HUD module
	NGS                   = 0x000B, //!< NGS module
	SULPHA                = 0x000C, //!< Sulpha module
	SAS                   = 0x000D, //!< Sas module
	PGF                   = 0x000E, //!< Pgf module
	APPUTIL               = 0x000F, //!< AppUtil module
	FIOS2                 = 0x0010, //!< Fios2 module
	IME                   = 0x0011, //!< Ime module
	NP_BASIC              = 0x0012, //!< NpBasic module
	SYSTEM_GESTURE        = 0x0013, //!< System Gesture module
	LOCATION              = 0x0014, //!< Location module
	NP                    = 0x0015, //!< Np module
	PHOTO_EXPORT          = 0x0016, //!< Photo Export module
	XML                   = 0x0017, //!< XML module
	NP_COMMERCE2          = 0x0018, //!< NPCommerce2 module
	NP_UTILITY            = 0x0019, //!< NpUtility module
	VOICE                 = 0x001A, //!< Voice module
	VOICEQOS              = 0x001B, //!< VoiceQos module
	NP_MATCHING2          = 0x001C, //!< NpMatching2 module
	SCREEN_SHOT           = 0x001D, //!< ScreenShot module
	NP_SCORE_RANKING      = 0x001E, //!< NpScoreRanking module
	SQLITE                = 0x001F, //!< Sqlite module
	TRIGGER_UTIL          = 0x0020, //!< TriggerUtil module
	RUDP                  = 0x0021, //!< Rudp module
	CODECENGINE_PERF      = 0x0022, //!< CodecEngine Perf module
	LIVEAREA              = 0x0023, //!< Livearea module
	NP_ACTIVITY           = 0x0024, //!< NpActivity module
	NP_TROPHY             = 0x0025, //!< NpTrophy module
	NP_MESSAGE            = 0x0026, //!< NpMessage module
	SHUTTER_SOUND         = 0x0027, //!< Shutter Sound module
	CLIPBOARD             = 0x0028, //!< Clipboard module
	NP_PARTY              = 0x0029, //!< NpParty module
	NET_ADHOC_MATCHING    = 0x002A, //!< NetAdhoc Matching module
	NEAR_UTIL             = 0x002B, //!< NearUtil module
	NP_TUS                = 0x002C, //!< NpTus module
	MP4                   = 0x002D, //!< MP4 module
	AACENC                = 0x002E, //!< AacEnc module
	HANDWRITING           = 0x002F, //!< Handwriting module
	ATRAC                 = 0x0030, //!< Atrac module
	NP_SNS_FACEBOOK       = 0x0031, //!< NpSns Facebook module
	VIDEO_EXPORT          = 0x0032, //!< Video Export module
	NOTIFICATION_UTIL     = 0x0033, //!< NotificationUtil module
	BG_APP_UTIL           = 0x0034, //!< BgAppUtil module
	INCOMING_DIALOG       = 0x0035, //!< Incoming Dialog module
	IPMI                  = 0x0036, //!< IPMI module
	AUDIOCODEC            = 0x0037, //!< AudioCodec module
	FACE                  = 0x0038, //!< Face module
	SMART                 = 0x0039, //!< Smart module
	MARLIN                = 0x003A, //!< Marlin module
	MARLIN_DOWNLOADER     = 0x003B, //!< Marlin Downloader module
	MARLIN_APP_LIB        = 0x003C, //!< Marlin AppLib module
	TELEPHONY_UTIL        = 0x003D, //!< TelephonyUtil module
	SHACCCG               = 0x003E, //!< ShaccCg module
	MONO_BRIDGE           = 0x003F, //!< Mono bridge module
	MONO                  = 0x0040, //!< Mono module
	PSM                   = 0x0041, //!< Psm module
	PSM_DEVAGENT          = 0x0042, //!< Psm devagent module
	PSPNET_ADHOC          = 0x0043, //!< PSPNet Adhoc module
	DTCP_IP               = 0x0044, //!< DTCP/IP module
	VIDEO_SEARCH_EMPR     = 0x0045, //!< VideoSearch module
	NP_SIGNALING          = 0x0046, //!< NpSignaling module
	BEISOBMF              = 0x0047, //!< BEISOBMF module
	BEMP2SYS              = 0x0048, //!< BEMP2SYS module
	MUSIC_EXPORT          = 0x0049, //!< Music Export module
	NEAR_DIALOG_UTIL      = 0x004A, //!< NearDialogUtil module
	LOCATION_EXTENSION    = 0x004B, //!< LocationExt module
	AVPLAYER              = 0x004C, //!< AVPlayer module
	GAME_UPDATE           = 0x004D, //!< Game Update module
	MAIL_API              = 0x004E, //!< Mail Api module
	TELEPORT_CLIENT       = 0x004F, //!< Teleport Client module
	TELEPORT_SERVER       = 0x0050, //!< Teleport Server module
	MP4_RECORDER          = 0x0051, //!< MP4 Recorder module
	APPUTIL_EXT           = 0x0052, //!< AppUtilExt module
	NP_WEBAPI             = 0x0053, //!< NpWebApi module
	AVCDEC                = 0x0054, //!< AVCDec module
	JSON                  = 0x0055  //!< JSON module
}

/** Available internal modules ID for ::sceSysmoduleLoadModuleInternal */
SceSysmoduleInternalModuleId :: enum c.uint {
	JPEG_ENC_ARM               = 0x80000001, //!< sceJpegEncArm module
	AUDIOCODEC                 = 0x80000002, //!< AudioCodec module
	JPEG_ARM                   = 0x80000003, //!< sceJpegArm module
	G729                       = 0x80000004, //!< G729 module
	BXCE                       = 0x80000005, //!< BXCE module
	INI_FILE_PROCESSOR         = 0x80000006, //!< INI File Processor module
	NP_ACTIVITY_NET            = 0x80000007, //!< NpActivityNet module
	PAF                        = 0x80000008, //!< Paf module
	SQLITE_VSH                 = 0x80000009, //!< sceSqliteVsh module
	DBUTIL                     = 0x8000000A, //!< DBUtil module
	ACTIVITY_DB                = 0x8000000B, //!< ActivityDB module
	COMMON_GUI_DIALOG          = 0x8000000C, //!< Common Gui Dialog module
	STORE_CHECKOUT             = 0x8000000D, //!< Store Checkout module
	IME_DIALOG                 = 0x8000000E, //!< Ime Dialog module
	PHOTO_IMPORT_DIALOG        = 0x8000000F, //!< Photo Import Dialog module
	PHOTO_REVIEW_DIALOG        = 0x80000010, //!< Photo Review Dialog module
	CHECKOUT_DIALOG            = 0x80000011, //!< Checkout Dialog module
	COMMON_DIALOG_MAIN         = 0x80000012, //!< Common Dialog Main module
	MSG_DIALOG                 = 0x80000013, //!< sceMsgDialog module
	NET_CHECK_DIALOG           = 0x80000014, //!< NetCheck Dialog module
	SAVEDATA_DIALOG            = 0x80000015, //!< SaveData Dialog module
	NP_MESSAGE_DIALOG          = 0x80000016, //!< NpMessage Dialog module
	TROPHY_SETUP_DIALOG        = 0x80000017, //!< Trophy Setup Dialog module
	FRIEND_LIST_DIALOG         = 0x80000018, //!< FriendList Dialog module
	NEAR_PROFILE               = 0x8000001A, //!< Near Profile module
	NP_FRIEND_PRIVACY_LEVEL    = 0x8000001B, //!< NpFriend Privacy Level module
	NP_COMMERCE2               = 0x8000001D, //!< NpCommerce2 module
	NP_KDC                     = 0x8000001E, //!< NpKdc module
	MUSIC_EXPORT               = 0x8000001F, //!< Music Export module
	VIDEO_EXPORT               = 0x80000020, //!< Video Export module
	NP_MESSAGE_DIALOG_IMPL     = 0x80000021, //!< NpMessageDlg module
	NP_MESSAGE_CONTACTS        = 0x80000022, //!< NpMessageContacts module
	DB_RECOVERY_UTILITY        = 0x80000023, //!< DBRecoveryUtil module
	PROMOTER_UTIL              = 0x80000024, //!< scePromoterUtil module
	PARTY_MEMBER_LIST          = 0x80000026, //!< Party Member List module
	ULT                        = 0x80000025, //!< Ult module
	DRM_PSM_KDC                = 0x80000027, //!< DRM PSM KDC module
	LOCATION_INTERNAL          = 0x80000028, //!< sceLocation module
	LOCATION_FACTORY           = 0x80000029  //!< Location Factory module
}

SceSysmoduleOpt :: struct {
  flags: c.int,
	result: ^c.int,
	unused: [2]c.int,
}

foreign sysmodule {
	/**
	* Load a module.
	*
	* @param[in] id - Module ID to load.
	*
	* @return 0 on success, <0 on error.
	*/
	sceSysmoduleLoadModule :: proc(id: SceSysmoduleModuleId) -> c.int ---

	/**
	* Unload a module.
	*
	* @param[in] id - Module ID to unload.
	*
	* @return 0 on success, <0 on error.
	*/
	sceSysmoduleUnloadModule :: proc(id: SceSysmoduleModuleId) -> c.int ---

	/**
	* Check if a module is loaded.
	*
	* @param[in] id - Module ID to check.
	*
	* @return 0 if loaded, <0 otherwise.
	*/
	sceSysmoduleIsLoaded :: proc(id: SceSysmoduleModuleId) -> c.int ---

	/**
	* Load an internal module.
	*
	* @param[in] id - Module ID to load.
	*
	* @return 0 on success, <0 on error.
	*/
	sceSysmoduleLoadModuleInternal :: proc(id: SceSysmoduleInternalModuleId) -> c.int ---

	/**
	* Unload an internal module.
	*
	* @param[in] id - Module ID to unload.
	*
	* @return 0 on success, <0 on error.
	*/
	sceSysmoduleUnloadModuleInternal :: proc(id: SceSysmoduleInternalModuleId) -> c.int ---

	/**
	* Check if an internal module is loaded.
	*
	* @param[in] id - Module ID to check.
	*
	* @return 0 if loaded, <0 otherwise.
	*/
	sceSysmoduleIsLoadedInternal :: proc(id: SceSysmoduleInternalModuleId) -> c.int ---

	/**
	* Load an internal module with custom arguments.
	*
	* @param[in] id     - Module ID to check.
	* @param[in] args   - Size of passed arguments.
	* @param[in] argp   - Pointer to arguments to pass.
	* @param[in] option - Module load option.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceSysmoduleLoadModuleInternalWithArg :: proc(id: SceSysmoduleInternalModuleId, args: SceSize, argp: rawptr, #by_ptr option: SceSysmoduleOpt) -> c.int ---

	/**
	* Unload an internal module with custom arguments.
	*
	* @param[in] id     - Module ID to check.
	* @param[in] args   - Size of passed arguments.
	* @param[in] argp   - Pointer to arguments to pass.
	* @param[in] option - Module load option.
	*
	* @return 0 on success, <0 otherwise.
	*/
	sceSysmoduleUnloadModuleInternalWithArg :: proc(id: SceSysmoduleInternalModuleId, args: SceSize, argp: rawptr, #by_ptr option: SceSysmoduleOpt) -> c.int ---
}

