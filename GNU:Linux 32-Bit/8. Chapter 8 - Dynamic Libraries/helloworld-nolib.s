# PURPOSE: This program writes the message "Hello World!" and
#          exits
#	

.include "../6.\ Chapter\ 6\ -\ Records/linux32.s"

.section .data
helloworld:
 .ascii "Hello World!\n"
helloworld_end:

.equ helloworld_len, helloworld_end - helloworld

.section .text

.global _start
_start:
 movl $STDOUT, %ebx
 movl $helloworld, $ecx
 movl $helloworld_len, %edx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL

 movl $0, %ebx
 movl $SYS_EXIT, %eax
 int $LINUX_SYSCALL

