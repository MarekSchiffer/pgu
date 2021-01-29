# Changes for 64-Bit:
# We started from the 64-Bit version of read-records64.s
# eXX => rXX
# movl, add, push =>
# %rcs => %rsi

.include "../6.\ Chapter\ 6\ -\ Records/linux64.s"
.include "../6.\ Chapter\ 6\ -\ Records/record-def.s"

.section .data
file_name:
 .ascii "OutputRecords.dat\0"

# The memory allocator will return a pointer to the memory,
# we cann use.
record_buffer_ptr:
 .quad 0

.section .text
# Main program
.global _start

_start:
# These are the locations on the stack where we will store the
# input and output descriptors (FYI - we could have used memory
# addresses in a .data section instead). Thx for the hint man!
.equ ST_INPUT_DESCRIPTOR, -8
.equ ST_OUTPUT_DESCRIPTOR, -16

# Copy the stack pointer to %rbp
movq %rsp, %rbp
# Allocate space to hold the file descriptors
subq $16, %rsp

# Use our memory allocator. At this point no memory heap_begin and
# heap_current are both at the same point.
call allocate_init 

# We're now requesting memory and get back a pointer to the
# address we can use.
pushq $RECORD_SIZE
call allocate
movq %rax, record_buffer_ptr


# Open the file
movq $SYS_OPEN, %rax
movq $file_name, %rdi
movq $0, %rsi		# This says to open read-only
movq $0666, %rdx
syscall

# Save file descriptor

movq %rax, ST_INPUT_DESCRIPTOR(%rbp)

# Even though it's a constant, we are saving the output file
# descriptor in a local variable so that if we later decide that
# it isn't always going to be STDOUT, we can change it easily.
movq $STDOUT, ST_OUTPUT_DESCRIPTOR(%rbp)


record_read_loop:
 pushq ST_INPUT_DESCRIPTOR(%rbp)
 pushq record_buffer_ptr
 call read_record                 # This function is defined in read-write.s. Included
 addq $8, %rsp                    # via linker.

# Returns the number of bytes read. If it isn't the same number
# we requested, then it's either and end-of-file, or an error, so
# we're quitting
cmpq $RECORD_SIZE, %rax
jne finished_reading


# Otherwise, print out the first name but first we must know
# it's size
 movq record_buffer_ptr, %rax	           # record_buffer_ptr is the address and 
 addq $RECORD_FIRSTNAME, %rax	           # $RECORD_FIRSTNAME is the number 0 we add.

pushq %rax
call count_chars                           # This function is definied in count-chars.s
addq $8, %rsp				   # included via linker
movq %rax, %rdx
movq ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
movq $SYS_WRITE, %rax
# We can only add in registers. We already did it on macOS.
# We add the number of $RECORD_FIRSTNAME to the address.
movq record_buffer_ptr, %rsi
addq $RECORD_FIRSTNAME, %rsi
syscall

pushq ST_OUTPUT_DESCRIPTOR(%rbp)
call write_newline			   # Defined in write-newline.s. 
addq $8, %rsp	                           # Included via linker

jmp record_read_loop

finished_reading:
 # Here we deallocate (free) the memory we used by simply passing the pointer.
 pushq record_buffer_ptr
 call deallocate

 movq $SYS_EXIT, %rax
 movq $0, %rdi
 syscall
