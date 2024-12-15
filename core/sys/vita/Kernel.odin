#+build vita
package vita

import "core:c"

foreign import libkernel "system:SceLibKernel_stub"
foreign import processmgr "system:SceProcessmgr_stub"
foreign import modulemgr "system:SceKernelModulemgr_stub"
foreign import sysmem "system:SceSysmem_stub"
foreign import threadmgr "system:SceKernelThreadMgr_stub"

// missing structs
SceKernelLoadModuleOption :: struct {}
SceKernelUnloadModuleOption :: struct {}
SceKernelLibraryInfo :: struct {}

/** Message Pipe status info */
SceKernelMppInfo :: struct {
    size: SceSize,
    mppId: SceUID, // Needs confirmation
    name: [32]c.char,
    attr: SceUInt,
    bufSize: c.int,
    freeSize: c.int,
    numSendWaitThreads: c.int,
    numReceiveWaitThreads: c.int,
}
#assert(size_of(SceKernelMppInfo) == 0x3C)

/** Additional options used when creating rwlock. */
SceKernelRWLockOptParam :: struct {
	/** Size of the ::SceKernelRWLockOptParam structure */
  size: SceSize,
}
#assert(size_of(SceKernelRWLockOptParam) == 4)

/** Current state of a rwlock.
 * @see sceKernelGetRWLockInfo
 */
SceKernelRWLockInfo :: struct {
	/** Size of the ::SceKernelRWLockInfo structure */
  size: SceSize,
	/** The UID of the rwlock */
	rwLockId: SceUID,
	/** NULL-terminated name of the rwlock */
	name: [32]c.char,
	/** Attributes */
  attr: SceUInt32,
	/** The current lock count */
	lockCount: SceInt32,
	/** The UID of the current owner of the rwlock with write access, 0 when locked for reads */
	writeOwnerId: SceUID,
	/** The number of threads waiting on the rwlock for read access */
	numReadWaitThreads: SceUInt32,
	/** The number of threads waiting on the rwlock for write access */
	numWriteWaitThreads: SceUInt32,
}
#assert(size_of(SceKernelRWLockInfo) == 0x3C)

SceKernelSystemInfo :: struct {
    size: SceSize,
    activeCpuMask: SceUInt32,

    cpuInfo: [4]struct {
        idleClock: SceKernelSysClock,
        comesOutOfIdleCount: SceUInt32,
        threadSwitchCount: SceUInt32,
    },
}
#assert(size_of(SceKernelSystemInfo) == 0x48)

