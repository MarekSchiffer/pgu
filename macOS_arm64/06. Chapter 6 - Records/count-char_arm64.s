.text
.global count_char
count_char:
  stp x29, x30, [sp, -0x10]!
  add x29, sp, #0

  ldr x1, [x29, 0x10]   // Buffer

  cmp x1, #0
  b.eq end_loop

  mov x0, #0

loop: 
  ldrb w5, [x1]
  cmp w5, #0
  b.eq end_loop

  add x0, x0, #1
  strb w5, [x1], #1
  bl loop

end_loop:
  ldp x29, x30, [sp], 0x10 
  ret

