.equ header_size, 16
.equ hdr_avail_offset, 0
.equ hdr_size_offset, 8

.equ unavailable, 0
.equ available, 1
.equ sys_brk, 12 // Where do we need this?

.text
.global allocate_init
allocate_init:
  stp x29, x30, [sp]
  add x29, sp, #0    // That's a mov instruction

  mov x0, #0
  bl _sbrk

  add x0, x0, #1
 
  adrp x11, heap_begin@page
  add x11, x11, heap_begin@pageoff
  str x0, [x11]

  adrp x12, current_break@page
  add x12, x12, current_break@pageoff
  str x0, [x12]

  ldp x29, x30, [sp]
  ret

.global allocate
allocate:
  stp x29, x30, [sp, #-0x20]!
  add x29, sp, #0    // That's a mov instruction
 
 ldr x8, [x29, #0x20]                 // Wanted Memory

 adrp x0, heap_begin@page
 add x0, x0, heap_begin@pageoff       // x0 has the heap_begin
 ldr x1, [x0]

 adrp x7, current_break@page
 add x7, x7, current_break@pageoff    // x7_ current_break
 ldr x2, [x7]

  ldr x14, [x0]
alloc_loop_begin:
  cmp x1, x2
  b.eq move_break

  //ldr x14, [x0]
  ldr x3, [x1, #hdr_avail_offset]
  cmp x3, #unavailable
  b.eq next_location

 // ldr x14, [x0]
  ldr x3, [x1, #hdr_size_offset]
  cmp x8, x3
  b.le allocate_here

next_location:
//  ldr x14, [x0]
  ldr x3, [x14, #hdr_size_offset]
  add x14, x14, x3
  add x14, x14, #0x10       //buffersize
//  str x14, [x0]             // to store the new break in the heap_begin
  mov x1, x14               // For the loop

  bl alloc_loop_begin

allocate_here:
  
  mov x17, #unavailable
  str x17, [x14, #hdr_avail_offset]
  add x1, x1, #0x10 // headersize
 
  mov x0, x1

  ldp x29, x30, [sp], 0x20 
  ret

move_break:
  str  x0, [sp, #-16]!
  str  x7, [sp, #-16]!
  str  x8, [sp, #-16]!
  bl _sbrk

  cmp x8, #0    // This is cheating. We'll have to adjust that
  b.eq error_exit

  sub sp, sp, #0x10   

  ldr  x8, [sp, #16]!
  ldr  x7, [sp, #16]!
  ldr  x0, [sp, #16]!

  add sp, sp, #0x10

  ldr x14, [x7]
  mov x1, #unavailable
  str x1, [x14, #hdr_avail_offset]
  str x8, [x14, #hdr_size_offset]

  add x14, x14, #header_size
  mov x0, x14
  add x14, x14, x8

  adrp x11, current_break@page
  add x11, x11, current_break@pageoff
  str x14, [x11]
 
//  mov x0, x14
  ldp x29, x30, [sp], 0x20 
  ret
 
// NOT HERE
error_exit:
 ldp x29, x30, [sp], 0x10 
 add sp, sp, #0x10
 ret


.global deallocate
.equ st_memory_seg, 8


.global deallocate
.equ st_memory_seg, 8
deallocate:

  ldr x0, [sp]
  ldr x1, [x0]
  sub x1, x1, 0x10   // substract the header
  mov x2, #1
  str x2, [x1]

  ret

 
.data
heap_begin:    .quad 0
current_break: .quad 0
