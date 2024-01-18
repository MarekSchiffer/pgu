.equ buffer_size, 500 // Must be on top

.text
.global _start
_start:

// Open Input File
  mov x0, #-2
  adrp x1, inputfile@page
  add x1, x1, inputfile@pageoff
  mov x2, #0
  mov x3, #0666
  mov x16, #0x1cf   // Apple sucks sometimes, eh!
  svc #0x80

  mov x11, x0 // save fd in x11

// Open Output File
  mov x0, #-2
  adrp x1, outputfile@page
  add x1, x1, outputfile@pageoff
  mov x2, #0x201
  mov x3, #0666
  mov x16, #0x1cf
  svc #0x80
  
  mov x12, x0 // save fd in x12

// Read into Buffer
read_loop:
   mov x0, x11
   adrp x1, buffer@page
   add x1, x1, buffer@pageoff
   mov x2, #buffer_size
   mov x16, #3
   svc #0x80
 
    mov x10, x0 // store length of file

   adrp x1, buffer@page
   add x1, x1, buffer@pageoff
   stp x1, x10, [sp, -0x10]!
   bl toUpper
   add sp, sp, 0x10

// Write File
   mov     x0, x12 
   adrp x1, buffer@page
   add x1, x1, buffer@pageoff
   mov x2, x10
   mov x16, #4
   svc #0x80


cmp x10, #buffer_size
b.eq read_loop

// Close Input File
  mov x0, x11
  mov x16, #6
  svc #0x80

// Close Output File
  mov x0, x12
  mov x16, #6
  svc #0x80

// Exit Program
  mov x16, #1
  mov x0, #23
  svc #0x80

toUpper:
 stp x29, x30, [sp, 0x10]!
 add x29, sp, #0

 ldr x3, [x29, -0x10]   // Buffer
 ldr x4, [x29, -0x08]   // Buffer length

loop:
 ldrb w5, [x3]
 cmp w5, #'z'
   b.gt next_byte
 cmp w5, #'a'
   b.lt next_byte
 sub w5, w5, #('a'-'A')

next_byte:
 strb w5, [x3], #1
 cmp w5, #0

   b.ne loop

 ldp x29, x30, [sp], 0x10 
 ret

.data
inputfile:  .asciz "BobDylan.txt"
outputfile: .asciz "out.txt"
buffer: .fill buffer_size + 1, 1, 0


