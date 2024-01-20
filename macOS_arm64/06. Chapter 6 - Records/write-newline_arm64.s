.include "macOS64.s"

.text
.global write_newline
write_newline:
  stp x29, x30, [sp, -0x10]!
  add x29, sp, #0

   mov x2, #1
   mov x0, #stdout 
   adrp x1, newline@page
   add x1, x1, newline@pageoff
   mov x16, #sys_write
   svc #0x80

  ldp x29, x30, [sp], 0x10 
  ret

.data
newline:    .asciz "\n"
