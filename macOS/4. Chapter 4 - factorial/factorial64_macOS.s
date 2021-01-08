################################################################################
#                                                                              #
#              Programming From The Ground Up - Jonathan Bartlett              #
#                                 Page 66 - 68                                 #
#                     Typed in & Commented by Marek Schiffer                   #
#                                                                              #
#                                                                              #
################################################################################

# PURPOSE - Given a number, this program computes the 
#           factorial. For example, the factorial of
#
#           4!=4*3*2*1=24
#

# Changes for 64 Bit:
# 1.) All instruactions changed from long to quad, i.e. movl -> movq ...
# 2.) stackspace for instructions doubled.

# Changes for macOS:
# .section had to disapear
# .type factorial, @function had to go as well
# In the future we might use C function convention _factorial
# movl $60 is changed to $0x2000001 like before
#
#	
# This program shows, how to call a function recursively

.data

# This program has no gloaba data

.text

.global _start
#.global factorial # this is unneeded unless we want to share
		  # the function among other programs

_start:                        # 01
	pushq $4               # 02
	call factorial         # 03
	addq $8, %rsp          # 04
                               # 05
	movq %rax, %rdi        # 06
	movl $0x2000001, %eax  # 07
	syscall                # 08


# This is the acutal function definition

#.type factorial, @function    # 09

factorial:                     # 10	
	pushq %rbp             # 11         # Push ebp onto the stack
	movq %rsp, %rbp        # 12         # and copy esp to ebp
	movq 16(%rbp), %rax    # 13         # get the value into eax. 8, because of the return address.

	cmpq $1, %rax          # 14         # check for recusion anchor
	je end_factorial       # 15         # jump to end, if the anchor holds true

	decq %rax	       # 16 	    # (if not) decrease n to (n-1)
	pushq %rax             # 17         # push (n-1) onto the stack
	call factorial         # 18         # call factorial with (n-1). The return address is
                               # 19         # after the function call, here 19.          
	movq 16(%rbp), %rbx    # 20        
	imulq %rbx, %rax       # 21           

end_factorial:                 # 22
movq %rbp, %rsp                # 23         # This part will be executed for every function, after 
popq %rbp                      # 24         # they returned
ret                            # 25

#   Stack until second call of		       eax      ebp    ip
# 0100 4							02			
# 0200 return address (# 04 )					03
# 0300 Old %ebp (?)				4	300     11 
# 0400 3 (n-1)					3	   	17
# 0500 return address (# 19)			3		18
# 0600 Old %ebp (300)				3		11
# 0700 2 (n-2)					2	600	17	
# 0800 return address ( # 19 )			2		18
# 0900 Old %ebp (600)				2		18
# 1000 1 (n-3)					1	900	17
# 2000 return address ( # 19 )			1		18
# 3000 Old %ebp (900)    <-ebp <-esp		1		18
# 4000						1	3000    18


# we reached 1!
#
# ip= 23
# esp = ebp = 3000
# popl ebp => ebp = 900 &esp = 2000
# ret => esp = 1000 & ip = 19 & %eax = 1

#   Stack until second call of		       eax      ebp    ip
# 0100 4							02			
# 0200 return address (# 04 )					03
# 0300 Old %ebp (?)				4	        11 
# 0400 3 (n-1)					3	300	17
# 0500 return address (# 19)			3		18
# 0600 Old %ebp (300)				3		11
# 0700 2 (n-2)					2	600	17	
# 0800 return address ( # 19 )			2		18
# 0900 Old %ebp (600)	<- ebp			2		18
# 1000 1 (n-3)		<- esp			1		17	

# ebx = 2, imull %ebx, %eax => %eax=2    ip=21;
# esp = ebp = 900
# popl ebp => ebp =600 & esp = 800
# ret => esp = 700 & ip=19 & eax=2

#   Stack until second call of		       eax      ebp    ip
# 0100 4							02			
# 0200 return address (# 04 )					03
# 0300 Old %ebp (?)				4	        11 
# 0400 3 (n-1)					3	300	17
# 0500 return address (# 19)			3		18
# 0600 Old %ebp (300)		<- ebp		3		11
# 0700 2 (n-2)			<- esp		2	600	17	

# ebx = 3, imull %ebx, %eax => %eax=6    ip=21;
# esp = ebp = 600
# popl %ebp => %ebp = 300 & esp = 500 
# ret => esp= 400 % ip =19 & eax =6

#   Stack until second call of		       eax      ebp    ip
# 0100 4							02			
# 0200 return address (# 04 )					03
# 0300 Old %ebp (?)		<- ebp		4	        11 
# 0400 3 (n-1)			<- esp		3	300	17

# ebx = 4, imull %ebx, %eax => %eax=24    ip=21;
# ebp=esp=300
# popl ebp => ebp = 200; esp=400
# ret => esp = 300 & ip = 4 eax=24

#   Stack until second call of		       eax      ebp    ip
# 0100 4			<- esp				02			
# 0200				<- ebp				03

