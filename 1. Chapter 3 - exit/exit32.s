################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                      Typed in & Comments by Marek Schiffer                   #
#                                                                              #
#                                                                              #
################################################################################

# Gihub Test

#Purpose: Simple program that exits and returns a
#	  status code back to the Linux kernel
#
#         To assembly use
#         as exit.s -o exit.o
#
#         For linking:
#         ld exit.o -o exit

#Input: none
#

#Output: returns the status code. This can be viewd by typing
#        by typing
#
#        echo $?


# Variables:
# %eax holds the system call number
# %ebx hold the return status 


# Every .section instruction is for the assembler and not for
# the computer. 
#
# .section .data will later contain data.

.section .data


# The section .text is, where the program instructions live.
.section .text

# _start is a symbol, it will be replaced during assembly or linking.
# Symbols are used to mark locations or data of programs.
#
# .global means, the assembler shouldn't discard the symbol, but
# leave it for the linker.
.global _start

# Notice the : _start: is a a "label". A label is a symbol with the colon
_start:
	movl $1, %eax	    # $1 is direct adressing mode and loads
			    # the value 1 into registr %eax
			    # This is the linux kernel command
			    # number (system call) for exiting
			    # a program

	movl $253, %ebx     # $253 is direct adressing mode and loads
                            # the value 253 into registr %eax
			    # This is the status number, we will
			    # return to the operating system.
                            # In 32-Bit the exit number can be 1 Byte.
                            # We can therefore choose a number between
			    # 0 and 255.
    


	int $0x80           # This wakes up the kernel to run the 
			    # exit command.

# int stands for interrupt 0x80 is the interupt number in hexadecima
