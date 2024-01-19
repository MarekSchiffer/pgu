.equ record_firstname, 0     // Firstname 0-40 bytes
.equ record_lastname, 40     // Lastname 40-80 bytes
.equ record_address, 80      // Address 80-320 bytes => 240 bytes
.equ record_age, 320	     // Age 320-324 bytes => 4 bytes
.equ record_size, 324        // Size is 40+40+240+4 = 324 It's more a partition.
