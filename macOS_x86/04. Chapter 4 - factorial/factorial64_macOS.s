################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 66 - 68                                 #
#                   Ported to macOS x86_64 by Marek Schiffer                   #
#                                                                              #
################################################################################

.text
.global _start
_start:
  pushq $4                        # Input value
  call factorial
  addq $8, %rsp

  movq %rax, %rdi
  movq $0x2000001, %rax
  syscall


factorial:
  pushq %rbp
  movq %rsp, %rbp
  movq 16(%rbp), %rax

  cmpq $1, %rax                   # Recursion anchor (base case)
  je end_factorial

  decq %rax
  pushq %rax
  call factorial

  movq 16(%rbp), %rbx
  imulq %rbx, %rax

end_factorial:
movq %rbp, %rsp
popq %rbp
ret
