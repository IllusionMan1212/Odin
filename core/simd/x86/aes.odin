#+build i386, amd64
package simd_x86

@(require_results, enable_target_feature = "aes")
_mm_aesdec_si128 :: #force_inline proc "c" (a, b: __m128i) -> __m128i {
	return aesdec(a, b)
}

@(require_results, enable_target_feature = "aes")
_mm_aesdeclast_si128 :: #force_inline proc "c" (a, b: __m128i) -> __m128i {
	return aesdeclast(a, b)
}

@(require_results, enable_target_feature = "aes")
_mm_aesenc_si128 :: #force_inline proc "c" (a, b: __m128i) -> __m128i {
	return aesenc(a, b)
}

@(require_results, enable_target_feature = "aes")
_mm_aesenclast_si128 :: #force_inline proc "c" (a, b: __m128i) -> __m128i {
	return aesenclast(a, b)
}

@(require_results, enable_target_feature = "aes")
_mm_aesimc_si128 :: #force_inline proc "c" (a: __m128i) -> __m128i {
	return aesimc(a)
}

@(require_results, enable_target_feature = "aes")
_mm_aeskeygenassist_si128 :: #force_inline proc "c" (a: __m128i, $IMM8: u8) -> __m128i {
	return aeskeygenassist(a, IMM8)
}


@(private, default_calling_convention = "none")
foreign _ {
	@(link_name = "llvm.x86.aesni.aesdec")
	aesdec :: proc(a, b: __m128i) -> __m128i ---
	@(link_name = "llvm.x86.aesni.aesdeclast")
	aesdeclast :: proc(a, b: __m128i) -> __m128i ---
	@(link_name = "llvm.x86.aesni.aesenc")
	aesenc :: proc(a, b: __m128i) -> __m128i ---
	@(link_name = "llvm.x86.aesni.aesenclast")
	aesenclast :: proc(a, b: __m128i) -> __m128i ---
	@(link_name = "llvm.x86.aesni.aesimc")
	aesimc :: proc(a: __m128i) -> __m128i ---
	@(link_name = "llvm.x86.aesni.aeskeygenassist")
	aeskeygenassist :: proc(a: __m128i, #const imm8: u8) -> __m128i ---
}
