#+build vita
package vita

import "core:c"

foreign import bt "system:SceBtForDriver_stub"

SceBtErrorCode :: enum c.uint {
	REG_NOT_READY                                  	 = 0x802F0101,
	REG_DELETE_NO_ENTRY                            	 = 0x802F0102,
	REG_UPDATE_CANNOT_SAVE                         	 = 0x802F0103,
	REG_SET_HID_DESC_BAD_ARG                       	 = 0x802F0105,
	REG_SET_HID_DESC_NO_REG                        	 = 0x802F0106,
	REG_GET_HID_DESC_NO_REG                        	 = 0x802F0107,
	REG_GET_HID_DESC_TOO_SHORT                     	 = 0x802F0108,
	REG_DELETE_CONNECTING                          	 = 0x802F0109,
	REG_CANNOT_LOAD                                	 = 0x802F010A,
	REG_CANNOT_OPEN                                	 = 0x802F010B,
	REG_CANNOT_READ                                	 = 0x802F010C,
	REG_CANNOT_WRITE                               	 = 0x802F010D,
	INQUIRY_START_BUSY                             	 = 0x802F0201,
	CONNECT_START_NO_REG                           	 = 0x802F0202,
	CONNECT_START_NOT_CONNECTABLE                  	 = 0x802F0203,
	CONNECT_START_BUSY                             	 = 0x802F0204,
	DISCONNECT_START_NOT_CONNECTED                 	 = 0x802F0205,
	PIN_INVALID_LENGTH                             	 = 0x802F0206,
	USER_CONFIRM_NOT_CONNECTED                     	 = 0x802F0207,
	SDP_OPEN_NO_L2C                                	 = 0x802F0208,
	CONNECT_START_REG_FULL                         	 = 0x802F0209,
	CONNECT_START_CONNECTED                        	 = 0x802F020A,
	CONNECT_START_TOO_MANY                         	 = 0x802F020D,
	CONNECT_START_DELETING                         	 = 0x802F020E,
	AVDTP_OPEN_NO_L2C                              	 = 0x802F0501,
	AVDTP_CLOSE_BAD_SERV                           	 = 0x802F0502,
	AVDTP_CLOSE_BAD_STATE                          	 = 0x802F0503,
	AVDTP_START_BAD_SERV                           	 = 0x802F0504,
	AVDTP_START_BAD_STATE                          	 = 0x802F0505,
	AVDTP_STOP_BAD_SERV                            	 = 0x802F0506,
	AVDTP_STOP_BAD_STATE                           	 = 0x802F0507,
	AVDTP_SEND_BAD_STATE                           	 = 0x802F0508,
	AVDTP_RECONF_BAD_SERV                          	 = 0x802F0509,
	AVDTP_RECONF_BAD_STATE                         	 = 0x802F050A,
	AVCTP_OPEN_NO_L2C                              	 = 0x802F0601,
	AVCTP_SEND_NO_L2C                              	 = 0x802F0603,
	AVCTP_NOT_CONNECTED                            	 = 0x802F0604,
	AVCTP_SEND_BUSY                                	 = 0x802F0605,
	AVCTP_SEND_NO_PRESS                            	 = 0x802F0606,
	AVCTP_SEND_NO_RELEASE                          	 = 0x802F0607,
	AVCTP_READ_NO_VOLUME                           	 = 0x802F0608,
	AVCTP_SEND_NOT_RUBY                            	 = 0x802F0609,
	HID_OPEN_NO_L2C                                	 = 0x802F0901,
	HID_CLOSE_NO_L2C                               	 = 0x802F0902,
	HID_SEND_NO_L2C                                	 = 0x802F0903,
	HID_NOT_CONNECTED                              	 = 0x802F0904,
	HID_NO_CAP                                     	 = 0x802F0905,
	HID_INVALID_REQUEST_TYPE                       	 = 0x802F0906,
	HID_INVALID_BUFFER_ADDRESS                     	 = 0x802F0907,
	HID_INVALID_PROTOCOL                           	 = 0x802F0908,
	HID_INVALID_IDLE                               	 = 0x802F0909,
	HID_NOT_YET                                    	 = 0x802F090C,
	HID_INVALID_LENGTH                             	 = 0x802F090D,
	HID_INVALID_REPORT_ID                          	 = 0x802F090E,
	HID_OVERWRITE_REQ                              	 = 0x802F090F,
	JUMBO_UNLOCK_NOT_OWNER                         	 = 0x802F0B01,
	HCI_TX_OVERFLOW                                	 = 0x802F0B02,
	ACL_TX_BUF_OVERFLOW                            	 = 0x802F0B03,
	ACL_TX_CB_OVERFLOW                             	 = 0x802F0B04,
	TIMER_CANCEL_BAD_ID                            	 = 0x802F0B05,
	TIMER_CANCEL_NOT_INITIALIZED                   	 = 0x802F0B06,
	TIMER_SET_NOT_INITIALIZED                      	 = 0x802F0B07,
	TIMER_SET_NO_SPACE                             	 = 0x802F0B08,
	COPYIN_FAILED                                  	 = 0x802F0B09,
	COPYOUT_FAILED                                 	 = 0x802F0B0A,
	GET_NAME_NO_DEVICE                             	 = 0x802F0C01,
	CB_TOO_MANY                                    	 = 0x802F0C02,
	CB_NOT_REGISTERED                              	 = 0x802F0C03,
	CB_OVERFLOW                                    	 = 0x802F0C04,
	AUDIO_START_NOT_CONNECTED                      	 = 0x802F0D01,
	AUDIO_START_NO_CAP                             	 = 0x802F0D02,
	AUDIO_STOP_NOT_CONNECTED                       	 = 0x802F0D03,
	AUDIO_STOP_NO_CAP                              	 = 0x802F0D04,
	AUDIO_SEND_NOT_CONNECTED                       	 = 0x802F0D05,
	AUDIO_SEND_NOT_STARTED                         	 = 0x802F0D06,
	AUDIO_SEND_INVALID_LENGTH                      	 = 0x802F0D07,
	AUDIO_RECV_NOT_CONNECTED                       	 = 0x802F0D08,
	AUDIO_RECV_NOT_STARTED                         	 = 0x802F0D09,
	AUDIO_RECV_INVALID_LENGTH                      	 = 0x802F0D0A,
	AUDIO_START_INVALID_SERV                       	 = 0x802F0D0B,
	AUDIO_STOP_INVALID_SERV                        	 = 0x802F0D0C,
	AUDIO_START_SERV_FAILED                        	 = 0x802F0D0D,
	AUDIO_STOP_SERV_FAILED                         	 = 0x802F0D0E,
	AUDIO_FREQ_NOT_CONNECTED                       	 = 0x802F0D0F,
	AUDIO_SEND_NO_CP                               	 = 0x802F0D10,
	AUDIO_SEND_BAD_TYPE                            	 = 0x802F0D11,
	AUDIO_RECV_BAD_TYPE                            	 = 0x802F0D12,
	AUDIO_COMBI_NOT_FOUND                          	 = 0x802F0D16,
	AUDIO_SEND_NO_L2C                              	 = 0x802F0D17,
	AUDIO_INTERNAL_1                               	 = 0x802F0D18,
	AUDIO_SEND_BUSY                                	 = 0x802F0D19,
	AUDIO_RECV_BUSY                                	 = 0x802F0D1A,
	AUDIO_SEND_NO_CAP                              	 = 0x802F0D1B,
	AUDIO_SEND_SERV_FAILED                         	 = 0x802F0D1C,
	AUDIO_RECV_NO_CAP                              	 = 0x802F0D1D,
	AUDIO_RECV_SERV_FAILED                         	 = 0x802F0D1E,
	HID_RECV_NOT_CONNECTED                         	 = 0x802F0E01,
	HID_RECV_INVALID_LENGTH                        	 = 0x802F0E02,
	AVRCP_TOO_LONG_TITLE                           	 = 0x802F1201,
	AVRCP_INVALID_PLAY_STATUS                      	 = 0x802F1202,
	CONF_NOT_READY                                 	 = 0x802F1501,
	CONF_INVALID_VALUE                             	 = 0x802F1502,
	CONF_BT_INACTIVE                               	 = 0x802F1503,
	CONF_TIMEOUT                                   	 = 0x802F1504,
	CONF_CARD_NOT_FOUND                            	 = 0x802F1505,
	CONF_FUNCTION_NOT_FOUND                        	 = 0x802F1506,
	CONF_CANT_ENABLE_FUNCTION                      	 = 0x802F1507,
	CONF_CANT_DISABLE_FUNCTION                     	 = 0x802F1508,
	CONF_REGISTER_SUBINTR_HANDLER                  	 = 0x802F1509,
	CONF_RELEASE_SUBINTR_HANDLER                   	 = 0x802F150A,
	CONF_ENABLE_SUBINTR                            	 = 0x802F150B,
	CONF_DISABLE_SUBINTR                           	 = 0x802F150C,
	CONF_ON_TIMEOUT                                	 = 0x802F150D,
	CONF_OFF_TIMEOUT                               	 = 0x802F150E,
	CONF_SUSPEND_TIMEOUT                           	 = 0x802F150F,
	CONF_CANT_ENTER                                	 = 0x802F1520,
	NOTIMP                                         	 = 0x802F2001,
	KPROC_CREATE                                   	 = 0x802F2002,
	SDIO_GET_FUNCTION                              	 = 0x802F2003,
	SDIO_REGISTER_INTR_HANDLER                     	 = 0x802F2004,
	SDIO_UNREGISTER_INTR_HANDLER                   	 = 0x802F2005,
	SDIO_LOCK                                      	 = 0x802F2006,
	SDIO_UNLOCK                                    	 = 0x802F2007,
	SDIO_ENABLE_FUNCTION                           	 = 0x802F2008,
	SDIO_DISABLE_FUNCTION                          	 = 0x802F2009,
	SDIO_SET_BLOCK_LEN                             	 = 0x802F200A,
	SDIO_SET_BUS_SPEED                             	 = 0x802F200B,
	SDIO_READ_DIR                                  	 = 0x802F200C,
	SDIO_WRITE_DIR                                 	 = 0x802F200D,
	SDIO_READ_FIX                                  	 = 0x802F200E,
	SDIO_WRITE_FIX                                 	 = 0x802F200F,
	TSLEEP                                         	 = 0x802F2010,
	GET_DEBUG_INFO_INVALID_REQUEST                 	 = 0x802F2101,
	SET_DEBUG_INFO_INVALID_REQUEST                 	 = 0x802F2102,
	GET_DEBUG_INFO_INVALID_SIZE                    	 = 0x802F2103,
	SET_DEBUG_INFO_INVALID_SIZE                    	 = 0x802F2104,
	GET_DEBUG_INFO_INVALID_ARGUMENT                	 = 0x802F2105,
	SET_DEBUG_INFO_INVALID_ARGUMENT                	 = 0x802F2106,
	GET_DEBUG_INFO_INVALID_STATE                   	 = 0x802F2107,
	SET_DEBUG_INFO_INVALID_STATE                   	 = 0x802F2108,
	GET_DEBUG_INFO_NOT_CONNECTED                   	 = 0x802F2109,
	SET_DEBUG_INFO_NOT_CONNECTED                   	 = 0x802F210A,
	PIN_IS_LE                                      	 = 0x802F2201,
	CONNECT_START_IS_LE                            	 = 0x802F2202,
	AVCTP_IS_LE                                    	 = 0x802F2203,
	HID_IS_LE                                      	 = 0x802F2204,
	AUDIO_START_IS_LE                              	 = 0x802F2205,
	AUDIO_STOP_IS_LE                               	 = 0x802F2206,
	AUDIO_SEND_IS_LE                               	 = 0x802F2207,
	AUDIO_RECV_IS_LE                               	 = 0x802F2208,
	AUDIO_FREQ_IS_LE                               	 = 0x802F2209,
	ATT_BASE                                       	 = 0x802F2300,
	ATT_INVALID_HANDLE                             	 = 0x802F2301,
	ATT_READ_NOT_PERMITTED                         	 = 0x802F2302,
	ATT_WRITE_NOT_PERMITTED                        	 = 0x802F2303,
	ATT_INVALID_PDU                                	 = 0x802F2304,
	ATT_INSUFFICIENT_AUTHENTICATION                	 = 0x802F2305,
	ATT_REQUEST_NOT_SUPPORTED                      	 = 0x802F2306,
	ATT_INVALID_OFFSET                             	 = 0x802F2307,
	ATT_INSUFFICIENT_AUTHORIZATION                 	 = 0x802F2308,
	ATT_PEPARE_QUEUE_FULL                          	 = 0x802F2309,
	ATT_ATTRIBUTE_NOT_FOUND                        	 = 0x802F230A,
	ATT_ATTRIBUTE_NOT_LONG                         	 = 0x802F230B,
	ATT_INSUFFICIENT_ENCRYPTION_KEY_SIZE           	 = 0x802F230C,
	ATT_INVALID_ATTRIBUTE_VALUE_LENGTH             	 = 0x802F230D,
	ATT_UNLIKELY_ERROR                             	 = 0x802F230E,
	ATT_INSUFFICIENT_ENCRYPTION                    	 = 0x802F230F,
	ATT_UNSUPPORTED_GROUP_TYPE                     	 = 0x802F2310,
	ATT_INSUFFICIENT_RESOURCES                     	 = 0x802F2311,
	ATT_APPLICATION_ERROR_LO                       	 = 0x802F2380,
	ATT_APPLICATION_ERROR_HI                       	 = 0x802F23FF,
	GATT_INVALID_NO                                	 = 0x802F2401,
	GATT_NOT_CONNECTED                             	 = 0x802F2402,
	GATT_BUSY                                      	 = 0x802F2403,
	GATT_INVALID_HANDLE                            	 = 0x802F2404,
	GATT_INVALID_FLAGS                             	 = 0x802F2405,
	GATT_INVALID_SIZE                              	 = 0x802F2406,
	GATT_NOT_LE                                    	 = 0x802F2407,
	GATT_TOO_BIG_RECORD                            	 = 0x802F2408,
	GATT_NOT_YET                                   	 = 0x802F2409,
	GATT_DISCONNECT                                	 = 0x802F240A,
	GATT_TSLEEP                                    	 = 0x802F240B,
	GATT_ENTER                                     	 = 0x802F240C,
	GATT_TOO_BIG_BUFFER                            	 = 0x802F240D,
	SM_INVALID_KEY_LENGTH                          	 = 0x802F2501,
	SM_NOT_DIGIT                                   	 = 0x802F2502,
	SM_NO_REQ                                      	 = 0x802F2503,
	SM_NOT_NEEDED_PIN                              	 = 0x802F2504,
	SM_INVALID_CONFIRM_REPLY                       	 = 0x802F2505,
	LE_SET_ADVERTISING_INVALID_REQ                 	 = 0x802F2601,
	LE_SET_ADVERTISING_INVALID_LENGTH              	 = 0x802F2602,
	LE_SET_ADVERTISING_INVALID_INTERVAL_MIN        	 = 0x802F2603,
	LE_SET_ADVERTISING_INVALID_INTERVAL_MAX        	 = 0x802F2604,
	LE_SET_ADVERTISING_INVALID_OWN_ADDRESS_TYPE    	 = 0x802F2605,
	LE_SET_ADVERTISING_INVALID_DIRECT_ADDRESS_TYPE 	 = 0x802F2606,
	LE_SET_ADVERTISING_INVALID_DIRECT_ADDRESS      	 = 0x802F2607,
	LE_SET_SCAN_INVALID_REQ                        	 = 0x802F2701,
	LE_SET_SCAN_INVALID_LENGTH                     	 = 0x802F2702,
	LE_SET_SCAN_INVALID_INTERVAL                   	 = 0x802F2703,
	LE_SET_SCAN_INVALID_WINDOW                     	 = 0x802F2704,
	LE_SET_SCAN_INVALID_OWN_ADDRESS_TYPE           	 = 0x802F2705,
	LE_GET_ADVERTISING_NOT_FOUND                   	 = 0x802F2801,
	LE_CREATE_CONNECTION_INVALID_SCAN_INTERVAL     	 = 0x802F2901,
	LE_CREATE_CONNECTION_INVALID_SCAN_WINDOW       	 = 0x802F2902,
	LE_CREATE_CONNECTION_INVALID_PEER_ADDRESS      	 = 0x802F2903,
	LE_CREATE_CONNECTION_INVALID_OWN_ADDRESS_TYPE  	 = 0x802F2904,
	LE_CREATE_CONNECTION_INVALID_INTERVAL_MIN      	 = 0x802F2905,
	LE_CREATE_CONNECTION_INVALID_INTERVAL_MAX      	 = 0x802F2906,
	LE_CREATE_CONNECTION_INVALID_LATENCY           	 = 0x802F2907,
	LE_CREATE_CONNECTION_INVALID_TIMEOUT           	 = 0x802F2908,
	LE_CREATE_CONNECTION_REG_FULL                  	 = 0x802F2909,
	LE_CREATE_CONNECTION_REG_ERROR                 	 = 0x802F290A,
	LE_CREATE_CONNECTION_CONNECTED                 	 = 0x802F290B,
	LE_CREATE_CONNECTION_FULL                      	 = 0x802F290C,
	LE_CREATE_CONNECTION_BUSY                      	 = 0x802F290D,
	ATT_READ_INVALID_NO                            	 = 0x802F2A01,
	ATT_READ_INVALID_LENGTH                        	 = 0x802F2A02,
	ATT_READ_INVALID_INTERNAL                      	 = 0x802F2A03,
	ATT_WRITE_INVALID_NO                           	 = 0x802F2A04,
	ATT_WRITE_INVALID_LENGTH                       	 = 0x802F2A05,
	ATT_WRITE_INVALID_INTERNAL                     	 = 0x802F2A06,
	ATT_NOT_YET                                    	 = 0x802F2A07,
	LE_NOT_SUPPORTED                               	 = 0x802F2B01,
	PAIRING_OOB_TIMEOUT                            	 = 0x802F3101,
	PAIRING_OOB_FULL                               	 = 0x802F3102,
	PAIRING_OOB_CAN_NOT_DISCONNECT                 	 = 0x802F3103,
	PAIRING_OOB_INTERNAL_ERROR                     	 = 0x802F3104,
	NOT_READY                                      	 = 0x802F3201,
	GET_JACK_STATUS_NOT_CONNECTED                  	 = 0x802F3301,
	TOO_MANY_CONNECTION                            	 = 0x802F3401,
	TOO_MANY_HID                                   	 = 0x802F3402,
	NOT_SUPPORTED_DEVICE                           	 = 0x802F3403,
	JEDI_VOLUME_GAIN_NOT_CONNECTED                 	 = 0x802F3501,
	JEDI_SNIFF_NOT_CONNECTED                       	 = 0x802F3601,
	JEDI_SNIFF_NOT_JEDI                            	 = 0x802F3602
}

