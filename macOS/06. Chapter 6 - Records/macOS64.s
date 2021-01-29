# MacOS system calls, as in toUpper, BRK still to do.

# System Call Numbers:
.equ SYS_OPEN, 0x2000005
.equ SYS_READ, 0x2000003
.equ SYS_WRITE, 0x2000004
.equ SYS_CLOSE, 0x2000006
.equ SYS_EXIT, 0x2000001
#.equ SYS_BRK, 12 

# Standard File Descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# Common Status Codes
.equ ENF_OF_FILE, 0
