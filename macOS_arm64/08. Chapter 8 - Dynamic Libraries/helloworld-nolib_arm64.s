.include "macOS64.s"

.equ helloworld_len, helloworld_end - helloworld

.text
.global _start
_start:

   mov x0, #stdout
   adrp x1, helloworld@page
   add x1, x1, helloworld@pageoff
   mov x2, #helloworld_len
   mov x16, #sys_write
   svc #0x80

   mov x16, #sys_exit
   mov x0, #23
   svc #0x80

  
.data
helloworld: .ascii "Hello World!\n"
helloworld_end:
