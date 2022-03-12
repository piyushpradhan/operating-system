[org 0x7e00]                      ; setting a different origin - different memory space

jmp enterProtectedMode

%include "gdt.asm"
%include "print.asm"

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

%include "cpu_id.asm"
%include "simplePaging.asm"

; making a far jump to codesegment to flush the CPU
; the CPU may do multiple tasks at once which may hinder
; entering into the protected mode, so make a far jump to flush the CPU

startProtectedMode: 
  ; point the new registers to the new data we defined in the GDT
  ; update the segment registers
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
  call setUpIdentityPaging
  call editGDT
  jmp codeseg:start64bit

[bits 64]

start64bit: 
  ; setting the destination address to video memory
  mov edi, 0xb8000
  ; hexadecimal representing...
  ; 1f20 : '20' is a space (' ')
  ; 1f : is a color code, (0x1f is white/blue)
  mov rax, 0x1f201f201f201f20
  mov ecx, 500 
  ; this will copy the value of rax register into video memory
  ; 500 times, each time executing the rep command
  rep stosq  
  jmp $

times 2048-($-$$) db 0
