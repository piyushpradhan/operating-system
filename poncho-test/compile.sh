#!/bin/bash
nasm -f bin bootloader.asm -o bootloader.bin
nasm -f bin extended_program.asm -o extended_program.bin

cp bootloader.bin out.bin 
cat extended_program.bin >> out.bin
