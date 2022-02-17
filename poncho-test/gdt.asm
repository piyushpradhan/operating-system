gdt_nulldesc:
  dd 0
  dd 0

gdt_codedesc:
  dw 0xFFFF                             ; 16-bit limit 0xFFFF covers the entire memory
  dw 0x0000                             ; 16-bit base 0x0000 points the beginning (low)
  db 0x00                               ; 8-bit base 0x00 points to the beginning (medium)
  ; declaring the access byte, this one is tricky
  ; the acess byte is structured as: 
  ; Present bit(5) - Privilege[Kernel privilege (00)] - Descriptor Type[Code/Data (1)] - Executable bit [Code(1)] - Direction/confirming [Code(0)] - read/write bit (1) - access bit (0)
  ; CPU will set the Access bit to 1 when it is executed
  ; add 'b' to the end so the CPU knows that it's a byte
  db 10011010b
  ; declaring the flag
  ; flag is structures as follows: 
  ; Granularitly[4 KB block(1)] - Size [32 bit(1)] - 0 - 0 - Next four bytes are extension of limit, we'll setting it to one to get the max limit
  db 11001111b                          ; flag + upper limit
  db 0x00                               ; the base (high)

; only change the executable bit
gdt_datadesc:
  dw 0xFFFF                             ; 16-bit limit 0xFFFF covers the entire memory
  dw 0x0000                             ; 16-bit base 0x0000 points the beginning
  db 0x00                               ; 8-bit base 0x00 points to the beginning
  db 10010010b
  db 11001111b
  db 0x00                               ; the base

gdt_end: 

gdt_descriptor:                         ; holds the size of the offset
  get_size: 
    dw gdt_end - gdt_nulldesc - 1       ; it has to be 2 bytes so dw instead of db 
    dd gdt_nulldesc
  
; defining the addresses of the code and data segments
codeseg equ gdt_codedesc - gdt_nulldesc
dataseg equ gdt_datadesc - gdt_nulldesc
