### About
This chapter uses the output to implement a linear search over a list of
number. Due to the limitation of the 


### Behind the Curtain
Behind the curtain this chapter is about two things
- Branching
- Addressing Modes

# Addressing Modes
In some way this is the main topic of this task.
Assume we have the following array, like in maximum
```
data_items: .long 23,6,17,46,52,69
```
### Immediate Addressing Mode
```
  movl $11, %edx
```
is called immediate Mode. The number 11 comes directly from the RAM slot we write it in. This is a direct consequence of the Von Neuman architecture. 
![alt text]("./Screeshots/Addressing32.png")
If we had the address of an array, like your data\_items, we can insert it immediately in a register
```
movl $0x804a000, %ecx
```
That is the same as writing
```
movl $data_items, %ecx
```
We notice the dollar sign $.
### Indirect Addressing Mode
Now, that we have the address in register ecx, we can
use the Indirect Addressing Mode to get the value at the address
```
movq (%ecx), %edx
```
At this point the number 23 is in register %edx as well. 
This line has all the secrets regarding pointer. Move the
address in ecx in the Memory Address Register, put
tbe value at that address on the BUS and captures it in edx.
Et voila!
### Direct Addressing Mode
We can achieve the same result with the "Direct Addressing Method:
```
 movl data_items, %edx
```
This moves the value 23 in edx as well. 
We notice the lack of a $ sign. If mov gets an address,
the value from that address will be moved in the register
directly.
### Base Pointer Addressing Mode
Once we have the address in a register, we can use the base
pointer addressing mode to add a constant to the address and
hop forward in memory
```
movq $data_items, %ecx
movq 4(%ecx), %edx
```
We now have the 6 in register ebx
### Indexed Addressing Mode
Additionally to the prefix offset, we can add a counting register with a multiplier:
```
movq $data_items, %ecx
movq $3, %edi
movq (%ecx,%edi,4), %edx
```
This moves the 46 in %edx. Additionally, we can use the pre offset:
```
movl $data_items, %ecx
movl $3, %edi
movl 4(%ecx,%edi,4), %ebx
```
To reach the 52. Finally we can use data\_items similarly:
```
movl $4, %edx
movl data_items(%edx,%edi,4), %ebx
```
Which again moves the 52 in register ebx
This notation sucks! It sucks, because data\_items is outside of the parenthesis and yet gets evaluated as if data\_items was inside and after the address is calculated, the parenthesis make the movq jump to the right address. 







