#LIBS := -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch x86_64
toupper64_macOS: toupper64_macOS.o
	ld -static -e _start -o $@ $<

%.o: %.s
	as -arch x86_64 -o $@ $<

clean:
	rm -f toupper64_macOS -f ./??*.o
