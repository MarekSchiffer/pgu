**Overview**
This program finds the maximum in an array of integers by the means
of linear search[^1]. We'll load the first element into a register as
the running maximum. Then update the address of the element and move along
the addresses, dereference the pointer and compare the element. with 0, to
see if we reached the end and then with the current maximum to see if
we need to update it.
First attempt in maximum arm:
```
add x3, x3, #1
mov x5, #8
mul x4, x3, x5
ldr x0, [x1, x4]
cmp x0, x2
b.lt next
```
Better (more arm like:):
```
add x3, x3, #1
ldr x0, [x1, x3, lsl #3]
cmp x0, x2
b.lt next
```
Alternative:
```
add x3, x3, #1
ldr x0, [x1, #8]!
cmp x0, x2
b.lt next
```
We might add a second array to show pageoff usage.

## Behind the Curtain
Behind the curtain this chapter is about two things
- Branching
- Addressing Modes

## Addressing Modes:
Addressing modes between arm64 and x86_64 are quite different.
The most striking difference is the RIP Mode. In x86_64 we could
calculate addresses directly by adding %rip to the label for either movq
or leaq. This is not possible in arm64. To be clear, that's not to say arm64 doesn't
use RIP. But it does so in a more concealed way, as we'll see.

This comes back to the fact that arm chose to use use 32 Bit
instructions. The opcode is between 6 and 8 Bits. The maximum
amount of opcodes is therefore 256. Many tricks are used to
make this as efficient as possible.
For ldr and str  That only leaves 21 Bits to address the address[^2]

Another difference between x86_64 and arm64 is the use of the word
move and load. In x86_64 we move something from register to register,
same in arm64, but we also move something from memory to a register.
or we even move it from a register to memory.  arm64 uses the menomic 
ldr (load) and str (store). Load and Store (str) are in a
way more precise, as we often follow the idiom load ALU, store. Nevertheless
if you switch back and forth, it'll drive you mad.
The same goes for leaq, Load effective address. This is not the same as ldr in
arm64 the corresponding mnemonic is adr. In the following we'll simply use the
arm64 mnemonics as they're used and not constantly compare to x86_64.

### Immediate Mode:
```
mov x0, #11
```
is called immediate Mode.
* Inserting the address directly into the register * \

If we had the address of an array, like your data\_items, we _could_ insert it immediately in a register.
Again, the 32 Bit limitation kicks in. The mov instruction is an alias for movz (move zero), which
zeros out the registers and moves. However, it gets an 16 Bit immediate value #imm16 as well as
a logical shift left (lsl). Again, opcode 8 Bit, size flag (sf) 1Bit, one Register 5 Bit, #imm16,
well, 16Bit and lsl 2Bit. Therefore to insert an address into a register, we need mov and movk (move keep)
movk has the same bits as movz and the same shift values 0,16,32,48.
```
mov  x1, #0x4000
movk x1, #0x0000, lsl #16        <-> .       movl $0x100004000, %rcx
movk x1, #0x0001, lsl #32
```
After this instruction the address 0x000100003f30 will be in register x1. In our
example, that's the address of the list item. We now, again _*could*_ load the first
item at that address into register x1 with
### Indirect Addressing Mode (Registers)
```
ldr x0, [x1]                  <->           movq %(rax), %rdi
```
Here, the address in x1 is dereferenced and the value at that address is loaded into x0. 
Always keep in mind, may steps are necessary to fulfill this one assembly instruction.
This will only work, if we run it in a debugger like lldb. The debugger will
not use Address Space Layout Randomization (*ASLR*). Apple does; and since we're not
allowed to statically link, the address of the list will be different
every time you run the program. We can still use a trick to make it work, at least
a little.
```
 adr x1, .
 add x1, x1, #-0x34
```
The dot . will load the current program counter (pc) into register x1.
adr x1, pc is not allowed. adr is loading the address of . into x1.
We talk about adr in a minute. For now we then manually, calculate the offset to the first
element in the list by adding it to the address and finally we can access the 
element with the indirect addressing mode. 
This is essentially doing manually,  what position independent code will do using RIP-Relative.
## IP-Relative Addressing Mode
### Literal load using PC-Relative ( Relative Addressing Mode movq(%rip) ) 
Now, that we have the hacks out of the way, let's look how we could load the first element of the list into a register normally.
```
 ldr x0, data_items
```
will load the first element at the address of data_items into register x0.
This is therefore called literal load using PC-Relative. The important part
to remember is that the value will be loaded into x0, not the address. 
### Indirect Addressing Mode (Memory)
If we don't want the first element but rather the address of data_items we can
use the command adr
```
adr x1, data_items
ldr x0, [x1]
```
adr is a 6Bit opcode (5Bit + sf), uses one Register (5 Bit) and 21 Bits to
load the address. $2^21/1024 = 2048 = 2 MiB$ or 2MB for non nerds. 
adr can therefore reach any address in +/- 1MB of the program counter.
The linker will then replace the data_items with the address as an immediate value.
### Indirect Addressing Mode (Memory Pages)
Up until now we had list in our .text section. That's necessary on macOS to
use ldr or adr. However, normally we'll store data in the .data section.
After all we can load  data in the .text section but not write to it.
To access data in the .data section, we use the command adrp address pages.
Memory on arm machines is separated into pages. Normally 4KB wide. To
get the address into a register, we proceed as follows:
```
adrp x1 data_items@gotpage
```
Please note the part @gotpage is an assembler directive. On ach-O file systems, we'll often
use @page instead.
On a Linux system with an ELF files system an different assembler directive is needed.  

