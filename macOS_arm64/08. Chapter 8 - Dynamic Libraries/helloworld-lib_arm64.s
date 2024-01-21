.text
.global _start1
_start1:

  adrp x0, helloworld@page
  add x0, x0, helloworld@pageoff
  bl _printf

  mov x0, #23
  bl _exit

.data
helloworld: .ascii "Hello World!\n\0"
