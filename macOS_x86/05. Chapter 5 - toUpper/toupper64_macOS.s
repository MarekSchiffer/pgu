# Syscall numbers:
.equ SYS_OPEN, 0x2000005
.equ SYS_WRITE, 0x2000004
.equ SYS_READ, 0x2000003
.equ SYS_CLOSE, 0x2000006
.equ SYS_EXIT, 0x2000001

# File Descriptor Flag and File Status Flag
.equ O_RDONLY, 0x000
.equ O_CREAT_WRONLY_TRUNC, 0x601

# Constants
.equ END_OF_FILE, 0
.equ NUMBER_ARGUMENTS, 2

# Local stack frame
.equ ST_SIZE_RESERVE, 16

.equ ST_FD_IN, -8
.equ ST_FD_OUT, -16
.equ ST_ARGC, 0
.equ ST_ARGV_0, 8
.equ ST_ARGV_1, 16
.equ ST_ARGV_2, 24



.bss
.equ BUFFER_SIZE, 516
.lcomm BUFFER_DATA, BUFFER_SIZE



.text
.global _start

_start:
  movq %rsp, %rbp
  subq $ST_SIZE_RESERVE, %rsp

  open_files:
  open_fd_in:

  movq $SYS_OPEN, %rax
  movq ST_ARGV_1(%rbp), %rdi
  movq $O_RDONLY, %rsi
  movq $0666, %rdx
  syscall


  store_fd_in:
  movq %rax, ST_FD_IN(%rbp)


  open_fd_out:
  movq $SYS_OPEN, %rax
  movq ST_ARGV_2(%rbp), %rdi
  movq $O_CREAT_WRONLY_TRUNC, %rsi
  movq $0666, %rdx
  syscall


  store_fd_out:
  movq %rax, ST_FD_OUT(%rbp)


read_loop_begin:

    movq $SYS_READ, %rax
    movq ST_FD_IN(%rbp), %rdi
    leaq BUFFER_DATA(%rip), %rsi
    movq $BUFFER_SIZE, %rdx
    syscall


    cmpq $END_OF_FILE, %rax
    jle end_loop

    continue_read_loop:

     leaq BUFFER_DATA(%rip), %r11
     pushq %r11
     pushq %rax
     call convert_to_upper
     popq %rax
     addq $8, %rsp


     movq %rax, %rdx
     movq $SYS_WRITE, %rax
     movq ST_FD_OUT(%rbp), %rdi
     leaq BUFFER_DATA(%rip), %rsi
     syscall

jmp read_loop_begin


end_loop:

  movq $SYS_CLOSE, %rax
  movq ST_FD_OUT(%rbp), %rdi
  syscall

  movq $SYS_CLOSE, %rax
  movq ST_FD_IN(%rbp), %rdi
  syscall

end_main:
  movq $SYS_EXIT, %rax
  movq $0, %rdi
  syscall



# Constants
.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

# Stack frame for convert_to_upper function
.equ ST_BUFFER_LEN, 16
.equ ST_BUFFER, 24


convert_to_upper:
  pushq %rbp
  movq %rsp, %rbp

  movq ST_BUFFER(%rbp), %rax
  movq ST_BUFFER_LEN(%rbp), %rbx
  movq $0, %rdi

  cmpq $0, %rbx
  je end_convert_loop


convert_loop:
  movb (%rax,%rdi,1), %cl

  cmpb $LOWERCASE_A, %cl
  jl next_byte
  cmpb $LOWERCASE_Z, %cl
  jg next_byte


  addb $UPPER_CONVERSION, %cl
  movb %cl, (%rax,%rdi,1)

next_byte:
  incq %rdi
  cmpq %rdi, %rbx

jne convert_loop

end_convert_loop:
  movq %rbp, %rsp
  popq %rbp
  ret
