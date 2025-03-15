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
as -arch x86_64 exit64_macOS.s  -o exit64_macOS.o
```
This will create the object file. 
To then link the object file, to get an exectuable use:
```
ld -static -e _start exit64_macOS.o -o exit64_macOS
```

**To Note**
`.global _start` declares the label `_start` as global, which
means it can be seen by the linker outside of the file. There
is nothing special about the name `_start` and it could as
well be `hugo` 

Subnote: Normally, it's written `globl` I thought that's a typo
and am running with `global` ever since. Both are identical.

The error code, which is used as a communication tool to the outside
up until Chapter 6 has to be in the intervall of [0,255] (1 Byte)

![x86_64_Registers](https://github.com/user-attachments/assets/eb321c21-d7b6-4768-b95f-6e374d4f6f73)


**Differences to the Linux 64-Bit version**
The syscall is macOS specific. Other than that we 
now have `.text` instead of `.section .text`

**Notes on quirks**
All 64-Bit assembly instructions have the the appendix 
q for quadword. Yes, I know!
Normally, the `word` size is equivalent to the size of the registers.
However, here a `word` is 32 Bit. Stripping it from all it's meaning.

The prefix r is the same. rax means, the 64Bit version of the a register.
a register 8 Bit;  ax - a eXtended 16-Bit; eax - EXtended 32-Bit.
rax - RXtended 64-Bit. 
Appologies to Matt Damon, but we ran out of letters!.
What I meant to say is the r has no mnemonic meaning. It's just `r`.
