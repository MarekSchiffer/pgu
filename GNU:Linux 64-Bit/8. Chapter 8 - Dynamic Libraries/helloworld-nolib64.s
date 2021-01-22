# PURPOSE: This program writes the message "Hello World!" and
#          exits
#	


# Changes for 64-Bit:
# linux32.s => linux64.s
# eXX => rXX
# int $SYS_LINUX => syscall
# movl => movq

.include "../6.\ Chapter\ 6\ -\ Records/linux64.s"

.section .data
helloworld:
 .ascii "Hello World!\n"
helloworld_end:

.equ helloworld_len, helloworld_end - helloworld

.section .text

.global _start
_start:
 movq $STDOUT, %rdi
 movq $helloworld, %rsi
 movq $helloworld_len, %rdx
 movq $SYS_WRITE, %rax
 syscall

 movq $0, %rdi
 movq $SYS_EXIT, %rax
 syscall