SceKernelErrorCode :: enum c.uint {
	OK                                                = 0x0,
	ERROR                                       = 0x80020001,
	NOT_IMPLEMENTED                             = 0x80020002,
	NOSYS                                       = 0x80020003,
	UNSUP                                       = 0x80020004,
	INVALID_ARGUMENT                            = 0x80020005,
	ILLEGAL_ADDR                                = 0x80020006,
	ILLEGAL_ALIGNMENT                           = 0x80020007,
	ILLEGAL_PERMISSION                          = 0x80020008,
	INVALID_ARGUMENT_SIZE                       = 0x80020009,
	INVALID_FLAGS                               = 0x8002000A,
	ILLEGAL_SIZE                                = 0x8002000B,
	ILLEGAL_TYPE                                = 0x8002000C,
	ILLEGAL_PATTERN                             = 0x8002000D,
	ILLEGAL_ATTR                                = 0x8002000E,
	ILLEGAL_COUNT                               = 0x8002000F,
	ILLEGAL_MODE                                = 0x80020010,
	ILLEGAL_OPEN_LIMIT                          = 0x80020011,
	ONLY_DEVELOPMENT_MODE                       = 0x80020012,
	DEBUG_ERROR                                 = 0x80021000,
	ILLEGAL_DIPSW_NUMBER                        = 0x80021001,
	PA_ERROR                                    = 0x80021100,
	PA_NOT_AVAILABLE                            = 0x80021101,
	PA_INVALID_KEY                              = 0x80021102,
	PA_KEY_IS_NOT_SHARED                        = 0x80021103,
	PA_INVALID_SIGNATURE                        = 0x80021104,
	CPU_ERROR                                   = 0x80022000,
	MMU_ILLEGAL_L1_TYPE                         = 0x80022001,
	MMU_L2_INDEX_OVERFLOW                       = 0x80022002,
	MMU_L2_SIZE_OVERFLOW                        = 0x80022003,
	INVALID_CPU_AFFINITY                        = 0x80022004,
	INVALID_MEMORY_ACCESS                       = 0x80022005,
	INVALID_MEMORY_ACCESS_PERMISSION            = 0x80022006,
	VA2PA_FAULT                                 = 0x80022007,
	VA2PA_MAPPED                                = 0x80022008,
	VALIDATION_CHECK_FAILED                     = 0x80022009,
	SYSMEM_ERROR                                = 0x80024000,
	INVALID_PROCESS_CONTEXT                     = 0x80024001,
	UID_NAME_TOO_LONG                           = 0x80024002,
	VARANGE_IS_NOT_PHYSICAL_CONTINUOUS          = 0x80024003,
	PHYADDR_ERROR                               = 0x80024100,
	NO_PHYADDR                                  = 0x80024101,
	PHYADDR_USED                                = 0x80024102,
	PHYADDR_NOT_USED                            = 0x80024103,
	NO_IOADDR                                   = 0x80024104,
	PHYMEM_ERROR                                = 0x80024300,
	ILLEGAL_PHYPAGE_STATUS                      = 0x80024301,
	NO_FREE_PHYSICAL_PAGE                       = 0x80024302,
	NO_FREE_PHYSICAL_PAGE_UNIT                  = 0x80024303,
	PHYMEMPART_NOT_EMPTY                        = 0x80024304,
	NO_PHYMEMPART_LPDDR2                        = 0x80024305,
	NO_PHYMEMPART_CDRAM                         = 0x80024306,
	PHYMEMPART_OUT_OF_INDEX                     = 0x80024307,
	CANNOT_GROW_PHYMEMPART                      = 0x80024308,
	NO_FREE_PHYSICAL_PAGE_CDRAM                 = 0x80024309,
	INVALID_SUBBUDGET_ID                        = 0x8002430A,
	FIXEDHEAP_ERROR                             = 0x80024400,
	FIXEDHEAP_ILLEGAL_SIZE                      = 0x80024401,
	FIXEDHEAP_ILLEGAL_INDEX                     = 0x80024402,
	FIXEDHEAP_INDEX_OVERFLOW                    = 0x80024403,
	FIXEDHEAP_NO_CHUNK                          = 0x80024404,
	UID_ERROR                                   = 0x80024500,
	INVALID_UID                                 = 0x80024501,
	SYSMEM_UID_INVALID_ARGUMENT                 = 0x80024502,
	SYSMEM_INVALID_UID_RANGE                    = 0x80024503,
	SYSMEM_NO_VALID_UID                         = 0x80024504,
	SYSMEM_CANNOT_ALLOCATE_UIDENTRY             = 0x80024505,
	NOT_PROCESS_UID                             = 0x80024506,
	NOT_KERNEL_UID                              = 0x80024507,
	INVALID_UID_CLASS                           = 0x80024508,
	INVALID_UID_SUBCLASS                        = 0x80024509,
	UID_CANNOT_FIND_BY_NAME                     = 0x8002450A,
	UID_NOT_VISIBLE                             = 0x8002450B,
	UID_MAX_OPEN                                = 0x8002450C,
	UID_RL_OVERFLOW                             = 0x8002450D,
	VIRPAGE_ERROR                               = 0x80024600,
	ILLEGAL_VIRPAGE_TYPE                        = 0x80024601,
	BLOCK_ERROR                                 = 0x80024700,
	ILLEGAL_BLOCK_ID                            = 0x80024701,
	ILLEGAL_BLOCK_TYPE                          = 0x80024702,
	BLOCK_IN_USE                                = 0x80024703,
	PARTITION_ERROR                             = 0x80024800,
	ILLEGAL_PARTITION_ID                        = 0x80024801,
	ILLEGAL_PARTITION_INDEX                     = 0x80024802,
	NO_L2PAGETABLE                              = 0x80024803,
	HEAPLIB_ERROR                               = 0x80024900,
	ILLEGAL_HEAP_ID                             = 0x80024901,
	OUT_OF_RANG                                 = 0x80024902,
	HEAPLIB_NOMEM                               = 0x80024903,
	HEAPLIB_VERIFY_ERROR                        = 0x80024904,
	SYSMEM_ADDRESS_SPACE_ERROR                  = 0x80024A00,
	INVALID_ADDRESS_SPACE_ID                    = 0x80024A01,
	INVALID_PARTITION_INDEX                     = 0x80024A02,
	ADDRESS_SPACE_CANNOT_FIND_PARTITION_BY_ADDR = 0x80024A03,
	SYSMEM_MEMBLOCK_ERROR                       = 0x80024B00,
	ILLEGAL_MEMBLOCK_TYPE                       = 0x80024B01,
	ILLEGAL_MEMBLOCK_REMAP_TYPE                 = 0x80024B02,
	NOT_PHY_CONT_MEMBLOCK                       = 0x80024B03,
	ILLEGAL_MEMBLOCK_CODE                       = 0x80024B04,
	ILLEGAL_MEMBLOCK_SIZE                       = 0x80024B05,
	ILLEGAL_USERMAP_SIZE                        = 0x80024B06,
	MEMBLOCK_TYPE_FOR_KERNEL_PROCESS            = 0x80024B07,
	PROCESS_CANNOT_REMAP_MEMBLOCK               = 0x80024B08,
	MEMBLOCK_RANGE_ERROR                        = 0x80024B09,
	MEMBLOCK_TYPE_FOR_UPDATER_OR_SAFEMODE       = 0x80024B0A,
	MEMBLOCK_OVERFLOW                           = 0x80024B0B,
	SYSMEM_PHYMEMLOW_ERROR                      = 0x80024C00,
	CANNOT_ALLOC_PHYMEMLOW                      = 0x80024C01,
	UNKNOWN_PHYMEMLOW_TYPE                      = 0x80024C02,
	SYSMEM_BITHEAP_ERROR                        = 0x80024D00,
	CANNOT_ALLOC_BITHEAP                        = 0x80024D01,
	SYSMEM_NAMEHEAP_ERROR                       = 0x80024E00,
	NO_SUCH_NAME                                = 0x80024E01,
	DUPLICATE_NAME                              = 0x80024E02,
	LOADCORE_ERROR                              = 0x80025000,
	ILLEGAL_ELF_HEADER                          = 0x80025001,
	ILLEGAL_SELF_HEADER                         = 0x80025002,
	EXCPMGR_ERROR                               = 0x80027000,
	ILLEGAL_EXCPCODE                            = 0x80027001,
	ILLEGAL_EXCPHANDLER                         = 0x80027002,
	NOTFOUND_EXCPHANDLER                        = 0x80027003,
	CANNOT_RELEASE_EXCPHANDLER                  = 0x80027004,
	INTRMGR_ERROR                               = 0x80027100,
	ILLEGAL_CONTEXT                             = 0x80027101,
	ILLEGAL_INTRCODE                            = 0x80027102,
	ILLEGAL_INTRPARAM                           = 0x80027103,
	ILLEGAL_INTRPRIORITY                        = 0x80027104,
	ILLEGAL_TARGET_CPU                          = 0x80027105,
	ILLEGAL_INTRFILTER                          = 0x80027106,
	ILLEGAL_INTRTYPE                            = 0x80027107,
	ILLEGAL_HANDLER                             = 0x80027108,
	FOUND_HANDLER                               = 0x80027109,
	NOTFOUND_HANDLER                            = 0x8002710A,
	NO_MEMORY                                   = 0x8002710B,
	DMACMGR_ERROR                               = 0x80027200,
	ALREADY_QUEUED                              = 0x80027201,
	NOT_QUEUED                                  = 0x80027202,
	NOT_SETUP                                   = 0x80027203,
	ON_TRANSFERRING                             = 0x80027204,
	NOT_INITIALIZED                             = 0x80027205,
	TRANSFERRED                                 = 0x80027206,
	NOT_UNDER_CONTROL                           = 0x80027207,
	CANCELING                                   = 0x80027208,
	SYSTIMER_ERROR                              = 0x80027300,
	NO_FREE_TIMER                               = 0x80027301,
	TIMER_NOT_ALLOCATED                         = 0x80027302,
	TIMER_COUNTING                              = 0x80027303,
	TIMER_STOPPED                               = 0x80027304,
	THREADMGR_ERROR                             = 0x80028000,
	UNKNOWN_UID                                 = 0x80028001,
	DIFFERENT_UID_CLASS                         = 0x80028002,
	ALREADY_REGISTERED                          = 0x80028003,
	CAN_NOT_WAIT                                = 0x80028004,
	WAIT_TIMEOUT                                = 0x80028005,
	WAIT_DELETE                                 = 0x80028006,
	WAIT_CANCEL                                 = 0x80028007,
	THREAD_ERROR                                = 0x80028020,
	UNKNOWN_THREAD_ID                           = 0x80028021,
	ILLEGAL_THREAD_ID                           = 0x80028022,
	ILLEGAL_PRIORITY                            = 0x80028023,
	ILLEGAL_STACK_SIZE                          = 0x80028024,
	ILLEGAL_CPU_AFFINITY_MASK                   = 0x80028025,
	ILLEGAL_THREAD_PARAM_COMBINATION            = 0x80028026,
	DORMANT                                     = 0x80028027,
	NOT_DORMANT                                 = 0x80028028,
	RUNNING                                     = 0x80028029,
	DELETED                                     = 0x8002802A,
	CAN_NOT_SUSPEND                             = 0x8002802B,
	THREAD_STOPPED                              = 0x8002802C,
	THREAD_SUSPENDED                            = 0x8002802D,
	NOT_SUSPENDED                               = 0x8002802E,
	ALREADY_DEBUG_SUSPENDED                     = 0x8002802F,
	NOT_DEBUG_SUSPENDED                         = 0x80028030,
	CAN_NOT_USE_VFP                             = 0x80028031,
	THREAD_EVENT_ERROR                          = 0x80028060,
	UNKNOWN_THREAD_EVENT_ID                     = 0x80028061,
	KERNEL_TLS_ERROR                            = 0x80028080,
	KERNEL_TLS_FULL                             = 0x80028081,
	ILLEGAL_KERNEL_TLS_INDEX                    = 0x80028082,
	KERNEL_TLS_BUSY                             = 0x80028083,
	CALLBACK_ERROR                              = 0x800280A0,
	UNKNOWN_CALLBACK_ID                         = 0x800280A1,
	NOTIFY_CALLBACK                             = 0x800280A2,
	CALLBACK_NOT_REGISTERED                     = 0x800280A3,
	ALARM_ERROR                                 = 0x800280C0,
	UNKNOWN_ALARM_ID                            = 0x800280C1,
	ALARM_CAN_NOT_CANCEL                        = 0x800280C2,
	EVF_ERROR                                   = 0x800280E0,
	UNKNOWN_EVF_ID                              = 0x800280E1,
	EVF_MULTI                                   = 0x800280E2,
	EVF_COND                                    = 0x800280E3,
	SEMA_ERROR                                  = 0x80028100,
	UNKNOWN_SEMA_ID                             = 0x80028101,
	SEMA_ZERO                                   = 0x80028102,
	SEMA_OVF                                    = 0x80028103,
	SIGNAL_ERROR                                = 0x80028120,
	ALREADY_SENT                                = 0x80028121,
	MUTEX_ERROR                                 = 0x80028140,
	UNKNOWN_MUTEX_ID                            = 0x80028141,
	MUTEX_RECURSIVE                             = 0x80028142,
	MUTEX_LOCK_OVF                              = 0x80028143,
	MUTEX_UNLOCK_UDF                            = 0x80028144,
	MUTEX_FAILED_TO_OWN                         = 0x80028145,
	MUTEX_NOT_OWNED                             = 0x80028146,
	FAST_MUTEX_ERROR                            = 0x80028160,
	UNKNOWN_FAST_MUTEX_ID                       = 0x80028161,
	FAST_MUTEX_RECURSIVE                        = 0x80028162,
	FAST_MUTEX_LOCK_OVF                         = 0x80028163,
	FAST_MUTEX_FAILED_TO_OWN                    = 0x80028164,
	FAST_MUTEX_NOT_OWNED                        = 0x80028165,
	FAST_MUTEX_OWNED                            = 0x80028166,
	FAST_MUTEX_ALREADY_INITIALIZED              = 0x80028167,
	FAST_MUTEX_NOT_INITIALIZED                  = 0x80028168,
	LW_MUTEX_ERROR                              = 0x80028180,
	UNKNOWN_LW_MUTEX_ID                         = 0x80028181,
	LW_MUTEX_RECURSIVE                          = 0x80028182,
	LW_MUTEX_LOCK_OVF                           = 0x80028183,
	LW_MUTEX_UNLOCK_UDF                         = 0x80028184,
	LW_MUTEX_FAILED_TO_OWN                      = 0x80028185,
	LW_MUTEX_NOT_OWNED                          = 0x80028186,
	COND_ERROR                                  = 0x800281A0,
	UNKNOWN_COND_ID                             = 0x800281A1,
	WAIT_DELETE_MUTEX                           = 0x800281A2,
	WAIT_CANCEL_MUTEX                           = 0x800281A3,
	WAIT_DELETE_COND                            = 0x800281A4,
	WAIT_CANCEL_COND                            = 0x800281A5,
	LW_COND_ERROR                               = 0x800281C0,
	UNKNOWN_LW_COND_ID                          = 0x800281C1,
	WAIT_DELETE_LW_MUTEX                        = 0x800281C2,
	WAIT_DELETE_LW_COND                         = 0x800281C3,
	RW_LOCK_ERROR                               = 0x800281E0,
	UNKNOWN_RW_LOCK_ID                          = 0x800281E1,
	RW_LOCK_RECURSIVE                           = 0x800281E2,
	RW_LOCK_LOCK_OVF                            = 0x800281E3,
	RW_LOCK_NOT_OWNED                           = 0x800281E4,
	RW_LOCK_UNLOCK_UDF                          = 0x800281E5,
	RW_LOCK_FAILED_TO_LOCK                      = 0x800281E6,
	RW_LOCK_FAILED_TO_UNLOCK                    = 0x800281E7,
	EVENT_ERROR                                 = 0x80028200,
	UNKNOWN_EVENT_ID                            = 0x80028201,
	EVENT_COND                                  = 0x80028202,
	MSG_PIPE_ERROR                              = 0x80028220,
	UNKNOWN_MSG_PIPE_ID                         = 0x80028221,
	MSG_PIPE_FULL                               = 0x80028222,
	MSG_PIPE_EMPTY                              = 0x80028223,
	MSG_PIPE_DELETED                            = 0x80028224,
	TIMER_ERROR                                 = 0x80028240,
	UNKNOWN_TIMER_ID                            = 0x80028241,
	EVENT_NOT_SET                               = 0x80028242,
	SIMPLE_EVENT_ERROR                          = 0x80028260,
	UNKNOWN_SIMPLE_EVENT_ID                     = 0x80028261,
	PMON_ERROR                                  = 0x80028280,
	PMON_NOT_THREAD_MODE                        = 0x80028281,
	PMON_NOT_CPU_MODE                           = 0x80028282,
	WORK_QUEUE                                  = 0x80028300,
	UNKNOWN_WORK_QUEUE_ID                       = 0x80028301,
	UNKNOWN_WORK_TASK_ID                        = 0x80028302,
	PROCESSMGR_ERROR                            = 0x80029000,
	INVALID_PID                                 = 0x80029001,
	INVALID_PROCESS_TYPE                        = 0x80029002,
	PLS_FULL                                    = 0x80029003,
	INVALID_PROCESS_STATUS                      = 0x80029004,
	PROCESS_CALLBACK_NOTFOUND                   = 0x80029005,
	INVALID_BUDGET_ID                           = 0x80029006,
	INVALID_BUDGET_SIZE                         = 0x80029007,
	CP14_DISABLED                               = 0x80029008,
	EXCEEDED_MAX_PROCESSES                      = 0x80029009,
	PROCESS_REMAINING                           = 0x8002900A,
	NO_PROCESS_DATA                             = 0x8002900B,
	PROCESS_EVENT_INHIBITED                     = 0x8002900C,
	IOFILEMGR_ERROR                             = 0x8002A000,
	IO_NAME_TOO_LONG                            = 0x8002A001,
	IO_REG_DEV                                  = 0x8002A002,
	IO_ALIAS_USED                               = 0x8002A003,
	IO_DEL_DEV                                  = 0x8002A004,
	IO_WOULD_BLOCK                              = 0x8002A005,
	MODULEMGR_START_FAILED                      = 0x8002D000,
	MODULEMGR_STOP_FAIL                         = 0x8002D001,
	MODULEMGR_IN_USE                            = 0x8002D002,
	MODULEMGR_NO_LIB                            = 0x8002D003,
	MODULEMGR_SYSCALL_REG                       = 0x8002D004,
	MODULEMGR_NOMEM_LIB                         = 0x8002D005,
	MODULEMGR_NOMEM_STUB                        = 0x8002D006,
	MODULEMGR_NOMEM_SELF                        = 0x8002D007,
	MODULEMGR_NOMEM                             = 0x8002D008,
	MODULEMGR_INVALID_LIB                       = 0x8002D009,
	MODULEMGR_INVALID_STUB                      = 0x8002D00A,
	MODULEMGR_NO_FUNC_NID                       = 0x8002D00B,
	MODULEMGR_NO_VAR_NID                        = 0x8002D00C,
	MODULEMGR_INVALID_TYPE                      = 0x8002D00D,
	MODULEMGR_NO_MOD_ENTRY                      = 0x8002D00E,
	MODULEMGR_INVALID_PROC_PARAM                = 0x8002D00F,
	MODULEMGR_NO_MODOBJ                         = 0x8002D010,
	MODULEMGR_NO_MOD                            = 0x8002D011,
	MODULEMGR_NO_PROCESS                        = 0x8002D012,
	MODULEMGR_OLD_LIB                           = 0x8002D013,
	MODULEMGR_STARTED                           = 0x8002D014,
	MODULEMGR_NOT_STARTED                       = 0x8002D015,
	MODULEMGR_NOT_STOPPED                       = 0x8002D016,
	MODULEMGR_INVALID_PROCESS_UID               = 0x8002D017,
	MODULEMGR_CANNOT_EXPORT_LIB_TO_SHARED       = 0x8002D018,
	MODULEMGR_INVALID_REL_INFO                  = 0x8002D019,
	MODULEMGR_INVALID_REF_INFO                  = 0x8002D01A,
	MODULEMGR_ELINK                             = 0x8002D01B,
	MODULEMGR_NOENT                             = 0x8002D01C,
	MODULEMGR_BUSY                              = 0x8002D01D,
	MODULEMGR_NOEXEC                            = 0x8002D01E,
	MODULEMGR_NAMETOOLONG                       = 0x8002D01F,
	LIBRARYDB_NOENT                             = 0x8002D080,
	LIBRARYDB_NO_LIB                            = 0x8002D081,
	LIBRARYDB_NO_MOD                            = 0x8002D082,
	PRELOAD_FAILED                              = 0x8002D0F0,
	PRELOAD_LIBC_FAILED                         = 0x8002D0F1,
	PRELOAD_FIOS2_FAILED                        = 0x8002D0F2,
	AUTHFAIL                                    = 0x8002F000,
	NO_AUTH                                     = 0x8002F001
}

SceKernelOpenPsId :: struct {
	id: [16]c.char,
}
#assert(size_of(SceKernelOpenPsId) == 0x10)

/** Threadmgr types */
SceKernelIdListType :: enum c.int {
	SCE_KERNEL_TMID_Thread             = 1,
	SCE_KERNEL_TMID_Semaphore          = 2,
	SCE_KERNEL_TMID_EventFlag          = 3,
	SCE_KERNEL_TMID_Mbox               = 4,
	SCE_KERNEL_TMID_Vpl                = 5,
	SCE_KERNEL_TMID_Fpl                = 6,
	SCE_KERNEL_TMID_Mpipe              = 7,
	SCE_KERNEL_TMID_Callback           = 8,
	SCE_KERNEL_TMID_ThreadEventHandler = 9,
	SCE_KERNEL_TMID_Alarm              = 10,
	SCE_KERNEL_TMID_VTimer             = 11,
	SCE_KERNEL_TMID_SleepThread        = 64,
	SCE_KERNEL_TMID_DelayThread        = 65,
	SCE_KERNEL_TMID_SuspendThread      = 66,
	SCE_KERNEL_TMID_DormantThread      = 67,
}

SceThreadStatus :: enum c.int {
	RUNNING   = 1,
	READY     = 2,
	STANDBY   = 4,
	WAITING   = 8,
	SUSPEND   = 8, /* Compatibility */
	DORMANT   = 16,
	STOPPED   = 16, /* Compatibility */
	DELETED   = 32, /* Thread manager has killed the thread (stack overflow) */
	KILLED    = 32, /* Compatibility */
	DEAD      = 64,
	STAGNANT  = 128,
	SUSPENDED = 256,
}

/** Statistics about a running thread.
 * @see sceKernelGetThreadRunStatus.
 */
SceKernelThreadRunStatus :: struct {
	size: SceSize,
	cpuInfo: [4]struct {
		processId: SceUID,
		threadId: SceUID,
		priority: c.int,
	},
}
#assert(size_of(SceKernelThreadRunStatus) == 0x34)

SceKernelThreadEntry :: #type ^proc(args: SceSize, argp: rawptr) -> c.int

/** Additional options used when creating threads. */
SceKernelThreadOptParam :: struct {
	/** Size of the ::SceKernelThreadOptParam structure. */
	size: SceSize,
	/** Attributes */
	attr: SceUInt32,
	kStackMemType: SceUInt32,
	uStackMemType: SceUInt32,
	uTLSMemType: SceUInt32,
	uStackMemid: SceUInt32,
	data_0x18: SceUInt32,
}
#assert(size_of(SceKernelThreadOptParam) == 0x1C)

/** Structure to hold the status information for a thread
  * @see sceKernelGetThreadInfo
  */
SceKernelThreadInfo :: struct {
	/** Size of the structure */
	size: SceSize,
	/** The UID of the process where the thread belongs */
	processId: SceUID,
	/** Nul terminated name of the thread */
	name: [32]c.char,
	/** Thread attributes */
	attr: SceUInt32,
	/** Thread status */
	status: SceUInt32,
	/** Thread entry point */
	entry: SceKernelThreadEntry,
	/** Thread stack pointer */
	stack: rawptr,
	/** Thread stack size */
	stackSize: SceInt32,
	/** Initial priority */
	initPriority: SceInt32,
	/** Current priority */
	currentPriority: SceInt32,
	/** Initial CPU affinity mask */
	initCpuAffinityMask: SceInt32,
	/** Current CPU affinity mask */
	currentCpuAffinityMask: SceInt32,
	/** Current CPU ID */
	currentCpuId: SceInt32,
	/** Last executed CPU ID */
	lastExecutedCpuId: SceInt32,
	/** Wait type */
	waitType: SceUInt32,
	/** Wait id */
	waitId: SceUID,
	/** Exit status of the thread */
	exitStatus: SceInt32,
	/** Number of clock cycles run */
	runClocks: SceKernelSysClock,
	/** Interrupt preemption count */
	intrPreemptCount: SceUInt32,
	/** Thread preemption count */
	threadPreemptCount: SceUInt32,
	/** Thread release count */
	threadReleaseCount: SceUInt32,
	/** Number of CPUs to which the thread is moved */
	changeCpuCount: SceInt32,
	/** Function notify callback UID */
	fNotifyCallback: SceInt32,
	/** Reserved */
	reserved: SceInt32,
}

/** Inherit calling thread affinity mask. */
SCE_KERNEL_THREAD_CPU_AFFINITY_MASK_DEFAULT :: 0



/** Callback function prototype */
SceKernelCallbackFunction :: #type ^proc(notifyId: c.int, notifyCount: c.int, notifyArg: c.int, userData: rawptr) -> c.int

/** Structure to hold the status information for a callback */
SceKernelCallbackInfo :: struct {
	/** Size of the structure (i.e. sizeof(SceKernelCallbackInfo)) */
	size: SceSize,
	/** The UID of the callback. */
	callbackId: SceUID, // Needs confirmation
	/** The name given to the callback */
	name: [32]c.char,
	/** The thread id associated with the callback */
	threadId: SceUID,
	/** Pointer to the callback function */
	callback: SceKernelCallbackFunction,
	/** User supplied argument for the callback */
	common: rawptr,
	/** Unknown */
	notifyCount: c.int,
	/** Unknown */
	notifyArg: c.int,
}

/** Additional options used when creating semaphores. */
SceKernelSemaOptParam :: struct {
	/** Size of the ::SceKernelSemaOptParam structure. */
	size: SceSize,
}
#assert(size_of(SceKernelSemaOptParam) == 4)

/** Current state of a semaphore.
 * @see sceKernelGetSemaInfo.
 */
SceKernelSemaInfo :: struct {
	/** Size of the ::SceKernelSemaInfo structure. */
	size: SceSize,
	/** The UID of the semaphore */
	semaId: SceUID,
	/** NUL-terminated name of the semaphore. */
	name: [32]c.char,
	/** Attributes. */
	attr: SceUInt,
	/** The initial count the semaphore was created with. */
	initCount: c.int,
	/** The current count. */
	currentCount: c.int,
	/** The maximum count. */
	maxCount: c.int,
	/** The number of threads waiting on the semaphore. */
	numWaitThreads: c.int,
}
#assert(size_of(SceKernelSemaInfo) == 0x3C)



SceKernelWaitableAttribute :: enum c.int {
	THREAD_FIFO  = 0x00000000, //!< Waiting threads First input First output
	THREAD_PRIO  = 0x00002000, //!< Waiting threads queued on priority basis
	OPENABLE     = 0x00000080,  //!< Sync object can be accessed by sceKernelOpenXxx
}

/** Event flag creation attributes */
SceEventFlagAttributes :: enum c.int {
	// Deprecated
	THREAD_FIFO = auto_cast SceKernelWaitableAttribute.THREAD_FIFO, //!< Use SCE_KERNEL_ATTR_THREAD_FIFO
	// Deprecated
	THREAD_PRIO = auto_cast SceKernelWaitableAttribute.THREAD_PRIO, //!< Use SCE_KERNEL_ATTR_THREAD_PRIO
	WAITSINGLE   = 0,          //!< Sync object can only be waited upon by one thread.
	WAITMULTIPLE = 0x00001000, //!< Sync object can be waited upon by multiple threads.
	// Deprecated
	OPENABLE = auto_cast SceKernelWaitableAttribute.OPENABLE, //!< Use SCE_KERNEL_ATTR_OPENABLE
}

SceKernelEventFlagOptParam :: struct {
	size: SceSize,
}
#assert(size_of(SceKernelEventFlagOptParam) == 4)

/** Structure to hold the event flag information */
SceKernelEventFlagInfo :: struct {
	size: SceSize,
	evfId: SceUID,          // Needs confirmation
	name: [32]c.char,
	attr: SceUInt,
	initPattern: SceUInt,
	currentPattern: SceUInt,
	numWaitThreads: c.int,
}
#assert(size_of(SceKernelEventFlagInfo) == 0x38)

/** Event flag wait types */
SceEventFlagWaitTypes :: enum c.int {
	/** Wait for all bits in the pattern to be set */
	WAITAND       = 0,
	/** Wait for one or more bits in the pattern to be set */
	WAITOR        = 1,
	/** Clear all the bits when it matches */
	WAITCLEAR     = 2,
	/** Clear the wait pattern when it matches */
	WAITCLEAR_PAT = 4,
}

SceKernelLwCondWork :: struct {
	data: [4]SceInt32 ,
}
#assert(size_of(SceKernelLwCondWork) == 0x10)

SceKernelLwCondOptParam :: struct {
	size: SceSize,
}
#assert(size_of(SceKernelLwCondOptParam) == 4)



SceKernelLwMutexWork :: struct {
	data: [4]SceInt64,
}
#assert(size_of(SceKernelLwMutexWork) == 0x20)

SceKernelLwMutexOptParam :: struct {
	size: SceSize,
}
#assert(size_of(SceKernelLwMutexOptParam) == 4)

SceKernelMutexAttribute :: enum c.int {
	RECURSIVE   = 0x02,
	CEILING     = 0x04,
}

/** Additional options used when creating mutexes. */
SceKernelMutexOptParam :: struct {
	/** Size of the ::SceKernelMutexOptParam structure. */
	size: SceSize,
	ceilingPriority: c.int,
}
#assert(size_of(SceKernelMutexOptParam) == 8)

/** Current state of a mutex.
 * @see sceKernelGetMutexInfo.
 */
SceKernelMutexInfo ::  struct {
	/** Size of the ::SceKernelMutexInfo structure. */
	size: SceSize,
	/** The UID of the mutex. */
	mutexId: SceUID,
	/** NUL-terminated name of the mutex. */
	name: [32]c.char,
	/** Attributes. */
	attr: SceUInt,
	/** The initial count the mutex was created with. */
	initCount: c.int,
	/** The current count. */
	currentCount: c.int,
	/** The UID of the current owner of the mutex. */
	currentOwnerId: SceUID,
	/** The number of threads waiting on the mutex. */
	numWaitThreads: c.int,
}
#assert(size_of(SceKernelMutexInfo) == 0x3C)

/** Additional options used when creating condition variables. */
SceKernelCondOptParam :: struct {
	/** Size of the ::SceKernelCondOptParam structure. */
	size: SceSize,
}
#assert(size_of(SceKernelCondOptParam) == 4)

/** Current state of a condition variable.
 * @see sceKernelGetCondInfo.
 */
SceKernelCondInfo :: struct {
	/** Size of the ::SceKernelCondInfo structure. */
	size: SceSize,
	/** The UID of the condition variable. */
	condId: SceUID,
	/** NUL-terminated name of the condition variable. */
	name: [32]c.char,
	/** Attributes. */
	attr: SceUInt,
	/** Mutex associated with the condition variable. */
	mutexId: SceUID,
	/** The number of threads waiting on the condition variable. */
	numWaitThreads: c.int,
}
#assert(size_of(SceKernelCondInfo) == 0x34)

/**
 * @brief      Return values for plugins `module_start` and `module_stop`
 */
/** @{ */
SCE_KERNEL_START_SUCCESS     ::  (0)
SCE_KERNEL_START_RESIDENT    ::  SCE_KERNEL_START_SUCCESS
SCE_KERNEL_START_NO_RESIDENT ::  (1)
SCE_KERNEL_START_FAILED      ::  (2)

SCE_KERNEL_STOP_SUCCESS      ::  (0)
SCE_KERNEL_STOP_FAIL         ::  (1)
SCE_KERNEL_STOP_CANCEL       ::  SCE_KERNEL_STOP_FAIL
/** @} */

