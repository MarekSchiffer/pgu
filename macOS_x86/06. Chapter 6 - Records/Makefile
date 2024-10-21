all: read-records64_macOS write-records64_macOS add-year64_macOS

write-records64_macOS:  write-records64_macOS.o write-record64_macOS.o
	ld -static -e _start -o $@ $^

read-records64_macOS: read-records64_macOS.o read-record64_macOS.o count-chars64_macOS.o write-newline64_macOS.o
	ld -static -e _start -o $@ $^

add-year64_macOS: add-year64_macOS.o read-record64_macOS.o write-record64_macOS.o
	ld -static -e _start -o $@ $^

%.o: %.s
	as -arch x86_64 -o $@ $<

clean:
	rm -f write-records64_macOS read-records64_macOS add-year64_macOS ./??*.dat ./??*.o
