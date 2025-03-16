################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                      Typed in & Comments by Marek Schiffer                   #
#                                                                              #
################################################################################

.data
data_items:
 .quad 3,1,56,4,11,23,44,22,222,33,33,56,64,8,15,0

.text
.global _start

_start:
  leaq data_items(%rip), %rsi
  movq $0, %rdi

  movq (%rsi,%rdi,8), %rax
  movq %rax, %rbx                            # rbx holds current maximum

start_loop:

  cmpq $0, %rax
  je loop_exit

  incq %rdi
  movq (%rsi,%rdi,8), %rax
  cmpq %rbx, %rax
  jle start_loop

  movq %rax, %rbx
jmp start_loop

loop_exit:
  movq $0x2000001, %rax
  movq %rbx, %rdi
  syscall
