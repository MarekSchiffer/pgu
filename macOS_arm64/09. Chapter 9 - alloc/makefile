testAlloc_arm64: testAlloc_arm64.o alloc_arm64.o
	ld -o testAlloc_arm64 testAlloc_arm64.o alloc_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

testAlloc_arm64.o: testAlloc_arm64.s
	as -arch arm64 testAlloc_arm64.s -o testAlloc_arm64.o
alloc_arm64.o: alloc_arm64.s
	as -arch arm64 alloc_arm64.s -o alloc_arm64.o

