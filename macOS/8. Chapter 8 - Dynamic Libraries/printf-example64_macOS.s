# Changes for macOS:
# .section .text/.data => .text/.data
# printf => _printf
# 
# API has changed, we have to use the registers instead of the stack.
# All Register can be seen below

# Changes for 64-Bit:
# pushl => pushq

# PURPOSE: This program is to demonstrate hoe to call printf
# 

.data

# This string is called the fromat string. It's the first parameter,
# and printf uses it to find out how many parameters it was given,
# and what kind they are.

firststring:
 .ascii "Hello! %s is a %s who loves the number %d\n\0"
name:
 .ascii "Jonathan\0"
personstring:
 .ascii "person\0"
 
# This could've also been and .equ, but we decided to give it
# a real memory location just for kicks 

numberloved:
 .long 3

.text

.globl _start
_start:
subq $8, %rsp
# Note that the parameters are passed in the reverse order that they
# are listed in the function's prototype.

 movq $0, %rax			# no vector registers used (abi requirement of x86_64)
 leaq firststring(%rip), %rdi	# This is the format string in the	
				# prototype		
 leaq name(%rip), %rsi		# This is the first %s
 leaq personstring(%rip), %rdx	# This is the second %s
 movq numberloved(%rip), %rcx	# This is the %d
 call _printf


 movq $0, %rdi
 call _exit
