add-year-error_arm64: add-year-error_arm64.o error-exit_arm64.o
	ld -o add-year-error_arm64 add-year-error_arm64.o error-exit_arm64.o ../06.\ Chapter\ 6\ -\ Records/write-newline_arm64.o ../06.\ Chapter\ 6\ -\ Records/read-record_arm64.o ../06.\ Chapter\ 6\ -\ Records/write-record_arm64.o ../06.\ Chapter\ 6\ -\ Records/count-char_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

add-year-error_arm64.o: add-year-error_arm64.s
	as -arch arm64 add-year-error_arm64.s -o add-year-error_arm64.o
