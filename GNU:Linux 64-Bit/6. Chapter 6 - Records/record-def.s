.equ RECORD_FIRSTNAME, 0     # Firstname 0-40 bytes
.equ RECORD_LASTNAME, 40     # Lastname 40-80 bytes
.equ RECORD_ADDRESS, 80      # Address 80-320 bytes => 240 bytes
.equ RECORD_AGE, 320	     # Age 320-324 bytes => 4 bytes
.equ RECORD_SIZE, 324        # Size is 40+40+240+4 = 324 It's more a partition.