SceBtRegisteredInfo :: struct {
	mac: [6]c.uchar,
	unk0: c.ushort,
	bt_class: c.uint,
	unk1: c.uint,
	unk2: c.uint,
	vid: c.ushort,
	pid: c.ushort,
	unk3: c.uint,
	unk4: c.uint,
	name: [128]c.char,
	unk5: [0x60]c.uchar,
}
#assert(size_of(SceBtRegisteredInfo) == 0x100)

SceBtEvent :: struct {
	using _: struct #raw_union {
		data: [0x10]c.uchar,
		using _: struct {
			id: c.uchar,
			unk1: c.uchar,
			unk2: c.ushort,
			unk3: c.uint,
			mac0: c.uint,
			mac1: c.uint,
		},
	},
}
#assert(size_of(SceBtEvent) == 0x10)

SceBtCallback :: #type ^proc "c" (r0: c.int, r1: c.int, r2: c.int, r3: c.int)

SceBtHidRequest :: struct #packed {
  unk00: c.uint32_t,
	unk04: c.uint32_t,
	type: c.uint8_t,    //!< 0 = read?, 1 = write?, 2 = feature?, 3 = ?
	unk09: c.uint8_t,
	unk0A: c.uint8_t,
	unk0B: c.uint8_t,
	buffer: rawptr,
	length: c.uint32_t,
	next: ^SceBtHidRequest,
}

