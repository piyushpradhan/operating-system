org 0x7C00 ; tells the assembler to calculate values from the offset 0x7C00
bits 16 ; tells assembler to emit 16/32/64-bit code, backwards compatibility

%define ENDL 0x0D, 0x0A	; nasm macro for line end and carriage return

start: 
	jmp main

; prints a string to the screen 
puts: 
	push si
	push ax

.loop: 
	lodsb	; loads the address of ds si registers into al reigster and then increments si
	or al, al   ; verify if the next character is null
	jz .done	; if the zero flag is set jump outside of the loop instruction

	mov ah, 0x0e	; setting it to tty mode 
	mov bh, 0	; setting the page number of the INT 10h
	int 0x10	; calling the INT 10h
	
	jmp .loop

.done: 
	pop ax
	pop si
	ret


main: 
	; setup data segments
	mov ax, 0	; using intermediary register to assign constant value to a register
	mov ds, ax
	mov es, ax

	; setup stack 
	mov ss, ax 
	mov sp, 0x7c00

	; print message 
	mov si, msg_hello
	call puts

	hlt ; halts the CPU from executing

.halt: 
	jmp .halt ; puts the CPU in inifite loop

msg_hello: db "Hello assembly", ENDL, 0

; repeats the given instruction a given number of times
; $ -> beginning position of the current line 
; $$ -> beginning position of the current memory offset
times 510-($-$$) db 0
dw 0xaa55
