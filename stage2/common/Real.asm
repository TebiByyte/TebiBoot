global interrupt_call
;This code is inspired by Limine's real mode interrupt routine:
;https://github.com/limine-bootloader/limine/blob/v9.x/common/lib/real.s2.asm_bios_ia32

;void interrupt_call(uint8_t int_num, regs *in_regs, regs *out_regs);
;ebx, esi, edi, ebp, and esp are scratch registers

;uint32_t eax;
;uint32_t ebx;
;uint32_t ecx;
;uint32_t edx;
;uint32_t esi;
;uint32_t edi;
;uint32_t ebp;
;uint32_t eflags;
;uint16_t ds;
;uint16_t gs;
;uint16_t fs;
;uint16_t es;
interrupt_call:

;Self modifying code. The INT instruction only takes an imm8
;GDTR -> 00007c7d 00000017
mov al, byte [esp + 4]
mov byte [int_num], al

mov eax, dword [esp + 8]
mov [in_regs], eax

mov eax, dword [esp + 12]
mov [out_regs], eax

sgdt [gdt_save]
sidt [idt_save]
lidt [rm_idt]

push ebx
push esi
push edi
push ebp

lgdt [GDT16.ptr]

jmp 0x08:bits16

bits16:
[bits 16]
mov eax, cr0
and al, 0xfe
mov cr0, eax

jmp 0x0:cszero

cszero:
mov dword [esp_save], esp
mov esp, dword [in_regs]
xor ax, ax
mov ss, ax

pop eax
pop ebx
pop ecx
pop edx
pop esi
pop edi
pop esi
pop ebp
popfd
pop ds
pop gs
pop fs
pop es
mov esp, dword[esp_save]

sti

db 0xcd
int_num:
db 0

cli

mov dword [esp_save], esp
mov esp, dword [out_regs]
lea esp, [esp + 10 * 4]

push es
push fs
push gs
push ds
pushfd
push ebp
push esi
push edi
push edx
push ecx
push ebx
push eax
mov esp, [esp_save]

lgdt [gdt_save] ;00007c7d 00000017
lidt [idt_save]

mov eax, cr0
or eax, 0x1
mov cr0, eax

jmp 0x08:pm_return

pm_return:
[bits 32]
mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

pop ebp
pop edi
pop esi
pop ebx

ret

align 16
esp_save:
dd 0
in_regs:
dd 0
out_regs:
dd 0
gdt_save:
dq 0
idt_save:
dq 0
rm_idt:
dw 0x3FF
dd 0


GDT16:
.null:
dq 0
.code:
dw 0xFFFF
dw 0x0000
db 0x00
db 0b10011011
db 0b10001111
db 0x00
.data:
dw 0xFFFF
dw 0x0000
db 0x00
db 0b10010011
db 0b10001111
db 0x00
.gdtend:

.ptr:
dw $ - GDT16 - 1
dd GDT16
