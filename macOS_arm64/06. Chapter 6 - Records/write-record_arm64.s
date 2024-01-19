.include "record-def.s"

.text
.global write_record
write_record:
 stp x29, x30, [sp, 0x10]!
 add x29, sp, #0

 ldr x0, [x29, -0x10]   // FD
 ldr x1, [x29, -0x08]   // Outputfile
 mov x2, #record_size
 mov x16, #4
 svc #0x80

 ldp x29, x30, [sp], 0x10 
 ret


