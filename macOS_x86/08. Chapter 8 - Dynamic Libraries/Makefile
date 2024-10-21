INCLUDES := -macosx_version_min 12.0 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem
OBJECTS := ../06.\ Chapter\ 6\ -\ Records/write-record64_macOS.o \
		   ../06.\ Chapter\ 6\ -\ Records/read-record64_macOS.o

OBJECTS1 := ../06.\ Chapter\ 6\ -\ Records/write-records64_macOS.o

all: helloworld-nolib64_macOS helloworld-lib64_macOS printf-example64_macOS librecord.dylib write-records64_macOSDyn 

helloworld-nolib64_macOS: helloworld-nolib64_macOS.o 
	ld -static -e _start -o $@ $<

helloworld-lib64_macOS: helloworld-lib64_macOS.o
	ld $(INCLUDES) -e _start -o $@ $<

printf-example64_macOS: printf-example64_macOS.o 
	ld $(INCLUDES) -e _start -o $@ $<

librecord.dylib:
	ld -e _start -dylib -o $@ $(INCLUDES) $(OBJECTS) 

#write-records64_macOSDyn: 
#	ld -e _start -o $@ $(INCLUDES) -L. -lrecord $(OBJECTS)           # <- The order here is important

write-records64_macOSDyn: 
	ld -e _start $(INCLUDES) -L . -lrecord -o $@ $(OBJECTS1)

clean:
	rm -f helloworld-nolib64_macOS helloworld-lib64_macOS printf-example64_macOS write-records64_macOSDyn librecord.dylib -f ./??*.o ./??*.dat
