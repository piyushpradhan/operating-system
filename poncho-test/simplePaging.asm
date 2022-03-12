; macro that represents the entry point of the table
; 0x1000 because if we start at 0x0000 then we may 
; overwrite some code at the beginning which we don't want to
PageTableEntry equ 0x1000

; four tables have to be setup in 64 bit mode to use paging
; PML4T[0] -> PDPT (Page Map Label 4 Table) 
; PDPT[0] -> PDT (Page Directory Pointer Table)
; PDT[0] -> PT (Page Directory Table) 
; PT -> 0x00000000 - 0x00200000 [2MB] (Page Table)
; these table have entries pointing to one another which helps 
; in determining which entry is mapped to which virtual address

setUpIdentityPaging:
    ; move that macro into the destination register
    mov edi, PageTableEntry
    ; move that address into the control register
    ; tells the memory management unit that page table is
    ; going to start at this address
    mov cr3, edi
    ; points to address of the second table
    ; set a few flags
    mov dword [edi], 0x2003
    add edi, 0x1000
    ; points to the next table
    mov dword [edi], 0x3003
    add edi, 0x1000
    ; points to the next table
    mov dword [edi], 0x4003
    add edi, 0x1000
    
    ; map 512 entries
    ; last table
    mov ebx, 0x00000003
    ; let the loop function know that we want to 
    ; loop 512 times and this will create 512 entries
    mov ecx, 512

    .setEntry: 
        mov dword[edi], ebx
        add ebx, 0x1000
        add edi, 8
        loop .setEntry

    ; activating physical address extension paging 
    ; setting the PAE bit in 4th control register

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; setting long mode bit in EFER, module specific register
    mov ecx, 0xC0000000
    ; reading from the register
    rmdsr
    ; changing the bit
    or eax, 1 << 8
    ; writing to the register
    wrmsr

    ; enabling paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret