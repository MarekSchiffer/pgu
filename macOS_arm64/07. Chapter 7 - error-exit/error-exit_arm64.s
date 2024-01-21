.include "macOS64.s"
.include "record-def.s"

.text
.global error_exit
error_exit:
 stp x29, x30, [sp, -0x10]!
 add x29, sp, #0

 ldr x0, [x29, 0x10]   // Error message

 
 ldr x1, [x29, 0x10]   // Error code
 str x1, [sp]
 bl count_char
 mov x2, x0
 mov x0, #stdout
 ldr x1, [x29, 0x10]   // Error code
 mov x16, #sys_write
 svc #0x80

 ldr x1, [x29, 0x18]   // Error message
 str x1, [sp]         //To Do, why is it sp here, and not in read records.
 bl count_char
 mov x2, x0
 mov x0, #stdout
 ldr x1, [x29, 0x18]   // Error message
 mov x16, #sys_write
 svc #0x80
 
 bl write_newline

 mov x16, #1
 mov x0, #1
 svc #0x80

