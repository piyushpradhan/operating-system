mov ah, 0x0e ; tty mode

mov bp, 0x8000 ; address far away from 0x7c00 (where BIOS is stored) to prevent overwiting
mov sp, bp ; if the stack is empty then sp points to bp

push 'A'
push 'B'
push 'C'

; to show how the stack grows downwards
mov al, [0x7ffe] 
int 0x10

mov al, [0x8000] 
int 0x10

pop bx ; recovering the characters pushed onto the stack
mov al, bl
int 0x10 ; prints C

pop bx
mov al, bl
int 0x10 ; prints B

pop bx
mov al, bl
int 0x10 ; prints A 

mov al, [0x8000]
int 0x10

jmp $ ; infinite loop

times 510 - ($-$$) db 0
dw 0xaa55
