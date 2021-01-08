# PURPOSE: This program vonverts an input file
#	   to an output file with all letters
#	   converted to uppercase
#
# PROCESSING: 1. Open the input file
#	      2. Open the output file
#	      3. While we're not at the end of the input file
#		 a. Read part of file into our memory buffer
#		 b. go through each byte of memory
#		    if the byte is a lower-case letter,
#		    convert it to uppercase
#	         c. write the memory buffer to output file

.section .data

########## CONSTANTS ##########

# system call numbers:
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# options for open ( look at /usr/include/asm/fcntl.h
# for various values. You can combine them by adding
# them or ORing them )
# This is discussed at greater length in "Counting Like a Computer"
# Thx for wrtiting this in the code...
.equ O_RDONLY, 0
.equ O_CREAT_WRONGLY_TRUNC, 03101

# standrard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# system call interrupt ( 32-Bit )
.equ LINUX_SYSCALL, 0x80

.equ END_OF_FILE, 0    # This is the return value of read,
		       # which means we've hit the end of the file

.equ NUMBER_ARGUMENTS, 2

.section .bss
# Buffer - This is where the data is loaded into from the data file
#	   and written from into the output file. This should never
#          exceed 16,000 for various reasons.
#

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE     # Defines a local uninitialized block of storage. ( Pseudo opcode )
				    # We can now get the address of the start of the buffer with
				    # $BUFFER_DATA, and the elemnt with BUFFER_DATA <- TO CHECK

.section .text

#STACK Positions					# Remeber, these are just constants.
.equ ST_SIZE_RESERVE, 8					# We'll reserve 8 bytes on the stack.
.equ ST_FD_IN, -4					# -4 to 0 for file descritor of the Inputfile	
.equ ST_FD_OUT, -8					# -8 to -4 for file descritor of the Outputfile	
.equ ST_ARGC, 0         # Number of arguments		# C convention main(int argc, char *argv[])
.equ ST_ARGV_0, 4	# Name of program		# int - 4 bytes
.equ ST_ARGV_1, 8       # Input file name		# char - 4 bytes
.equ ST_ARGV_2, 12      # Output file name

# Linux puts the pointers to the command line arguments automaically on the stack. 
# Remember in reverse order. The number of arguments is stored in %(esp)
# The name of the program is stored at 4(%esp), and the arguments from 8(%esp) to 4*N+4(%esp)

.global _start

_start:
#### INITIALZIE PROGRAM ####
# Save the stack pointer

	movl %esp, %ebp						# We'll use the stack in the main function.

# Allocate space for our file descriptors on the stack

subl $ST_SIZE_RESERVE, %esp					# We move the stack pointer 8 FOREWARD!
								# Remember, the Stack grows downwards
								# and the axis shows upwards.
				# At this point %esp=%ebp+8. The 

open_files:
open_fd_in:
#### OPEN INPUT FILES ####


# open syscall                               # (%eax SYS_OPEN, %ebx InputFile, %ecx Flag, %edx Permisson)
movl $SYS_OPEN, %eax			     # Just a setup for the syscall.
# input filename into %ebx
movl ST_ARGV_1(%ebp), %ebx
# read-only flag
movl $O_RDONLY, %ecx
# This doesn't really matter for reading
movl $0666, %edx
# call linux
int $LINUX_SYSCALL

store_fd_in:
# Save the given file descriptor
movl %eax, ST_FD_IN(%ebp)                     # ST_FD_IN is -4 => -4(%ebp). ebp was inilzilaized at the start
					      # directly above %ebp is the file discriptor for the Inputfile


open_fd_out:
#### OPEN OUTPUT FILE ####


