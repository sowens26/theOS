
gdt_start:

gdt_null: ; mando null descriptor
    dd 0x0 ; define double word, double 2byte, 4byte. define it as 0
    dd 0x0 ; do this twice to get 8 byte 0s 

gdt_code:
    ;    base=0x0, limit = 0xfffff,
    ;   1st flags: (present)1 (priveledge)00 (descriptor type)1 -> 1001b
    ;   type flags: (code)1 (conforming)0 (readable)1 (accessed)0 ->1010b
    ;   2nd flags: (granularity)1 (32 bit default)1 (64 bit seg)0 (AVL)0 -> 1100b
    dw 0xffff ; limit bits 0-15
    dw 0x0 ; base bits 0-15
    db 0x0 ; base bits 16-23
    db 10011010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, limit bits 16-19
    db 0x0 ; base bits 24-31

gdt_data: ; same as above except type flags
    ;       ;   type flags: (code)1 (conforming)0 (readable)1 (accessed)0 ->1010b

    dw 0xffff ; limit bits 0-15
    dw 0x0 ; base bits 0-15
    db 0x0 ; base bits 16-23
    db 10010010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, limit bits 16-19
    db 0x0 ; base bits 24-31

gdt_end:    ;used to calculate size

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size of gdt, -1 because index from 0
    dd gdt_start    ; start address of our gdt

CODE_SEGMENT equ gdt_code - gdt_start ; label for offset of code 
DATA_SEGMENT equ gdt_data - gdt_start ; label for offset of data
