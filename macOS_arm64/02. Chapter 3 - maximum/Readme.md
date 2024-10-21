**Overview**
This program finds the maximum in an array of integers by the means
of linear search[^1].  We'll load the first element into a register as
the running maximum. Then update the address of the element and move along
the addresses, derefence the pointer and compare the element. with 0, to
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
Addressing modes between arm64 and x86_64 are quite diffrent.
The most striking difference is the RIP Mode. In x86_64 we could
calculate addresses directly by adding %rip mode. This is not 
possible in arm64. To be clear, that's not to say arm64 doesn't 
use rip. It comes back to the fact that arm chose to use use 32 Bit
instructions. That only leaves ??? Bits to address the address[^2] 
### Immediate Mode:
```
mov x0, #11
```
is called immediate Mode.
* Inserting the address directly into the register * \
\
If we had the address of an array, like your data\_items, we can insert it immediately in a register
```
movl $0x100001000, %rcx
```

### Indirect Addressing Mode
```
mov x1, [x0]
```

The number 11 comes directly form the RAM slot we write it in. This
is  a direct consequence of the von Neumann architecture. \

[^1]: It's actually a good exercise (after Chapter 3 and maybe 8) to
implement
```
void *lsearch(void *baseAddr, int *elmSize, int n, int (*cmp)(void*,void*));
```
to implement linear search for generics to be called from C.

[^2] Pun intended, asshole! :)
