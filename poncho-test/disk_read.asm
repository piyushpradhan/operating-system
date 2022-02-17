PROGRAM_SPACE equ 0x7e00          ; whenever it is referenced it'll load it right after 0x7c00

readDisk: 

  mov ah, 0x02
  mov bx, PROGRAM_SPACE
  mov al, 4                       ; define the number of sectors to be loaded
  mov dl, [BOOT_DISK]             ; drive we want to read it from
  mov ch, 0x00                    ; cylinder to read from
  mov dh, 0x00                    ; disk to read from 
  mov cl, 0x02                    ; sector to read from, bootloader was in first sector

  int 0x13                        ; if it fails to read the disk it sets a special register
  jc diskReadFailed
  ret  

BOOT_DISK: 
  db 0

diskReadErrorString: 
  db 'Disk read failed', 0

diskReadFailed: 
  mov bx, diskReadErrorString
  call printString

  jmp $
