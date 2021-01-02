################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 31 - 33                                 #
#                      Typed in & Comments by Marek Schiffer                   #
#                                                                              #
#                                                                              #
################################################################################

# Purpose: This program finds the maximum number of a 
#          set of number (data items).
#
#         To assembly use
#         as -32 exit.s -o exit.o
#
#         For linking:
#         ld -m elf_i386 exit.o -o exit


# Variables: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# $eax - Current data item

# The following memory locatins are used:
# 
# data_items - contains the item data. A "0" is used
#              to terminate the data.

# The idea is simple, we fill the first number in %ebx. %edi is the loop
# counter, starting at 0. %ebx will constantly be updated, if the next value 
# is bigger. If not kkjj

.section .data

# Notice a) data_items: has no .global option. Therefore it can only be used by this program
#        b) .long is 4 bytes, Therefore 2^{32}= 4 294 967 296 numbers can be stored.
#           other data types are .byte, .int, .ascii

# INDEXED ADDRESSING MODE:
# The most interesting thing here is the "Indexed Addressing Mode"
# BeginningAddress (%Base_or_Offset,%IndexRegister,WordSizs)
#
# data_items(,%edi,4), data_items is the address of the list. the 0 item is 3
# The Index Reigistr will be calculated with %edi*4


# NOTE: 
# If a comparsion is made the %eflags register will have a bit set and the je, jle will use
# these bits. It's exactly as in J. Clark Scott - But How Do it know?

data_items:
 .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text

.global _start

_start:
	movl $0, %edi			        # Fill %edi (loop counter) with 0.
	movl data_items(,%edi,4), %eax		# This is the and "Indexed Addressing Mode"
	movl %eax, %ebx				# The first value is the largest, move it to %ebx

start_loop:

	cmpl $0, %eax				# cmpl (compare long). Check if the current value is 0
	je loop_exit                            # if equal (je =^ jump equal) yes, jump to exit.

	incl %edi				# increase loop counter. 
	movl data_items(,%edi,4), %eax		# Same as above, check above.
	cmpl %ebx, %eax
	jle start_loop				# jle =^ jump less equal. If the next item is smaller than jump.
	
	movl %eax, %ebx				# If the next item is larger, change %ebx.
jmp start_loop					# Wash, rinse, repeat.

loop_exit:					# Same as exit.s. %ebx will be the exit status and has to be 
	movl $1, %eax				# smaller than 255.
	int $0x80

