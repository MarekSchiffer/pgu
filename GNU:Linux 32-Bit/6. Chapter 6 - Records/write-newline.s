.include "linux32.s"
.global write_newline
.type write_newline, @function
.section .data

newline:
 .ascii "\n"
 .section .text
 .equ ST_FILEDES, 8

write_newline:
 pushl %ebp
 movl %esp, %ebp

 movl $SYS_WRITE, %eax
 movl ST_FILEDES(%ebp), %ebx           # I assume the function write_newline will
 movl $newline, %ecx		       # be called with an argument and the pointer
 movl $1, %edx                         # will be on the stack. Why 8 not 4? 
				       # functionname?
 int $LINUX_SYSCALL

 movl %ebp, %esp
 popl %ebp
 ret

