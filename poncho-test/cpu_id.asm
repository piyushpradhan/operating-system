detectCPUId: 
  ; copy the bit to the flag register
  ; flip the bit and if it stays flipped 
  ; the CPUID is available
  pushfd                  ; moving the flag to the stack
  pop eax                 ; popping the value into eax register

  mov ecx, eax            ; setting the value of eax into ecx to comparison
  xor eax, 1 << 21        ; flipping the bit

  push eax                ; pushing it onto the stack
  popfd                   ; popping it back into the flag

  pushfd
  pop eax                 ; flipped (new) value of the flag 

  push ecx                ; pushing ecx to stack to use it for comparison (the old value)
  popfd

  xor eax, ecx
  jz noCPUId
  ret

; checking for Long Mode support
detectLongMode: 
  mov eax, 0x80000001
  cpuid
  test edx, 1 << 29       ; checking if the bit is flipped for long mode support
  jz noLongMode
  ret

noLongMode: 
  hlt                     ; no long mode

noCPUId: 
  hlt                     ; no CPU ID support
