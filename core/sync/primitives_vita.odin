#+build vita
#+private
package sync

import "core:sys/vita"
import "core:time"

_current_thread_id :: proc "contextless" () -> int {
	return cast(int)vita.sceKernelGetThreadId()
}

//_Mutex :: vita.SceKernelMutexInfo

_Mutex :: struct {
	mutexId: vita.SceUID,
}

//_Mutex :: struct {
//	srwlock: win32.SRWLOCK,
//}

_mutex_lock :: proc "contextless" (m: ^Mutex) {
	if m.impl.mutexId == 0 {
		m.impl.mutexId = vita.sceKernelCreateMutex("mutex", 0, 0, nil)
	}
	vita.sceKernelLockMutex(m.impl.mutexId, 0, nil)
	//win32.AcquireSRWLockExclusive(&m.impl.srwlock)
}

_mutex_unlock :: proc "contextless" (m: ^Mutex) {
	vita.sceKernelUnlockMutex(m.impl.mutexId, 0)
	//win32.ReleaseSRWLockExclusive(&m.impl.srwlock)
}

_mutex_try_lock :: proc "contextless" (m: ^Mutex) -> bool {
	vita.sceClibPrintf("mutex try lock not implemented")
	return false
	//return bool(win32.TryAcquireSRWLockExclusive(&m.impl.srwlock))
}

_RW_Mutex :: struct {
	mutexId: vita.SceUID,
}

//_RW_Mutex :: struct {
//	srwlock: win32.SRWLOCK,
//}

_rw_mutex_lock :: proc "contextless" (rw: ^RW_Mutex) {
	vita.sceClibPrintf("rw mutex lock not implemented")
	//win32.AcquireSRWLockExclusive(&rw.impl.srwlock)
}

_rw_mutex_unlock :: proc "contextless" (rw: ^RW_Mutex) {
	vita.sceClibPrintf("rw mutex unlock not implemented")
	//win32.ReleaseSRWLockExclusive(&rw.impl.srwlock)
}

_rw_mutex_try_lock :: proc "contextless" (rw: ^RW_Mutex) -> bool {
	vita.sceClibPrintf("rw mutex try lock not implemented")
	return false
	//return bool(win32.TryAcquireSRWLockExclusive(&rw.impl.srwlock))
}

_rw_mutex_shared_lock :: proc "contextless" (rw: ^RW_Mutex) {
	vita.sceClibPrintf("rw mutex shared lock not implemented")
	//win32.AcquireSRWLockShared(&rw.impl.srwlock)
}

_rw_mutex_shared_unlock :: proc "contextless" (rw: ^RW_Mutex) {
	vita.sceClibPrintf("rw mutex shared unlock not implemented")
	//win32.ReleaseSRWLockShared(&rw.impl.srwlock)
}

_rw_mutex_try_shared_lock :: proc "contextless" (rw: ^RW_Mutex) -> bool {
	vita.sceClibPrintf("rw mutex try shared lock not implemented")
	return false
	//return bool(win32.TryAcquireSRWLockShared(&rw.impl.srwlock))
}

_Cond :: struct {
	condId: vita.SceUID,
}

//_Cond :: struct {
//	cond: win32.CONDITION_VARIABLE,
//}

_cond_wait :: proc "contextless" (c: ^Cond, m: ^Mutex) {
	vita.sceClibPrintf("cond wait not implemented")
	//_ = win32.SleepConditionVariableSRW(&c.impl.cond, &m.impl.srwlock, win32.INFINITE, 0)
}

_cond_wait_with_timeout :: proc "contextless" (c: ^Cond, m: ^Mutex, duration: time.Duration) -> bool {
	vita.sceClibPrintf("cond wait with timeout not implemented")
	return false
	//duration := u32(duration / time.Millisecond)
	//ok := win32.SleepConditionVariableSRW(&c.impl.cond, &m.impl.srwlock, duration, 0)
	//return bool(ok)
}


_cond_signal :: proc "contextless" (c: ^Cond) {
	vita.sceClibPrintf("cond signal not implemented")
	//win32.WakeConditionVariable(&c.impl.cond)
}

_cond_broadcast :: proc "contextless" (c: ^Cond) {
	vita.sceClibPrintf("cond broadcast not implemented")
	//win32.WakeAllConditionVariable(&c.impl.cond)
}