# open the file				     # (%eax SYS_OPEN, %ebx OutputFile, %ecx Flag, %edx Permisson)
movl $SYS_OPEN, %eax			     # Just a setup for the syscall.
# output filename into %ebx
movl ST_ARGV_2(%ebp), %ebx
# flags for writing to the file
movl $O_CREAT_WRONGLY_TRUNC, %ecx
#permission set for new file ( if it's created )
movl $0666, %edx
#call linux
int $LINUX_SYSCALL

store_fd_out:
# store file descriptor here
movl %eax, ST_FD_OUT(%ebp)                    # See ST_FD_IN, file descpriptor for the Outfile lives two away 
					      # from ebp.

#### BEGIN MAIN LOOP ####
read_loop_begin:

	#### READ IN A BLOCK FORM THE INPUT FILE ####
	movl $SYS_READ, %eax					# Again just a setup for the syscall 
	#get the input file descriptor
	movl ST_FD_IN(%ebp), %ebx
	#the location to read into
	movl $BUFFER_DATA, %ecx
	# the size of the buffer
	movl $BUFFER_SIZE, %edx
	#Size of buffer read is returned into %eax                   # eax has 32 bits = 4 bytes
	int $LINUX_SYSCALL


	#### EXIT IF WE'VE RACHED THE END ####
	# check for the EOF marker
	cmpl $END_OF_FILE, %eax					# If %eax is 0 after the syscall, we
	# if found or on error, go the end                      # reached the end of the file
	jle end_loop						# is thath \0? What happens, if we put
								# 0 in the file? 0 in ASCII is 48.

continue_read_loop:

	#### CONVERT THE BLOCK TO UPPER CASE ####
	pushl $BUFFER_DATA		# location of buffer    $BUFFER_DATA is the element
	pushl %eax			# size of the buffer
	call convert_to_upper
	popl %eax			# get the size back
	addl $4, %esp			# restore %esp


	#### WRITE THE BLOCK OUT TO THE OUTPUT FILE ####
	# size of the buffer
	movl %eax, %edx						# The return value is in %eax and is no moved
	movl $SYS_WRITE, %eax					# to %edx, why not immediatly pop it to edx?

	#file to use
	movl ST_FD_OUT(%ebp), %ebx

	#loction of the buffer
	movl $BUFFER_DATA, %ecx
	int $LINUX_SYSCALL

	#### CONTINUE THE LOOP ####
	jmp read_loop_begin

end_loop:
#### CLOSE THE FILES ####
# Note - We don't need to do error checking on these,
#	 because error conditions don't signify anything
#        special here.

	movl $SYS_CLOSE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_CLOSE, %eax
	movl ST_FD_IN(%ebp), %ebx
	int $LINUX_SYSCALL

	#### EXIT ####
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

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
#		%eax - beginning of buffer
#		%ebx - length of buffer
#		%ecx - current buffer offset
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
.equ ST_BUFFER_LEN, 8	# Length of buffer
.equ ST_BUFFER, 12	# acutal buffer			# We have 4 bytes for the buffer from 12-8.
							# Therefore we add one character at a time.


convert_to_upper:
	pushl %ebp
	movl %esp, %ebp

	#### SET UP VARAIBLES ####			# The buffer lives on the stackframe of the function
	movl ST_BUFFER(%ebp), %eax			# Buffer element
	movl ST_BUFFER_LEN(%ebp), %ebx			# Length of buffer

	movl $0, %edi					# Initialize byte counter

	# if a buffer with zero length was given to us, just leave
	cmpl $0, %ebx
	je end_convert_loop


convert_loop:
	# get the current byte
	movb (%eax,%edi,1), %cl		# The first element is 0, we start in %eax, byte for byte
					# and move it into %cl, lower part of %ecl

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
	movb %cl, (%eax,%edi,1)		# It goes back into %eax.

next_byte:
	incl %edi		# next byte
	cmpl %edi, %ebx		# continue unless we've reached the end. (Lenght of buffer)

	jne convert_loop

end_convert_loop:
	# no return value, just leave
	movl %ebp, %esp
	popl %ebp
	ret
