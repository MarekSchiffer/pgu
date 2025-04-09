# Records

This program is basically a primitive CRUD App, which creates a file
Datarecord.dat. with 3 names, addresses and age. Then we're gonna
read from that file and only print out the first names to stdout.

Only a few new assembly directives are taught, but parts of the functions will
be needed later on and the next chapter builds on it. The basic
outline is as follows:

0.) Before we start, we need to define the sizes of the record. They're all gonna
    be fixed size.

1.) write-record.s will write one record consisting of a name, address and age to
    a file discriptor (fd) provided by the caller.
2.) write-records.s has the names, addresses & age hardcoded inside and will write 
    them to a file using write-record.s.

 Now, the .dat file is created and holds the data of 3 records. Next, we want to read
 from the file and print the first name  to stdout.

3.) read-record.s is the analogon to write-record.s. read\_record reads one record 
    from the .dat file provided and puts it into a buffer.
4.) From the buffer we now need the amount of characters of the first name by means
    of a function called count-chars.s. count-chars determines the length of a string ending
    with a '\0'.
5.) read-records.s is the analogon to write-records.s. read-records.s uses read\_record
    to read in a record from the file into the buffer and then writes the output 
    to stdout.
6.) Finally, we'll notice that there needs to be a newline after printing out the names.
    Therefore, we create the file newline.


By default this program prints out the first name of the record, but it can also print out
the last name and the address by changing the offset.
