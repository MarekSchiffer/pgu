.text
.global _start
_start:
  mov x29, sp

  bl allocate_init

  mov x11, #firstPush
  str x11, [sp, -0x10]!
  bl allocate

  adrp x12, record_buffer_ptr1@page
  add x12, x12, record_buffer_ptr1@pageoff
  str x0, [x12]


  mov x11, #secondPush
  str x11, [sp, -0x10]!
  bl allocate

  adrp x12, record_buffer_ptr2@page
  add x12, x12, record_buffer_ptr2@pageoff
  str x0, [x12]

  mov x11, #thirdPush
  str x11, [sp, -0x10]!
  bl allocate

  adrp x12, record_buffer_ptr3@page
  add x12, x12, record_buffer_ptr3@pageoff
  str x0, [x12]

  adrp x11, record_buffer_ptr2@page
  add x11, x11, record_buffer_ptr2@pageoff
  str x11, [sp, -0x10]!
  bl deallocate

  mov x11, #forthPush
  str x11, [sp, -0x10]!
  bl allocate

  adrp x12, record_buffer_ptr4@page
  add x12, x12, record_buffer_ptr4@pageoff
  str x0, [x12]

  mov x11, #fifthPush
  str x11, [sp, -0x10]!
  bl allocate

  adrp x12, record_buffer_ptr5@page
  add x12, x12, record_buffer_ptr5@pageoff
  str x0, [x12]

  mov     X16, #1
  mov     X0, #23
  svc     #0x80



.data
.equ firstPush, 500
.equ secondPush, 500
.equ thirdPush, 500
.equ forthPush, 800
.equ fifthPush, 200

record_buffer_ptr1: .quad 0
record_buffer_ptr2: .quad 0
record_buffer_ptr3: .quad 0
record_buffer_ptr4: .quad 0
record_buffer_ptr5: .quad 0
