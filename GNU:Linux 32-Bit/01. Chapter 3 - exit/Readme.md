Taking the clutter away, the program really reads:
```
.section .text
.global _start
_start:
  movl $23, %eax
  movl $253, %ebx
  int $0x80
```
Where 0x80 calls the interrupt or syscall.

To assemble and link use:
```
as -32 exit32.s -o exit32.o
ld -m elf_i386 exit32.o -o exit32
```
The output 23 (MJ forver!) can be seen with the help of
```
echo $?
```
####About
This chapter first and foremost sets up the assembler and linker.
On top of that it provoides the ingenius method for the next three 
chapters to write more interssting programs without yet having the
ability to print numbers to the output.

### License

**© 2020 Marek Schiffer**
