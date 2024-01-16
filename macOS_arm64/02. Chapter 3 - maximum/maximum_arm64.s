.global _start
.align 4

_start:
  ADRP X1, data_items@PAGE
  ADD  X1, X1, data_items@PAGEOFF

  mov x7, #8
  mov x8, #0
  ldr x3, [x1]
  mov x4, x3

loop:
  cmp x3, #0
  b.eq end_loop

  add x8, x8, #1
  mov x7, #8
  mul x7, x7, x8

  ldr x3, [x1,x7]
  cmp x3, x4
  b.le loop

  mov x4, x3

b loop

end_loop:
 mov     x0, x4
 mov     x16, #1
 svc     #0x80

.data
data_items: .quad 33,32,255,17,54,2,1,8,9,54,222,254,0
