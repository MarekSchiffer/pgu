.section .data
data_items: .long 23,6,17,46,52,69


.section .text
.global _start
_start:
#  movl $11, %edx

#  jmp end

  movl $0x804a000, %ecx
  movl (%ecx), %edx

#  jmp end

  movl $data_items, %ecx
  movl (%ecx), %edx

#  jmp end

  movl data_items, %edx

#  jmp end

  movl $data_items, %ecx
  movl 4(%ecx), %edx

#  jmp end

  movl $data_items, %ecx
  movl $3, %edi
  movl (%ecx,%edi,4), %edx

#  jmp end

  movl $data_items, %ecx
  movl $3, %edi
  movl 4(%ecx,%edi,4), %edx

#  jmp end

  movl $4, %ecx
  movl data_items(%ecx,%edi,4), %edx    # This notation sucks! We're glad it is dead!

  jmp end

##WHAT DOES NOT WORK:
#
##  movl (data_items,%edi,4), %ebx
##  movl ($data_items,%edi,4), %ebx


end:
  movl $1, %eax
  movl %edx, %ebx
  int $0x80

