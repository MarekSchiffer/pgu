.global _start
.align 4

_start:
 mov     X0, #23
 mov     X16, #1
 svc     #0x80
