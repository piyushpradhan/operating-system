mystring: 
  db 'Hello world', 0 ; 0 will be passed as a null byte to terminate the strings

cmp ax, 4 ; if ax == 4
je ax_is_four ; jump the label (ax_is_four)
jmp else ; do something else if the comparison failed
jmp endif ; finally, resume the normal flow

ax_is_four: 
  ... ; the code
  jmp endif

else: 
  .... ; the code
  jmp endif 

endif: 

