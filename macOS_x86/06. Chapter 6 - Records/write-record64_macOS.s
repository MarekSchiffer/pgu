# Changes linux64.s => macOS64.s
# .section .text => .text
#.type write_record, @function  removed

# Changes 64-bit version:
# linux32.s -> linux64.s
# int $LINUX_SYSCALL => syscall
# eXX => rXX
# Stack number *2
# addl, popl, pushl, movl => addq, popq, pushq, movq
#
# For syscalls: rbx => rdi & rcx => rsi
# 

.include "record-def.s"
.include "macOS64.s"

# PURPOSE: This function writes a record to the give file descriptor
#
# INPUT:   The file descriptor and a buffer
#
# OUTPUT:  This function produces a status code
#

# STACK LOCAL VARIABLES

.equ ST_WRITE_BUFFER, 16 
.equ ST_FILEDES, 24 

.text
.global write_record
#.type write_record, @function

write_record:
pushq %rbp
movq %rsp, %rbp

pushq %rdi
movq ST_FILEDES(%rbp), %rdi
movq ST_WRITE_BUFFER(%rbp), %rsi
movq $RECORD_SIZE, %rdx
movq $SYS_WRITE, %rax
syscall

# NOTE - %rax has the return value, which we will give back to our
#        calling program

popq %rdi

movq %rbp, %rsp
popq %rbp
ret
