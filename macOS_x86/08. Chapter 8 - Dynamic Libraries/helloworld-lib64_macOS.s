# PURPOSE: This program writes the message "Hello World!" and
#          exits

# Changes for macOS:
# .section .data/.text => .data/.text
# 
# printf and exit => _printf & _exit
#
# API is not via stack, but %rdi


# Changes for 64-Bit:
# pushl => pushq

.data

helloworld:
 .ascii "Hello World!\n\0"

.text

.globl _start                  # It's really globl not global. Both work though.

_start:
subq $8, %rsp                  # Align the %rsp stack, so it is multiples of 16
leaq helloworld(%rip), %rdi
call _printf

movq $0, %rdi
call _exit
