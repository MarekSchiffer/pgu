# About
This chapter uses the output to implement a linear search over a list of
numbers to find the maximum. Due to the limitation of the output, the list
is reduced to numbers between [0,255] until the completion of Chapter 10.

# Changes to the 64-Bit Linux version


## Behind the Curtain
Behind the curtain this chapter is about two things
- Branching
- Addressing Modes

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
is called immediate Mode. \ 
The number 11 comes directly from the RAM slot we write it in. This is a direct consequence of the von Neumann architecture. \

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
## IP-Relatvie Addressing Mode
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
The second introduction in this chapter is branching. The opcode cmp sets
the %rflags register and according to the result the branch is made.
The first branch is equivalent to a while loop and the second to an if statement


