nasm -f bin bootloader.asm -o bootloader.bin
nasm -f bin extended_program.asm -o extended_program.bin

copy bootloader.bin out.bin
type extended_program.bin >> out.bin
