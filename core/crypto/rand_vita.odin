package crypto

HAS_RAND_BYTES :: true

import "core:fmt"
import "core:sys/vita"

@(private)
_rand_bytes :: proc (dst: []byte) {
	fmt.println(len(dst))
	assert(len(dst) <= 64) // sceKernelGetRandomNumber has a limit of 64 bytes
	err := vita.sceKernelGetRandomNumber(raw_data(dst), vita.SceSize(len(dst)))

	if err < 0 {
		panic(fmt.tprintf("crypto/rand_bytes: sceKernelGetRandomNumber returned non-zero result: %v", err))
	}
}
