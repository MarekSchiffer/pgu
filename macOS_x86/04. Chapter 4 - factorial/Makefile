SOURCE := factorial64_macOS.s
TARGET := $(basename $(SOURCE))
OBJECT := $(TARGET).o

$(TARGET): $(OBJECT)
	ld -static -e _start -o $@ $<

%.o: %.s
	as -arch x86_64 -o $@ $<

clean:
	rm -f $(TARGET) ./??*.o
