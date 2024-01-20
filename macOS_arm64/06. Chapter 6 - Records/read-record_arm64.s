.include "macOS64.s"
.include "record-def.s"

.global read_record
read_record:
  stp x29, x30, [sp, -0x10]!
  add x29, sp, #0

  ldr x0, [x29, 0x10]   // FD
  ldr x1, [x29, 0x18]   // Inputfile
  mov x2, #record_size
  mov x16, #sys_read
  svc #0x80

  ldp x29, x30, [sp], 0x10 
  ret

