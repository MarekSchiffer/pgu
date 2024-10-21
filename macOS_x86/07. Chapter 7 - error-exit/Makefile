SOURCE  := error-exit64_macOS.s
TARGET  := $(basename $(SOURCE))
OBJECT  := $(TARGET).o

INCLUDES := ../06.\ Chapter\ 6\ -\ Records/count-chars64_macOS.o  \
			../06.\ Chapter\ 6\ -\ Records/write-newline64_macOS.o \
			../06.\ Chapter\ 6\ -\ Records/read-record64_macOS.o \
			../06.\ Chapter\ 6\ -\ Records/write-record64_macOS.o \
			


all: $(TARGET)
#ld -arch x86_64 -e _start -static add-year_error64_macOS.o error-exit64_macOS.o ../06.\ Chapter\ 6\ -\ Records/count-chars64_macOS.o ../06.\ Chapter\ 6\ -\ Records/write-record64_macOS.o ../06.\ Chapter\ 6\ -\ Records/read-record64_macOS.o ../06.\ Chapter\ 6\ -\ Records/write-newline64_macOS.o -o add-year_error64_macOS

$(TARGET): $(OBJECT) add-year_error64_macOS.o
	ld -static -e _start $(INCLUDES) -o $@ $^

#$(TARGET1): $(OBJECT1)
#	ld -static -e _start $(INCLUDES) -o $@ $<

%.o: %.s
	as -arch x86_64 -o $@ $<

clean:
	rm -f $(TARGET) ./??*.dat ./??*.o
