# Changes for 64-Bit:
# linux32.s => linux64.s
# eXX => rXX
# movl, pushl, addl => movq, pushq, addq
# int $LINUX_SYSCALL => syscall
# For syscall rbx => rdi, rcx => rsi
# Stack Cleanup doubled

.include "../6.\ Chapter\ 6\ -\ Records/linux64.s"
 
.section .data

# This is where it will be stored
tmp_buffer:
 .ascii "\0\0\0\0\0\0\0\0\0\0\0"

.section .text

.globl _start
_start:
 movq %rsp, %rbp

 # Storage for the result
 pushq $tmp_buffer
 
 # Number to convert
 pushq $824
 call integer2string
 addq $16, %rsp
 
 # Get the character count for our system call
 pushq $tmp_buffer
 call count_chars
 addq $8, %rsp

 # The count goes in %rdx for SYS_WRITE
 movq %rax, %rdx

 # Make the system call
 movq $SYS_WRITE, %rax
 movq $STDOUT, %rdi
 movq $tmp_buffer, %rsi
 syscall

 # Write a carriage return
 pushq $STDOUT
 call write_newline

 # Exit
 movq $SYS_EXIT, %rax
 movq $0, %rdi
 syscall
