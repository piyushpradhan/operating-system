nasm -f bin bootloader.asm -o bootloader.bin
nasm -f bin extended_program.asm -o extended_program.bin

copy /b bootloader.bin+extended_program.bin bootloader.flp

qemu-system-x86_64.exe out.bin