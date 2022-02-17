## Legacy Booting
BIOS loads the first sector of each bootable device into memory at location 0x7C00

BIOS checks for 0xAA55 signature

If found, it starts executing the instructions

## EFI 
BIOS looks for certain EFI partition

The operating system must be compiled as an EFI

