.section .data
data_items: .quad 23,6,17,46,52,69


.section .text
.global _start
_start:
#  movq $11, %rdx
  
#  jmp end

  movq $0x402000, %rcx
  movq (%rcx), %rdx

#  jmp end

  movq $data_items, %rcx
  movq (%rcx), %rdx

#  jmp end

  movq data_items, %rdx

#  jmp end

  movq $data_items, %rcx
  movq 8(%rcx), %rdx

#  jmp end

  movq $data_items, %rcx
  movq $3, %rdi
  movq (%rcx,%rdi,8), %rdx

#  jmp end

  movq $data_items, %rcx
  movq $3, %rdi
  movq 8(%rcx,%rdi,8), %rdx

#  jmp end

  movq $8, %rcx
  movq data_items(%rcx,%rdi,8), %rdx    # This notation sucks! We're glad it is dead!

#  jmp end

#WHAT DOES NOT WORK:

#  movq (data_items,%rdi,8), %rbx
#  movq ($data_items,%rdi,8), %rbx

# IP-Relative
  leaq data_items(%rip), %rcx
  movq (%rcx), %rdx

#  jmp end

  movq data_items(%rip), %rdx

  
end:
  movq $60, %rax  
  movq %rdx, %rdi
  syscall

