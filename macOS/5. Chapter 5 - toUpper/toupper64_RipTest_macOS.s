# PURPOSE: This program vonverts an input file
#	   to an output file with all letters
#	   converted to uppercase
#
# PROCESSING: 1. Open the input file
#	      2. Open the output file
#	      3. While we're not at the end of the input file
#		 a. Read part of file syscallo our memory buffer
#		 b. go through each byte of memory
#		    if the byte is a lower-case letter,
#		    convert it to uppercase
#	         c. write the memory buffer to output file


# Changes for 64-Bit:
# eax,ebx, ecx, edx -> rax, rbx, rcx, rdx
# edi, esp, ebp -> rdi, rsp, rbp	
# movl, pushl, popl, subl, cmpl, addl, incl  -> movq, pushq, popq, subq, cmpq, addq, incq
# syscall -> syscall
# rax -> rdi for syscalls
# x80 exit -> 60
# Stack positions doubled, also in STACK SUFF 
# $4 in cleanup $8

.data

#TestText:	
#     .ascii "Write Motherfucker"
#len:
# .long . - TestText # string length

########## CONSTANTS ##########


# system call numbers:
.equ SYS_OPEN, 0x2000005		# 5 -> 2
.equ SYS_WRITE, 0x2000004		# 4 -> 1
.equ SYS_READ, 0x2000003		# 3 -> 0
.equ SYS_CLOSE, 0x2000006		# 6 -> 3
.equ SYS_EXIT, 0x2000001		# 1 -> 60

# options for open ( look at /usr/include/asm-generic/fcntl.h
# for various values. You can combine them by adding
# them or ORing them )
# This is discussed at greater length in "Counting Like a Computer"
# Thx for wrtiting this in the code...
.equ O_RDONLY,0x000 # 0xa02 # 0x0000   # 0 -> 64
.equ O_CREAT_WRONGLY_TRUNC, 0x201 # 0xa02 #0x00000400 # 03101 0x0400  

# /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk//usr/include/sys/fcntl.h

# standrard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# system call syscallerrupt ( 32-Bit )		# in 64-Bit we only call syscall
#.equ $LINUX_SYSCALL

.equ END_OF_FILE, 0    # This is the return value of read,
		       # which means we've hit the end of the file

.equ NUMBER_ARGUMENTS, 2

.bss
# Buffer - This is where the data is loaded syscallo from the data file
#	   and written from syscallo the output file. This should never
#          exceed 16,000 for various reasons.
#

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE     # Defines a local uninitialized block of storage. ( Pseudo opcode )
				    # We can now get the address of the start of the buffer with
				    # $BUFFER_DATA, and the elemnt with BUFFER_DATA.

.text

#STACK Positions					# Remeber, these are just constants.
.equ ST_SIZE_RESERVE, 16				# We'll reserve 16 bytes on the stack.
.equ ST_FD_IN, -8					# 0 to -8 for file descritor of the Inputfile	
.equ ST_FD_OUT, -16					# -8 to -16 for file descritor of the Outputfile	
.equ ST_ARGC, 24         # 0 Number of arguments		# C convention main(int argc, char *argv[])
.equ ST_ARGV_0, 32	# 8 Name of program		# int* - 8 bytes
.equ ST_ARGV_1, 40      # 16 Input file name		# char* - 8 bytes
.equ ST_ARGV_2, 48      # 24 Output file name

# Linux puts the pointers to the command line arguments automaically on the stack. 
# Remember in reverse order. The number of arguments is stored in %(rsp)
# The name of the program is stored at 8(%rsp), and the arguments from 16(%rsp) to 8*N+8(%rsp)

.global _start

_start:
#### INITIALZIE PROGRAM ####
# Save the stack posyscaller

#	xorq %rax, %rax
#	xorq %rbx, %rbx
#	xorq %rcx, %rcx
#	xorq %rdx, %rdx
#	xorq %rdi, %rdi
#	xorq %rsi, %rsi
	movq %rsp, %rbp						# We'll use the stack in the main function.

