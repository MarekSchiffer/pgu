## Exit Program
The exit program is essential a "Hello, World!" program. In the sense that
we insert a number into the register and use the Terminal to print (echo)
out the number.

This is indissmissable connected with the von Neumann architecture. The
program code, together with the number, is inserted into memory,
then loaded into registers and finally executed.

There is still this pesky "little" layer of abstraction called macOS or
the operating system. Everything is controlled by the Kernel.
The API between userspace and Kernelspace is bridged by syscalls.

In this particular case, we're asking the Kernel to quit the program
and return a number into stderr. The return value can then be seen
with the Terminal command:
```
echo $?
```

The error code, which is used as a communication tool to the outside
up until Chapter 6 has to be in the intervall of [0,255] (1 Byte)

This is the basis for all upcoming programs. 
The most important part is to get it to run. i.e. assemble
and link it.

## How to assemble & link
To assemble the program:
```
as -arch x86_64 exit64_macOS.s  -o exit64_macOS.o
```
This will create the object file. 
To then link the object file, to get an exectuable use:
```
ld -static -e _start exit64_macOS.o -o exit64_macOS
```

## Notes and quirks

<div align=center>
  <img src="https://raw.githubusercontent.com/MarekSchiffer/pgu/main/macOS_x86/01.%20Chapter%203%20-%20exit/.assets/x86_64_Registers.png" alt="ra" width="600">
<div align=center>
  <figcaption>Figure 1: Different parts of the rax registers on x86_64.</figcaption>
</div>
   <br> <br>
</div>

`.global _start` declares the label `_start` as global, which
means it can be seen by the linker outside of the file. There
is nothing special about the name `_start` and it could as
well be `hugo`

All 64-Bit assembly instructions have the the appendix q for quadword. Yes, I know!  Normally, the `word` size is equivalent to the size of the registers.  However, here a `word` is 32-Bit. Stripping it from all it's meaning. Therefore `.quad` not `.word`.

It's the same for the **r** prefix. **r**ax means, the 64-Bit version of the a register.  
a - a register 8-Bit (intel 8080, 1974)  
ax - a eXtended 16-Bit (Intel 8086, 1978)  
eax - EXtended 32-Bit (Intel 386, 1985)  
rax - RXtended 64-Bit (AMD Opteron / Athlon 64, 2003)  
Appologies to Matt Damon, but we ran out of letters!.
What I meant to say was the **r** has no mnemonic meaning. It's just `r`.

## Differences to the Linux 64-Bit version
The syscall is macOS x86_64 specific. Other than that we
now have `.text` instead of `.section .text`


