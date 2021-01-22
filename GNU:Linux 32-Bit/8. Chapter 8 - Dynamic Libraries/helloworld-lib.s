# PURPOSE: This program writes the message "Hello World!" and
#          exits

.section .data

helloworld:
 .ascii "Hello World!\n\0"

.section .text

.globl _start             # It's really globl not global. Both work though.
_start:
pushl $helloworld
call printf

pushl $0
call exit