# Allocate space for our file descriptors on the stack

subq $ST_SIZE_RESERVE, %rsp					# We move the stack posyscaller 8 FOREWARD!
								# Remember, the Stack grows downwards
								# and the axis shows upwards.
				# At this posyscall %rsp=%rbp+8. The 

open_files:
open_fd_in:
#### OPEN INPUT FILES ####


# open syscall                               # (%rax SYS_OPEN, %rbx InputFile, %rcx Flag, %rdx Permisson)
movq $SYS_OPEN, %rax			     # Just a setup for the syscall.
movq ST_ARGV_1(%rbp), %rdi
movq $O_RDONLY, %rsi
movq $0666, %rdx
syscall

store_fd_in:
movq %rax, ST_FD_IN(%rbp)                     # ST_FD_IN is -8 => -8(%rbp). rbp was inilzilaized at the start
					      # directly above %rbp is the file discriptor for the Inputfile


open_fd_out:
#### OPEN OUTPUT FILE ####


movq $SYS_OPEN, %rax			     # Just a setup for the syscall.
movq ST_ARGV_2(%rbp), %rdi
#movq $0xa02, %rsi  
movq $O_CREAT_WRONGLY_TRUNC, %rsi  
movq $0666, %rdx
syscall

#movq %rax, %rdi
#leaq TestText(%rip), %r11
#movq %r11, %rsi
#movq len(%rip), %rdx    # Why movq here and not leaq ???
#movq $SYS_WRITE, %rax
#syscall 
#
store_fd_out:
movq %rax, ST_FD_OUT(%rbp)                    # See ST_FD_IN, file descpriptor for the Outfile lives two away 
					      # from rbp.
#movq $SYS_EXIT, %rax
#movq $76, %rdi
#syscall

#####################################################################################################
#	#### READ IN A BLOCK FORM THE INPUT FILE ####
#	movq $SYS_READ, %rax					# Again just a setup for the syscall 
#	#get the input file descriptor
#	movq ST_FD_IN(%rbp), %rdi   # rbx -> rdi
#	#the location to read syscallo
#	leaq BUFFER_DATA(%rip), %r10			# %rsi, has now the address of the Buffer start
#	movq %r10, %rsi
#	# the size of the buffer
#	leaq BUFFER_SIZE(%rip), %r11                    # %rdx, has now the address of Buffer size
#	movq %r11,%rdx
#	#Size of buffer read is returned syscallo %rax                   # rax has 32 bits = 4 bytes
#	syscall
#
#
#	movq $SYS_EXIT, %rax
#	movq $23, %rdi
#	syscall
#
#
#####################################################################################################
##### BEGIN MAIN LOOP ####
read_loop_begin:

	movq ST_FD_IN(%rbp), %rdi
	leaq BUFFER_DATA(%rip), %r10			# %rsi, has now the address of the Buffer start
	movq %r10, %rsi
	#movq BUFFER_SIZE(%rip), %rdx                   # %rdx, has now the address of Buffer size
	movq $500, %rdx                   # %rdx, has now the address of Buffer size
	movq $SYS_READ, %rax					# Again just a setup for the syscall 
	syscall

#movq $SYS_EXIT, %rax
#movq $23, %rdi
#syscall

	#### EXIT IF WE'VE RACHED THE END ####
	# check for the EOF marker

	cmpq $END_OF_FILE, %rax					# If %rax is 0 after the syscall, we
	# if found or on error, go the end                      # reached the end of the file
	jle end_loop						# is thath \0? What happens, if we put
								# 0 in the file? 0 in ASCII is 48.

continue_read_loop:

	#### CONVERT THE BLOCK TO UPPER CASE ####
	leaq BUFFER_DATA(%rip), %r11	# r11 has now the address of start of Buffer.
	pushq %r11

#	movq $SYS_EXIT, %rax
#	movq (%r11), %rdi
#	syscall

