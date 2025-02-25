**Exit Program**
The exit program is essential a "Hello, World!" program. In the sense that
we insert a number into the register and use the Terminal to print (echo)
out the number.

This is indissmissable connected with the von Neumann architecture. The 
program code, together with the number, is inserted into memory and then
executed.

There is still this pesky "little" layer of abstraction called macOS or
the operating system. Everything is controlled by the Kernel. 
Ths API between userspace and Kernelspace is bridged by syscalls.

In this particular case, we're asking the Kernel to quit the program
and return a number into stderr. This is the basis for all upcoming
programs. The most important part is to get it to run. i.e. assemble
and link it.

** How to assemble & link **
To assemble the program:
```
as -arch arm64 exit_arm64.s -o exit_arm64.o 
```
This will create the object file. 
To then link the object file, to get an exectuable use:
```
ld -e _start exit_arm64.o -o exit_arm64
```
Please note, static linking is now depreciated. In the x86_64
versions, we primarily linked the executables as static.
Apple doesn't allow this anymore. At the beginning it was also necessary
to link against lSystem and sysroot. As of now, this is no longer necessary.

**To Note**
`.global _start` declares the label `_start` as global, which
means it can be seen by the linker outside of the file. There
is nothing special about the name `_start` and it could as
well be `hugo` 

Subnote: Normally, it's written `globl` I thought that's a typo
and am running with `global` ever since. Both are identical.

The error code, which is used as a communication tool to the outside
up until Chapter 6 has to be in the intervall of [0,255] (1 Byte)

**Immediate diffrences**
Before we go into more details about the differnces between x86_64
and arm64, let's get the immediate consequences out of the way.
The stderr return value is now in register x0.
The syscall number is alwasy stored in x16 and for exit is 1
without the nasty `0x200000` The word syscall is replaced wit
svc (supervised call) #0x80. 
Comparing this with the 32-Bit GNU-Linux version, we can say;
Welcome Back!


**Differences to the x86_64 macOS version**
There are quite a few differences between Arm64 and x86_64.
The most striking one is, that all arm64 (AArch64) instructions
have a constant length. That's significatn for decoding and the
underlying implementation. For understanding the assembly code it's
secondary. But remember learning assembly is primarly of interest to
understand the underlying hardware.

Here, we'll  primarily focuse on the differences with practical implications.
We'll also mention them as the become relevant in the program. Therefore
differences in the calling convention will be mentioned with the 3rd program.

**Number of Registers**
Compared to x86_64, arm64 has 32 general purpose registers.
The full 64-Bit registers have the prefix x. Therefore we 
have x0-x32. The 32-Bit part of the registers have the prefix w.
w0-w32.

**Number of Operands**
While all the  main x86_64 instructions take one or two operands,
most arm64 instructions take 3 operands. The instructions also
reassamble the intel syntax instead of the AT&T syntax. Meaning
we're now reading from right to left!
```
add x1, x0, #23          vs      addq $23, %rax
```
As you can see the sign from the immediate value changed and we now
have 3 operands. The add instruction reads, add 23 to what's in x0 and
put the result in register x1. 

**Aliases**
Just as a complete asside, arm64 uses a lot of aliases
The mov instruction does not really exists for example it's an alias for
```
mov x0, x1     <=>      add x0, x1, #0
```
See https://developer.arm.com/documentation/ddi0602/2021-12/Base-Instructions/MOV--to-from-SP---Move-between-register-and-stack-pointer--an-alias-of-ADD--immediate--

arm64 opcodes are restricted to 9 Bits, which limits them to 512 different instructions.
(NEED TO FIND THIS IN THE ARM DOCMUMENTATION FOR CONFIRMATION)
