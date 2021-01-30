# Changes for macOS:
# linux64.s => macOS64.s
# .section .data/.text => .data/.text
#
# pushq $tmp_buffer =>  leaq tmp_buffer(%rip), %r11 && pushq %r11
# movq $tmp_buffer, %rsi => leaq tmp_buffer(%rip), %rsi

# Changes for 64-Bit:
# linux32.s => linux64.s
# eXX => rXX
# movl, pushl, addl => movq, pushq, addq
# int $LINUX_SYSCALL => syscall
# For syscall rbx => rdi, rcx => rsi
# Stack Cleanup doubled

.include "../06. Chapter 6 - Records/macOS64.s"
 
.data

# This is where it will be stored
tmp_buffer:
 .ascii "\0\0\0\0\0\0\0\0\0\0\0"

 .text

.globl _start
_start:
 movq %rsp, %rbp

 # Storage for the result
 leaq tmp_buffer(%rip), %r11
 pushq %r11
 
 # Number to convert
 pushq $824
 call integer2string
 addq $16, %rsp
 
 # Get the character count for our system call
 leaq tmp_buffer(%rip), %r11
 pushq %r11
 call count_chars
 addq $8, %rsp

 # The count goes in %rdx for SYS_WRITE
 movq %rax, %rdx

 # Make the system call
 movq $SYS_WRITE, %rax
 movq $STDOUT, %rdi
 leaq tmp_buffer(%rip), %rsi
 syscall

 # Write a carriage return
 pushq $STDOUT
 call write_newline

 # Exit
 movq $SYS_EXIT, %rax
 movq $0, %rdi
 syscall
