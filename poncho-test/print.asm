printString: 
  mov ah, 0x0e   ; moving value to the higher part of the EAX register, tty mode
  .loop:
    cmp [bx], byte 0
    je .exit
      mov al, [bx]
      int 0x10
      inc bx
      jmp .loop
  .exit:
  ret

testString: 
  db 'This is a test string', 0   ; important to add the null byte at the end or the program will keep reading the garbage values
