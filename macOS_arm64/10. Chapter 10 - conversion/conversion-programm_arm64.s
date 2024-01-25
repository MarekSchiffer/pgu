.include "macOS64.s"

.text
.global _start
_start:
  mov x29, sp

  mov x12, #824
  adrp x11, tmp_buffer@page
  add x11, x11, tmp_buffer@pageoff
  stp x11, x12, [sp, -0x10]!

  bl integer2string

  adrp x11, tmp_buffer@page
  add x11, x11, tmp_buffer@pageoff
  str x11, [sp, -0x10]!
  bl count_char

  mov x2, x0
  mov x0, #stdout 
  adrp x1, tmp_buffer@page
  add x1, x1, tmp_buffer@pageoff
  mov x16, #sys_write
  svc #0x80

  bl write_newline

  mov x16, #sys_exit
  svc #0x80









.data
tmp_buffer: .ascii "\0\0\0\0\0\0\0\0\0\0\0" 
