# Introduction
Numbers in memory are represented for the most efficient use of addition
and multiplication. The corresponding ASCII representtion of each digit is
different. Therefore in order print a number to the terminal it has to be
converted into its ASCII representation. The digit $0$ is $48$ and $9$ is 
$57$.

As an example let's take the number $1998$ and transform it into it's respective 
ASCII represntation, which would be, $49575756$. First recall that
$$
  1998 = 1 \cdot 10^{3} + 9 \cdot 10^{2} + 9 \cdot 10^{1} + 8 \cdot 10^{0} \\
$$
In order to get the individual digits, the number needs to be devided by powers of 10.
$$
Therefore deviding by 10 will yield the frist full digit. It's the right shift operation
in decimal. The exponent will be reduced by $-1$ with each devision up until the full
devision yileds $0$. In our example:
\begin{aling*}
1998 &/ 10 = 199 \hspace{1cm} \text{remainder:} \hspace{0.1cm} 8
199  &/ 10 = 19 \hspace{1cm} \text{remainder:} \hspace{0.1cm}  9
19   &/ 10 = 1 \hspace{1cm} \text{remainder:} \hspace{0.1cm}   9
1    &/ 10 = 0 \hspace{1cm} \text{remainder:} \hspace{0.1cm}   1
0    &/ 10 = 0 \hspace{1cm} \text{remainder:} \hspace{0.1cm}   0
\end{aling*}
$$

We therefore need the modulo operation. On $x86\_64$ that's implicit.
The Dividend needs to go into the accumulator \%rax and the Devisor goes into 
another general purpose register. The result will be in %rax and the remainder
in \%rdx, which also means, \%rdx is volitaile with respect to divq !
```asm
.text
.global _start
_start
  movq $23, %r8
  movq $1998, %rax
  divq %r8
  movq %rdx, %rdi
  movq $0x2000001, %rax
  syscall
```
Will reeturn 20. and rax will contain 86.
