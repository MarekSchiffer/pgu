################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                      Typed in & Comments by Marek Schiffer                   #
#                                                                              #
################################################################################

.data
data_items:
 #.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
 .long 3,1,56,4,11,23,44,22,222,33,33,56,64,8,15,0

.text
.global _start
_start:
  leaq data_items(%rip), %rsi 
  movq $0, %rdi

  movl (%rsi,%rdi,4), %eax
  movl %eax, %ebx                               # eax holds current maximum, ebx holds final maximum

start_loop:

  cmpl $0, %eax
  je loop_exit

  incq %rdi
  movl (%rsi,%rdi,4), %eax
  cmpl %ebx, %eax
  jle start_loop

  movl %eax, %ebx
jmp start_loop  

loop_exit:
  movq $0x2000001, %rax
  movl %ebx, %edi
  syscall
