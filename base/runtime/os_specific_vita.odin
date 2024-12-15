#+build vita
#+private
package runtime

// TODO(illusion): implement `os.write`
_stderr_write :: proc "contextless" (data: []byte) -> (int, _OS_Errno) {
	return 0, -1
}
