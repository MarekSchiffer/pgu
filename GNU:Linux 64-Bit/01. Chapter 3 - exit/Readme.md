Without the clutter, the program reads
```

.section .text

.global _start
_start:
  movl $1, %eax
  movq $60, %rax
  movq $64, %rdi
```
```
#	#########################################################################
#	# rax: 64-Bit                   #########################################
#	#                               # eax: 32-Bit    ########################
#	#                               #                # ax:     ##############
#	#                               #                # 16-Bit  #ah: #al: ####
#	#                               #                #         #    #    ####
#	#                               #                #         ##############
#	#                               #                ########################
#	#                               #########################################
#	#########################################################################
```

### Changes to the 32-Bit version
- eXX Registers are 4 Byte or 32-Bit and change to 8 Byte or 64-Bit rXX registers.
- movq (move Quadword) is used for 64-Bit registers instead of movl (longword)
- Value 60 in %rax is used for exit interupt
- rdi (register destination index) holds the return status
- int (interrupt) is replaced by syscall

