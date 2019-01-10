[org 0x7c00] ; set loadsite

;need to build BPB to boot on physical pc
;becuase of use of usb emulated floppy
;this section would need to be altered for alternative
;boot methods
boot:   ;I need to study this topic more
        ;I'd like to play with moving this around to different files
    jmp INIT_OS;
    times 3-($-$$) db 0x90 ; 2or3 byte encoded jmp support
    ;DOS 4.0 EBPB 1.44MB floppy
    OEMname:    db  "mkfs.fat" ; mkdosfs uses mkfs.fat
    bytesPerSector: dw 512
    sectPerCluster: db 1
    reservedSectors: dw 1
    numFAT:    db 2
    numRootDirEntries: dw 224
    numSectors: dw 2880
    mediaType: db 0xf0
    numFATsectors: dw 9
    sectorsPerTrack: dw 18
    numHeads: dw 2
    numHiddenSectors: dd 0
    numSectorsHuge: dd 0
    driveNum: db 0
    reserved: db 0
    signature: db 0x29
    volumeID: dd 0x2d7e5a1a
    volumeLabel: db "NO NAME    "
    fileSysType: db "FAT12  "
INIT_OS:
    xor ax, ax
;   mov cs, ax  ; DO NOT DO THIS
                ; CODE SEGMENT MUST REMAIN INTACT
    mov ds, ax ; data seg
    mov ss, ax  ;stack seg
    mov es, ax  ;extra seg

    mov [boot_device], dl ; get boot device loadsite from bios
    mov bp, 0x7c00 ; set stack base below loadsite
    mov sp, bp ;set stack = bottom == empty stack

    mov bx, REAL_MODE_MSG; print realModeMsg
    call printString

    call loadKernel; load c kernel
    call switch_to_32pm
    jmp $

%include "funcs/diskLoad.asm"
%include "funcs/printString.asm"
%include "funcs/switch_to_32pm.asm" 
%include "funcs/gdt.asm"

REAL_MODE_MSG:
   db ":: 16 bit real mode ::",10,13, 0
PM_MSG:
     db ":: 32 bit protected mode ::",10,13, 0
LOAD_KERNEL_MSG:
    db "Kernel loading", 10,13, 0
boot_device:
    db 0

KERNEL_OFFSET equ 0x1000

[bits 16]
loadKernel:
    mov bx, LOAD_KERNEL_MSG
    call printString

    mov bx, KERNEL_OFFSET
    call printString
    mov dh, 1 ; first sectors excluding boot sector
            ; only loading 1 for now bc kernel should be less than 1 sector
            ; when booting on hardware all necessary data will get loaded
            ; on emulation the live image will only have the minimum required
            ; number of sectors unless otherwise specified /
            ; trying to load more will cause disk error in emulation
    mov dl, [boot_device]
    call diskLoad
    ret

[bits 32]
begin_32pm:
    cli
    call KERNEL_OFFSET
    ;mov ebx, PM_MSG    ; not printing anything bc it will just be  
    ;call printStringPM     ; overwritten by kernel
    jmp $


times 510 - ($-$$) db 0 
dw 0xaa55


