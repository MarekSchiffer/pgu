.text
.global _start
_start:

  adrp x0, helloworld@page
  add x0, x0, helloworld@pageoff
  bl _printf

  mov x0, #23
  bl _exit

.data
helloworld: .ascii "Hello World!\n\0"
