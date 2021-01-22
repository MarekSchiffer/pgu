# Changes for macOS:
# linux64.s => macOS64.s
# Copied working add-year64_macOS parts here
# movq $0, %rsi => movq $0x201, %rsi
# .section .data/.text => .data/.text
#
# movq $input_file_name, %rdi => leaq input_file_name(%rip), %rdi
# pushq $no_open_file_msg => leaq no_open_file_msg(%rip), %r11 &&  pushq %r11
# pushq $no_open_file_code => leaq no_open_file_code(%rip), %r11 && pushq %r11
# movq $0, %rsi => movq $0x000, %rsi
#
# From lldb, the file descriptors have always been greater than 3.
# Not confirmed by any documentation.
# cmpq $0, %rax => cmpq $3, %rax             



# Changes for 64 Bit:
# linux32.s => linux64.s
# Copied 64 Bit version of add-year64.s
# eXX => rXX
# movl, cmpl, pushl => movq, cmpq, pushq
# Replace in open rbx => rdi & rcx => rsi
.include "../6. Chapter 6 - Records/macOS64.s"
.include "../6. Chapter 6 - Records/record-def.s"

.data
input_file_name:
 .ascii "OutputRecords.dat\0"

output_file_name:
 .ascii "ChangedRecords.dat\0"

.bss
.lcomm record_buffer, RECORD_SIZE

# Stack offsets of local variables
.equ ST_INPUT_DESCRIPTOR, -8
.equ ST_OUTPUT_DESCRIPTOR, -16

.text
.global _start

_start:
# Copy stack pointer and make room for local variables
 movq %rsp, %rbp
 subq $16, %rsp

# Open file for reading
movq $SYS_OPEN, %rax
leaq input_file_name(%rip), %rdi
movq $0x000, %rsi
movq $0666, %rdx
syscall

movq %rax, ST_INPUT_DESCRIPTOR(%rbp)

# This will test and see if %rax is negative. If it 
# is not negative, it will jump to continue_precessing.
# Otherwise it will handle the error conditionn that 
# the negative number represents.
cmpq $3, %rax                           # First file descriptor macOS returs was always 3 in lldb
jge continue_processing                 # and we continue with the program

# Send the error
.data
no_open_file_code:
.ascii "0001: \0"
no_open_file_msg:
.ascii "Can't Open Input File\0"

.text
leaq no_open_file_msg(%rip), %r11
pushq %r11
#pushq $no_open_file_msg
leaq no_open_file_code(%rip), %r11
pushq %r11
#pushq $no_open_file_code
call error_exit

continue_processing:

# Open file for writing
movq $SYS_OPEN, %rax
leaq output_file_name(%rip), %rdi
movq $0x201, %rsi
movq $0666, %rdx
syscall

movq %rax, ST_OUTPUT_DESCRIPTOR(%rbp)

loop_begin:
 pushq ST_INPUT_DESCRIPTOR(%rbp)
 leaq record_buffer(%rip), %r11 
 pushq %r11
 call read_record
 addq $16, %rsp

# Returns the number of bytes read. If it isn't the same number
# we requested, then it's either an enf-of-file, or an error,
# so we're quitting.
cmpq $RECORD_SIZE, %rax
jne loop_end

# Increment the age
leaq record_buffer(%rip), %r11               # We get the address of the buffer into %r11
addq $RECORD_AGE, %r11                       # Now we add 320 to the address and get to the age
					     # section of the buffer.
movq (%r11), %r12                            # Next we take the element, the age, and put it 
incq  %r12                                   # in r12, so we can increment it.
movq %r12, (%r11)                            # Now we move it back. Not into %r11, 
					     # but the address of
xorq %r11,%r11
xorq %r12,%r12

# Write the record out
pushq ST_OUTPUT_DESCRIPTOR(%rbp)
leaq record_buffer(%rip), %r11 
pushq %r11
call write_record
addq $16, %rsp

jmp loop_begin

loop_end:
 movq $SYS_EXIT, %rax
 movq $0, %rdi
 syscall
