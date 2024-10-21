INCLUDES := -macosx_version_min 12.0 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem

OBJECTS :=  ../06.\ Chapter\ 6\ -\ Records/count-chars64_macOS.o  \
			../06.\ Chapter\ 6\ -\ Records/write-newline64_macOS.o \
			../06.\ Chapter\ 6\ -\ Records/read-record64_macOS.o

all: TestAllocator read-records64_macOS_alloc

TestAllocator: TestAllocator.o alloc64_macOS.o
	ld -e _start $(INCLUDES) -o $@ $^

read-records64_macOS_alloc: read-records64_macOS_alloc.o alloc64_macOS.o 
	ld $(INCLUDES) -e _start -o $@ $(OBJECTS) $^

%.o: %.s
	as -arch x86_64 -o $@ $<

clean: 
	rm -f TestAllocator alloc64_macOS read-records64_macOS_alloc ./??*.o ./??*.dat
