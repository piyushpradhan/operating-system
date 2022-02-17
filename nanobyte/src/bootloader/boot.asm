org 0x7C00 ; tells the assembler to calculate values from the offset 0x7C00
bits 16 ; tells assembler to emit 16/32/64-bit code, backwards compatibility

%define ENDL 0x0D, 0x0A	; nasm macro for line end and carriage return

;
; FAT12 Headers
; The first three bytes must be a jump short instruction followed by a NOP
jmp short start
nop

bdb_oem: 					db 'MSWIN4.1'			; 8 bytes
; this value was found using hexeditor on the .img which had '00 02' set in Little Endian
; which means the original value is (0200) which is 512 in decimal
bdb_bytes_per_sector: 		dw 512
; All these values can be found in the wikipedia page of FAT12 file system
bdb_sector_per_cluster: 	db 1
bdb_reserved_sectors: 		dw 1
bdb_fat_count:				db 2
bdb_dir_entries_count:		dw 0E0h
bdb_total_sectors:			dw 2880
bdb_media_descriptor_type: 	db 0F0h
bdb_sectors_per_fat: 		dw 9
bdb_sectors_per_track: 		dw 18
bdb_heads: 					dw 2
bdb_hidden_sectors: 		dd 0
bdb_large_sector_count: 	dd 0

; extended boot record
ebr_drive_number: 			db 0
							db 0
ebr_signature: 				db 29h
ebr_volume_id:				db 12h, 34h, 56h, 78h
ebr_volume_label: 			db 'MYTESTSYSTM'
ebr_system_id:				db 'FAT12	'

;
; Code
;

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

;
; Disk Routine
;

; 
; Converts an LBA address to a CHS addres
; Parameters: 
;   ax: LBA address 
; Returns: 
;   cx: sector number 
;   cx: cylinder
;   dh: head

lba_to_chs: 

  push ax 
  push dx

  xor dx, dx                          ; dx = 0
  div word [bdb_sectors_per_track]    ; ax = LBA / SectorsPerTrack
                                      ; dx = LBA % SectorPerTrack

  inc dx                              ; dx = (LBA % SectorsPerTrack) + 1
  mov cx, dx                          ; cx = sector

  xor dx, dx                          ; dx = 0
  div word [bdb_heads]                ; ax = (LBA / SectorsPerTrack) / Heads = cylinder 
                                      ; dx = (LBA / SectorsPerTrack) % Heads = heads

  mov dh, dl                          ; dh = head
  mv ch, al                           ; ch = cylinder (lower 8 bits)
  shl ah, 6                           
  or cl, ah                           ; put upper 2 bits of cylinder in cl

  pop ax
  mov dl, al                          ; restore dl
  pop ax
  ret

; 
; Disk read
;
; Read sectors from a disk
; Parameters: 
;   - ax : LBA address 
;   - cl : number of sectors to read (up to 128)
;   - dl : drive number
;   - es:bx : memory address where to store read data

disk_read: 
  push cx

msg_hello: db "Hello assembly", ENDL, 0

; repeats the given instruction a given number of times
; $ -> beginning position of the current line 
; $$ -> beginning position of the current memory offset
times 510-($-$$) db 0
dw 0xaa55
