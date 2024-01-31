.data 
data_items: .quad 23,6,17,46,52,69


.text
.global _start
_start:
#  movq $11, %rdx

#  jmp end

  movq $0x100001000, %rcx
  movq (%rcx), %rdx

#  jmp end

#  movq $data_items, %rdx
#  movq (%rcx), %rdx

#  jmp end

#  movq data_items, %rdx

#  jmp end

  leaq data_items(%rip), %rcx
  movq (%rcx), %rdx

#  jmp end

  movq data_items(%rip), %rdx

#  jmp end

  leaq data_items(%rip), %rcx
  movq 8(%rcx), %rdx

#  jmp end

  leaq data_items(%rip), %rcx
  movq $3, %rdi
  movq (%rcx,%rdi,8), %rdx

#  jmp end
  
# Finally this horrible notation is dead!
#  movq $8, %rcx
#  movq data_items(%rcx,%rdi,8), %rdx
#
# RIP, pun intended!

end:
   movq $0x2000001, %rax
   movq %rdx, %rdi
   syscall
