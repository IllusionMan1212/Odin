#+build vita
package vita

import "core:c"

foreign import registrymgr "system:SceRegistryMgr_stub"
foreign import registrymgrkern "system:SceRegMgrForDriver_stub"

foreign registrymgr {
  /**
  * Get a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrGetKeyBin :: proc(category: cstring, name: cstring, buf: rawptr, size: c.int) -> c.int ---

  /**
  * Get a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a int buffer to hold the value
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrGetKeyInt :: proc(category: cstring, name: cstring, buf: ^c.int) -> c.int ---

  /**
  * Get a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a char buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrGetKeyStr :: proc(category: cstring, name: cstring, buf: [^]c.char, size: c.int) -> c.int ---

  /**
  * Set a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrSetKeyBin :: proc(category: cstring, name: cstring, buf: rawptr, size: c.int) -> c.int ---

  /**
  * Set a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to an int buffer to hold the value
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrSetKeyInt :: proc(category: cstring, name: cstring, buf: c.int) -> c.int ---

  /**
  * Set a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a char buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrSetKeyStr :: proc(category: cstring, name: cstring, buf: [^]c.char, size: c.int) -> c.int ---

  /**
  * Get all keys' initial information by category (from os0:kd/registry.db0)
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param buf[out] - Pointer to a char buffer to hold the values
  * @param elements_number - The number of elements of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrGetInitVals :: proc(category: cstring, buf: [^]c.char, elements_number: c.int) -> c.int ---

  /**
  * Get all keys' information by category
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param buf[out] - Pointer to a char buffer to hold the values
  * @param elements_number - The number of elements of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrGetKeys :: proc(category: cstring, buf: [^]c.char, elements_number: c.int) -> c.int ---

  /**
  * Set all keys' information by category
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param buf[out] - Pointer to a char buffer that holds the values
  * @param elements_number - The number of elements of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrSetKeys :: proc(category: cstring, buf: [^]c.char, elements_number: c.int) -> c.int ---

  /**
  * Get a system param key's information by id
  *
  * @param id - The id of the key
  * @param buf[out] - Pointer to an int to hold the value
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrSystemParamGetInt :: proc(id: c.int, buf: ^c.int) -> c.int ---

  /**
  * Get a system param key's information by id
  *
  * @param id - The id of the key
  * @param buf[out] - Pointer to a char buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrSystemParamGetStr :: proc(id: c.int, buf: [^]c.char, size: c.int) -> c.int ---


  /**
  * Get the registry version
  *
  * @param id - The id of the key
  * @param buf[out] - Pointer to a char buffer to hold the value
  *
  * @return 0 on success, < 0 on error
  */
  sceRegMgrGetRegVersion :: proc(version: c.int, buf: [^]c.char) -> c.int ---
}

foreign registrymgrkern {
  /**
  * Get a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  ksceRegMgrGetKeyBin :: proc(category: cstring, name: cstring, buf: rawptr, size: SceSize) -> c.int ---

  /**
  * Get a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a int buffer to hold the value
  *
  * @return 0 on success, < 0 on error
  */
  ksceRegMgrGetKeyInt :: proc(category: cstring, name: cstring, buf: ^c.int) -> c.int ---

  /**
  * Get a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a char buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  ksceRegMgrGetKeyStr :: proc(category: cstring, name: cstring, buf: [^]c.char, size: SceSize) -> c.int ---

  /**
  * Set a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  ksceRegMgrSetKeyBin :: proc(category: cstring, name: cstring, buf: rawptr, size: SceSize) -> c.int ---

  /**
  * Set a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to an int buffer to hold the value
  *
  * @return 0 on success, < 0 on error
  */
  ksceRegMgrSetKeyInt :: proc(category: cstring, name: cstring, buf: c.int) -> c.int ---

  /**
  * Set a key's information by category and name
  *
  * @param category - The path to the directory to be opened (e.g. /CONFIG/SYSTEM)
  * @param name - Name of the key
  * @param buf - Pointer to a char buffer to hold the value
  * @param size - The size of the buffer
  *
  * @return 0 on success, < 0 on error
  */
  ksceRegMgrSetKeyStr :: proc(category: cstring, name: cstring, buf: [^]c.char, size: SceSize) -> c.int ---
}

