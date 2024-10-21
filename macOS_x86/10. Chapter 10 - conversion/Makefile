SOURCE := conversion-program64_macOS.s
TARGET := $(basename $(SOURCE))
OBJECT := $(TARGET).o

OBJECTS :=  ../06.\ Chapter\ 6\ -\ Records/count-chars64_macOS.o  \
			../06.\ Chapter\ 6\ -\ Records/write-newline64_macOS.o \
			../06.\ Chapter\ 6\ -\ Records/read-record64_macOS.o

$(TARGET): $(OBJECT) interger-to-string64_macOS.o  
	ld -static -e _start -o $@ $(OBJECTS) $^

%.o: %.s
	as -arch x86_64 -o $@ $<

clean:
	rm -f $(TARGET) ./??*.o
