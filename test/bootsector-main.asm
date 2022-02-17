; [org 0x07c00] ; tells the assembler that our offset is bootsector code

; the main routine makes sure the parameters are ready 
mov bx, HELLO
call print

call print_nl

mov bx, GOODBYE
call print

call print_nl

jmp $

; including subroutines below the hang
%include "bootsector-print.asm"

HELLO: 
  db 'Hello world', 0

GOODBYE: 
  db 'Goodbye', 0

; padding and magic number 
times 510 - ($-$$) db 0
dw 0xaa55
