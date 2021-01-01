;nasm -f macho64 -o max.a maximum.asm 
;ld -macosx_version_min 11.0 -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -e _start -arch x86_64 max.a -lSystem -o max

default rel

section .data

data_items:
    dq 3,67,34,222,45,75,54,34,44,33,22,11,66,255,0

section .text

global _start

_start:
    lea rsi, [data_items]

    mov rdi, 0
    mov rax, [rsi + rdi*8]
    mov rbx, rax

start_loop:
    cmp rax, 0
    je loop_exit
    inc rdi
    mov rax, [rsi + rdi*8]
    cmp rax, rbx
    jle start_loop

mov rbx, rax
jmp start_loop

loop_exit:
mov rdi,rbx
mov rax, 0x2000001          ;1 is the exit() syscall
syscall
