At the moment the toUpper can't be linked as static

We need  
 ld -macosx_version_min 11.0 -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem -e _start toupper64_macOS.o -o toupper64_macOS  
  
Also it seems that filenames are a problem
  
/toupper64_macOS BobDylanIAM.txt out.txt  
  
But
/toupper64_macOS ./BobDylanIAM.txt out.txt  
  
Does not!

To Do: Find out why!

