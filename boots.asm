[org 0x7c00] ; set loadsite
KERNEL_OFFSET equ 0x1000
    xor ax, ax
;   mov cs, ax  ; DO NOT DO THIS, CODE SEGMENT MUST REMAIN INTACT
    mov ds, ax ; data
    mov ss, ax  ;stack
    mov es, ax  ;extra

    mov [boot_device], dl ; get boot device loadsite from bios
    mov bp, 0x7c00 ; set stack below loadsite
    mov sp, bp ; empty stack

    mov bx, REAL_MODE_MSG
    call printString
    call loadKernel
    call switch_to_32pm
    jmp $

%include "funcs/diskLoad.asm"
%include "funcs/printString.asm"
%include "funcs/switch_to_32pm.asm" 
%include "funcs/gdt.asm"



[bits 16]
loadKernel:
    mov bx, LOAD_KERNEL_MSG
    call printString

    mov bx, KERNEL_OFFSET
    call printString
    mov dh, 1 ; first # sectors excluding boot sector
    mov dl, [boot_device]
    call diskLoad
    ret

[bits 32]
begin_32pm:
    cli
    mov ebx, PM_MSG
    call printStringPM 
    call KERNEL_OFFSET
    jmp $

REAL_MODE_MSG:
   db ":: 16 bit real mode ::",10,13, 0
PM_MSG:
     db "32 bit protected mode",10,13, 0
LOAD_KERNEL_MSG:
    db "Kernel loading", 10,13, 0
boot_device:
    db 0

times 510 - ($-$$) db 0 
dw 0xaa55


