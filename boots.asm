;
; A boot sector that prints a string using our function.
;
[org 0x7c00] ; Tell the assembler where this code will be loaded

boot:
    jmp main
    TIMES 3-($-$$) DB 0x90   ; Support 2 or 3 byte encoded JMPs before BPB.

    ; Dos 4.0 EBPB 1.44MB floppy
    OEMname:           db    "mkfs.fat"  ; mkfs.fat is what OEMname mkdosfs uses
    bytesPerSector:    dw    512
    sectPerCluster:    db    1
    reservedSectors:   dw    1
    numFAT:            db    2
    numRootDirEntries: dw    224
    numSectors:        dw    2880
    mediaType:         db    0xf0
    numFATsectors:     dw    9
    sectorsPerTrack:   dw    18
    numHeads:          dw    2
    numHiddenSectors:  dd    0
    numSectorsHuge:    dd    0
    driveNum:          db    0
    reserved:          db    0
    signature:         db    0x29
    volumeID:          dd    0x2d7e5a1a
    volumeLabel:       db    "NO NAME    "
    fileSysType:       db    "FAT12   "

main:
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov [boot_device], dl ; BIOS stores boot drive in dl hold it for later 
	
	mov bp, 0x8000 ; set stack load site
	mov sp, bp ; set top to bottom eg empty stack
	
	;set params for diskLoad bx
	mov bx, 0x9000 ; set loadsite for drive
	mov dh, 4 ; num sectors = 5
	mov dl, [boot_device]
	call diskLoad


	mov dx, [9000h]	;	print first loaded word
	call printHex

	mov dx, [0x9200] ; print 1st word from second loaded sector
	call printHex

	mov dx, [0x9400] ; print 1st word from third loaded sector
	call printHex
	
	mov dx, [0x9600] ; print 1st word from fourth loaded sector
	call printHex
	call newline
	mov bx, msg
	call printString
msg:
	db "Welcome to TheOS",10,13,0 ; newline, carriage return, null terminus
	
	jmp $
	; Data
boot_device:
	db 0
%include "printString.asm"
%include "printHex.asm"
%include "diskLoad.asm"
	;padding	
times 510-($-$$) db 0
dw 0xaa55

;load some sectors after this code to be read
times 256 dw 0xdada	; 4char hex or 16bit word or 2byte word 256 times
times 256 dw 0xface	; gives total of 512 bytes to fill one drive sector
times 256 dw 0xadac
times 256 dw 0xdeed
