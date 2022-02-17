; load 'dh' sectors from drive 'dl' into ES:BX
disk_load: 
  pusha
  push dx ; overwriting input parameters from 'dx' and saving it on the stack.

  mov ah, 0x02 ; 'ah' = 0x02 -> read
  mov al, dh ; number of sectors to read (0x01.. 0x80)
  mov cl, 0x02 ; 'cl' <- sector (0x01 .. 0x11)



