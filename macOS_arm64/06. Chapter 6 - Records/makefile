all: write-records_arm64 read-records_arm64 add-year_arm64

write-records_arm64: write-records_arm64.o write-record_arm64.o
	ld -e _start -o $@ $^

read-records_arm64: read-records_arm64.o read-record_arm64.o count-char_arm64.o write-newline_arm64.o
	ld -e _start -o $@ $^

add-year_arm64: read-record_arm64.o write-record_arm64.o add-year_arm64.o
	ld -e _start -o $@ $^

%.o: %.s
	as -arch arm64 -o $@ $<

clean:
	rm -f write-records_arm64 read-records_arm64 add-year_arm64 ./??*.o
