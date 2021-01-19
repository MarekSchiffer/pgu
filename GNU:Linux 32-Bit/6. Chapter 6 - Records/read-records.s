.include "linux32.s"
.include "record-def.s"

.section .data
file_name:
 .ascii "OutputRecords.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE         # RECORD_SIZE is definied in record-def.s


.section .text
# Main program
.global _start

_start:
# These are the locations on the stack where we will store the
# input and output descriptors (FYI - we could have used memory
# addresses in a .data section instead). Thx for the hint man!
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

# Copy the stack pointer to %ebp
movl %esp, %ebp
# Allocate space to hold the file descriptors
subl $8, %esp

# Open the file
movl $SYS_OPEN, %eax
movl $file_name, %ebx
movl $0, %ecx		# This says to open read-only
movl $0666, %edx
int $LINUX_SYSCALL

# Save file descriptor

movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

# Even though it's a constant, we are saving the output file
# descriptor in a local variable so that if we later decide that
# it isn't always going to be STDOUT, we can change it easily.
movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)


record_read_loop:
 pushl ST_INPUT_DESCRIPTOR(%ebp)
 pushl $record_buffer
 call read_record                 # This function is defined in read-write.s. Included
 addl $8, %esp                    # via linker.

# Returns the number of bytes read. If it isn't the same number
# we requested, then it's either and end-of-file, or an error, so
# we're quitting
cmpl $RECORD_SIZE, %eax
jne finished_reading


# Otherwise, print out the first name but first we must know
# it's size
pushl $RECORD_FIRSTNAME + record_buffer    # $RECORD_FIRSTNAME ist the address,
				           # record_buffer is the address to the buffer 
call count_chars                           # This function is definied in count-chars.s
addl $4, %esp				   # included via linker
movl %eax, %edx
movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
movl $SYS_WRITE, %eax
movl $RECORD_FIRSTNAME + record_buffer, %ecx
int $LINUX_SYSCALL

pushl ST_OUTPUT_DESCRIPTOR(%ebp)
call write_newline			   # Defined in write-newline.s. 
addl $4, %esp	                           # Included via linker

jmp record_read_loop

finished_reading:
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL
