TARGET1 := helloworld-nolib_arm64
TARGET2 := helloworld-lib_arm64
TARGET3 := printf-example_arm64
TARGET4 := librecord.dylib
TARGET5 := write-records_arm64Dyn 
LIBS := -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path`
INCLUDES := ../06.\ Chapter\ 6\ -\ Records/read-record_arm64.o  \
            ../06.\ Chapter\ 6\ -\ Records/write-record_arm64.o 
INCLUDES1 := ../06.\ Chapter\ 6\ -\ Records/write-records_arm64.o

all: $(TARGET1) $(TARGET2) $(TARGET3) $(TARGET5)

$(TARGET5): librecord.dylib
	ld -arch arm64 -e _start -L . -lrecord -o $@ $(INCLUDES1)

$(TARGET4):
	ld -dylib $(LIBS) $(INCLUDES) -o $@

$(TARGET1): helloworld-nolib_arm64.o
	ld -e _start -o $@ $<

$(TARGET2): helloworld-lib_arm64.o
	ld -e _start $(LIBS) -o $@ $<

$(TARGET3): printf-example_arm64.o
	ld -e _start $(LIBS) -o $@ $<

%.o: %.s
	as -arch arm64 -o $@ $<

clean:
	rm -f  $(TARGET1) $(TARGET2) $(TARGET3) $(TARGET4) $(TARGET5) ./??*.dat ./??*.o
