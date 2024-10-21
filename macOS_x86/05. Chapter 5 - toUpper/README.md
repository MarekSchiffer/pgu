At the moment the toUpper can't be linked as static

Update 2023/2024. Now it can ONLY be linked as static. Well, I guess it could
be linked against the macOS crap, but then you need to follow the modern
x86_64 calling convention via registers (%rsi).

We do that in the arm64 case, because it's necessary.

The stack alignment has changed from 2021 to 2023, on the same machine mind you!
Stack now doesn't have to be 16 aligned (like in arm64) and there is no padding.
The old numbers are still in the file in case somebody needs them.

The stack alignment has changed from 2021 to 2023, on the same machine, mind you! The stack now doesn't have to be 16-byte aligned (like in arm64), and there is no padding. The old numbers are still in the file in case somebody needs them.

| Year | ST_SIZE_RESERVE | ST_FD_IN | ST_FD_OUT | ST_ARGC | ST_ARGV_0 | ST_ARGV_1 | ST_ARGV_2 |
|------|------------------|----------|-----------|---------|------------|------------|------------|
| 2020 | .equ 32          | -16      | -32       | 24      | 32         | 40         | 48         |
| 2023 | .equ 16          | -8       | -16       | 0       | 8          | 16         | 24         |

| <center>2020</center>                     | <center>2023</center>                   |
|------------------------------------------|------------------------------------------|
| .equ ST_SIZE_RESERVE, 32                 | .equ ST_SIZE_RESERVE, 16                 |
| .equ ST_FD_IN, -16                        | .equ ST_FD_IN, -8                       |
| .equ ST_FD_OUT, -32                       | .equ ST_FD_OUT, -16                     |
| .equ ST_ARGC, 24                          | .equ ST_ARGC, 0                         |
| .equ ST_ARGV_0, 32                        | .equ ST_ARGV_0, 8                       |
| .equ ST_ARGV_1, 40                        | .equ ST_ARGV_1, 16                      |
| .equ ST_ARGV_2, 48                        | .equ ST_ARGV_2, 24                      |

Note from 2020, no obsolete!

We need:
Note from 2020, no obsolete!
```
        2020:                                2023:
.equ ST_SIZE_RESERVE, 32          .equ ST_SIZE_RESERVE, 16
.equ ST_FD_IN, -16                .equ ST_FD_IN, -8
.equ ST_FD_OUT, -32               .equ ST_FD_OUT, -16
.equ ST_ARGC, 24                  .equ ST_ARGC, 0
.equ ST_ARGV_0, 32                .equ ST_ARGV_0, 8
.equ ST_ARGV_1, 40                .equ ST_ARGV_1, 16
.equ ST_ARGV_2, 48                .equ ST_ARGV_2, 24

```
Note from 2020, no obsolete!

We need

```
ld -macosx_version_min 11.0 -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem -e _start toupper64_macOS.o -o toupper64_macOS

Also it seems that filenames are a problem
/toupper64_macOS BobDylanIAM.txt out.txt

But
/toupper64_macOS ./BobDylanIAM.txt out.txt

Does not!

To Do: Find out why!
```
