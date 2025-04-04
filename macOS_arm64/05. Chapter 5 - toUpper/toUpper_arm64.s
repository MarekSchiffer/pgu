//Syscalls
.equ SYS_EXIT,  1
.equ SYS_READ,  3
.equ SYS_WRITE, 4
.equ SYS_OPEN,  5
.equ SYS_CLOSE, 6

.equ BUFFER_SIZE, 516

// Local Stackframe
.equ BUFFER_ADDRESS,   0
.equ FD1_STACK,       -8
.equ FD2_STACK,       -16
.equ ADDR_INPUTFILE,  -24
.equ ADDR_OUTPUTFILE, -32

// File Status Flags
.equ O_RDONLY, 0x000
.equ O_WRONLY_CREATE_TRUNC, 0x601

// File Descriptor
.equ READ_WRITE_PERMISSION, 0666



.text
.global _start
_start:
  mov fp, sp
  sub sp, sp, #48

  cmp x0, #3                               ; argc
  b.ne exitError

  ldr x0, [x1, #8]                         ; argv[1]
  ldr x1, [x1, #16]                        ; argv[2]

  str x0, [fp, #ADDR_INPUTFILE]
  str x1, [fp, #ADDR_OUTPUTFILE]

open_input_file:
  mov x1,  #O_RDONLY                       ; Open Inputfile
  mov x2,  #READ_WRITE_PERMISSION
  mov x16, #SYS_OPEN
  svc #0x80


  str x0, [fp, #FD1_STACK]
  ldr x0, [fp, #ADDR_OUTPUTFILE]


open_output_file:
  mov x1,  #O_WRONLY_CREATE_TRUNC          ; Open Outputfile
  mov x2,  #READ_WRITE_PERMISSION
  mov x16, #SYS_OPEN
  svc #0x80


  str x0, [fp, #FD2_STACK]


  adrp x1, buffer@page                      ; Local Buffer
  add x1, x1, buffer@pageoff
  str x1, [fp, #BUFFER_ADDRESS]

begin_read_loop:

    ldr x0, [fp, #FD1_STACK]
    ldr x1, [fp, #BUFFER_ADDRESS]
    mov x2, #BUFFER_SIZE
    mov x16, #SYS_READ
    svc #0x80

    cmp x0, #0
    b.eq close_files

;   str x0, [fp, #READ_BYTES]

    ldr x1, [fp, #BUFFER_ADDRESS]
    stp x0, x1, [sp, #-16]!
    bl toUpper

    ldp x2, x1, [sp], #16
    ldr x0, [fp, #FD2_STACK]
    mov x16, #SYS_WRITE
    svc #0x80

b begin_read_loop

close_files:
  ldr x0, [fp, #FD1_STACK]                    ; Close inputfile
  mov x16, #SYS_CLOSE
  svc #0x80

  ldr x0, [fp, #FD2_STACK]                    ; Close outputfile
  mov x16, #SYS_CLOSE
  svc #0x80

  mov x16, #1
  svc #0x80

exitError:
  mov x0,  #44
  mov x16, #1
  svc #0x80





toUpper:
  stp fp, lr, [sp, #-16]!
  mov fp, sp

  ldp x0, x1, [fp, #16]

  cmp x0, #0
  b.eq end_toUpper

  mov x2, #0

loop_toUpper:
  cmp x2, x0
  b.eq end_toUpper

  ldrb w3, [x1]
  cmp w3, #96
  b.le next_byte
  cmp w3, #123
  b.ge next_byte

  sub w3, w3, #32

next_byte:
  strb w3, [x1], #1
  add x2, x2, #1
  b loop_toUpper

end_toUpper:
  mov sp, fp
  ldp fp, lr, [sp], #16
  ret

.bss
.lcomm buffer, BUFFER_SIZE

;.data
;inputfile:  .asciz "BobDylan.txt"
;outputfile: .asciz "out.txt"
