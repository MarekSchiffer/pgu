.text
.global _start
_start:
  sub  sp, sp, #48
  stp  x29, x30, [sp, #32]
  add  x29, sp, #32

  adrp x8, name@page
  add x8, x8, name@pageoff
  str  x8, [sp]
  adrp x8, personstring@page
  add x8, x8, personstring@pageoff
  str  x8, [sp, #8]
  adrp x7, numberloved@page
  add x7, x7, numberloved@pageoff
  ldr x8, [x7]
  str  x8, [sp, #16]
  adrp x0, firststring@page
  add x0, x0, firststring@pageoff
  bl _printf

  mov x0, #23
  bl _exit

.data
firststring: .ascii "Hello! %s is a %s who loves the number %d\n\0"
name: .ascii "Jonathan\0"
personstring: .ascii "person\0"
numberloved: .long 7
