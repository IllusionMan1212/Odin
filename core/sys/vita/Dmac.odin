#+build vita
package vita

import "base:intrinsics"
import "core:c"

foreign import dmac "system:SceKernelDmacMgr_stub"
foreign import dmac5 "system:SceSblSsMgr_stub"

SceSblDmac5EncDecParam :: struct { // size is 0x18-bytes
  src: rawptr, //<! The operation input buffer
	dst: rawptr,       //<! The operation output buffer
	length: SceSize,  //<! The src data length
	key: rawptr, //<! The key data
	keysize: SceSize, //<! The key size in bits
	iv: rawptr,        //<! The initialization vector
}

SceSblDmac5HashTransformContext :: struct { // size is 0x28-bytes
  state: [8]SceUInt32,
	length: SceUInt64,
}
#assert(size_of(SceSblDmac5HashTransformContext) == 0x28)

SceSblDmac5HashTransformParam :: struct { // size is 0x18-bytes
  src: rawptr, //<! The operation input buffer
	dst: rawptr,       //<! The operation output buffer
	length: SceSize,  //<! The src data length
	key: rawptr, //<! The key data
	keysize: SceSize, //<! The key size in bits
	ctx: rawptr,       //<! SceSblDmac5HashTransformContext Or another context of size 0x10-bytes
}

foreign dmac {
  /**
  * DMA memcpy
  *
  * @param[in] dst - Destination
  * @param[in] src - Source
  * @param[in] size - Size
  *
  * @return < 0 on error.
  */
  sceDmacMemcpy :: proc(dst: rawptr, src: rawptr, size: SceSize) -> c.int ---

  /**
  * DMA memset
  *
  * @param[in] dst  - Destination
  * @param[in] ch   - The character
  * @param[in] size - Size
  *
  * @return < 0 on error.
  */
  sceDmacMemset :: proc(dst: rawptr, ch: c.int, size: SceSize) -> c.int ---
}

AesCbcEnc :: #force_inline proc(src: rawptr, dst: rawptr, length: SceSize, key: rawptr, keysize: SceSize, iv: rawptr) -> c.int {
	param := SceSblDmac5EncDecParam{src = src, dst = dst, length = length, key = key, keysize = keysize, iv = iv}

	return sceSblDmac5EncDec(
		&param,
		1 | 8 | (((auto_cast keysize << 2) - 0x100) & 0x300)
	)
}

AesCbcDec :: #force_inline proc(src: rawptr, dst: rawptr, length: SceSize, key: rawptr, keysize: SceSize, iv: rawptr) -> c.int {
	param := SceSblDmac5EncDecParam{src = src, dst = dst, length = length, key = key, keysize = keysize, iv = iv}

	return sceSblDmac5EncDec(
		&param,
		2 | 8 | (((auto_cast keysize << 2) - 0x100) & 0x300)
	)
}

AesCtrEnc :: #force_inline proc(src: rawptr, dst: rawptr, length: SceSize, key: rawptr, keysize: SceSize, iv: rawptr) -> c.int {
	param := SceSblDmac5EncDecParam{src = src, dst = dst, length = length, key = key, keysize = keysize, iv = iv}

	return sceSblDmac5EncDec(
		&param,
		1 | 0x20 | (((auto_cast keysize << 2) - 0x100) & 0x300)
	)
}

AesCtrDec :: #force_inline proc(src: rawptr, dst: rawptr, length: SceSize, key: rawptr, keysize: SceSize, iv: rawptr) -> c.int {
	param := SceSblDmac5EncDecParam{src = src, dst = dst, length = length, key = key, keysize = keysize, iv = iv}

	return sceSblDmac5EncDec(
		&param,
		2 | 0x20 | (((auto_cast keysize << 2) - 0x100) & 0x300)
	)
}

Sha256Digest :: #force_inline proc(src: rawptr, dst: rawptr, length: SceSize) -> c.int {
	ctx: SceSblDmac5HashTransformContext
	param := SceSblDmac5HashTransformParam{src = src, dst = dst, length = length, key = c.NULL, keysize = 0, ctx = &ctx}

	ctx.state[0] = auto_cast intrinsics.byte_swap(u32(0x6a09e667))
	ctx.state[1] = auto_cast intrinsics.byte_swap(u32(0xbb67ae85))
	ctx.state[2] = auto_cast intrinsics.byte_swap(u32(0x3c6ef372))
	ctx.state[3] = auto_cast intrinsics.byte_swap(u32(0xa54ff53a))
	ctx.state[4] = auto_cast intrinsics.byte_swap(u32(0x510e527f))
	ctx.state[5] = auto_cast intrinsics.byte_swap(u32(0x9b05688c))
	ctx.state[6] = auto_cast intrinsics.byte_swap(u32(0x1f83d9ab))
	ctx.state[7] = auto_cast intrinsics.byte_swap(u32(0x5be0cd19))
	ctx.length = 0

	return sceSblDmac5HashTransform(
		&param,
		3 | 0x10, 0x800
	)
}

foreign dmac5 {
  /**
  * @brief Execute DMAC5 encdec command
  *
  * @param[inout] param   - The encdec param.
  * @param[in]    command - The DMAC5 encdec command.
  *
  * @return 0 on success, else < 0.
  */
  sceSblDmac5EncDec :: proc(param: ^SceSblDmac5EncDecParam, command: SceUInt32) -> c.int ---


  /**
  * @brief Execute DMAC5 hash transform command
  *
  * @param[inout] param   - The encdec param.
  * @param[in]    command - The DMAC5 hash base command.
  * @param[in]    extra   - The DMAC5 extra command.
  *
  * @return 0 on success, else < 0.
  */
  sceSblDmac5HashTransform :: proc(param: ^SceSblDmac5HashTransformParam, command: SceUInt32, extra: SceUInt32) -> c.int ---
}

