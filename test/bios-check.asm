; Infinite loop (e9 fd ff)
loop: 
    jmp loop

; Filling with 510 zeroes minus the size of the previous code
times 510-($-$$) db 0
; Magic number
dw 0xaa55
