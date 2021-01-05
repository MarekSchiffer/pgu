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

#Changes for 64-Bit:





# Everything in the main program is stored in registers, 
# so the data section doesn't have anything.
.section .data

.section .text

.global _start

_start:
	pushq $3		      # First we push the power on the stack
	pushq $2		      # no the base
	call power		      # Here we call power, This does two things.
			              # 1. Push return address on the stack 2. Change eip to
				      # first beginning of power funciton

	addq $16, %rsp                 # move the stack pointer two values down so 3 and 2 will
				      # be overwritten

	pushq %rax		      # pushes the result %eax onto the stack to save it.

	pushq $2		      # Same as above for 5^2
	pushq $5
	call power
	addq $16, %rsp
	
	popq %rdi                     # Get the result from 2^3 from the stack intro %ebx
	
	addq %rax, %rdi               # add 2^3 and 5^2. Result is in %ebx

	movq $60, %rax
	syscall

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
	pushq %rbp                     # The base pointer goes on the stack
	movq  %rsp, %rbp               # The base pointer gets replaced by the stack pointer
	subq  $8, %rsp		       # Substract 4 from the stack pointer

	movq 16(%rbp), %rbx             # Before the function is called, the power and then the 
	movq 24(%rbp), %rcx            # base are pushed on the stack. Now we load the base in %ebx
				       # and power in %ebx
	movq %rbx, -8(%rbp)

#Stack at this point:
#     power 3           12(%ebp) = %ecx
#  ^  base  2            8(%ebp) = %ebx
#  |  Return Address    Invisible added by  call.
#  |  ebp (Backup)	 <-ebp
#  |  %ebx               <-esp
#    
power_loop_start:

	cmpq $1, %rcx                  # End loop if power is 1
	je end_power
	
	movq -8(%rbp), %rax            # move base from the stack intro %eax
	imulq %rbx, %rax               # multiply base with base ans put result in %eax.
	movq %rax, -8(%rbp)            # put new result on the stack
	decq %rcx		       # remove power by 1.
jmp power_loop_start                   # keep going untill power is 1
	cmpq $1, %rcx
	je end_power
	
	movq -8(%rbp), %rax
	imulq %rbx, %rax
	movq %rax, -8(%rbp)
	
	decq %rcx
	jmp power_loop_start

end_power:
	movq -8(%rbp), %rax            # move the result from the stack in %eax

	movq %rbp, %rsp                # move base pointer to stack pointer. %ebp never moved.
	popq %rbp                      # remove old Base pointer from stack, esp now points to return address.
	ret	                       # return  address to ip.

#Stack at this point:
#     power 3           12(%ebp) = %ecx
#  ^  base  2            8(%ebp) = %ebx
#  |  Return Address    Invisible added by call. <-esp
#  |                    <-ebp 
#  |  8

