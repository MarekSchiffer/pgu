.text
.global _start
_start:

adrp x1, data_items@page
ldr x0, [x1]
mov x2, x0                    ; x2 running maximum

loop:
 cmp x0, #0
 b.eq endProgram

 ldr x0, [x1, #8]!
 cmp x0, x2
 b.lt next

 mov x2, x0

next:
  b loop

endProgram:
 mov x0, x2
 mov x16, #1
 svc #0x80

.data
data_items: .quad 33,32,255,17,54,2,1,8,9,54,222,254,0