adrp works differently than adr! As adr, adrp has a 6Bit opcode (5Bit + sf), uses
one register (5 Bit) and has 21 Bits left to load an address. So what does it do differently 
than adr?
First, it truncates the last 3 Bytes (12 Bit) to get to an even page number. For example,
if the pc is pc = 0x0000000100003f50 it will zero out the last 12 Bits to pc = 0x0000000100003000.
Therefore all instructions with a pc within 4096 Bits (512 Bytes) will give the same address. The 21 Bits are still used to calculate an address but now the 3 Bits are used to space out the target address. i.e
$4096 * 2^21 = 2^12 * 2^21$. To get this in GiB, we get $2^33/2^30 = 8$. Making addresses in the 
range of +/- 4GB accessible. However, not every address since the 4096 were arbitrarily cut short. 
In practice this means from every given point in the program code the linker you can only access labels 
in chunks of 512 Bytes. For example if the value would be 1 it would evaluate to 1* 4096 or 0x1000, 
returning the address 0x0000000100004000. If it were 65537  we would arrive at 65537 * 4096 =  0x10001000 
and at the address would be 0x0000000110004000   Everything within a page needs to be additionally added. 
This can be achieved with the help of the assembler directive gotpageoff. On macOS and the Macho-O file system,
we'll often use @pageoff instead. Again, both are not arm64 assembly instruction.
```
adrp x1 data_items@gotpage
add x1, x1, data_items@gotpageoff
```
The assembler directive gotpageoff will now calculate the #imm16 offset within the page to arrive at the correct label. 
### Base Pointer Addressing Mode
Now, we have the bulk out of the way. We can store data in the .data section
and get the address back into a register to work with. Now, let's assume
we want to access an array. If we declare the array as .quad, each element will
be 8 Bytes long. To access the 3rd element we need to add 24 Bytes to the base
address. We can do that with an base pointer offset.
```
adrp x1, data_items@page
mov x2, #24
ldr x0, [x1,x2]
```
Symbolically we'll have [ x1 + x2 ]  = [ 0x100004000 + 0x18] = [ 0x100004018] and after dereferencing we'll get the value at that address. A similar effect can be achived with
### Immediate Offset Addressing
```
adrp x1, data_items@page
ldr x0, [x1, #24]
```
This means, take the address of x1, add 24 to it, then dereference and load the element at
that address into x0. If the address in x1 is the same as above, we'll get the same value into x0.
### Pre-Indexed Addressing Mode ( with write-back)
Pre Indexed Addressing Mode is accomplished by a bang or exclamation mark,
whatever you prefer.
```
adrp x1, data_items@page
ldr x0, [x1, #24]!
```
The little "!" will first add 24 to x1 and then dereference it. However, here it 
will not act like a rvalue and leave x1 unchanged. After the instruction is executed,
x1 will be updated. This is particularly useful when working with an array and are
we're looping through it, like we saw in the maximum example. In the next chapter we'll
also see how this is used for the stack. 
### Post-Indexed Addressing Mode (with write-back)
On the same token the current address can also be used first to load the value into
a register and then be increased/decreased. That's called Post-Indexed Addressing Mode.
```
adrp x1, data_items@page
ldr x2, [x1], #32
ldr x0, [x1]
```
In this example the address at x1 is first dereferenced and loaded into x2 before 32 gets added to x1. We'll use a close relative of this instruction in the next chapter in the context of the stack usage.
### Indirect indexed  Addressing Mode with Scaling (Memory)
Finally we  look at a few more obfuscated arm instructions. If you just want to access one
element in and an array by index, you can scale the index with the
```
adrp x1, data_items@page
mov x2, #17
ldr x0, [x1, x2, lsl #3]
```
The options for ldr with a 64 Bit register are 0 default and 3. That's it. 3 here means $2^3$
Why not simply #8? Nobody knows! Symbolically the expression evaluates to
`[ 0x100004000 + (0x11 * 0x8 )] = [ 0x100004000 + 0x88] = [ 0x100004088]` the parentheses
would now dereference the address and load the value into x0.
###  Word, Halfword, Byte, Heh?
The following  
A word is the length of a register. So, for a 64Bit machine a word referees to 64Bit. However,
for some reason they messed it up. In arm64 a word is only 32Bit long. Why? again, who knows?So, word 32Bit. halfword is 16Bit and a byte is indeed a byte! For simplicity I choose to make the
array in the maximum program 8 bytes long. The values were all between [1,255] so a byte would've sufficed. macOS is a little endian system. That means the values in the registers are
big endian but in memory the *Byte* order is reversed. With that said, if we write the following:
```
adrp x1, data_items@page
mov x2, #17
ldr w0, [x1, x2, lsl #2]
```
Note, only by using the 32Bit registers the opcode will change and we can use lsl #2. 
this will evaluate to $2^2 = 4$ and we get again symbolically
[ 0x100004000 + (0x11 * 0x4 )] = [ 0x100004044] and we would get the value at that address.
Note, the array hasn't changed. We're just going to the starting address in memory and instead of hopping forward in 8 byte steps, we do it in 4 Byte steps.  In C the equivalent would be
```
long array[20];
int s = *(((short*)(&array[0])) + 17);
```
But, don't worry it doesn't stop here, we can also hop foreword in halfword steps (2 Bytes)
```
adrp x1, data_items@page
mov x2, #17
ldrh w0, [x1, x2, lsl #1]
```
#1 means again $2^1$. Otherwise, same spiel as before `[ 0x100004000 + (0x11 * 0x2 )]   = [ 0x100004022]`. 
Finally,  we have the pure byte.
```
adrp x1, data_items@page
mov x2, #17
ldrb w0, [x1, x2, lsl #0]
```
Here the lsl #0 can be omitted and normally will. As before it means $2^0 = 1$.
This time we hope forward in memory in bytes 
`[ 0x100004000 + (0x11 * 0x1 )]   = [ 0x100004011]` . 
[^1]: It's actually a good exercise (after Chapter 3 and maybe 8) to
implement
```
void *lsearch(void *baseAddr, void *elm,  int *elmSize, int n, int (*cmp)(void*,void*));
```
to implement linear search for generics to be called from C. Note to self, done!

[^2] Pun intended, asshole! :)
