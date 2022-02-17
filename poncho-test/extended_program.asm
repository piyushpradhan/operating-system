[org 0x7e00]                      ; setting a different origin - different memory space

jmp enterProtectedMode

%include "gdt.asm"
%include "print.asm"
%include "cpu_id.asm"

; Enter 32-bit protected mode
enterProtectedMode:
  ; disable interrupts
  ; enable a20 line
  ; load GDT
  ; set GDT in a register so that CPU can track it
  call enableA20
  cli                              ; disable interrupts
  lgdt [gdt_descriptor]            ; load GDT

  mov eax, cr0                     ; set GDT, to let CPU know that it's in protected mode
  or eax, 1
  mov cr0, eax

  jmp codeseg:startProtectedMode

enableA20:                         ; enable A20 line for backward compatibility 
  in al, 0x92
  or al, 2 
  out 0x92, al
  ret

; flushing CPU
[bits 32]

; making a far jump to codesegment to flush the CPU
; the CPU may do multiple tasks at once which may hinder
; entering into the protected mode, so make a far jump to flush the CPU

startProtectedMode: 
  ; point the new registers to the new data we defined in the GDT
  mov ax, dataseg
  mov dx, ax
  mov ss, ax
  mov es, ax 
  mov fs, ax
  mov gs, ax

  ; to create more space for the stack 
  ; mov ebp, 0x90000
  ; mov esp, ebp

  ; moving 'H' to video memory to print it
  ; older print function won't work anymore
  ; address of the video memory is 0xb8000
  mov [0xb8000], byte 'H'
  mov [0xb8002], byte 'e'
  mov [0xb8004], byte 'l'
  mov [0xb8006], byte 'l'
  mov [0xb8008], byte 'o'
  mov [0xb8010], byte ' '
  mov [0xb8012], byte 'A'
  mov [0xb8014], byte 'S'
  mov [0xb8016], byte 'M'

  call detectCPUId
  call detectLongMode
  jmp $

times 2048-($-$$) db 0
