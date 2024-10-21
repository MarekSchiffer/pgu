.global _start

_start:
 mov     x0, #23
 mov     x16, #1
 svc     #0x80
