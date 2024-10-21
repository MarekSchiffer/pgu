INCLUDES := ../06.\ Chapter\ 6\ -\ Records/write-newline_arm64.o \
			../06.\ Chapter\ 6\ -\ Records/read-record_arm64.o \
			../06.\ Chapter\ 6\ -\ Records/write-record_arm64.o \
			../06.\ Chapter\ 6\ -\ Records/count-char_arm64.o

add-year-error_arm64: add-year-error_arm64.o error-exit_arm64.o
	ld -e _start -arch arm64 -o $@ $^ $(INCLUDES)

%.o: %.s
	as -arch arm64 -o $@ $^

clean: 
	rm -f add-year-error_arm64 ./??*.o
