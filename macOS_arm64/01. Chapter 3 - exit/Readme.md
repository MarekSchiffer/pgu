## Exit Program
The exit program is essential a "Hello, World!" program. In the sense that
we insert a number into the register and use the Terminal to print (echo)
out the number.

This is undismissable connected with the von Neumann architecture. The
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
up until Chapter 6 has to be in the interval of [0,255] (1 Byte)

This is the basis for all upcoming programs.
The most important part is to get it to run. i.e. assemble
and link it.

## How to assemble & link
To assemble the program:
```
as -arch arm64 exit_arm64.s -o exit_arm64.o
```
This will create the object file.
To then link the object file, to get an exectuable use:
```
ld -e _start exit_arm64.o -o exit_arm64
```
Please note, static linking is now depreciated.
In the x86_64 versions, we primarily linked the executables as static.
Apple doesn't allow that anymore. At the beginning it was also necessary
to link against lSystem and sysroot. As of now, this is no longer necessary,
but may change in the future again.

<div align=center>
  <img src="https://github.com/MarekSchiffer/pgu/blob/main/macOS_arm64/01.%20Chapter%203%20-%20exit/.assets/arm64_Registers.png" alt="ra" width="600">
<div align=center>
  <figcaption>Figure 1: Different parts of the x0 registers on arm64.</figcaption>
</div>
   <br> <br>
</div>

## Notes
`.global _start` declares the label `_start` as global, which
means it can be seen by the linker outside of the file. There
is nothing special about the name `_start` and it could as
well be `hugo`


## Immediate diffrences**
Before we go into more details about the differnces between x86_64
and arm64, let's get the immediate consequences out of the way.
The stderr return value is now in register x0.
The syscall number is alwasy stored in x16 and for exit is 1
without the nasty `0x200000` The word syscall is replaced wit
svc (supervised call) #0x80.
Comparing this with the 32-Bit GNU-Linux version, we can say;
Welcome Back!


# Differences to the x86_64 macOS version

There are quite a few differences between arm64 and x86_64.
The most striking one is, that all arm64 (AArch64) instructions
have a constant length. That's significatn for decoding and the
underlying implementation. For understanding the assembly code it's
secondary. But remember learning assembly is primarly of interest to
understand the underlying hardware.

Here, we'll  primarily focuse on the differences with practical implications.
We'll also mention them as the become relevant in the program. Therefore
differences in the calling convention will be mentioned with the 3rd program.

## Number of Registers
arm64 has 31 general purpose registers. The full 64-Bit registers have the prefix x.
Therefore we have x0-x28. The 32-Bit part of the registers have the prefix w.
w0-w28. See (Figure 1). There is no direct way to acccess the 16-Bit
or 8-Bit parts. Of course it can be achived with a bitmask.

## Number of Operands
Most arm64 instructions take 3 operands. The instructions also
reassamble the intel syntax instead of the AT&T syntax.
We're now operating from right to left, like in mathematics or C.
```
add x1, x0, #23         x1 = x0 + 23;
```
## Instruction length
```
100003f9c: d28002e0     mov  x0, #23        100000ff0: 48 c7 c0 01 00 00 02   movq  $0x2000001, %rax
100003fa0: d2800030     mov  x16, #1        100000ff7: 48 c7 c7 17 00 00 00   movq  $23, %rdi
100003fa4: d4001001     svc  #0x80          100000ffe: 0f 05                  syscall
```

The most significant difference on a fundamental level between arm64 and x86_64 is the fact that
that arm64 instructions have a constant length of 4-Byte or 32-Bit. As you can see from the comparison of
the two exit programs the syscall instruction on the x86_64 system is only 16-Bit long, while
the equivalent instruction on arm64 is 32-Bit long. The movq instruction on the other hand is 7-Byte 56 Bit long.

Constant length instructions make decoding a little easier and certainly more intuitive.
Since there are 31 registers to address we need 5 Bits for that $2^{5} = 32$. The opcode has a minimum for 4-Bits, leaving only 23-Bits.

An immediate consequence is that not every immediate can be loaded directly in a register. While on x86_64 we could
replace the value in the output register with with 0xFFFFFFFFFFFFFFFF, the highest possible 64-Bit number, that is not possible 
in arm64. Since we only have 23-Bits left, the highest value that theoretically could be placed in a register is
$2^{23}$ ^= 0x800000. 

In practice it's actually less than that. The opcode is bigger and other bits are need for some neat subterfuges.  
The point is Bits are scarce and arm64 uses a lot of clever tricks to safe bits. One of those tricks are aliases.
## Aliases
The mov instruction we used above is an alias not a real instruction. The real instruction is called movz.
movz zeros out the every other bit except for the immediate.
```
mov x0, #23      <=>       movz x0, #23
```
The immediate is limited to 16-Bit $2^{16} = 0x10000$, but there is an additional shift option to the opcode, which
we'll see later.

A more striking example of an alias is the mov instruction with two registers.
```
mov x0, x1      <=>       orr x0, xzr, x1
```
Here zr is a zero register; the x prefix is the 64-Bit version. Since $0 ∨ a = a, ∀a $ it's the same as the mov instruction.
Therefore wasting bits on a redundant opcode is omitted.
