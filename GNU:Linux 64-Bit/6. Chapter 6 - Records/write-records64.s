# Changes 64-bit version:
# linux32.s -> linux64.s
# int $LINUX_SYSCALL => syscall
# eXX => rXX
# Stack number *2
# addl, popl, pushl, movl => addq, popq, pushq, movq
#
# For syscalls: rbx => rdi & rcx => rsi
# 

.include "linux64.s"
.include "record-def.s"

.section .data

# Constant data of the records we want to write.
# Each text data item is padded to the proper length with null
# (i.e. 0) bytes.

# .rept is used to pad each item. .rept tells the assembler to
# to repeat the section between .rept and .endr the number of times
# specified. This is used in this program to add extra null characters
# at the end of each field to fill it up

record1:
 .ascii "Frederick\0"                 # Frederick has 9 characters.
 .rept 31 #Padding to 40 bytes
 .byte 0
 .endr

 .ascii "Bartlett\0"                  # Bartlett has 8 characters.
 .rept 31 #Padding to 40 bytes        # Why is the padding the same?
 .byte 0
 .endr

 .ascii "4242 S Prairie\nTulsa, OK 55555\0"      # 29 characters + \n + \0
 .rept 209 #Padding to 240 bytes                 $ 209+29+2=240
 .byte 0
 .endr

 .long 45

record2:
 .ascii "Marilyn\0"		      # 7+1 (\0)
 .rept 32 #Padding to 40 bytes
 .byte 0
 .endr

 .ascii "Taylor\0"                    #6+1
 .rept 33 #Padding to 40 bytes
 .byte 0
 .endr

 .ascii "2224 S Johannan St\nChicago, IL 12345\0"  # 35+2
 .rept 203 #Padding to 240 bytes
 .byte 0
 .endr

 .long 29

record3:
 .ascii "Derrick\0"                   # 7+1 (\0)
 .rept 32 #Padding to 40 bytes
 .byte 0
 .endr

 .ascii "McIntire\0"                  # 8+1 (\0)
 .rept 31 #Padding to 40 bytes
 .byte 0
 .endr

 .ascii "500 W Oakland\nSan Diego, CA 54321\0"    # 32+2
 .rept 206 #Padding to 240 bytes
 .byte 0
 .endr

 .long 36

# This is the name of the file we will write to file_name:
file_name:
.ascii "OutputRecords.dat\0"

.equ ST_FILE_DESCRIPTOR, -8

.global _start
_start:

# Copy the stack pointer to %ebp 
movq %rsp, %rbp
# Allocate space to hold the file descriptor
subq $8, %rsp

# Open the file
movq $SYS_OPEN, %rax
movq $file_name, %rdi
movq $0101, %rsi          # This says to create if it
			   # doesn't exist, and open for
			   # writing. 

# To do: put it in the linux32.s file

movq $0666, %rdx
syscall


# Store the file descriptor away
movq %rax, ST_FILE_DESCRIPTOR(%rbp)

# Write the first record
pushq ST_FILE_DESCRIPTOR(%rbp)
pushq $record1
call write_record                      # In read-write.s, included via linker.
addq $16, %rsp

# Write the second record
pushq ST_FILE_DESCRIPTOR(%rbp)
pushq $record2
call write_record
addq $16, %rsp

# Write the third record
pushq ST_FILE_DESCRIPTOR(%rbp)
pushq $record3
call write_record
addq $16, %rsp

# Close the file descriptor
movq $SYS_CLOSE, %rax
movq ST_FILE_DESCRIPTOR(%rbp), %rdi
syscall

# Exit the program
movq $SYS_EXIT, %rax
movq $0, %rdi
syscall
