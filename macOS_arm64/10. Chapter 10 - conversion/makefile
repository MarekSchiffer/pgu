
conversion-programm_arm64: conversion-programm_arm64.o interger-to-string_arm64.o
	ld -o conversion-programm_arm64  conversion-programm_arm64.o interger-to-string_arm64.o ../06.\ Chapter\ 6\ -\ Records/count-char_arm64.o ../06.\ Chapter\ 6\ -\ Records/write-newline_arm64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64	


conversion-programm_arm64.o: conversion-programm_arm64.s
	as -arch arm64 conversion-programm_arm64.s -o conversion-programm_arm64.o

interger-to-string_arm64.o: interger-to-string_arm64.s 
	as -arch arm64 interger-to-string_arm64.s -o interger-to-string_arm64.o  
