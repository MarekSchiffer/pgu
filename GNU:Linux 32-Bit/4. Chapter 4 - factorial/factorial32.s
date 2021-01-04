# PURPOSE - Given a number, this program computes the 
#           factorial. For example, the factorial of
#
#           4!=4*3*2*1=24
#

# This program shows, how to call a function recursively

.section .data

# This program has no gloaba data

.section .text

.global _start
.global factorial # this is unneeded unless we want to share
		  # the function among other programs

_start:
	pushl $4
	call factorial
;	addl $4, %esp
 
	movl %eax, %ebx
	movl $1, %eax
	int $0x80



# This is the acutal function definition

.type factorial, @function

factorial:
	pushl %ebp                      # Push ebp onto the stack
;	movl %esp, %ebp                 # and copy esp to ebp
	movl 8(%ebp), %eax              # get the value into eax. 8, because of the return address.

	cmpl $1, %eax                   # check for recusion anchor
	je end_factorial                # jump to end, if the anchor holds true

	decl %eax			# (if not) decrease n to (n-1)
	pushl %eax                      # push (n-1) onto the stack
	call factorial                  # call factorial with (n-1)

	movl 8(%ebp), %ebx
	imull %ebx, %eax

end_factorial:
;movl %ebp, %esp
;movl %esp, %ebp
popl %ebp
ret

# Stack until second call of f	       eax      ebp    ip
# 00 4							
# 01 return address (1 -> 01)			
# 02 Old %ebp (1)			4
# 03 3 (n-1)				3	
# 04 return address (2 -> 04)
# 05 Old %ebp (2)			2
# 06 2 (n-2)				
# 07 return address (3 -> 07)
# 08 Old %ebp (3)			1
# 09 1 (n-3)				
# 10 return address (4 -> 10)
# 11 Old %epb (4)    <-ebp <-esp        1


# we reached 1!

# Stack until second call of f	       eax      ebp    ip
# 00 4							
# 01 return address (1 -> 01)			
# 02 Old %ebp (1)			4
# 03 3 (n-1)				3	
# 04 return address (2 -> 04)
# 05 Old %ebp (2)			2
# 06 2 (n-2)				
# 07 return address (3 -> 07)
# 08 Old %ebp (3)			1
# 09 1 (n-3)				
# 10 return address (4 -> 10)
# 11 Old %epb (4)    <-ebp <-esp
