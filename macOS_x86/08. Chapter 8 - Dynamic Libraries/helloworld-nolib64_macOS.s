# PURPOSE: This program writes the message "Hello World!" and
#          exits
#	

# Changes for macOS:
# linux64 => macOS64
# movq $helloworld, %rsi => leaq helloworld(%rip), %rsi

# Changes for 64-Bit:
# linux32.s => linux64.s
# eXX => rXX
# int $SYS_LINUX => syscall
# movl => movq

.include "../06. Chapter 6 - Records/macOS64.s"

.data
helloworld:
 .ascii "Hello World!\n"
helloworld_end:

.equ helloworld_len, helloworld_end - helloworld

.text

.global _start
_start:
 movq $STDOUT, %rdi
 leaq helloworld(%rip), %rsi
 movq $helloworld_len, %rdx
 movq $SYS_WRITE, %rax
 syscall

 movq $0, %rdi
 movq $SYS_EXIT, %rax
 syscall

