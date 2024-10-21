To create a dynamic library on macOS, we link as follows:
```
ld -dylib -macosx_version_min 11.0 -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem -e _start ../6.\ Chapter\ 6\ -\ Records/read-record64_macOS.o ../6.\ Chapter\ 6\ -\ Records/write-record64_macOS.o -o librecord.dylib
```
This will create the dynamic library librecord.dylib.
The most part is cobbled by path names. The gist is:   
ld -dylib file1.o file2.o -o libfiles.dylib  
  
The -dylib flag is also on by default.  

Once librecord.dylib is created, we refer to the library with -lrecord.  
  
We now create the executable with:
```
ld -macosx_version_min 11.0 -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem -e _start -o write-records64_macOSDyn -L . -lrecord ../6.\ Chapter\ 6\ -\ Records/write-records64_macOS.o   
 ``` 
Again the gist is:

 ``` 
ld -lrecord file.o -o fileExecutable  
 ``` 
To check use otool -L. write-records64_macOSDyn, which should show  

```  
write-records64_macOSDyn:  
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1281.100.1)  
        librecord.dylib (compatibility version 0.0.0, current version 0.0.0)  
```  
