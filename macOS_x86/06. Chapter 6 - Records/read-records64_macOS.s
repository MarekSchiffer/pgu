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

.include "macOS64.s"
.include "record-def.s"

.data
file_name:
 .ascii "OutputRecords.dat\0"

.bss
.lcomm record_buffer, RECORD_SIZE         # RECORD_SIZE is definied in record-def.s

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
 leaq record_buffer(%rip), %r11 
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
leaq record_buffer(%rip), %r11
//addq $RECORD_FIRSTNAME, %r11
addq $RECORD_LASTNAME, %r11
//addq $RECORD_ADDRESS, %r11
pushq %r11			           # $RECORD_FIRSTNAME is the address,
				           # record_buffer is the address to the buffer 
call count_chars                           # This function is definied in count-chars.s
addq $8, %rsp				   # included via linker
movq %rax, %rdx
movq ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
movq $SYS_WRITE, %rax
leaq record_buffer(%rip), %rsi
//addq $RECORD_FIRSTNAME, %rsi
addq $RECORD_LASTNAME, %rsi
//addq $RECORD_ADDRESS, %rsi
syscall

pushq ST_OUTPUT_DESCRIPTOR(%rbp)
call write_newline			   # Defined in write-newline.s. 
addq $8, %rsp	                           # Included via linker

jmp record_read_loop

finished_reading:
 movq $SYS_EXIT, %rax
 movq $0, %rdi
 syscall
