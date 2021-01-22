# PURPOSE: This program writes the message "Hello World!" and
#          exits

# Changes for 64-Bit:
# pushl => pushq

.section .data

helloworld:
 .ascii "Hello World!\n\0"

.section .text

.globl _start             # It's really globl not global. Both work though.
_start:
pushq $helloworld
call printf

pushq $0
call exit
