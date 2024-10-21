SOURCE := factorial64_arm64.s
TARGET := $(basename $(SOURCE))
OBJECT := $(TARGET).o

$(TARGET): $(OBJECT)
	ld -e _start -o $@ $<

%.o: %.s
	as -arch arm64 -o $@ $<

clean:
	rm -f $(TARGET) ./??*.o
