# Changes for macOS:
# 1. We start with the working function read-records64_macOS.s
# 2. Apply changes for 64-Bit from the book.
#
# record_buffer_ptr => record_buffer_ptr(%rip)
# leaq record_buffer(%rip), %r11 => movq record_buffer_ptr(%rip), %r11
# leaq record_buffer(%rip), %r11 => movq record_buffer_ptr(%rip), %rax
# addq $RECORD_FIRSTNAME, %r11 %% pushq %r11 => addq $RECORD_FIRSTNAME, %rax %% pushq %rax
#
# leaq record_buffer(%rip), %rsi => leaq record_buffer_ptr(%rip), %rsi
#
# pushq record_buffer_ptr => movq record_buffer_ptr(%rip), %r11 && pushq %r11


# Changes for macOS:
# linux64.s => macOS64.s
# .section .data => .data
# #movq $file_name, %rdi => leaq file_name(%rip), %rdi
# movq $0, %rsi	 => movq $0x000, %rsi
# leaq record_buffer(%rip), %r11 && addq $RECORD_FIRSTNAME, %r11 && pushq %r11
# pushq $record_buffer => leaq record_buffer(%rip), %r11 && pushq %r11
# pushq $RECORD_FIRSTNAME + record_buffer => leaq record_buffer(%rip), %r11
#                  && addq $RECORD_FIRSTNAME, %r11 && pushq %r11
# movq $RECORD_FIRSTNAME + record_buffer, %rsi => leaq record_buffer(%rip), %rsi
#       && addq $RECORD_FIRSTNAME, %rsi
#
# NOT changed, but file_name had to be before a a test wrtiting record1 before.
.include "../6. Chapter 6 - Records/macOS64.s"
.include "../6. Chapter 6 - Records/record-def.s"

.data
file_name:
 .ascii "OutputRecords.dat\0"

# The memory allocator will return a pointer to the memory,
# we can use. We store that pointer with record_buffer_ptr
record_buffer_ptr:
 .quad 0

.text
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

movq %rax, record_buffer_ptr(%rip)

# Open the file
movq $SYS_OPEN, %rax
leaq file_name(%rip), %rdi
movq $0x000, %rsi		# This says to open read-only
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
 movq record_buffer_ptr(%rip), %r11
 pushq %r11
 call read_record                 # This function is defined in read-write.s. Included
 addq $8, %rsp                    # via linker.

# Returns the number of bytes read. If it isn't the same number
# we requested, then it's either and end-of-file, or an error, so
# we're quitting
cmpq $RECORD_SIZE, %rax
jne finished_reading


# Otherwise, print out the first name but first we must know
# it's size
movq record_buffer_ptr(%rip), %rax
addq $RECORD_FIRSTNAME, %rax
pushq %rax			           # $RECORD_FIRSTNAME is the address,
				           # record_buffer is the address to the buffer
call count_chars                           # This function is definied in count-chars.s
addq $8, %rsp				   # included via linker
movq %rax, %rdx
movq ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
movq $SYS_WRITE, %rax
#leaq record_buffer_ptr(%rip), %rsi
movq record_buffer_ptr(%rip), %rsi
addq $RECORD_FIRSTNAME, %rsi
syscall

pushq ST_OUTPUT_DESCRIPTOR(%rbp)
call write_newline			   # Defined in write-newline.s.
addq $8, %rsp	                           # Included via linker

jmp record_read_loop

finished_reading:
# Here we deallocate (free) the memory we used by simply passing the pointer.
 movq record_buffer_ptr(%rip), %r11
 pushq %r11
 call deallocate

 movq $SYS_EXIT, %rax
 movq $0, %rdi
 syscall
