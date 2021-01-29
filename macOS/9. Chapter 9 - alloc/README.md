The syscall brk does not exist on macOS anymore, as can 
be seen from syscall.master, which reads
  
69 AUE_NULLALL{ int nosys(void); }   { old sbrk }  
  
We therefore have to revert to _sbrk from the libc.
Although _brk exists, it doesn't have the same behaviour as the
syscall under Linux and only returns 0xffffffffffffffff

_sbrk has a slightly different functionality than brk.

calling _sbrk with 0 in %rdi still gives us back the
break_begin. 

However, instead of passing the address  of where we want the new
break to be to brk, we have to pass the increment to _sbrk.

This leads to two changes:
1.) We have to have the increment in %rdi and not the address.
    %rdi and %rsi are therefore interchanged.
2.) The header has to be added to %rdi and not the address.


The allocator works with these changes as described in the book.
