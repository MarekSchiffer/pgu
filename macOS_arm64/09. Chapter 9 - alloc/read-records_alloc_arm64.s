.include "../06. Chapter 6 - Records/macOS64.s"
.include "../06. Chapter 6 - Records/record-def.s"

.text
.global _start
_start:
  mov x29, sp
  sub sp, sp, #0x10
  
  bl allocate_init
 
  mov x11, #record_size
  str x11, [sp, -0x10]!
  bl allocate
  
  adrp x12, record_buffer_ptr@page
  add x12, x12, record_buffer_ptr@pageoff
  str x0, [x12]

//  bl write_newline
//  bl write_newline


// Open the file
  mov x0, #-2
  adrp x1, inputfile@page
  add x1, x1, inputfile@pageoff
  mov x2, #0
  mov x3, #p_rw
  mov x16, #sys_open
  svc #0x80

  str x0, [x29]   // Store fd on the stack

   
loop_output:
// Read File in buffer
   ldr x0, [x29]   // FD
   adrp x11, record_buffer_ptr@page
   add x11, x11, record_buffer_ptr@pageoff
   stp x0, x11, [sp, -0x10]!
   bl read_record

   cmp x0, #record_size
   b.ne output_loop_end

   adrp x11, record_buffer_ptr@page
   add x11, x11, record_buffer_ptr@pageoff
   str x11, [sp, -0x10]!
   bl count_char
  
   mov x12, x0

// Write buffer to stdout
   mov x2, x0
   mov x0, #stdout 
   adrp x1, record_buffer_ptr@page
   add x1, x1, record_buffer_ptr@pageoff
   mov x16, #sys_write
   svc #0x80
  
   bl write_newline

   bl loop_output
output_loop_end:
 // adrp x11, record_buffer_ptr@page
 // add x11, x11, record_buffer_ptr@pageoff
 // str x11, [sp, -0x10]!
 // bl deallocate

  ldr x0, [x29]   // FD
  mov x16, #sys_close
  svc #0x80

  mov x16, #sys_exit
  mov x0, x12
  svc #0x80

.data
record_buffer_ptr: .quad 0
.align 16     // Without an alignment here, the newline gets somehow 
              // overwritten. To Do: Investigate why.
inputfile:  .asciz "Dataoutput.dat"
newline:    .asciz "\n"