#	pushq $BUFFER_DATA		# location of buffer    $BUFFER_DATA is the element
	pushq %rax			# size of the buffer
	call convert_to_upper
	popq %rax			# get the size back
	addq $8, %rsp			# restore %rsp


	#### WRITE THE BLOCK OUT TO THE OUTPUT FILE ####
	# size of the buffer
	movq %rax, %rdx						# The return value is in %rax and is no moved
	movq $SYS_WRITE, %rax					# to %rdx, why not immediatly pop it to rdx?

	#file to use
	movq ST_FD_OUT(%rbp), %rdi  

	#loction of the buffer
	leaq BUFFER_DATA(%rip), %r10
	movq %r10, %rsi
#	movq $BUFFER_DATA, %rsi   # rcx -> rsi
	syscall 


	#### CONTINUE THE LOOP ####
	jmp read_loop_begin

end_loop:
#### CLOSE THE FILES ####
# Note - We don't need to do error checking on these,
#	 because error conditions don't signify anything
#        special here.

	movq $SYS_CLOSE, %rax
	movq ST_FD_OUT(%rbp), %rdi   # rbx -> rdi
	syscall 

	movq $SYS_CLOSE, %rax
	movq ST_FD_IN(%rbp), %rdi    # rbx -> rdi
	syscall

	#### EXIT ####
	movq $SYS_EXIT, %rax
	movq $41, %rdi
	syscall

# PURPOSE:	This function acutally does the conversion to
#		upper case for a block.
#
# INPUT:	The first parameter is the length of the block of
#		memory.
#
# Output:	This function overwrites the current
#		buffer with tue upper-casified version
#
# VARIABLES:
#		%rax - beginning of buffer
#		%rbx - length of buffer
#		%rcx - current buffer offset
#		%cl  - current byte being examined
#		       (first part of %(ecx)
#
#

#### CONSTANTS ####
# The lower boundary of our search
.equ LOWERCASE_A, 'a'					# Is 'a' translated to 97???
# The upper boundary of our search			# YES!
.equ LOWERCASE_Z, 'z'
# Conversion between upper and lower case
.equ UPPER_CONVERSION, 'A' - 'a'			# The - means actually minus !!!
							# The assembler does quite a bit for us here
							# should just be the vaule -32
#### STACK STUFF ####
.equ ST_BUFFER_LEN, 16	# Length of buffer
.equ ST_BUFFER, 24	# acutal buffer			# We have 4 bytes for the buffer from 12-8.
							# Therefore we add one character at a time.


convert_to_upper:
	pushq %rbp
	movq %rsp, %rbp

	#### SET UP VARAIBLES ####			# The buffer lives on the stackframe of the function
	movq ST_BUFFER(%rbp), %rax			# Buffer element
	movq ST_BUFFER_LEN(%rbp), %rbx			# Length of buffer

	movq $0, %rdi					# Initialize byte counter

	# if a buffer with zero length was given to us, just leave
	cmpq $0, %rbx
	je end_convert_loop


convert_loop:
	# get the current byte
	movb (%rax,%rdi,1), %cl		# The first element is 0, we start in %rax, byte for byte
					# and move it syscallo %cl, lower part of %ecl

	# go to the next byte unless it is between 'a' and 'z'
	cmpb $LOWERCASE_A, %cl                          # Assume 'a' is 97, the difference to lower letter
	jl next_byte					# is always 32. 'z' is 122. if the value in %cl
	cmpb $LOWERCASE_Z, %cl				# is in between 97 and 122, it is a lowercase letter.
	jg next_byte					# If it is not i.e. it is less than 97 and greater
							# than 122, it is not a lowercase letter and we jump
							# to next byte.
	# otherwise convert the byte to uppercase
	addb $UPPER_CONVERSION, %cl			# we should add 32 to any small letter to get the
	# and store it back				# capital letter.
	movb %cl, (%rax,%rdi,1)		# It goes back syscallo %rax.

next_byte:
	incq %rdi		# next byte
	cmpq %rdi, %rbx		# continue unless we've reached the end. (Lenght of buffer)

	jne convert_loop

end_convert_loop:
	# no return value, just leave
	movq %rbp, %rsp
	popq %rbp
	ret