SceKernelModuleState :: enum c.int {
    READY   = 0x00000002,
    STARTED = 0x00000006,
    ENDED   = 0x00000009
}

/*
 * Assigning the following macro to the variable sceKernelPreloadModuleInhibit with the OR operator inhibit preloading that module.
 *
 * Example
 * <code>
 * // Inhibit preload SceLibc and SceShellSvc.
 * int sceKernelPreloadModuleInhibit = SCE_KERNEL_PRELOAD_INHIBIT_LIBC | SCE_KERNEL_PRELOAD_INHIBIT_LIBSHELLSVC;
 * </code>
 *
 * And these are only valid for modules in the process image, preload is not inhibited even if specified for modules to be loaded later.
 *
 * WARNING
 * If SceLibNet etc. is loaded without SceShellSvc etc. loaded, an unintended system crash will occur.
 */
SceKernelPreloadInhibit :: enum c.int {
	NONE        = 0x00000000,
	LIBC        = 0x10000,
	LIBDBG      = 0x20000,
	LIBSHELLSVC = 0x80000,
	LIBCDLG     = 0x100000,
	LIBFIOS2    = 0x200000,
	APPUTIL     = 0x400000,
	LIBSCEFT2   = 0x800000,
	LIBPVF      = 0x1000000,
	LIBPERF     = 0x2000000
}
#assert(size_of(SceKernelPreloadInhibit) == 4)


SceKernelSegmentInfo :: struct {
	size: SceSize,   //!< this structure size (0x18)
  perms: SceUInt,  //!< probably rwx in low bits
  vaddr: rawptr,    //!< address in memory
  memsz: SceSize,  //!< size in memory
  filesz: SceSize, //!< original size of memsz
  res: SceUInt,    //!< unused
}

SceKernelModuleInfo :: struct {
	size: SceSize,                       //!< 0x1B8 for Vita 1.x
  modid: SceUID,
  modattr: c.uint16_t,
  modver: [2]c.uint8_t,
  module_name: [28]c.char,
  unk28: SceUInt,
  start_entry: rawptr,
  stop_entry: rawptr,
  exit_entry: rawptr,
  exidx_top: rawptr,
  exidx_btm: rawptr,
  extab_top: rawptr,
  extab_btm: rawptr,
  tlsInit: rawptr,
  tlsInitSize: SceSize,
  tlsAreaSize: SceSize,
  path: [256]c.char,
  segments: [4]SceKernelSegmentInfo,
  state: SceUInt,                       //!< see:SceKernelModuleState
}

SceKernelLMOption :: struct {
	size: SceSize,
}
#assert(size_of(SceKernelLMOption) == 4)

SceKernelULMOption :: struct {
	size: SceSize,
}
#assert(size_of(SceKernelULMOption) == 4)

SceKernelSystemSwVersion :: struct {
	size: SceSize,
	versionString: [0x1C]c.char,
	version: SceUInt,
	unk_24: SceUInt,
}
#assert(size_of(SceKernelSystemSwVersion) == 0x28)

/* For backward compatibility */
SceKernelFwInfo :: SceKernelSystemSwVersion

SceKernelModuleLibraryInfo :: struct {
	size: SceSize, //!< sizeof(SceKernelModuleLibraryInfo) : 0x120
  library_id: SceUID,
  libnid: c.uint32_t,
  version: c.uint16_t,
  flags: c.uint16_t,
  entry_num_function: c.uint16_t,
  entry_num_variable: c.uint16_t,
  unk_0x14: c.uint16_t,
  unk_0x16: c.uint16_t,
  library_name: [0x100]c.char,
  number_of_imported: SceSize,
  modid2: SceUID,
}
#assert(size_of(SceKernelModuleLibraryInfo) == 0x120)

SceKernelProcessType :: distinct SceUInt32
SceKernelClock :: distinct SceUInt64
SceKernelTime :: distinct SceUInt32

SceKernelTimeval :: struct {
	sec: SceInt32,
	usec: SceInt32,
}
#assert(size_of(SceKernelTimeval) == 8)

SceKernelTimezone :: struct {
	value: SceUInt64,
}
#assert(size_of(SceKernelTimezone) == 8)

SceKernelProcessPrioritySystem :: enum c.int {
	SCE_KERNEL_PROCESS_PRIORITY_SYSTEM_HIGH     = 32,
	SCE_KERNEL_PROCESS_PRIORITY_SYSTEM_DEFAULT  = 96,
	SCE_KERNEL_PROCESS_PRIORITY_SYSTEM_LOW      = 159,
	__SCE_KERNEL_PROCESS_PRIORITY_SYSTEM = -1 // 0xFFFFFFFF
}
#assert(size_of(SceKernelProcessPrioritySystem) == 4)

SceKernelProcessPriorityUser :: enum c.int {
	SCE_KERNEL_PROCESS_PRIORITY_USER_HIGH       = 64,
	SCE_KERNEL_PROCESS_PRIORITY_USER_DEFAULT    = 96,
	SCE_KERNEL_PROCESS_PRIORITY_USER_LOW        = 127,
	__SCE_KERNEL_PROCESS_PRIORITY_USER = -1 // 0xFFFFFFFF
}
#assert(size_of(SceKernelProcessPriorityUser) == 4)

SceKernelPowerTickType :: enum c.int {
	/** Cancel all timers */
	SCE_KERNEL_POWER_TICK_DEFAULT			= 0,
	/** Cancel automatic suspension timer */
	SCE_KERNEL_POWER_TICK_DISABLE_AUTO_SUSPEND	= 1,
	/** Cancel OLED-off timer */
	SCE_KERNEL_POWER_TICK_DISABLE_OLED_OFF		= 4,
	/** Cancel OLED dimming timer */
	SCE_KERNEL_POWER_TICK_DISABLE_OLED_DIMMING	= 6,
	__SCE_KERNEL_POWER_TICK_DISABLE = -1 // 0xFFFFFFFF
}
#assert(size_of(SceKernelPowerTickType) == 4)

SceKernelMemBlockType :: distinct SceUInt32
#assert(size_of(SceKernelMemBlockType) == 4)

/*
 * User/Kernel shared memtypes
 */

