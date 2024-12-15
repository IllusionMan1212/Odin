#+build vita
package vita

import "core:c"

foreign import postssmgr "system:SceSblSsMgrForDriver_stub"

SceSblRsaDataParam :: struct {
  data: rawptr,
	size: c.uint,
}

SceSblRsaPublicKeyParam :: struct {
	n: rawptr,
	k: rawptr, // e/d
}

SceSblRsaPrivateKeyParam :: struct {
	unk_0x00: c.int,
	unk_0x04: c.int,
	unk_0x08: c.int,
	unk_0x0C: c.int,
	p: rawptr,
	q: rawptr,
	dp: rawptr, // d % (p - 1)
	dq: rawptr, // d % (q - 1)
	qp: rawptr, // q^-1 % p
}

foreign postssmgr {
	/**
	* Create the new RSA signature
	*
	* @param[inout] rsa_signature - The RSA signature result
	* @param[in]             hash - The RSA signature hash
	* @param[in]      private_key - The RSA private key
	* @param[in]             type - The RSA signature type. [2, 4, 5, 0xB, 0xC, 0xD, 0xE]
	*
	* @return SCE_OK on success, < 0 on error
	*/
	ksceSblRSA2048CreateSignature :: proc(rsa_signature: ^SceSblRsaDataParam, hash: ^SceSblRsaDataParam, private_key: SceSblRsaPrivateKeyParam, type: c.int) -> c.int ---

	/**
	* Verufy the new RSA signature
	*
	* @param[in] rsa_signature - The RSA signature input
	* @param[in]          hash - The RSA signature hash
	* @param[in]    public_key - The RSA public key
	* @param[in]          type - The RSA signature type. [2, 4, 5, 0xB, 0xC, 0xD, 0xE]
	*
	* @return SCE_OK on success, < 0 on error
	*/
	ksceSblRSA2048VerifySignature :: proc(rsa_signature: ^SceSblRsaDataParam, hash: ^SceSblRsaDataParam, public_key: ^SceSblRsaPublicKeyParam, type: c.int) -> c.int ---
}

