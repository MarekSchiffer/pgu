# Changes for macOS:
# linux64.s => macOS64.s
# .section .data => .data
# movq $input_file_name, %rdi => leaq input_file_name(%rip), %rdi
# movq $0, %rsi	 => movq $0x000, %rsi
# movq $output_file_name, %rdi => leaq output_file_name(%rip), %rdi
# movq $0101, %rsi => movq $0x201, %rsi
# pushq $record_buffer => leaq record_buffer(%rip), %r11 && pushq %r11
#
# incl record_buffer + RECORD_AGE => See # Increment the age (Explanation there)


# #movq $file_name, %rdi => leaq file_name(%rip), %rdi
# leaq record_buffer(%rip), %r11 && addq $RECORD_FIRSTNAME, %r11 && pushq %r11
# pushq $RECORD_FIRSTNAME + record_buffer => leaq record_buffer(%rip), %r11 
#                  && addq $RECORD_FIRSTNAME, %r11 && pushq %r11
# movq $RECORD_FIRSTNAME + record_buffer, %rsi => leaq record_buffer(%rip), %rsi 
#       && addq $RECORD_FIRSTNAME, %rsi
#
# NOT changed, but file_name had to be before a a test wrtiting record1 before.

# Changes 64-bit version:
# linux32.s -> linux64.s
# int $LINUX_SYSCALL => syscall
# eXX => rXX
# Stack number *2
# addl, popl, pushl, movl => addq, popq, pushq, movq
#
# For syscalls: rbx => rdi & rcx => rsi
# 

.include "macOS64.s"
.include "record-def.s"

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
 #pushq $record_buffer
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
