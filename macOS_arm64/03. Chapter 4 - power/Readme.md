# Power function
The power function here is a rudimentary function that takes two
integer inputs, the base and the exponent and calculates the power
$a^b$. The function is called twice and then the results are added 
together, to explore the full stack behaviour.

While the function itself is primitive, this chapter introduces
the concept of function calls in assembly, as well as stack management.

In modern assembly code parameters are passed to subroutines via registers.
This is much faster as access to memory is about 50-100 times slower than 
accessing a register. In the past when computers had fewer registers, e.g.
6502 has 3 general purpose registers, the stack was primarily used.
To this day, the x86_64 uses the stack for the return address but function
parameters are nowadays passed by registers. After all, you place the value
in the register, call the function and et voilà everything is there.

Using the stack to pass parameters needs a little more getting used to than
passing by registers and in this chapter we will focus on that. The calling
convention using the stack is also inevitable when dealing with recursive
functions, as seen in the next chapter. 
In Chapter 8, we'll call functions from C making it necessary 
to use modern calling convention. We'll get into more detail there. 

<table border="0" align="center">
  <tr>
    <td align="center">
      <img src="./.assets/2025-03-22_Marek_Schiffer_Animation_arm64_Stack_Retracted.gif" alt="Stack Animation arm_64" width="300"><br>
      <figcaption>Figure 1: Calling a function using the stack; without using stp showing 16 Byte alignment consequences.</figcaption>
    </td>
    <td align="center">
      <img src="./.assets/2025-03-22_Marek_Schiffer_Animation_arm64Stack_stp_Retracted.gif" alt="Stack Animation arm_64" width="300"><br>
      <figcaption>Figure 2: Second instance of the animation (same as first).</figcaption>
    </td>
  </tr>
</table>

# The Stack
Every program on modern hardware "thinks" it owns all of memory. This little
power function as well as Adobe Photoshop or Google Chrome. In reality
the memory is obviously limited but the operating system handles that
for us and creates a lookup table for what is called virtual memory.

So, even though we see all of memory, not every virtual block is mapped
to real physical memory. The moment we try to access a block of memory that is
not mapped to real memory, we get the most comprehensive and accurate error
message ever devised  
 **Segmentation fault**.

From this point on we'll just say memory and keep in mind that it's realy virtual memory.
The memory for a program is roughly divided into 3 sections. The code section,
.text where the program code lives and the .data section, where
the data resigns. By design the data section is again divided into
a part called the heap and another part called the stack. As the program
owns all of RAM the stack and the heap are divided by as much space as possible.
The heap starts at the bottom of memory (low memory addresses) just above the
code block and the stack starts at the top of memory and grows down. 

It's important to point out that the stack being on top and growing down is
purely a design decision. In a way memory was there first, and the stack came
later. Nevertheless, this can lead to confusion and you should have a picture
like (Figure 1) in mind. 

In practive remember, the axis for adding and subtracting is the memory axis __not__ 
the direction in which the stack grows.

## Stack calling convention
The gist of the stack calling convention is this:
 - We push the values in reverse order onto the stack. Using the 
   reverse order is just a convention to comply with the old C calling convention. 
   Do what you want!
 - We branch using the **bl** (branch label) instruction.
 - The **bl** instruction inserts the return address, that is the address
   of the current instruction + 4 Bytes in the **lr** register.
   and then changes the program counter (PC) to the label address.  
 - By convention, at the beginning of the function, we push the frame pointer **fp** and the return address **lr** onto the stack
 - We then point the frame pointer **fp** at the same address as the stack pointer **sp**.
   Essentially, remembering what **sp** was when we entered the function.
 - Next we do what the function needs to do
 - At the end we restore **sp** with the help of **fp**. So, whatever we did
   after this the stack pointer will be the same as when we entered the function.
 - Next, we load  the frame pointer and link register back into **fp** and **lr**, 
   restoring it to the value it was before we called the function. Remember, the **ldp** instruction 
   uses **sp**. **ldp** simply returns the value at the address of **sp** and **sp** + **8**.
   If **sp** is not properly adjusted we would get the wrong values.
 - Finally, we use the **ret** instruction to return to the address. **ret** copies the address from 
   the link register **lr** into the program counter **pc**. If you forget to update **lr**
   **ret** will copy whatever value is in **lr** and try to branch there.
## The Stack ain't no Stack

## Stack Frame
You will often hear the term stack frame. The stack frame is basically the currently
active scope of the function; starting at the base pointer and ending at the current
stack pointer. All variables within the current stack frame are said to be in scope.
Obviously that's kind of nonsense, as we just pulled down the variables from callers 
stack frame and moved them into our registers. Like the stack itself, the stack frame 
is more a software design choice, supported by the hardware than a concept required by 
the  hardware.

## Context insensitive Code
I just want to mention that when we call the power function in this example, we immediately
use the base and the exponent. If we're dealing with more complex code or were to write a compiler
a very standard way to handle things is to create what's called context insensitive code. 
What it basically means is, we would first make space on the local stack frame and immediately
store every variable on the local stack frame. We then can break down every instruction into
Load, ALU, Store idiom. That becomes also very useful the moment you write bigger functions and are 
running out of registers or just start to lose track. 
Every compiler without optimizations, will translate the code to into context insensitive assembly
int debugging mode or with optimizations turned off. After the context insensitive code is created
the optimizer will then get rid of unnecessary operations. A simple but  striking example for that 
is a generic swap function. 


## Modern calling convention
<div align="center">
   <img src="./.assets/2025-03-22_Marek_Schiffer_Animation_arm64_modern_calling_Convention.gif" alt="Graph modern calling convention x86_64" width="600">
   <div align ="center">
      <figcaption> Figure 2: Modern calling convention on x86_64 </figcaption>
   </div>
   <br> <br>
</div>

As mentioned before on modern systems the first 7 elements on arm64 are passed
by registers. Those seven registers are, in order

| Argument | Register |
|----------|----------|
| 1st      |    x0    |
| 2nd      |    x1    |
| 3rd      |    x2    |
| 4th      |    x3    |
| 5th      |    x4    |
| 6th      |    x5    |
| 7th      |    x6    |
| 8th      |    x7    |

Therefore basically, x0-x7. x0 is still the first argument, not the 0th! 
The return value is still in x0.

We'll go into more detail in Chapter 8, when interacting with C. 
Every, register that passes a function argument is considered volatile from the
callers perspective. 

DRP, Don't repeat yourself is a fundamental concept in programming.
Once understood that the CPU just executes one instruction at a time
with the occasional branch, we quickly realize that we often need
to do the same thing
[^1]:
Reverse order, because it's the C convention
```
extern int power(int base, int exponent);
```
With this prototype, we would first push base onto the stack.
[^bignoe]