SCE_KERNEL_MEMBLOCK_TYPE_USER_CDRAM_L1WBWA_RW    :: (0x09404060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_CDRAM_R            :: (0x09408040)
SCE_KERNEL_MEMBLOCK_TYPE_USER_CDRAM_RW           :: (0x09408060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_DEVICE_RW     :: (0x0C200860)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_R             :: (0x0C20D040)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_RW            :: (0x0C20D060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_NC_RW         :: (0x0C208060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_GAME_RW       :: (0x0C50D060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_PHYCONT_RW    :: (0x0C80D060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_PHYCONT_NC_RW :: (0x0D808060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_CDIALOG_RW    :: (0x0CA0D060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_CDIALOG_NC_RW :: (0x0CA08060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_TOOL_RW       :: (0x0CF0D060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_MAIN_TOOL_NC_RW    :: (0x0CF08060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_CDIALOG_R          :: (0x0E20D040)
SCE_KERNEL_MEMBLOCK_TYPE_USER_CDIALOG_RW         :: (0x0E20D060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_CDIALOG_NC_R       :: (0x0E208040)
SCE_KERNEL_MEMBLOCK_TYPE_USER_CDIALOG_NC_RW      :: (0x0E208060)


/*
 * For Backwards compatibility
 */

SCE_KERNEL_MEMBLOCK_TYPE_USER_RW_UNCACHE        :: (0x0C208060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_RW                :: (0x0C20D060)
SCE_KERNEL_MEMBLOCK_TYPE_USER_TOOL_NC_RW        :: (0x0CF08060)


SceKernelAllocMemBlockAttr :: enum c.uint {
	HAS_PADDR          = 0x00000002,
	HAS_ALIGNMENT      = 0x00000004,
	HAS_MIRROR_BLOCKID = 0x00000040,
	HAS_PID            = 0x00000080,
	HAS_PADDR_LIST     = 0x00001000,
	PHYCONT            = 0x00200000,
	ALLOW_PARTIAL_OP   = 0x04000000,
}

SceKernelModel :: enum c.int {
	VITA   = 0x10000,
	VITATV = 0x20000
}

SCE_KERNEL_CPU_MASK_USER_0 :: 0x00010000
SCE_KERNEL_CPU_MASK_USER_1 :: 0x00020000
SCE_KERNEL_CPU_MASK_USER_2 :: 0x00040000
SCE_KERNEL_CPU_MASK_SYSTEM :: 0x00080000

SCE_KERNEL_CPU_MASK_USER_ALL :: (SCE_KERNEL_CPU_MASK_USER_0 | SCE_KERNEL_CPU_MASK_USER_1 | SCE_KERNEL_CPU_MASK_USER_2)

SceKernelAllocMemBlockOpt :: struct {
    size: SceSize,
    attr: SceUInt32,
    alignment: SceSize,
    uidBaseBlock: SceUInt32,
    strBaseBlockName: cstring,
    flags: c.int,                     //! Unknown flags 0x10 or 0x30 for ::sceKernelOpenMemBlock
    reserved: [10]c.int,
}

SceKernelFreeMemorySizeInfo :: struct {
    size: c.int,         //!< sizeof(SceKernelFreeMemorySizeInfo)
    size_user: c.int,    //!< Free memory size for *_USER_RW memory
    size_cdram: c.int,   //!< Free memory size for USER_CDRAM_RW memory
    size_phycont: c.int, //!< Free memory size for USER_MAIN_PHYCONT_*_RW memory
}
#assert(size_of(SceKernelFreeMemorySizeInfo) == 0x10)

SceKernelMemBlockInfo :: struct {
    size: SceSize,
    mappedBase: rawptr,
    mappedSize: SceSize,
    memoryType: c.int,
    access: SceUInt32,
    type: SceKernelMemBlockType,
}

SceKernelMemoryAccessType :: enum c.int {
    SCE_KERNEL_MEMORY_ACCESS_X = 0x01,
    SCE_KERNEL_MEMORY_ACCESS_W = 0x02,
    SCE_KERNEL_MEMORY_ACCESS_R = 0x04
}

SceKernelMemoryType :: enum c.int {
    SCE_KERNEL_MEMORY_TYPE_NORMAL_NC = 0x80,
    SCE_KERNEL_MEMORY_TYPE_NORMAL    = 0xD0
}

foreign libkernel {
    /**
    * Fills the output buffer with random data.
    *
    * @param[out] output - Output buffer
    * @param[in] size - Size of the output buffer, 64 bytes maximum
    *
    * @return 0 on success, < 0 on error.
    */
    sceKernelGetRandomNumber :: proc(output: rawptr, size: SceSize) -> c.int ---

    /**
    * Gets the status of a specified callback.
    *
    * @param cb - The UID of the callback to retrieve info for.
    * @param status - Pointer to a status structure. The size parameter should be
    * initialised before calling.
    *
    * @return < 0 on error.
    */
    sceKernelGetCallbackInfo :: proc(cb: SceUID, infop: ^SceKernelCallbackInfo) -> c.int ---

    /**
    * Creates a new condition variable
    *
    * @par Example:
    * @code
    * SceUID condId
    * condId = sceKernelCreateCond("MyCond", 0, mutexId, NULL)
    * @endcode
    *
    * @param name - Specifies the name of the condition variable
    * @param attr - Condition variable attribute flags (normally set to 0)
    * @param mutexId - Mutex to be related to the condition variable
    * @param option - Condition variable options (normally set to 0)
    * @return A condition variable id
    */
    sceKernelCreateCond :: proc(name: cstring, attr: SceUInt, mutexId: SceUID, option: ^SceKernelCondOptParam) -> SceUID ---

    /**
    * Waits for a signal of a condition variable
    *
    * @param condId - The condition variable id returned from ::sceKernelCreateCond
    * @param timeout - Timeout in microseconds (assumed)
    * @return < 0 On error.
    */
    sceKernelWaitCond :: proc(condId: SceUID, timeout: ^c.uint) -> c.int ---

    /**
    * Waits for a signal of a condition variable (with callbacks)
    *
    * @param condId - The condition variable id returned from ::sceKernelCreateCond
    * @param timeout - Timeout in microseconds (assumed)
    * @return < 0 On error.
    */
    sceKernelWaitCondCB :: proc(condId: SceUID, timeout: ^c.uint) -> c.int ---

    /**
    * Create an event flag.
    *
    * @param name - The name of the event flag.
    * @param attr - Attributes from ::SceEventFlagAttributes
    * @param bits - Initial bit pattern.
    * @param opt  - Options, set to NULL
    * @return < 0 on error. >= 0 event flag id.
    *
    * @par Example:
    * @code
    * int evid
    * evid = sceKernelCreateEventFlag("wait_event", 0, 0, NULL)
    * @endcode
    */
    sceKernelCreateEventFlag :: proc(name: cstring, attr: c.int, bits: c.int, opt: ^SceKernelEventFlagOptParam) -> SceUID ---

    /**
    * Poll an event flag for a given bit pattern.
    *
    * @param evid - The event id returned by ::sceKernelCreateEventFlag.
    * @param bits - The bit pattern to poll for.
    * @param wait - Wait type, one or more of ::SceEventFlagWaitTypes or'ed together
    * @param outBits - The bit pattern that was matched.
    * @return < 0 On error
    */
    sceKernelPollEventFlag :: proc(evid: c.int, bits: c.uint, wait: c.uint, outBits: ^c.uint) -> c.int ---

    /**
    * Wait for an event flag for a given bit pattern.
    *
    * @param evid - The event id returned by ::sceKernelCreateEventFlag.
    * @param bits - The bit pattern to poll for.
    * @param wait - Wait type, one or more of ::SceEventFlagWaitTypes or'ed together
    * @param outBits - The bit pattern that was matched.
    * @param timeout  - Timeout in microseconds
    * @return < 0 On error
    */
    sceKernelWaitEventFlag :: proc(evid: c.int, bits: c.uint, wait: c.uint, outBits: ^c.uint, timeout: ^SceUInt) -> c.int ---

    /**
    * Wait for an event flag for a given bit pattern with callback.
    *
    * @param evid - The event id returned by ::sceKernelCreateEventFlag.
    * @param bits - The bit pattern to poll for.
    * @param wait - Wait type, one or more of ::SceEventFlagWaitTypes or'ed together
    * @param outBits - The bit pattern that was matched.
    * @param timeout  - Timeout in microseconds
    * @return < 0 On error
    */
    sceKernelWaitEventFlagCB :: proc(evid: c.int, bits: c.uint, wait: c.uint, outBits: ^c.uint, timeout: ^SceUInt) -> c.int ---

    /**
    * Get the status of an event flag.
    *
    * @param event - The UID of the event.
    * @param status - A pointer to a ::SceKernelEventFlagInfo structure.
    *
    * @return < 0 on error.
    */
    sceKernelGetEventFlagInfo :: proc(event: SceUID, info: ^SceKernelEventFlagInfo) -> c.int ---

    sceKernelCreateLwCond :: proc(pWork: ^SceKernelLwCondWork, pName: cstring, attr: c.uint, pLwMutex: ^SceKernelLwMutexWork, pOptParam: ^SceKernelLwCondOptParam) -> c.int ---
    sceKernelDeleteLwCond :: proc(pWork: ^SceKernelLwCondWork) -> c.int ---
    sceKernelSignalLwCond :: proc(pWork: ^SceKernelLwCondWork) -> c.int ---
    sceKernelSignalLwCondAll :: proc(pWork: ^SceKernelLwCondWork) -> c.int ---
    sceKernelSignalLwCondTo :: proc(pWork: ^SceKernelLwCondWork, threadId: SceUID) -> c.int ---
    sceKernelWaitLwCond :: proc(pWork: ^SceKernelLwCondWork, pTimeout: ^c.uint) -> c.int ---

    sceKernelCreateLwMutex :: proc(pWork: ^SceKernelLwMutexWork, pName: cstring, attr: c.uint, initCount: c.int, pOptParam: ^SceKernelLwMutexOptParam) -> c.int ---
    sceKernelDeleteLwMutex :: proc(pWork: ^SceKernelLwMutexWork) -> c.int ---
    sceKernelLockLwMutex :: proc(pWork: ^SceKernelLwMutexWork, lockCount: c.int, pTimeout: ^c.uint) -> c.int ---
    sceKernelTryLockLwMutex :: proc(pWork: ^SceKernelLwMutexWork, lockCount: c.int) -> c.int ---
    sceKernelUnlockLwMutex :: proc(pWork: ^SceKernelLwMutexWork, unlockCount: c.int) -> c.int ---

    /**
    * Create a message pipe
    *
    * @param name - Name of the pipe
    * @param type - The type of memory attribute to use internally (set to 0x40)
    * @param attr - Set to 12
    * @param bufSize - The size of the internal buffer in multiples of 0x1000 (4KB)
    * @param opt  - Message pipe options (set to NULL)
    *
    * @return The UID of the created pipe, < 0 on error
    */
    sceKernelCreateMsgPipe :: proc(name: cstring, type: c.int, attr: c.int, bufSize: c.uint, opt: rawptr) -> SceUID ---

    /**
    * Send a message to a pipe
    *
    * @param uid - The UID of the pipe
    * @param message - Pointer to the message
    * @param size - Size of the message
    * @param unk1 - Unknown - async vs sync? use 0 for sync
    * @param unk2 - Unknown - use NULL
    * @param timeout - Timeout for send in us. use NULL to wait indefinitely
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelSendMsgPipe :: proc(uid: SceUID , message: rawptr, size: c.uint, unk1: c.int, unk2: rawptr, timeout: ^c.uint) -> c.int ---

    /**
    * Send a message to a pipe (with callback)
    *
    * @param uid - The UID of the pipe
    * @param message - Pointer to the message
    * @param size - Size of the message
    * @param unk1 - Unknown - async vs sync? use 0 for sync
    * @param unk2 - Unknown - use NULL
    * @param timeout - Timeout for send in us. use NULL to wait indefinitely
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelSendMsgPipeCB :: proc(uid: SceUID, message: rawptr, size: c.uint, unk1: c.int, unk2: rawptr, timeout: ^c.uint) -> c.int ---

    /**
    * Try to send a message to a pipe
    *
    * @param uid - The UID of the pipe
    * @param message - Pointer to the message
    * @param size - Size of the message
    * @param unk1 - Unknown - use 0
    * @param unk2 - Unknown - use NULL
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelTrySendMsgPipe :: proc(uid: SceUID, message: rawptr, size: SceSize, unk1: c.int, unk2: rawptr) -> c.int ---

    /**
    * Receive a message from a pipe
    *
    * @param uid - The UID of the pipe
    * @param message - Pointer to the message
    * @param size - Size of the message
    * @param unk1 - Unknown - async vs sync? use 0 for sync
    * @param unk2 - Unknown - use NULL
    * @param timeout - Timeout for receive in us. use NULL to wait indefinitely
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelReceiveMsgPipe :: proc(uid: SceUID, message: rawptr, size: SceSize, unk1: c.int, unk2: rawptr, timeout: ^c.uint) -> c.int ---

    /**
    * Receive a message from a pipe (with callback)
    *
    * @param uid - The UID of the pipe
    * @param message - Pointer to the message
    * @param size - Size of the message
    * @param unk1 - Unknown - async vs sync? use 0 for sync
    * @param unk2 - Unknown - use NULL
    * @param timeout - Timeout for receive in us. use NULL to wait indefinitely
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelReceiveMsgPipeCB :: proc(uid: SceUID, message: rawptr, size: SceSize, unk1: c.int, unk2: rawptr, timeout: ^c.uint) -> c.int ---

    /**
    * Receive a message from a pipe
    *
    * @param uid - The UID of the pipe
    * @param message - Pointer to the message
    * @param size - Size of the message
    * @param unk1 - Unknown - use 0
    * @param unk2 - Unknown - use NULL
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelTryReceiveMsgPipe :: proc(uid: SceUID, message: rawptr, size: SceSize, unk1: c.int, unk2: rawptr) -> c.int ---


    /**
    * Cancel a message pipe
    *
    * @param uid - UID of the pipe to cancel
    * @param psend - Receive number of sending threads, NULL is valid
    * @param precv - Receive number of receiving threads, NULL is valid
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelCancelMsgPipe :: proc(uid: SceUID, psend: ^c.int, precv: ^c.int) -> c.int ---

    /**
    * Get the status of a Message Pipe
    *
    * @param uid - The uid of the Message Pipe
    * @param info - Pointer to a ::SceKernelMppInfo structure
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelGetMsgPipeInfo :: proc(uid: SceUID, info: ^SceKernelMppInfo) -> c.int ---

    /**
    * Creates a new mutex
    *
    * @par Example:
    * @code
    * int mutexid
    * mutexid = sceKernelCreateMutex("MyMutex", 0, 1, NULL)
    * @endcode
    *
    * @param name - Specifies the name of the mutex
    * @param attr - Mutex attribute flags (normally set to 0)
    * @param initCount - Mutex initial value
    * @param option - Mutex options (normally set to 0)
    * @return A mutex id
    */
    sceKernelCreateMutex :: proc(name: cstring, attr: SceUInt, initCount: c.int, option: ^SceKernelMutexOptParam) -> SceUID ---

    /**
    * Lock a mutex
    *
    * @param mutexid - The mutex id returned from ::sceKernelCreateMutex
    * @param lockCount - The value to increment to the lock count of the mutex
    * @param timeout - Timeout in microseconds (assumed)
    * @return < 0 On error.
    */
    sceKernelLockMutex :: proc(mutexid: SceUID, lockCount: c.int, timeout: ^c.uint) -> c.int ---

    /**
    * Lock a mutex and handle callbacks if necessary.
    *
    * @param mutexid - The mutex id returned from ::sceKernelCreateMutex
    * @param lockCount - The value to increment to the lock count of the mutex
    * @param timeout - Timeout in microseconds (assumed)
    * @return < 0 On error.
    */
    sceKernelLockMutexCB :: proc(mutexid: SceUID, lockCount: c.int, timeout: ^c.uint) -> c.int ---

    /**
    * Cancels a mutex
    *
    * @param mutexid - The mutex id returned from ::sceKernelCreateMutex
    * @param newCount - The new lock count of the mutex
    * @param numWaitThreads - Number of threads waiting for the mutex
    * @return < 0 On error.
    */
    sceKernelCancelMutex :: proc(mutexid: SceUID, newCount: c.int, numWaitThreads: ^c.int) -> c.int ---

    /**
    * Retrieve information about a mutex.
    *
    * @param mutexid - UID of the mutex to retrieve info for.
    * @param info - Pointer to a ::SceKernelMutexInfo struct to receive the info.
    *
    * @return < 0 on error.
    */
    sceKernelGetMutexInfo :: proc(mutexid: SceUID, info: ^SceKernelMutexInfo) -> c.int ---

    /**
    * Creates a new rwlock
    *
    * @par Example:
    * @code
    * int rwlock_id
    * rwlock_id = sceKernelCreateRWLock("MyRWLock", 0, NULL)
    * @endcode
    *
    * @param name - Specifies the name of the rwlock
    * @param attr - RWLock attribute flags (normally set to 0)
    * @param option - RWLock options (normally set to NULL)
    * @return RWLock id on success, < 0 on error
    */
    sceKernelCreateRWLock :: proc(name: cstring, attr: SceUInt32, opt_param: ^SceKernelRWLockOptParam) -> SceUID ---

    /**
    * Lock a rwlock with read access
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @param timeout - Timeout in microseconds, use NULL to disable it
    * @return 0 on success, < 0 on error
    */
    sceKernelLockReadRWLock :: proc(rwlock_id: SceUID, timeout: ^c.uint) -> c.int ---

    /**
    * Lock a rwlock with write access
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @param timeout - Timeout in microseconds, use NULL to disable it
    * @return 0 on success, < 0 on error
    */
    sceKernelLockWriteRWLock :: proc(rwlock_id: SceUID, timeout: ^c.uint) -> c.int ---

    /**
    * Lock a rwlock with read access and handle callbacks
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @param timeout - Timeout in microseconds, use NULL to disable it
    * @return 0 on success, < 0 on error
    */
    sceKernelLockReadRWLockCB :: proc(rwlock_id: SceUID, timeout: ^c.uint) -> c.int ---

    /**
    * Lock a rwlock with write access and handle callbacks
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @param timeout - Timeout in microseconds, use NULL to disable it
    * @return 0 on success, < 0 on error
    */
    sceKernelLockWriteRWLockCB :: proc(rwlock_id: SceUID, timeout: ^c.uint) -> c.int ---

    /**
    * Retrieve information about a rwlock.
    *
    * @param rwlock_id - UID of the rwlock to retrieve info for.
    * @param info - Pointer to a ::SceKernelRWLockInfo struct to receive the info.
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelGetRWLockInfo :: proc(rwlock_id: SceUID, info: ^SceKernelRWLockInfo) -> c.int ---

    /**
    * Creates a new semaphore
    *
    * @par Example:
    * @code
    * int semaid
    * semaid = sceKernelCreateSema("MySema", 0, 1, 1, NULL)
    * @endcode
    *
    * @param name - Specifies the name of the sema
    * @param attr - Sema attribute flags (normally set to 0)
    * @param initVal - Sema initial value
    * @param maxVal - Sema maximum value
    * @param option - Sema options (normally set to 0)
    * @return A semaphore id
    */
    sceKernelCreateSema :: proc(name: cstring, attr: SceUInt, initVal: c.int, maxVal: c.int, option: ^SceKernelSemaOptParam) -> SceUID ---


    /**
    * Lock a semaphore
    *
    * @par Example:
    * @code
    * sceKernelWaitSema(semaid, 1, 0)
    * @endcode
    *
    * @param semaid - The sema id returned from ::sceKernelCreateSema
    * @param signal - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
    * @param timeout - Timeout in microseconds (assumed).
    *
    * @return < 0 on error.
    */
    sceKernelWaitSema :: proc(semaid: SceUID, signal: c.int, timeout: ^SceUInt) -> c.int ---

    /**
    * Lock a semaphore and handle callbacks if necessary.
    *
    * @par Example:
    * @code
    * sceKernelWaitSemaCB(semaid, 1, 0)
    * @endcode
    *
    * @param semaid - The sema id returned from ::sceKernelCreateSema
    * @param signal - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
    * @param timeout - Timeout in microseconds (assumed).
    *
    * @return < 0 on error.
    */
    sceKernelWaitSemaCB :: proc(semaid: SceUID, signal: c.int, timeout: ^SceUInt) -> c.int ---

    /**
    * Cancels a semaphore
    *
    * @param semaid - The sema id returned from ::sceKernelCreateSema
    * @param setCount - The new lock count of the semaphore
    * @param numWaitThreads - Number of threads waiting for the semaphore
    * @return < 0 On error.
    */
    sceKernelCancelSema :: proc(semaid: SceUID, setCount: c.int, numWaitThreads: ^c.int) -> c.int ---

    /**
    * Retrieve information about a semaphore.
    *
    * @param semaid - UID of the semaphore to retrieve info for.
    * @param info - Pointer to a ::SceKernelSemaInfo struct to receive the info.
    *
    * @return < 0 on error.
    */
    sceKernelGetSemaInfo :: proc(semaid: SceUID, info: ^SceKernelSemaInfo) -> c.int ---

    /**
    * @brief Sleep current thread and wait for a signal. After it receives a signal, the thread wakes up.
    *
    * This is like a semphore with limit 1.
    * If signal was sent before and not consumed before, the function will immediately return.
    * @param unk0 unknown parameter. 0 can be used.
    * @param delay the delay before wating for a signal
    * @param timeout the timeout if it's null, it waits indefinitely.
    * @return 0 on success
    */
    sceKernelWaitSignal :: proc(unk0: SceUInt32, delay: SceUInt32, timeout: ^SceUInt32) -> c.int ---

    /**
    * Create a thread
    *
    * @par Example:
    * @code
    * SceUID thid
    * thid = sceKernelCreateThread("my_thread", threadFunc, 0x10000100, 0x10000, 0, 0, NULL)
    * @endcode
    *
    * @param name - An arbitrary thread name.
    * @param entry - The thread function to run when started.
    * @param initPriority - The initial priority of the thread. Less if higher priority.
    * @param stackSize - The size of the initial stack.
    * @param attr - The thread attributes, zero or more of ::SceThreadAttributes.
    * @param cpuAffinityMask - The CPU affinity mask
    *                          A thread can run only on the cores specified in the CPU affinity mask.
    *                          The CPU affinity mask can be specified by the logical sum of the following macros:
    *                          - SCE_KERNEL_CPU_MASK_USER_0
    *                          - SCE_KERNEL_CPU_MASK_USER_1
    *                          - SCE_KERNEL_CPU_MASK_USER_2
    *                          - SCE_KERNEL_CPU_MASK_SYSTEM (system-reserved core)
    *                          The following macro are also available to represent all available in userland CPU cores:
    *                          - SCE_KERNEL_CPU_MASK_USER_ALL
    *                          The following macro are also available to inherit affinity mask of the calling process:
    *                          - SCE_KERNEL_THREAD_CPU_AFFINITY_MASK_DEFAULT
    * @param option - Additional options specified by ::SceKernelThreadOptParam.

    * @return UID of the created thread, or an error code.
    */
    sceKernelCreateThread :: proc(name: cstring, entry: SceKernelThreadEntry, initPriority: c.int, stackSize: SceSize, attr: SceUInt, cpuAffinityMask: c.int, option: ^SceKernelThreadOptParam) -> SceUID ---


    /**
    * Start a created thread
    *
    * @param thid - Thread id from ::sceKernelCreateThread
    * @param arglen - Length of the data pointed to by argp, in bytes
    * @param argp - Pointer to the arguments.
    */
    sceKernelStartThread :: proc(thid: SceUID, arglen: SceSize, argp: rawptr) -> c.int ---


    /**
    * Wait until a thread has ended.
    *
    * @param thid - Id of the thread to wait for.
    * @param stat - Exit status.
    * @param timeout - Timeout in microseconds (assumed).
    *
    * @return < 0 on error.
    */
    sceKernelWaitThreadEnd :: proc(thid: SceUID, stat: ^c.int, timeout: ^SceUInt) -> c.int ---

    /**
    * Wait until a thread has ended and handle callbacks if necessary.
    *
    * @param thid - Id of the thread to wait for.
    * @param stat - Exit status.
    * @param timeout - Timeout in microseconds (assumed).
    *
    * @return < 0 on error.
    */
    sceKernelWaitThreadEndCB :: proc(thid: SceUID, stat: ^c.int, timeout: ^SceUInt) -> c.int ---

    /**
    * Modify the attributes of the current thread.
    *
    * @param clearAttr - The thread attributes to clear.  One of ::SceThreadAttributes.
    * @param setAttr - The thread attributes to set.  One of ::SceThreadAttributes.
    *
    * @return < 0 on error.
    */
    sceKernelChangeCurrentThreadAttr :: proc(clearAttr: SceUInt, setAttr: SceUInt) -> c.int ---


    /**
    * Get the current priority of the thread you are in.
    *
    * @return The current thread priority
    */
    sceKernelGetThreadCurrentPriority :: proc() -> c.int ---

    /**
    * Get the exit status of a thread.
    *
    * @param[in]  thid   - The UID of the thread to check.
    * @param[out] status - Status out pointer
    * @return The exit status
    */
    sceKernelGetThreadExitStatus :: proc(thid: SceUID, status: ^c.int) -> c.int ---

    /**
    * Check the thread stack?
    *
    * @return Unknown.
    */
    sceKernelCheckThreadStack :: proc() -> c.int ---


    /**
    * Get the status information for the specified thread.
    *
    * @param thid - Id of the thread to get status
    * @param info - Pointer to the info structure to receive the data.
    * Note: The structures size field should be set to
    * sizeof(SceKernelThreadInfo) before calling this function.
    *
    * @par Example:
    * @code
    * SceKernelThreadInfo status
    * status.size = sizeof(SceKernelThreadInfo)
    * if(sceKernelGetThreadInfo(thid, &status) == 0)
    * { Do something... }
    * @endcode
    * @return 0 if successful, otherwise the error code.
    */
    sceKernelGetThreadInfo :: proc(thid: SceUID, info: ^SceKernelThreadInfo) -> c.int ---

    /**
    * Retrive the runtime status of a thread.
    *
    * @param thid - UID of the thread to retrieve status.
    * @param status - Pointer to a ::SceKernelThreadRunStatus struct to receive the runtime status.
    *
    * @return 0 if successful, otherwise the error code.
    */
    sceKernelGetThreadRunStatus :: proc(thid: SceUID, status: ^SceKernelThreadRunStatus) -> c.int ---

    /**
    * Get the current thread Id
    *
    * @return The thread id of the calling thread.
    */
    sceKernelGetThreadId :: proc() -> c.int ---

    /**
    * Get the system information
    *
    * @param info - Pointer to a ::SceKernelSystemInfo structure
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelGetSystemInfo :: proc(info: ^SceKernelSystemInfo) -> c.int ---

    /**
    * @brief sceKernelGetTLSAddr get pointer to TLS key area for current thread
    * @param key - the TLS keyslot index
    * @return pointer to TLS key value
    */
    sceKernelGetTLSAddr :: proc(key: c.int) -> rawptr ---

    sceKernelAtomicSet8 :: proc(store: ^SceInt8, value: SceInt8) ---
    sceKernelAtomicSet16 :: proc(store: ^SceInt16, value: SceInt16) ---
    sceKernelAtomicSet32 :: proc(store: ^SceInt32, value: SceInt32) ---
    sceKernelAtomicSet64 :: proc(store: ^SceInt64, value: SceInt64) ---

    sceKernelAtomicCompareAndSet8 :: proc(store: ^SceInt8, value: SceInt8, new_value: SceInt8) -> SceInt8 ---
    sceKernelAtomicCompareAndSet16 :: proc(store: ^SceInt16, value: SceInt16, new_value: SceInt16) -> SceInt16 ---
    sceKernelAtomicCompareAndSet32 :: proc(store: ^SceInt32, value: SceInt32, new_value: SceInt32) -> SceInt32 ---
    sceKernelAtomicCompareAndSet64 :: proc(store: ^SceInt64, value: SceInt64, new_value: SceInt64) -> SceInt64 ---

    sceKernelAtomicAddAndGet8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicAddAndGet16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicAddAndGet32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicAddAndGet64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicAddUnless8 :: proc(store: ^SceInt8, value: SceInt8, cmpv: SceInt8) -> SceBool ---
    sceKernelAtomicAddUnless16 :: proc(store: ^SceInt16, value: SceInt16, cmpv: SceInt16) -> SceBool ---
    sceKernelAtomicAddUnless32 :: proc(store: ^SceInt32, value: SceInt32, cmpv: SceInt32) -> SceBool ---
    sceKernelAtomicAddUnless64 :: proc(store: ^SceInt64, value: SceInt64, cmpv: SceInt64) -> SceBool ---

    sceKernelAtomicSubAndGet8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicSubAndGet16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicSubAndGet32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicSubAndGet64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicAndAndGet8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicAndAndGet16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicAndAndGet32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicAndAndGet64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicOrAndGet8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicOrAndGet16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicOrAndGet32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicOrAndGet64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicXorAndGet8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicXorAndGet16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicXorAndGet32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicXorAndGet64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicClearAndGet8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicClearAndGet16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicClearAndGet32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicClearAndGet64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicGetAndSet8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicGetAndSet16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicGetAndSet32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicGetAndSet64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicGetAndAdd8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicGetAndAdd16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicGetAndAdd32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicGetAndAdd64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicGetAndSub8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicGetAndSub16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicGetAndSub32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicGetAndSub64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicGetAndAnd8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicGetAndAnd16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicGetAndAnd32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicGetAndAnd64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicGetAndOr8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicGetAndOr16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicGetAndOr32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicGetAndOr64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicGetAndXor8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicGetAndXor16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicGetAndXor32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicGetAndXor64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicGetAndClear8 :: proc(store: ^SceInt8, value: SceInt8) -> SceInt8 ---
    sceKernelAtomicGetAndClear16 :: proc(store: ^SceInt16, value: SceInt16) -> SceInt16 ---
    sceKernelAtomicGetAndClear32 :: proc(store: ^SceInt32, value: SceInt32) -> SceInt32 ---
    sceKernelAtomicGetAndClear64 :: proc(store: ^SceInt64, value: SceInt64) -> SceInt64 ---

    sceKernelAtomicClearMask8 :: proc(store: ^SceInt8, value: SceInt8) ---
    sceKernelAtomicClearMask16 :: proc(store: ^SceInt16, value: SceInt16) ---
    sceKernelAtomicClearMask32 :: proc(store: ^SceInt32, value: SceInt32) ---
    sceKernelAtomicClearMask64 :: proc(store: ^SceInt64, value: SceInt64) ---

    sceKernelAtomicDecIfPositive8 :: proc(store: ^SceInt8) -> SceInt8 ---
    sceKernelAtomicDecIfPositive16 :: proc(store: ^SceInt16) -> SceInt16 ---
    sceKernelAtomicDecIfPositive32 :: proc(store: ^SceInt32) -> SceInt32 ---
    sceKernelAtomicDecIfPositive64 :: proc(store: ^SceInt64) -> SceInt64 ---

    sceKernelLoadModule :: proc(path: cstring, flags: c.int, option: ^SceKernelLMOption) -> SceUID ---
    sceKernelUnloadModule :: proc(modid: SceUID, flags: c.int, option: ^SceKernelULMOption) -> c.int ---

    sceKernelStartModule :: proc(modid: SceUID, args: SceSize, argp: rawptr, flags: c.int, option: rawptr, status: ^c.int) -> c.int ---
    sceKernelStopModule :: proc(modid: SceUID, args: SceSize, argp: rawptr, flags: c.int, option: rawptr, status: ^c.int) -> c.int ---

    sceKernelLoadStartModule :: proc(path: cstring, args: SceSize, argp: rawptr, flags: c.int, option: ^SceKernelLMOption, status: ^c.int) -> SceUID ---
    sceKernelStopUnloadModule :: proc(modid: SceUID, args: SceSize, argp: rawptr, flags: c.int, option: ^SceKernelULMOption, status: ^c.int) -> c.int ---

    /**
    * Exit current Process with specified return code
    *
    * @param[in] res - Exit code to return
    *
    * @return 0 on success, < 0 on error.
    */
    sceKernelExitProcess :: proc(res: c.int) -> c.int ---

    /**
    * Get the process time of the current process.
    *
    * @param[out] type - Pointer to a ::SceKernelSysClock structure which will receive the process time.
    *
    * @return 0 on success, < 0 on error.
    */
    sceKernelGetProcessTime :: proc(pSysClock: ^SceKernelSysClock) -> c.int ---

    /**
    * Get the lower 32 bits part of process time of the current process.
    *
    * @return process time of the current process
    */
    sceKernelGetProcessTimeLow :: proc() -> SceUInt32 ---

    /**
    * Get the process time of the current process.
    *
    * @return process time of the current process
    */
    sceKernelGetProcessTimeWide :: proc() -> SceUInt64 ---

    sceKernelGetOpenPsId :: proc(id: ^SceKernelOpenPsId) -> c.int ---
}

foreign processmgr {
    /**
    * Cancel specified idle timers to prevent entering in power save processing.
    *
    * @param[in] type - One of ::SceKernelPowerTickType
    *
    * @return 0
    */
    sceKernelPowerTick :: proc(type: SceKernelPowerTickType) -> c.int ---

    /**
    * Locks certain timers from triggering.
    *
    * @param[in] type - One of ::SceKernelPowerTickType
    *
    * @return 0
    */
    sceKernelPowerLock :: proc(type: SceKernelPowerTickType) -> c.int ---

    /**
    * Unlocks certain timers.
    *
    * @param[in] type - One of ::SceKernelPowerTickType
    *
    * @return 0
    */
    sceKernelPowerUnlock :: proc(type: SceKernelPowerTickType) -> c.int ---

    sceKernelGetCurrentProcess :: proc() -> SceUID ---
    sceKernelGetRemoteProcessTime :: proc(processId: SceUID, pClock: ^SceKernelSysClock) -> SceInt32 ---

    sceKernelGetStderr :: proc() -> SceUID ---
    sceKernelGetStdin :: proc() -> SceUID ---
    sceKernelGetStdout :: proc() -> SceUID ---

    sceKernelGetProcessParam :: proc() -> rawptr ---

    sceKernelLibcClock :: proc() -> SceKernelClock ---
    sceKernelLibcTime :: proc(tloc: ^SceKernelTime) -> SceKernelTime ---

    sceKernelLibcGettimeofday :: proc(tv: ^SceKernelTimeval, tz: ^SceKernelTimezone) -> c.int ---
}

foreign modulemgr {
    sceKernelGetModuleInfo :: proc(uid: SceUID, info: ^SceKernelModuleInfo) -> c.int ---
    sceKernelGetModuleList :: proc(type: SceUInt8, uids: [^]SceUID, num: ^SceSize) -> c.int ---

    /**
    * Gets system firmware information.
    *
    * @param[out] version - System sw version.
    *
    * @note - If you spoofed the firmware version it will return the spoofed firmware.
    */
    sceKernelGetSystemSwVersion :: proc(version: ^SceKernelSystemSwVersion) -> c.int ---

    _sceKernelLoadModule :: proc(module_filename: cstring, flags: SceUInt32, option: ^SceKernelLoadModuleOption) -> SceUID ---
    _sceKernelLoadStartModule :: proc(module_filename: cstring, args: SceSize, argp: rawptr, flags: SceUInt32) -> SceUID ---
    _sceKernelUnloadModule :: proc(uid: SceUID, flags: SceUInt32, option: ^SceKernelUnloadModuleOption) -> c.int ---
    _sceKernelStopModule :: proc(uid: SceUID, args: SceSize, argp: rawptr, flags: SceUInt32) -> c.int ---
    _sceKernelStopUnloadModule :: proc(uid: SceUID, args: SceSize, argp: rawptr, flags: SceUInt32) -> c.int ---

    _sceKernelOpenModule :: proc(module_filename: cstring, args: SceSize, argp: rawptr, flags: SceUInt32) -> SceUID ---
    _sceKernelCloseModule :: proc(modid: SceUID, args: SceSize, argp: rawptr, flags: SceUInt32) -> SceUID ---

    sceKernelGetLibraryInfoByNID :: proc(modid: SceUID, libnid: SceNID, info: ^SceKernelLibraryInfo) -> c.int ---

    sceKernelIsCalledFromSysModule :: proc(lr: rawptr) -> c.int ---
    sceKernelGetModuleIdByAddr :: proc(addr: rawptr) -> SceUID ---
    sceKernelGetAllowedSdkVersionOnSystem :: proc() -> SceUInt32 ---
}

foreign sysmem {
    sceKernelGetCpuId :: proc() -> c.int ---

    /**
    * Allocates a new memory block
    *
    * @param[in] name - Name for the memory block
    * @param[in] type - Type of the memory to allocate. Use `SCE_KERNEL_MEMBLOCK_TYPE_USER_*`.
    * @param[in] size - Size of the memory to allocate
    * @param[in] opt  - Memory block options?
    *
    * @return SceUID of the memory block on success, < 0 on error.
    */
    sceKernelAllocMemBlock :: proc(name: cstring, type: SceKernelMemBlockType, size: SceSize, opt: ^SceKernelAllocMemBlockOpt) -> SceUID ---

    /**
    * Frees new memory block
    *
    * @param[in] uid - SceUID of the memory block to free
    *
    * @return 0 on success, < 0 on error.
    */
    sceKernelFreeMemBlock :: proc(uid: SceUID) -> c.int ---

    /**
    * Gets the base address of a memory block
    *
    * @param[in]  uid  - SceUID of the memory block to free
    * @param[out] base - Base address of the memory block identified by SceUID
    *
    * @return 0 on success, < 0 on error.
    */
    sceKernelGetMemBlockBase :: proc(uid: SceUID, base: ^rawptr) -> c.int ---

    sceKernelFindMemBlockByAddr :: proc(addr: rawptr, size: SceSize) -> SceUID ---

    sceKernelGetMemBlockInfoByAddr :: proc(base: rawptr, info: ^SceKernelMemBlockInfo) -> c.int ---
    sceKernelGetMemBlockInfoByRange :: proc(base: rawptr, size: SceSize, info: ^SceKernelMemBlockInfo) -> c.int ---

    sceKernelAllocMemBlockForVM :: proc(name: cstring, size: SceSize) -> SceUID ---
    sceKernelSyncVMDomain :: proc(uid: SceUID, data: rawptr, size: SceSize) -> c.int ---
    sceKernelOpenVMDomain :: proc() -> c.int ---
    sceKernelCloseVMDomain :: proc() -> c.int ---

    sceKernelOpenMemBlock :: proc(name: cstring, flags: c.int) -> c.int ---
    sceKernelCloseMemBlock :: proc(uid: SceUID) -> c.int ---

    /**
    * Get the model number of the device
    *
    * @return A value from SCE_KERNEL_MODEL
    */
    sceKernelGetModelForCDialog :: proc() -> c.int ---

    /**
    * Get the model number of the device
    *
    * @return A value from SCE_KERNEL_MODEL
    */
    sceKernelGetModel :: proc() -> c.int ---

    /**
    * Get free memory size in bytes
    *
    * @param[out] info - Returned free memory size for different kind of memory block types
    * @return 0 on success, < 0 on error.
    */
    sceKernelGetFreeMemorySize :: proc(info: ^SceKernelFreeMemorySizeInfo) -> c.int ---

    sceKernelIsPSVitaTV :: proc() -> c.int ---
}

foreign threadmgr {
    /**
    * Create callback
    *
    * @par Example:
    * @code
    * int cbid
    * cbid = sceKernelCreateCallback("Exit Callback", 0, exit_cb, NULL)
    * @endcode
    *
    * @param name      - A textual name for the callback
    * @param attr      - ?
    * @param func      - A pointer to a function that will be called as the callback
    * @param userData  - User defined data to be passed to the callback.
    *
    * @return >= 0 A callback id which can be used in subsequent functions, < 0 an error.
    */
    sceKernelCreateCallback :: proc(name: cstring, attr: c.uint, func: SceKernelCallbackFunction, userData: rawptr) -> c.int ---

    /**
    * Delete a callback
    *
    * @param cb - The UID of the specified callback
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelDeleteCallback :: proc(cb: SceUID) -> c.int ---

    /**
    * Notify a callback
    *
    * @param cb - The UID of the specified callback
    * @param arg2 - Passed as arg2 into the callback function
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelNotifyCallback :: proc(cb: SceUID, arg2: c.int) -> c.int ---

    /**
    * Cancel a callback ?
    *
    * @param cb - The UID of the specified callback
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelCancelCallback :: proc(cb: SceUID) -> c.int ---

    /**
    * Get the callback count
    *
    * @param cb - The UID of the specified callback
    *
    * @return The callback count, < 0 on error
    */
    sceKernelGetCallbackCount :: proc(cb: SceUID) -> c.int ---

    /**
    * Check callback ?
    *
    * @return Something or another
    */
    sceKernelCheckCallback :: proc() -> c.int ---

    /**
    * Destroy a condition variable
    *
    * @param condition variableid - The condition variable id returned from ::sceKernelCreateCond
    * @return Returns the value 0 if it's successful, otherwise -1
    */
    sceKernelDeleteCond :: proc(condId: SceUID) -> c.int ---

    /**
    * Open a condition variable
    *
    * @param name - The name of the condition variable to open
    * @return Returns the value 0 if it's successful, otherwise -1
    */
    sceKernelOpenCond :: proc(name: cstring) -> c.int ---

    /**
    * Close a condition variable
    *
    * @param condition variableid - The condition variable id returned from ::sceKernelCreateCond
    * @return Returns the value 0 if it's successful, otherwise -1
    */
    sceKernelCloseCond :: proc(condId: SceUID) -> c.int ---

    /**
    * Signals a condition variable
    *
    * @param condId - The condition variable id returned from ::sceKernelCreateCond
    * @return < 0 On error.
    */
    sceKernelSignalCond :: proc(condId: SceUID) -> c.int ---

    /**
    * Signals a condition variable to all threads waiting for it
    *
    * @param condId - The condition variable id returned from ::sceKernelCreateCond
    * @return < 0 On error.
    */
    sceKernelSignalCondAll :: proc(condId: SceUID) -> c.int ---

    /**
    * Signals a condition variable to a specific thread waiting for it
    *
    * @param condId - The condition variable id returned from ::sceKernelCreateCond
    * @param threadId - The thread id returned from ::sceKernelCreateThread
    * @return < 0 On error.
    */
    sceKernelSignalCondTo :: proc(condId: SceUID, threadId: SceUID) -> c.int ---

    /**
    * Set an event flag bit pattern.
    *
    * @param evid - The event id returned by ::sceKernelCreateEventFlag.
    * @param bits - The bit pattern to set.
    *
    * @return < 0 On error
    */
    sceKernelSetEventFlag :: proc(evid: SceUID, bits: c.uint) -> c.int ---

    /**
    * Clear a event flag bit pattern
    *
    * @param evid - The event id returned by ::sceKernelCreateEventFlag
    * @param bits - The bits to clean
    *
    * @return < 0 on Error
    */
    sceKernelClearEventFlag :: proc(evid: SceUID, bits: c.uint) -> c.int ---

    /**
    * Delete an event flag
    *
    * @param evid - The event id returned by ::sceKernelCreateEventFlag.
    *
    * @return < 0 On error
    */
    sceKernelDeleteEventFlag :: proc(evid: c.int) -> c.int ---

    /**
    * Delete a message pipe
    *
    * @param uid - The UID of the pipe
    *
    * @return 0 on success, < 0 on error
    */
    sceKernelDeleteMsgPipe :: proc(uid: SceUID) -> c.int ---

    /**
    * Destroy a mutex
    *
    * @param mutexid - The mutex id returned from ::sceKernelCreateMutex
    * @return Returns the value 0 if it's successful, otherwise -1
    */
    sceKernelDeleteMutex :: proc(mutexid: SceUID) -> c.int ---


    /**
    * Open a mutex
    *
    * @param name - The name of the mutex to open
    * @return Returns the value 0 if it's successful, otherwise -1
    */
    sceKernelOpenMutex :: proc(name: cstring) -> c.int ---

    /**
    * Close a mutex
    *
    * @param mutexid - The mutex id returned from ::sceKernelCreateMutex
    * @return Returns the value 0 if it's successful, otherwise -1
    */
    sceKernelCloseMutex :: proc(mutexid: SceUID) -> c.int ---


    /**
    * Try to lock a mutex (non-blocking)
    *
    * @param mutexid - The mutex id returned from ::sceKernelCreateMutex
    * @param lockCount - The value to increment to the lock count of the mutex
    * @return < 0 On error.
    */
    sceKernelTryLockMutex :: proc(mutexid: SceUID, lockCount: c.int) -> c.int ---

    /**
    * Try to unlock a mutex (non-blocking)
    *
    * @param mutexid - The mutex id returned from ::sceKernelCreateMutex
    * @param unlockCount - The value to decrement to the lock count of the mutex
    * @return < 0 On error.
    */
    sceKernelUnlockMutex :: proc(mutexid: SceUID, unlockCount: c.int) -> c.int ---

    /**
    * Destroy a rwlock
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @return 0 on success, < 0 on error
    */
    sceKernelDeleteRWLock :: proc(rwlock_id: SceUID) -> c.int ---

    /**
    * Open a rwlock
    *
    * @param name - The name of the rwlock to open
    * @return RWLock id on success, < 0 on error
    */
    sceKernelOpenRWLock :: proc(name: cstring) -> SceUID ---

    /**
    * Close a rwlock
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @return 0 on success, < 0 on error
    */
    sceKernelCloseRWLock :: proc(rwlock_id: SceUID) -> c.int ---
    /**
    * Try to lock a rwlock with read access (non-blocking)
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @return 0 on success, < 0 on error
    */
    sceKernelTryLockReadRWLock :: proc(rwlock_id: SceUID) -> c.int ---

    /**
    * Try to lock a rwlock with write access (non-blocking)
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @return 0 on success, < 0 on error
    */
    sceKernelTryLockWriteRWLock :: proc(rwlock_id: SceUID) -> c.int ---

    /**
    * Try to unlock a rwlock with read access (non-blocking)
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @return 0 on success, < 0 on error
    */
    sceKernelUnlockReadRWLock :: proc(rwlock_id: SceUID) -> c.int ---

    /**
    * Try to unlock a rwlock with write access (non-blocking)
    *
    * @param rwlock_id - The rwlock id returned from ::sceKernelCreateRWLock
    * @return 0 on success, < 0 on error
    */
    sceKernelUnlockWriteRWLock :: proc(rwlock_id: SceUID) -> c.int ---

    /**
    * Destroy a semaphore
    *
    * @param semaid - The semaid returned from a previous create call.
    * @return Returns the value 0 if it's successful, otherwise -1
    */
    sceKernelDeleteSema :: proc(semaid: SceUID) -> c.int ---

    /**
    * Send a signal to a semaphore
    *
    * @par Example:
    * @code
    * // Signal the sema
    * sceKernelSignalSema(semaid, 1)
    * @endcode
    *
    * @param semaid - The sema id returned from ::sceKernelCreateSema
    * @param signal - The amount to signal the sema (i.e. if 2 then increment the sema by 2)
    *
    * @return < 0 On error.
    */
    sceKernelSignalSema :: proc(semaid: SceUID, signal: c.int) -> c.int ---

    /**
    * Poll a semaphore.
    *
    * @param semaid - UID of the semaphore to poll.
    * @param signal - The value to test for.
    *
    * @return < 0 on error.
    */
    sceKernelPollSema :: proc(semaid: SceUID, signal: c.int) -> c.int ---

    sceKernelOpenSema :: proc(name: cstring) -> SceUID ---

    sceKernelCloseSema :: proc(semaid: SceUID) -> c.int ---

    /**
    * @brief Send a signal to the thread specified by thid. Note that it can send a signal to the current thread as well.
    *
    * @param thid - the id of the thread to send a signal to
    * @return 0 on success
    * @return SCE_KERNEL_ERROR_ALREADY_SENT if the last signal was not consumed by sceKernelWaitSignal
    */
    sceKernelSendSignal :: proc(thid: SceUID) -> c.int ---

    /**
    * Delate a thread
    *
    * @param thid - UID of the thread to be deleted.
    *
    * @return < 0 on error.
    */
    sceKernelDeleteThread :: proc(thid: SceUID) -> c.int ---


    /**
    * Exit a thread
    *
    * @param status - Exit status.
    */
    sceKernelExitThread :: proc(status: c.int) -> c.int ---


    /**
    * Exit a thread and delete itself.
    *
    * @param status - Exit status
    */
    sceKernelExitDeleteThread :: proc(status: c.int) -> c.int ---

    /**
    * Delay the current thread by a specified number of microseconds
    *
    * @param delay - Delay in microseconds.
    *
    * @par Example:
    * @code
    * sceKernelDelayThread(1000000) // Delay for a second
    * @endcode
    */
    sceKernelDelayThread :: proc(delay: SceUInt) -> c.int ---

    /**
    * Delay the current thread by a specified number of microseconds and handle any callbacks.
    *
    * @param delay - Delay in microseconds.
    *
    * @par Example:
    * @code
    * sceKernelDelayThread(1000000) // Delay for a second
    * @endcode
    */
    sceKernelDelayThreadCB :: proc(delay: SceUInt) -> c.int ---

    /**
    * Change the threads current priority.
    *
    * @param thid - The ID of the thread (from ::sceKernelCreateThread or ::sceKernelGetThreadId)
    * @param priority - The new priority (the lower the number the higher the priority)
    *
    * @par Example:
    * @code
    * int thid = sceKernelGetThreadId()
    * // Change priority of current thread to 16
    * sceKernelChangeThreadPriority(thid, 16)
    * @endcode
    *
    * @return 0 if successful, otherwise the error code.
    */
    sceKernelChangeThreadPriority :: proc(thid: SceUID, priority: c.int) -> c.int ---


    /**
    * Get the free stack size for a thread.
    *
    * @param thid - The thread ID
    *
    * @return The free size.
    */
    sceKernelGetThreadStackFreeSize :: proc(thid: SceUID) -> c.int ---

    /**
    * Retrive the cpu affinity mask of a thread.
    *
    * @param thid - UID of the thread to retrieve affinity mask for.
    *
    * @return current affinity mask if >= 0, otherwise the error code.
    */
    sceKernelGetThreadCpuAffinityMask :: proc(thid: SceUID) -> c.int ---

    /**
    * Set the cpu affinity mask of a thread.
    *
    * @param thid - UID of the thread to retrieve affinity mask for.
    * @param mask - New cpu affinity mask.
    *
    * @return 0 if successful, otherwise the error code.
    */
    sceKernelChangeThreadCpuAffinityMask :: proc(thid: SceUID, mask: c.int) -> c.int ---

    /**
    * Get the process ID of in the running thread.
    *
    * @return process ID of in the running thread
    */
    sceKernelGetProcessId :: proc() -> SceUID ---

    /**
    * Get the type of a Threadmgr uid
    *
    * @param uid - The uid to get the type from
    *
    * @return The type, < 0 on error
    */
    sceKernelGetThreadmgrUIDClass :: proc(uid: SceUID) -> SceKernelIdListType ---


    /**
    * @brief sceKernelGetThreadTLSAddr gets an address to a 4 bytes area of TLS memory for the specified thread
    * @param thid - The UID of the thread to access TLS
    * @param key - the TLS keyslot index
    * @return pointer to TLS memory
    */
    sceKernelGetThreadTLSAddr :: proc(thid: SceUID, key: c.int) -> rawptr ---


    /**
    * Get the system time (wide version)
    *
    * @return The system time
    */
    sceKernelGetSystemTimeWide :: proc() -> SceInt64 ---
}

