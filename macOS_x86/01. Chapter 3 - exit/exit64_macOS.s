################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                        macOS port by Marek Schiffer                          #
#                                                                              #
################################################################################

.text
.global _start
_start:
  movq $0x2000001, %rax
  movq $23, %rdi
  syscall

