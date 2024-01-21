.include "macOS64.s"
.include "record-def.s"

.equ st_in_des, -16
.equ st_out_des, -32

.text
.global _start2
_start2:
  mov x29, sp
  sub sp, sp, #0x10

// Open input file
  mov x0, #-2
  adrp x1, inputfile@page
  add x1, x1, inputfile@pageoff
  mov x2, #0
  mov x3, #p_rw
  mov x16, #sys_open
  svc #0x80
  
  str x0, [x29]   // Store fd on the stack

// Open output file
  mov x0, #-2
  adrp x1, outputfile@page
  add x1, x1, outputfile@pageoff
  mov x2, #0x201
  mov x3, #p_rw
  mov x16, #sys_open
  svc #0x80

  str x0, [x29, 0x10]   // Store fd on the stack

loop:
   ldr x0, [x29]   // FD
   adrp x11, buffer@page
   add x11, x11, buffer@pageoff
   stp x0, x11, [sp, -0x10]!
   bl read_record
  
   cmp x0, record_size
   b.ne loop_end

   adrp x11, buffer@page
   add x11, x11, buffer@pageoff

   add x11, x11, record_age
 
   ldr x12, [x11]
   add x12, x12, #1
   str x12, [x11]
   
  ldr x0, [x29, 0x10]   // FD
  adrp x11, buffer@page
  add x11, x11, buffer@pageoff
  stp x0, x11, [sp, -0x10]!
  bl write_record

bl loop

loop_end:
// Exit
  mov x16, #1
  mov x0, #23 
  svc #0x80

.data
inputfile:  .asciz "Dataoutput.dat"
outputfile: .asciz "ChangedRecord.dat"
buffer: .fill record_size + 1, 1, 0
