
.data
.equ FirstPush, 500
.equ SecondPush, 500
.equ ThirdPush, 500
.equ ForthPush, 800
.equ FifthPush, 200

record_buffer_ptr1:
 .quad 0
record_buffer_ptr2:
 .quad 0
record_buffer_ptr3:
 .quad 0
record_buffer_ptr4:
 .quad 0
record_buffer_ptr5:
 .quad 0

.text
.globl _start
_start:
movq %rsp, %rbp
call allocate_init

pushq $FirstPush        # Allocate 500 Bytes
call allocate
movq %rax, record_buffer_ptr1(%rip)

pushq $SecondPush
call allocate
movq %rax, record_buffer_ptr2(%rip)

pushq $ThirdPush
call allocate
movq %rax, record_buffer_ptr3(%rip)


movq record_buffer_ptr2(%rip), %r11
pushq %r11
call deallocate

pushq $ForthPush
call allocate
movq %rax, record_buffer_ptr4(%rip)

pushq $FifthPush
call allocate
movq %rax, record_buffer_ptr5(%rip)


movq $0x2000001, %rax
movq $23, %rdi
syscall


