.global _start
_start:
  mov x1, #5
  str x1, [sp, -0x10]!
  bl fac

  mov x16, #1
  svc #0x80

fac:
 stp x29, x30, [sp, -0x10]!
 add x29, sp, #0

 ldr x11, [X29, 0x10]
 cmp x11, #1
 b.eq end_fac

 sub x11, x11, #1
 str x11, [sp, -0x10]!
 bl fac

 add sp, sp, 0x10           // That's what made the stack work. See Notes below
 ldr x2, [X29, 0x10]
 mul x0, x2, x0

end_fac:
 ldp x29, x30, [sp], 0x10
 ret

/* This is the recursive version of factorial. The stack needs to always be a multiple
   of 16. Therefore if we put the pair x29, x30 on the stack and then the new value x11,
   we have one 8 byte part of the stack which has random junk in it. When we reach the
   end of the stack there is only 1, x30, x29 on it. After the return we go the 16 byte
   back and the stack pointer is correcton the 1. However the 2 is now 4 spaces
   (4*8 byte) away from the stack pointer. So by adding 16 (0x10), we undo the 
   str x11 part and are back on x29 with the stack pointer. Now we can load x2 as before.
*/
