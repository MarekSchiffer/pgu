################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                    Typed in & Commented by Marek Schiffer                    #
#                                                                              #
#           Credit for 64-Bit Port: "realead" https://github.com/realead       #
#                                                                              #
################################################################################

#Purpose: Simple program that exits and returns a
#	  status code back to the Linux kernel
#

#Input: none
#

#Output: returns the status code. This can be viewd by typing
#        by typing
#
#        echo $?


# Variables:
# %rax holds the system call number
# %rdi hold the return status 


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

#	movl $1, %eax	    # $60 is direct adressing mode and loads
	movq $60, %rax	    # the value 60 into register %rax
			    # This is the linux kernel command
			    # number (system call) for exiting
			    # a program in 64-Bit mode

#	movl $253, %ebx     # $64 is direct adressing mode and loads
	movq $64, %rdi      # the value 64 into registr %rdi
			    #
			    # rdi - register destinateion index
			    #
			    # This is the status number, we will
			    # return to the operating system.
                            # In 64-Bit the exit number can be 1 Byte.
                            # We can therefore choose a number between
			    # 0 and 255.
    


#	int $0x80           # This wakes up the kernel to run the 
	syscall	            # exit command.

#syscall  depends on what number is in %rax 
