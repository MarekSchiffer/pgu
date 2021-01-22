# Changes for macOS:
# linux64.s => macOS64.s
#.type error_exit, @function has to go

# Changes for 64-Bit:
# linux32.s => linux64.s
# eXX => rXX
# pushl, popl, movl => pushq, popq, movq
# int $LINUX_SYSCALL => syscall
# Double Stack size 
# For syscalls, rbx=>rdi & rcx=rsi

#.include "../6.\ Chapter\ 6\ -\ Records/macOS64.s"
.include "../6. Chapter 6 - Records/macOS64.s"
.equ ST_ERROR_CODE, 16
.equ ST_ERROR_MSG, 24
.global error_exit
#.type error_exit, @function

error_exit:
pushq %rbp
movq %rsp, %rbp

# Write out error code
movq ST_ERROR_CODE(%rbp), %rsi
pushq %rsi
call count_chars
popq %rsi
movq %rax, %rdx
movq $STDERR, %rdi
movq $SYS_WRITE, %rax
syscall

# Write out error message
movq ST_ERROR_MSG(%rbp), %rsi
pushq %rsi
call count_chars
popq %rsi
movq %rax, %rdx
movq $STDERR, %rdi
movq $SYS_WRITE, %rax
syscall

pushq $STDERR
call write_newline

# Exit with status 1
movq $SYS_EXIT, %rax
movq $1, %rdi
syscall

