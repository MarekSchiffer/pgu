################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                      Typed in & Comments by Marek Schiffer                   #
#                                                                              #
#           Credit for 64-Bit Port: "realead" https://github.com/realead       #
#                                                                              #
################################################################################


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

# Changes to 32-Bit:
# eXX Registers are 4 Byte or 32-Bit and cahnge to 8 Byte or 64 Bit rXX registers.
# movq (move Quadword) is used for 64 Bit registers
# Value 60 in %Aax is used for exit interupt
# rdi (register destination index) holds the return status
# syscall


# Changes to GNU/Linux 64-Bit
# .section data, .section text  =>  .data, .text
# system call $60  => 0x2000001 for macOS kernel.

#Purpose: Simple program that exits and returns a
#	  status code back to the macOS kernel
#
#         To assembly use
#	  as -arch x86_64 exit64_macOS.s -o exit64_macOS.o
#
#         For linking:
#	  ld -static -e _start exit64_macOS.o -o exit64_macOS
#	  Needed for Chapter 8:
#         ld -macosx_version_min 11.0 -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem -e _start exit64_macOS.o -o exit64_macOS	

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
# .data will later contain data.
#
# NOTE: on macOS the .section part is removed.

.data


# The section .text is, where the program instructions live.
.text

# _start is a symbol, it will be replaced during assembly or linking.
# Symbols are used to mark locations or data of programs.
#
# .global means, the assembler shouldn't discard the symbol, but
# leave it for the linker.
.global _start

# Notice the : _start: is a a "label". A label is a symbol with the colon
_start:
	movq $0x2000001, %rax	 # The syscalls in macOS can be optained from
				 # syscall.h, located

# The explantaion for 0x200000 is given in syscall_sw.h, located at
# [...]/Frameworks/Kernel.framework/Versions/A/Headers/mach/arm/syscall_sw.h
# Quoting "lzana" https://stackoverflow.com/questions/48845697/macos-64-bit-system-call-table

	movq $64, %rdi      # the value 64 into registr %rdi
			    # This is the status number, we will
			    # return to the operating system.
                            # The number is elm [0,255]    

	syscall	            # exit command.

# As in the 64-Bit version of GNU/Linux.
