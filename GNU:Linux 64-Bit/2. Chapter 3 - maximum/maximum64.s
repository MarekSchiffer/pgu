################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                      Typed in & Comments by Marek Schiffer                   #
#                                                                              #
#           Credit for 64-Bit Port: "realead" https://github.com/realead       #
#                                                                              #
################################################################################

#64bit version

# Changes compared to 32bit:
#
# 1. 4byte edi register -> 8byte rdi register, 
# 2. uses movq, incq and not movl, incl for 8byte long rdi register
# 3. rax value for interupt is 60 (not 1 as for 32bit)
# 4. edi holds the return status (not ebx as for 32bit)
# 5. int $0x080  -> syscall
# 


# Purpose: This program finds the maximum number of a 
#          set of number (data items).
#


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
# is bigger.

.section .data

# Notice a) data_items: has no .global option. Therefore it can only be used by this program
#        b) .long is 4 bytes, Therefore 2^{32}= 4 294 967 296 numbers can be stored.
#           other data types are .byte, .int, .ascii

# INDEXED ADDRESSING MODE:
# The most interesting thing here is the "Indexed Addressing Mode".
# First note:
# movl data_items, %eax is "Direct Addressing Mode", %eax holds the value (directly).
# movl $data_items, %eax would load the address of data_items into %eax "Immediate Mode".
#
# Final Address = BeginningAddress(%Base_or_Offset,%IndexRegister,WordSizes)
#
# data_items(,%edi,4), data_items is the address of the list. the 0 item is 3
# The Index Reigister will be calculated with %edi*4 and give back the value as in 
# the "Direct Addresing Mode"


# NOTE: 
# If a comparsion is made the %eflags register will have a bit set and the je, jle will use
# these bits. It's exactly as in J. Clark Scott - But How Do it know?

data_items:
 #.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
 .long 3,1,56,4,11,23,44,22,33,33,56,64,8,15,0

# .long is saves 32-Bit words, we therefore only use the 32-Bit parts of the registers.

.section .text

.global _start

_start:
	movq $0, %rdi			        # Fill %rdi (loop counter) with 0.
						# rdi is a 8 Byte register. Therefore we need movq
						# move quad word.
	movl data_items(,%edi,4), %eax		# This is the and "Indexed Addressing Mode"
	movl %eax, %ebx				# The first value is the largest, move it to %ebx

#Note we still work with eax and ebx, not the full rax and rbx, as we are using .long here.
	
start_loop:

	cmpl $0, %eax				# cmpl (compare long). Check if the current value is 0
	je loop_exit                            # if equal (je =^ jump equal) yes, jump to exit.

	incq %rdi				# increase loop counter. Again, rdi is now 8 Byte.
	movl data_items(,%edi,4), %eax		# Same as above, check above.
	cmpl %ebx, %eax
	jle start_loop				# jle =^ jump less equal. If the next item is smaller than jump.
	
	movl %eax, %ebx				# If the next item is larger, change %ebx.
jmp start_loop					# Wash, rinse, repeat.

loop_exit:					# Same as exit.s. %ebx will be the exit status and has to be 
	movq $60, %rax				# smaller than 255.
	movl %ebx, %edi				# For 64 Bit the syscal returns edi, therefore we move ebx to edi now	
	syscall
