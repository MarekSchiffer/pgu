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
# movq, pushq, popq, subl, cmpl, addl, incl  -> movq, pushq, popq
# syscall -> syscall
# rax -> rdi for syscalls
# x80 exit -> 60
# Stack positions doubled, also in STACK SUFF 
# $4 in cleanup $8

.section .data

########## CONSTANTS ##########

# system call numbers:
.equ SYS_OPEN, 2		# 5 -> 2
.equ SYS_WRITE, 1		# 4 -> 1
.equ SYS_READ, 0		# 3 -> 0
.equ SYS_CLOSE, 3		# 6 -> 3
.equ SYS_EXIT, 60		# 1 -> 60

# options for open ( look at /usr/include/asm/fcntl.h
# for various values. You can combine them by adding
# them or ORing them )
# This is discussed at greater length in "Counting Like a Computer"
# Thx for wrtiting this in the code...
.equ O_RDONLY, 0   # 0 -> 64
.equ O_CREAT_WRONGLY_TRUNC, 03101	# 00001000 -> 03101

# standrard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# system call syscallerrupt ( 32-Bit )		# in 64-Bit we only call syscall
#.equ $LINUX_SYSCALL

.equ END_OF_FILE, 0    # This is the return value of read,
		       # which means we've hit the end of the file

.equ NUMBER_ARGUMENTS, 2

.section .bss
# Buffer - This is where the data is loaded syscallo from the data file
#	   and written from syscallo the output file. This should never
#          exceed 16,000 for various reasons.
#

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE     # Defines a local uninitialized block of storage. ( Pseudo opcode )
				    # We can now get the address of the start of the buffer with
				    # $BUFFER_DATA, and the elemnt with BUFFER_DATA <- TO CHECK

.section .text

#STACK Positions					# Remeber, these are just constants.
.equ ST_SIZE_RESERVE, 16					# We'll reserve 8 bytes on the stack.
.equ ST_FD_IN, -8					# -4 to 0 for file descritor of the Inputfile	
.equ ST_FD_OUT, -16					# -8 to -4 for file descritor of the Outputfile	
.equ ST_ARGC, 0         # Number of arguments		# C convention main(syscall argc, char *argv[])
.equ ST_ARGV_0, 8	# Name of program		# syscall - 4 bytes
.equ ST_ARGV_1, 16       # Input file name		# char - 4 bytes
.equ ST_ARGV_2, 24      # Output file name

# Linux puts the posyscallers to the command line arguments automaically on the stack. 
# Remember in reverse order. The number of arguments is stored in %(rsp)
# The name of the program is stored at 4(%rsp), and the arguments from 8(%rsp) to 4*N+4(%rsp)

.global _start

_start:
#### INITIALZIE PROGRAM ####
# Save the stack posyscaller

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
# input filename syscallo %rbx
movq ST_ARGV_1(%rbp), %rdi      # rbx -> rdi
# read-only flag
movq $O_RDONLY, %rsi		 #rcx -> rsi
# This doesn't really matter for reading
movq $0666, %rdx
# call linux
syscall

store_fd_in:
# Save the given file descriptor
movq %rax, ST_FD_IN(%rbp)                     # ST_FD_IN is -4 => -4(%rbp). rbp was inilzilaized at the start
					      # directly above %rbp is the file discriptor for the Inputfile


open_fd_out:
#### OPEN OUTPUT FILE ####


# open the file				     # (%rax SYS_OPEN, %rbx OutputFile, %rcx Flag, %rdx Permisson)
movq $SYS_OPEN, %rax			     # Just a setup for the syscall.
# output filename syscallo %rbx
movq ST_ARGV_2(%rbp), %rdi	# rbx -> rdi
# flags for writing to the file
movq $O_CREAT_WRONGLY_TRUNC, %rsi  # rcx -> rsi 
#permission set for new file ( if it's created )
movq $0666, %rdx
#call linux
syscall

store_fd_out:
# store file descriptor here
movq %rax, ST_FD_OUT(%rbp)                    # See ST_FD_IN, file descpriptor for the Outfile lives two away 
					      # from rbp.

#### BEGIN MAIN LOOP ####
read_loop_begin:

	#### READ IN A BLOCK FORM THE INPUT FILE ####
	movq $SYS_READ, %rax					# Again just a setup for the syscall 
	#get the input file descriptor
	movq ST_FD_IN(%rbp), %rdi   # rbx -> rdi
	#the location to read syscallo
	movq $BUFFER_DATA, %rsi     # rcx -> rsi
	# the size of the buffer
	movq $BUFFER_SIZE, %rdx
	#Size of buffer read is returned syscallo %rax                   # rax has 32 bits = 4 bytes
	syscall


	#### EXIT IF WE'VE RACHED THE END ####
	# check for the EOF marker
	cmpq $END_OF_FILE, %rax					# If %rax is 0 after the syscall, we
	# if found or on error, go the end                      # reached the end of the file
	jle end_loop						# is thath \0? What happens, if we put
								# 0 in the file? 0 in ASCII is 48.

continue_read_loop:

	#### CONVERT THE BLOCK TO UPPER CASE ####
	pushq $BUFFER_DATA		# location of buffer    $BUFFER_DATA is the element
	pushq %rax			# size of the buffer
	call convert_to_upper
	popq %rax			# get the size back
	addq $8, %rsp			# restore %rsp


	#### WRITE THE BLOCK OUT TO THE OUTPUT FILE ####
	# size of the buffer
	movq %rax, %rdx						# The return value is in %rax and is no moved
	movq $SYS_WRITE, %rax					# to %rdx, why not immrdiatly pop it to rdx?

	#file to use
	movq ST_FD_OUT(%rbp), %rdi  # rbx -> rdi

	#loction of the buffer
	movq $BUFFER_DATA, %rsi   # rcx -> rsi
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
	movq $0, %rdi
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
#		       (first part of %(rcx)
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
