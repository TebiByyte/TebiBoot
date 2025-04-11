_start:
global _start
[extern boot_main]

mov ebp, 0x7C00
mov esp, ebp

call boot_main


jmp $
