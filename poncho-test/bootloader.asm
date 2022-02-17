[org 0x7c00]      ; calculate the offset from 0x7c00

; when the program is loaded into the memory from BIOS
; the disk number from which it was loaded is stored in 
; 'dl' register, so we're storing it for later into BOOT_DISK
mov [BOOT_DISK], dl

mov bp, 0x7c00    ; this is the address where the bootloader loads into
mov sp, bp        ; setting up the stack pointer

mov bx, testString      ; moves the address of testString label into bx
call printString

call readDisk

jmp PROGRAM_SPACE       ; jump to the address of extended program

%include "print.asm"
%include "disk_read.asm"

times 510-($-$$) db 0
dw 0xaa55

