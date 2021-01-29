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

pushq $FirstPush
call allocate
movq %rax, record_buffer_ptr1(%rip)

pushq $SecondPush
call allocate
movq %rax, record_buffer_ptr2(%rip)

pushq $ThirdPush
call allocate
movq %rax, record_buffer_ptr3(%rip)

# To this point we allocated 1500 bytes + 48 bytes for 3 headers.

# Next we remove the middle block
movq record_buffer_ptr2(%rip), %r11
pushq %r11
call deallocate

# We now ask for an 800 bytes block. The middle block is free, but
# to small.

pushq $ForthPush
call allocate
movq %rax, record_buffer_ptr4(%rip)

# Finally, we ask for 200 bytes, which fit in the middle block and
# will get allocated there.

pushq $FifthPush
call allocate
movq %rax, record_buffer_ptr5(%rip)


#movq $0x2000001, %rax
movq $60, %rax
movq $23, %rdi
syscall


