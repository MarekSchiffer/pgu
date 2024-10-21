SOURCE  := maximum64_macOS.s
SOURCE1 := maximum64_macOS_version2.s
TARGET  := $(basename $(SOURCE))
TARGET1 := $(basename $(SOURCE1))
OBJECT  := $(TARGET).o
OBJECT1  := $(TARGET1).o


all:  $(TARGET)  $(TARGET1)

$(TARGET): $(OBJECT)
	ld -static -e _start -o $@ $<

$(TARGET1): $(OBJECT1)
	ld -static -e _start -o $@ $<

%.o: %.s
	as -arch x86_64 -o $@ $<

clean:
	rm -f $(TARGET) $(TARGET1) ./??*.o
