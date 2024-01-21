ld -dylib -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` ../06.\ Chapter\ 6\ -\ Records/read-record_arm64.o ../06.\ Chapter\ 6\ -\ Records/write-record_arm64.o -o librecord.dylib

ld -o write-records_arm64Dyn -e _start -lrecord -L . ../06.\ Chapter\ 6\ -\ Records/write-records_arm64.o
