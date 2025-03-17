# Programming from the Ground Up (macOS $x86_64$ \& arm64)
Programming from the Ground Up is a book written by Jonathan Bartlett in 2004.

Like Kernighan and Ritchie it focus on the right things, creating programs that are useful and instructive.. 

It focuses on the right things. Instead of rambling on about binary numbers, 
twos complement, arithmetic left shift and so on, without giving any frame of
reference of why these things are needed or useful, the author lets you jump into
the deepend and let's you build that frame of reference. Once that foundation is
set there will be much more appreciation for twos complement and the other things
mentioned above.

Programming from the Ground Up contains 10 useful Katas to introduce
assembly language on an x86 processor on a Linux system.


Here all the programs are ported to run on macOS $x86_64$ as well as macOS arm64 (Apple Silicon).
As mentioned the book was written for Linux in 2004. The first $x86_64$ was 
introduced in 2003. The adoption to x86_64 was done [realed](https://github.com/realead/pgu_64) 
in 2016. Since, macOS is basically a Linux system[^1], I ported it to  macOS in 2020
and to arm64 in 2023.

This repository contains all 10 programs for both instruction sets.




[^1]: Yeah, Yeah, it's a BSD branch of the Unix system. Shut up!





