################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 19 - 20                                 #
#                      Typed in & Comments by Marek Schiffer                   #
#                                                                              #
#           Credit for 64-Bit Port: "realead" https://github.com/realead       #
#                                                                              #
################################################################################

# Changes in 64-Bit Version 2
# We use the whole 64 Bit registers.
# Changes all eXX registers to rXX and l-instructions to q-instructions.

#changes compared to 32bit:
#
# 1. 4byte edi register -> 8byte rdi register
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
# %rdi - Holds the index of the data item being examined
# %rbx - Largest data item found
# $rax - Current data item

# The following memory locatins are used:
# 
# data_items - contains the item data. A "0" is used
#              to terminate the data.

# The idea is simple, we fill the first number in %rbx. %edi is the loop
# counter, starting at 0. %rbx will constantly be updated, if the next value 
# is bigger. If not

.section .data

# Notice a) data_items: has no .global option. Therefore it can only be used by this program
#        b) .long is 4 bytes, Therefore 2^{32}= 4 294 967 296 numbers can be stored.
#           other data types are .byte, .int, .ascii

# INDEXED ADDRESSING MODE:
# The most interesting thing here is the "Indexed Addressing Mode".
# First note:
# movl data_items, %rax is "Direct Addressing Mode", %rax holds the value (directly).
# movl $data_items, %rax would load the address of data_items into %rax "Immediate Mode".
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
 .quad 3,1,56,4,11,23,44,22,33,33,56,64,232,8,15,0
# .quad saves 64-Bit values.

.section .text

.global _start

_start:
	movq $0, %rdi			        # Fill %rdi (loop counter) with 0.
						# rdi is a 8 Byte register. Therefore we need movq
						# move quad word
	movq data_items(,%rdi,8), %rax		# This is the and "Indexed Addressing Mode" (s.a)
						#
						# We are now moving in steps of 8 Bytes foreward.
						#
	movq %rax, %rbx				# The first value is the largest, move it to %rbx

# We now work with rax and rbx, since we are working with .quad
	
start_loop:

	cmpq $0, %rax				# cmpl (compare long). Check if the current value is 0
	je loop_exit                            # if equal (je =^ jump equal) yes, jump to exit.

	incq %rdi				# increase loop counter. 
	movq data_items(,%rdi,8), %rax		# Same as above, check above.
	cmpq %rbx, %rax
	jle start_loop				# jle =^ jump less equal. If the next item is smaller than jump.
	
	movq %rax, %rbx				# If the next item is larger, change %ebx.
jmp start_loop					# Wash, rinse, repeat.

loop_exit:					# Same as exit.s. %ebx will be the exit status and has to be 
	movq $60, %rax				# smaller than 255.
	movq %rbx, %rdi				# For 64 Bit the syscal returns edi, therefore we move ebx to edi now	
	syscall