foreign bt {
	ksceBtAvrcpReadVolume :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtAvrcpSendButton :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtAvrcpSendVolume :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtAvrcpSetPlayStatus :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtAvrcpSetTitle :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtDeleteRegisteredInfo :: proc(mac0: c.uint, mac1: c.uint) -> c.int ---
	ksceBtFreqAudio :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtGetConfiguration :: proc() -> c.int --- // returns 0x0 BT disabled, 0x9 if enabled
	ksceBtGetConnectingInfo :: proc(mac0: c.uint, mac1: c.uint) -> c.int --- // 1 = disconnected?, 2 = connecting?, 5 = connected?
	ksceBtGetDeviceName :: proc(mac0: c.uint, mac1: c.uint, name: [0x79]c.char) -> c.int ---
	ksceBtGetInfoForTest :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtGetLastError :: proc() -> c.int ---
	ksceBtGetRegisteredInfo :: proc(device: c.int, unk: c.int, info: ^SceBtRegisteredInfo, info_size: SceSize) -> c.int ---
	ksceBtGetStatusForTest :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtGetVidPid :: proc(mac0: c.uint, mac1: c.uint, vid_pid: [2]c.ushort) -> c.int ---
	ksceBtHfpGetCurrentPhoneNumber :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtHfpRequest :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtHidGetReportDescriptor :: proc(mac0: c.uint, mac1: c.uint, buffer: rawptr, size: SceSize) -> c.int ---
	ksceBtHidTransfer :: proc(mac0: c.uint, mac1: c.uint, request: ^SceBtHidRequest) -> c.int ---
	ksceBtPushBip :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtPushOpp :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtReadEvent :: proc(events: [^]SceBtEvent, num_events: c.int) -> c.int ---
	ksceBtRecvAudio :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtRecvBip :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtRecvOpp :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtRecvSpp :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtRegisterCallback :: proc(cb: SceUID, unused: c.int, flags1: c.int, flags2: c.int) -> c.int --- // looks like flags1 is a mask for permitted MACs
	ksceBtReplyPinCode :: proc(mac0: c.uint, mac1: c.uint, code: ^c.uchar, length: SceSize) -> c.int ---
	ksceBtReplyUserConfirmation :: proc(mac0: c.uint, mac1: c.uint, unk: c.int) -> c.int ---
	ksceBtSendAudio :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtSendL2capEchoRequestForTest :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtSendSpp :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtSetConfiguration :: proc(r0: c.int) -> c.int --- //0 = disable bt, 1 = enabling, 2 = enabled 3 = disabling?
	ksceBtSetContentProtection :: proc(r0: c.int) -> c.int ---
	ksceBtSetInquiryResultForTest :: proc(_: ^c.uchar) -> c.int ---
	ksceBtSetInquiryScan :: proc(r0: c.int) -> c.int ---
	ksceBtSetL2capEchoResponseBufferForTest :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtSetStatusForTest :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtStartAudio :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtStartConnect :: proc(mac0: c.uint, mac1: c.uint) -> c.int --- // mac0 can be used as a device index (already paired devices)?
	ksceBtStartDisconnect :: proc(mac0: c.uint, mac1: c.uint) -> c.int ---
	ksceBtStartInquiry :: proc() -> c.int ---
	ksceBtStopAudio :: proc(r0: c.int, r1: c.int, r2: c.int, r3: c.int) -> c.int ---
	ksceBtStopInquiry :: proc() -> c.int ---
	ksceBtUnregisterCallback :: proc(cb: SceUID) -> c.int ---
}

