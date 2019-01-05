printHex:
    pusha
    mov cx, 0x0004
char_loop:
    dec cx ; decrement
    mov ax, dx  ; make copy for later
    shr dx, 4 ;shift right 4
    and ax, 0xf ; mask ah to get the last 4 bits

    mov bx, hex ; set bx to addr hex
    add bx, 2 ; skip 0x
    add bx, cx ; add counter to address to get current char

    cmp ax, 0xa ; if less go straight to setChar
    jl setChar
    add al, 0x27 ; otherwise add 27h because letters come after numbers in ascii
    jl setChar ; after adding the 27h you then need to setchar
setChar:
    add al, 0x30 ; ascii numbers start at 30h
    mov byte  [bx], al ; add value of the char to the byte at bx
    cmp cx, 0 ; is counter 0
    je printHexDone
    jmp char_loop; if no keep looping
printHexDone:
    mov bx, hex
    call printString
    popa
    ret

hex: db '0x0000', 0