all: write-records_arm64 read-records_arm64 add-year_arm64

write-records_arm64: write-records_arm64.o write-record_arm64.o
	ld -o write-records_arm64 write-records_arm64.o write-record_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start

read-records_arm64: read-records_arm64.o read-record_arm64.o count-char_arm64.o write-newline_arm64.o
	ld -o read-records_arm64 read-records_arm64.o read-record_arm64.o write-newline_arm64.o count-char_arm64.o  -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start1

add-year_arm64: read-record_arm64.o write-record_arm64.o add-year_arm64.o
	ld -o add-year_arm64 read-record_arm64.o write-record_arm64.o add-year_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start2


write-records_arm64.o: write-records_arm64.s
	as -arch arm64 write-records_arm64.s -o write-records_arm64.o

write-record_arm64.o: write-record_arm64.s
	as -arch arm64 write-record_arm64.s -o write-record_arm64.o

read-records_arm64.o: read-records_arm64.s
	as -arch arm64 read-records_arm64.s -o read-records_arm64.o

read-record_arm64.o: read-record_arm64.s
	as -arch arm64 read-record_arm64.s -o read-record_arm64.o

count-char_arm64.o: count-char_arm64.s
	as -arch arm64 count-char_arm64.s -o count-char_arm64.o

write-newline_arm64.o: write-newline_arm64.s
	as -arch arm64 write-newline_arm64.s -o write-newline_arm64.o

add-year_arm64.o: add-year_arm64.s
	as -arch arm64 add-year_arm64.s -o add-year_arm64.o


