## Overview
This program finds the maximum in an array of integers by the means
of linear search[^linSearch]. We'll load the first element into a register as
the running maximum. Then update the address of the element and move along
the addresses, dereference the pointer and compare the element. with 0, to
see if we reached the end and then with the current maximum to see if
we need to update it.
First attempt in maximum arm:

## Behind the Curtain
Behind the curtain this chapter is about two things
- Addressing Modes
- Branching

# Addressing Modes
In some way this is the main topic of this task.
Assume we have the following array, like in maximum
```
data_items: .quad 23,6,17,46,52,69
```
## Immediate Addressing Mode
```
  movq $11, %rdx
```
is called immediate Mode. The number 11 comes directly from the RAM slot we write it in.
This is a direct consequence of the von Neumann architecture.

![](https://github.com/MarekSchiffer/pgu/blob/main/macOS_x86/02.%20Chapter%203%20-%20maximum/Screenshots/Addressing_macOS.png)
* Inserting the address directly into the register * \
\
If we had the address of an array, like your data\_items, we can insert it immediately in a register
```
movl $0x100001000, %rcx
```
## Indirect Addressing Mode
Now, that we have the address in register ecx, we can
use the Indirect Addressing Mode to get the value at the address
```
movq (%rcx), %rdx
```
At this point the number 23 is in register %rdx as well.
This line has all the secrets regarding pointer. Move the
address in ecx in the Memory Address Register, put
tbe value at that address on the BUS and captures it in edx.
Et voila!
## IP-Relative Addressing Mode
![](https://github.com/MarekSchiffer/pgu/blob/main/macOS_x86/02.%20Chapter%203%20-%20maximum/Screenshots/RIP-Relative_macOS.png)
* data\_itmes(%rip) gets replaced by 15(%rip). We can check, that 0xff1+0x15 is indeed 0x1000 *
Under macOS Direct Addressing Mode is not supported anymore. Instead
IP-Relative Addressing Mode is used.
```
leaq data_items(%rip), %rcx
movq (%rcx), %rdx
```
lea stand for "Load Effective Address". \

In IP-Relative Addressing Mode, the address is calculated by the relative
offset to the instruction pointer (ip). This is entirely different from
the Absolute Addressing Mode. Here the prefix data\_items, will be calculated
 to the difference or offset to the address of data\_items. See (Figure 2).  \

We can also move the item directly into the register with
```
movq data_items(%rip), %rdx
```
This gives us again the value 23 in register rdx.
## Base Pointer Addressing Mode
Once we have the address in a register, we can use the base
pointer addressing mode to add a constant to the address and
hop forward in memory
```
leaq data_items(%rip), %rcx
movq 8(%rcx), %rdx
```
We now have the 6 in register rdx. Notice that the 8 gets "pulled in" the
parenthesis. Symbolically the expression gets evaluated to (%rcx+8) and the Indirect Addressing Mode gives back the value.
## Indexed Addressing Mode
Additionally to the prefix offset, we can add a counting register with a multiplier:
```
leaq data_items(%rip), %rcx
movq $3, %rdi
movq (%rcx,%rdi,8), %rdx
```
This moves the 46 in %rdx. (%rcx+3\*8).
Additionally, we can use the pre offset:
```
leaq data_items(%rip), %rcx
movq $3, %rdi
movq 8(%rcx,%rdi,4), %rdx
```
To reach the 52.

# Branching
Branching is the ability for a computer to execute instructions in memory one
at a time and react to certain conditions and branch out into other parts of the
program code.

Branching is where the magic happens.

Before the invention of digital technology, electronic devices were very rigid.
Rigid in a sense that they followed a strict control flow. They were also analog but
that's not the point here. Every device before the takeover of the semiconductor
followed a very rigid path of execution. Complex behaviour was carefully managed
by signals and timing. Let's take an old CRT TV as an example. With the help of
a magnetic field an electron beam can be moved by changing the magnetic field
between two metal plates, which is directly proportional to the current. But getting
MacGyver on the screen is a little more involved. In order for a picture to from in
front of the screen, the signal has to go from left to right and the moment it reaches
the end needs to reset to the left. At the same time the magnetic field for the vertical
direction has to notch the beam down one scanline. All of that was carefully orchestrated by signals.
The AC signal was used to create two sawtooth signals of two different frequencies with the
help of basically capacitors, to guide the beam. Each time the current dropped to zero,
the beam would reset to the left and when the slower sawtooth signal dropped to zero the beam would
reset to the top left. The video signal would then be superposed on the beam to change
the intensity and form the picture. Turning from black (low intensity), over different shades
of gray to white (full intensity). Additionally, the signal had a pulse to synchronize the
horizontal and vertical beam with the automatic moving beam.


The takeaway point here is that even though a device like a CRT TV seems to have something
like a control flow <br> 
"**If** the beam reaches the right side **then** reset it to the left" 
<br>
That is not the case. This magical feature needs digital technology.

## Fetch-Execution Cycle
To understand a computer a crucial point is to understand the Fetch-Execution Cycle.
Modern CPUs are complicated and use a lot of trickery and abstractions to bypass
physical limitations. When I describe the Fetch-Exectuion Cycle I'll have a simpler
chip in mind. Something like the 6502. The point is to understand how electronics
can be used to create a conditional logic that depends on something that's in itself
nothing but bytes in memory.


### 1. Fetch
The first critical component to understand is that every byte in memory can be accessed.
Since the von Neumann architecture puts the opcode in memory, all the machine needs to
know is where the current instruction is. That information is stored in the instruction
pointer or better the instruction address register. Because that's all it is. One register
that holds the binary number of the address in memory where the current instruction lives.
This binary number must then be transferred to the Instruction Register. Note, these
are two different registers. One holds the address to the current instruction and the other
the instruction itself.

### 2. Decode
Next the instruction in the Instruction Register needs to be decoded. As the opcode is nothing
but a binary number, the first step is to separate the number into different wires. That's
done by a multiplexer.

The important part here is to understand that the opcode acts like a punch card.
A punch card had holes in it. Depending on where the holes were, different connections
were conductive or isolated and different circles would be closed or not be closed.

By putting the binary number in the Instruction Register and splitting the number into different
wires the same result is achieved. The different wires can then be connected in different ways
to form a finite state machine for each step of the instruction encoded in the binary number.

The concrete wiring behind the differnt connections is what forms the micro instructions that 
need to be executed.

That means the instruction is **not** executed in one go.

### 3. Execute
Up to this point multiple steps were already executed. The memory address in the Instruction
Address Register was used to enable that  memory address and put it on the Data Bus.
Then the Instruction Register was opened/set to store that Instruction. If we imagine these
discrete steps as button presses that need to happen carefully in order one fafter the other, then 
there is still one crucial piece missing. The CPU clock. 
Contrary to the CRT TV example above the signal in a CPU is digital. A square wave
on a fixed interval. That's very different than the analog signal mentioned above. The analog
signal is based on timing. The digital signal is based on steps. If the clock speed is changed,
the steps would still be executed in the exact same order of the steps, while an analog signal
is based on timing and can get out of sync. The digital signal is like consecutive button presses,
that are executed in order. The unit that orecestrates all these instructions is normally called
the Control Unit. 


Depending on the opcode that was loaded in the Instruction Register there are now multiple additional
steps that need to take place in order to execute a command. For example, loading another value from
memory into a register takes again multiple steps. First, putting the address in the Memory Address Access 
Register[^1]. Second, putting the 
value at that address on the Data Bus and third setting the desired register to store it. Forth, disabling the 
Memory address, so the Data Bus is free again.

Those are four steps encoded in one instruction and hardwired in micorcode into the CPU.

### 4. Write-Back
After the instruction is executed, The Fetch-Execution cycle isn't finished yet.
The last part is to take the current address in the Instruction Address Register and add to it, so that 
the number holds the address of the next instruction in the Instruction Address Register. On a system with 
a fixed instruction length that's just adding a constant to the address 2 Byte for a 6502, 4 Byte for arm64 
and a variable length for an x86.

After the number has been added, the instruction pointer is updated and the cycle continues.  
Wash, rinse, repeat! or  
Lift, eat, sleep, repeat!  
Whatever you prefer.

## Arbitrary Branching
Now, that we have an idea how one instruction after the other can be executed. The next question is how can can
a program run indefinitely, given that RAM is finite? In other words how are loops implemented on a hardware level? 

Given the previous explanation, the answer is surprisingly simple. After all, all that needs to be done is updating
the Instruction Address Register. Again, keep in mind that it's just a binary number addressing a memory position. 
And since each memory address is equaly accesibleihh In other words, the number given has to be loaded as an immediate from the opcode 
into the Instruction Address Register. 

Like above about 4 steps must be hardwired behind the scenes to encode the branch instruction into a finite state machine or microcode if you like. After the Fetch-Execution Cycle is completed, the instruction pointer will now point to the address give in the instruction. The
next execution will start from there and the branch is completed[^2].

## Conditional Branching
The final part of the puzzle is the conditional branch. if-else statements. If two registers are compared one
value in a register can either be smaller or equal to the second register. If it's neither smaller nor equal, it's
bigger. Based off of this comparison a flag is set. Naturally, comparing two word long numbers and setting a comparison
bit takes more than one microstep, which are hardwired in the compare instruction.

On x86_64 the flag will be set in the rflags register. On arm64 it's NZCV (**N**egative,**Z**ero,**C**arry,o**V**erflow), which is 
part of the cpsr register. Subtracting two binary numbers for example will either lead to a 1 or a 0 in the most significant bit within 
two's complement. 1 means negative, 0 means positive. If the number is negative the hardwired state machine microcode 
of the cmp operation will update the conditional flag register will be set. The next opcode will then check if the appropriate condition
is met or not and based upon that update the instruction pointer and follow the code path.

[^1]: The Address Bus Low and Address Bus High for the 6502.
[^2]: Note, if we assume the instruction length is automatically added at the end of the Fetch Execution-Cycle, the assembler woudld simply subtract that number and place the correct one in the opcode. All of that would depend on how the CPU is wired together.
[^linSearch]: It's actually a good exercise (after Chapter 3 and maybe 8) to implement
```
void *lsearch(void *baseAddr, void *elm,  int *elmSize, int n, int (*cmp)(void*,void*));
```
lement linear search for generics to be called from C. Note to self, done!
