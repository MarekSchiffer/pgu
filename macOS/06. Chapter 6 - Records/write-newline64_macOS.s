# Changes linux64.s => macOS64.s
# .section .text => .text
#.type write_record, @function  removed
# movq $newline, %rsi => leaq newline(%rip), %rsi

# Changes 64-bit version:
# linux32.s -> linux64.s
# int $LINUX_SYSCALL => syscall
# eXX => rXX
# Stack number *2
# addl, popl, pushl, movl => addq, popq, pushq, movq
#
# For syscalls: rbx => rdi & rcx => rsi
# 

.include "macOS64.s"
.global write_newline
#.type write_newline, @function
.data

newline:
 .ascii "\n"
 .text
 .equ ST_FILEDES, 16

write_newline:
 pushq %rbp
 movq %rsp, %rbp

 movq $SYS_WRITE, %rax
 movq ST_FILEDES(%rbp), %rdi           # I assume the function write_newline will
 leaq newline(%rip), %rsi	       # be called with an argument and the pointer
 movq $1, %rdx                         # will be on the stack. Why 8 not 4? 
				       # functionname?
syscall

 movq %rbp, %rsp
 popq %rbp
 ret
