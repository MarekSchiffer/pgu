.include "record-def.s"
.data
.equ sys_exit, 1
.equ sys_close, 6
.equ sys_write, 0x1cf

.equ O_RWT, 0x201
.equ P_RW, 0666

record1:
 .ascii "Frederick\0"
 .rept 30
 .byte 0
 .endr

 .ascii "Bartlett\0"
 .rept 31
 .byte 0
 .endr

 .ascii "4242 S Prairie\0Tulsa, OK 55555\0"
 .rept 209
 .byte 0
 .endr

 .long 45

record2:
 .ascii "Marilyn\0"
 .rept 32
 .byte 0
 .endr

 .ascii "Taylor\0"
 .rept 33
 .byte 0
 .endr
 
 .ascii "2224 S Johannan St\0Chicago, IL 12345\0"
 .rept 203
 .byte 0
 .endr

 .long 29

record3:
 .ascii "Derrick\0"
 .rept 32
 .byte 0
 .endr

 .ascii "McIntire\0"
 .rept 31
 .byte 0
 .endr

 .ascii "500 W Oakland\0San Diego, CA 54321\0"
 .rept 206
 .byte 0
 .endr

 .long 36

.equ st_input_fd, 0x10

.text
.global _start

_start:
  mov x29, sp
  sub sp, sp, #0x10

  mov x0, #-2
  adrp x1, outputfile@page
  add x1, x1, outputfile@pageoff
  mov x2, #O_RWT
  mov x3, #P_RW
  mov x16, #sys_write
  svc #0x80

  str x0, [x29, 0x10]

  adrp x11, record1@page
  add x11, x11, record1@pageoff
  stp x0, x11, [sp, -0x10]!
  bl write_record
  sub sp, sp, 0x10    // To do: explain why sub instead of add.

  ldr x0, [x29, 0x10]

  adrp x11, record2@page
  add x11, x11, record2@pageoff
  stp x0, x11, [sp, -0x10]!
  bl write_record
  sub sp, sp, 0x10

  ldr x0, [x29, 0x10]

  adrp x11, record3@page
  add x11, x11, record3@pageoff
  stp x0, x11, [sp, -0x10]!
  bl write_record
  add sp, sp, 0x10

  ldr x0, [x29, 0x10]

// Close File
  mov x16, #sys_close
  svc #0x80

// Exit file
  mov x16, #sys_exit
  svc #0x80

.data
outputfile: .asciz "Dataoutput.dat"
