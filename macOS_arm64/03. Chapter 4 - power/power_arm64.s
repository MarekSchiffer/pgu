.global _start

_start:
  mov x1, #2
  mov x2, #4
  stp x1, x2, [sp, -0x10]!
  bl power
  add sp, sp, 0x10

  str x0, [sp, -0x10]!

  mov x1, #5
  mov x2, #3
  stp x1, x2, [sp, -0x10]!
  bl power
  add sp, sp, 0x10

  ldr x1, [sp]

  add x0, x0, x1

end_func:
 mov x16, #1
 svc #0x80

power:
 stp x29, x30, [sp, -0x10]!
 add x29, sp, #0

 ldr x4, [X29, 0x10]
 ldr x3, [X29, 0x18]
 mov x5, x4

loop_power:
  cmp x3, #1
  b.eq end_loop

  sub x3, x3, #1
  mul x5, x5, x4
b loop_power

end_loop:
 mov x0, x5
 ldp x29, x30, [sp], 0x10
 ret
