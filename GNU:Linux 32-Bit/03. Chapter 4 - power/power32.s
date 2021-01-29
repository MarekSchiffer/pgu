################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 60 - 62                                 #
#                     Typed in & Commented by Marek Schiffer                   #
#                                                                              #
#                                                                              #
################################################################################

# PURPOSE: Program to illustrate how functions work
#          This program will compute the value of
#          2^3 + 5^2
#

# Everything in the main program is stored in registers, 
# so the data section doesn't have anything.
.section .data

.section .text

.global _start

_start:
	pushl $3		      # First we push the power on the stack
	pushl $2		      # no the base
	call power		      # Here we call power, This does two things.
			              # 1. Push return address on the stack 2. Change eip to
				      # first beginning of power funciton

	addl $8, %esp                 # move the stack pointer two values down so 3 and 2 will
				      # be overwritten

	pushl %eax		      # pushes the result %eax onto the stack to save it.

	pushl $2		      # Same as above for 5^2
	pushl $5
	call power
	addl $8, %esp
	
	popl %ebx                     # Get the result from 2^3 from the stack intro %ebx
	
	addl %eax, %ebx               # add 2^3 and 5^2. Result is in %ebx

	movl $1, %eax
	int $0x80

# PURPOSE: The function is used to compute
#          the value of a number raiset to
#          a power
#
# INPUT: First argument - the base number
#	 Second argument - the power to raise it to
#
# OUTPUT: Will give the result as a return value
#
# NOTES: The power must be 1 or greater
# 
# VARIABLES: 
#             %ebx - holds the base number
#             %ecx - holds the power
#
#             -4(%ebp) - holds the current result
#             %eax is used for temporary storage 
#

.type power, @function
power:
	pushl %ebp                     # The base pointer goes on the stack
	movl  %esp, %ebp               # The base pointer gets replaced by the stack pointer
	subl  $4, %esp		       # Substract 4 from the stack pointer

	movl 8(%ebp), %ebx             # Before the function is called, the power and then the 
	movl 12(%ebp), %ecx            # base are pushed on the stack. Now we load the base in %ebx
				       # and power in %ebx
	movl %ebx, -4(%ebp)

#Stack at this point:
#     power 3           12(%ebp) = %ecx
#  ^  base  2            8(%ebp) = %ebx
#  |  Return Address    Invisible added by  call.
#  |  ebp (Backup)	 <-ebp
#  |  %ebx               <-esp
#    
power_loop_start:

	cmpl $1, %ecx                  # End loop if power is 1
	je end_power
	
	movl -4(%ebp), %eax            # move base from the stack intro %eax
	imull %ebx, %eax               # multiply base with base and put result in %eax.
	movl %eax, -4(%ebp)            # put new result on the stack
	decl %ecx		       # remove power by 1.
jmp power_loop_start                   # keep going until power is 1
	cmpl $1, %ecx
	je end_power
	
	movl -4(%ebp), %eax
	imull %ebx, %eax
	movl %eax, -4(%ebp)
	
	decl %ecx
	jmp power_loop_start

end_power:
	movl -4(%ebp), %eax            # move the result from the stack in %eax

	movl %ebp, %esp                # move base pointer to stack pointer. %ebp never moved.
	popl %ebp                      # remove old Base pointer from stack, esp now points to return address.
	ret	                       # return  address to ip.

#Stack at this point:
#     power 3           12(%ebp) = %ecx
#  ^  base  2            8(%ebp) = %ebx
#  |  Return Address    Invisible added by call. <-esp
#  |                    <-ebp 
#  |  8

