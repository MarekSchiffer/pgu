APPLECRAP := -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path`

SOURCE   := testAlloc_arm64.s
SOURCE1  := read-records_alloc_arm64.s 
TARGET   := $(basename $(SOURCE))
TARGET1  := $(basename $(SOURCE1))
OBJECT   := $(TARGET).o
OBJECT1  := $(TARGET1).o

INCLUDES :=  ../06.\ Chapter\ 6\ -\ Records/count-char_arm64.o \
			 ../06.\ Chapter\ 6\ -\ Records/read-record_arm64.o \
			 ../06.\ Chapter\ 6\ -\ Records/write-newline_arm64.o

all: $(TARGET) $(TARGET1)

$(TARGET): $(OBJECT) alloc_arm64.o
	ld -e _start -arch arm64 -o $@ $^ $(APPLECRAP) 

$(TARGET1): $(OBJECT1) alloc_arm64.o
	ld -e _start -arch arm64 -o $@ $(INCLUDES) $^ $(APPLECRAP) 

%.o: %.s
	as -arch arm64 -o $@ $<

#testAlloc_arm64.o: testAlloc_arm64.s
#	as -arch arm64 testAlloc_arm64.s -o testAlloc_arm64.o
#alloc_arm64.o: alloc_arm64.s
#	as -arch arm64 alloc_arm64.s -o alloc_arm64.o

clean:
	rm -f  $(TARGET) $(TARGET1) ./??*.o
