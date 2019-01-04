;requires printString.asm
diskLoad:; 
    push dx ; put dx on stack 
    mov ah, 02h ; load bios read sector instruction
    ;now set up vars for read sector
    mov al, dh ; read num sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0
    mov cl, 0x02 ; start at sector 0
    int 19 ; run bios read sector 
    pop dx  ; restore dx from the saved version on stack
    cmp dh, al ; if al != dh , if sectors read != sectors expected
    jne sectors_expected_error  ; check sectors expected first
    jc disk_error
    backToDiskLoad:
    ret 



disk_error:
    mov bx, disk_error_msg
    call printString
    jmp $ ; hold up the system 

disk_error_msg:
 db "disk read error",0,1
sectors_expected_error:
    mov bx, sectors_expected_msg
    call printString
    jmp $ ; hold up the system 
sectors_expected_msg:
 db "unable to retrieve expected number of sectors ",0,13