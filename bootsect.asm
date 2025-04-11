[org 0x7c00]
[bits 16]
jmp start

;TODO include other data here

start:
cli
jmp 0x0000:initcs

initcs: 
mov ax, 0
mov ss, ax
mov ds, ax
mov gs, ax
mov es, ax
mov fs, ax
sti
mov sp, 0x7c00
mov [drv_num_cache], dl
;Check for the existence of int 13h extensions
mov ah, 0x41
mov bx, 0x55aa
mov dl, 0x80
int 0x13
jc error
cmp bx, 0xaa55
jne error.nointext
;Read stage2
mov byte [disk_struct], 0x10
mov byte [disk_struct + 1], 0
mov ax, [stage2_size]
mov [disk_struct + 2], ax
mov dword [disk_struct + 4], 0x8000 ;buffer
mov dword [disk_struct + 8], 1
mov dword [disk_struct + 12], 0
mov si, disk_struct
mov ah, 0x42
mov dl, [drv_num_cache]
int 0x13
jc error.loaderror
;Switch to protected mode
cli

lgdt [GDT.ptr]
mov eax, 0xdead
mov eax, cr0
or eax, 0x1
mov cr0, eax

jmp 0x08:pm_load

GDT:
.null:
dq 0
.code:
dw 0xFFFF
dw 0x0000
db 0x00
db 0b10011011
db 0b11001111
db 0x00
.data:
dw 0xFFFF
dw 0x0000
db 0x00
db 0b10010011
db 0b11001111
db 0x00
.gdtend:

.ptr:
dw $ - GDT - 1
dd GDT

[bits 32]
pm_load:
mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

jmp 0x8000


[bits 16]

error:
.nointext:
mov si, 0x0001
jmp nocontinue
.loaderror:
mov si, 0x0002
jmp nocontinue

nocontinue:
hlt
jmp nocontinue

drv_num_cache: db 0


;TODO change these during build process
stage2_loc: dw 0x1 ;LBA 1
stage2_size: dw 0x8 ;8 sectors
disk_struct equ 0x6000


times 510-($-$$) db 0 
dw 0xaa55
