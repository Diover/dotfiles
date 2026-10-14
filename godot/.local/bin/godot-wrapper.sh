#!/bin/sh
# Launch the Godot editor, forwarding any arguments (e.g. --path <project>).
# A shebang is required: without one execve() fails with ENOEXEC and callers
# that spawn us directly (e.g. vim.fn.jobstart) cannot fall back to /bin/sh.
exec open -a /Applications/Godot.app --args "$@"
