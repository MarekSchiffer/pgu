all: helloworld-nolib_arm64 helloworld-lib_arm64

#write-records_arm64Dyn: librecord.dylib
#	ld -o write-records_arm64Dyn -macos_version_min 14.0 -e _start -L . -lrecord ../06.\ Chapter\ 6\ -\ Records/write-records_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -arch arm64 -o librecord.dylib

helloworld-nolib_arm64: helloworld-nolib_arm64.o
	ld -o helloworld-nolib_arm64 helloworld-nolib_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start2

helloworld-lib_arm64: helloworld-lib_arm64.o
	ld -o helloworld-lib_arm64 helloworld-lib_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start1

helloworld-nolib_arm64.o: helloworld-nolib_arm64.s
	as -arch arm64 helloworld-nolib_arm64.s -o helloworld-nolib_arm64.o

helloworld-lib_arm64.o: helloworld-lib_arm64.s
	as -arch arm64 helloworld-lib_arm64.s -o helloworld-lib_arm64.o

#librecord.dylib: 
#	ld -dylib -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` ../06.\ Chapter\ 6\ -\ Records/read-record_arm64.o ../06.\ Chapter\ 6\ -\ Records/write-record_arm64.o -o librecord.dylib
