.include "macOS64.s"
.include "record-def.s"

.global _start1
_start1:
  mov x29, sp
  sub sp, sp, #0x10


// Open the file
  mov x0, #-2
  adrp x1, inputfile@page
  add x1, x1, inputfile@pageoff
  mov x2, #0
  mov x3, #p_rw
  mov x16, #sys_open
  svc #0x80

  str x0, [x29]   // Store fd on the stack

   
// Read File in buffer
loop_output:
   ldr x0, [x29]   // FD
   adrp x11, buffer@page
   add x11, x11, buffer@pageoff
   stp x0, x11, [sp, -0x10]!
   bl read_record

   cmp x0, #record_size
   b.ne output_loop_end

   adrp x11, buffer@page
   add x11, x11, buffer@pageoff
   str x11, [sp, -0x10]!
   bl count_char
  
   mov x12, x0

// Write buffer to stdout
   mov x2, x0
   mov x0, #stdout 
   adrp x1, buffer@page
   add x1, x1, buffer@pageoff
   mov x16, #sys_write
   svc #0x80
   
   bl write_newline

   bl loop_output
   
output_loop_end:
  ldr x0, [x29]   // FD
  mov x16, #sys_close
  svc #0x80

  mov x16, #sys_exit
  mov x0, x12
  svc #0x80

.data
inputfile:  .asciz "Dataoutput.dat"
newline:    .asciz "\n"
buffer: .fill record_size + 1, 1, 0
