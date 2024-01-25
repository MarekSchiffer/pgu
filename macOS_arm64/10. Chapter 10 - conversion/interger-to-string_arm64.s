
.global integer2string
integer2string:
  stp x29, x30, [sp, -0x10]!
  mov x29, sp

  ldr x0, [x29, 0x18]   // Inputnumber
  mov x1, #10   //Divisor

  mov x11, #0

conversion_loop:
 eor x3, x3, x3 

// input: x0=dividend, x1=divisor
udiv x2, x0, x1
msub x3, x2, x1, x0
// result: x2=quotient, x3=remainder

add x3, x3, #48

str  x3, [sp, #-16]!
add x11, x11, #1

cmp x2, #0
b.eq end_conversion_loop

mov x0, x2
bl conversion_loop
end_conversion_loop:

  ldr x4, [x29, 0x10]   // Buffer
  sub sp, sp, #0x10   
copy_reversing_loop:
  ldr  x3, [sp, #16]!
  str  w3, [x4]
  sub x11,x11, #1
  add x4, x4, #1

  cmp x11, #0
  b.eq end_copy_reversing_loop

  bl copy_reversing_loop 

end_copy_reversing_loop:
  add sp, sp, #0x10
  mov x3, #0
  str  w3, [x4], #1
  ldp x29, x30, [sp], 0x10 
  ret

