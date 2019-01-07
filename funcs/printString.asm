printString:
	pusha
string_loop:
	mov al, [bx]	
	cmp al, 0	; is current char = 0?
	jne printChar	; not print char
	jmp printStringDone
printChar:
	mov ah, 0x0e ; teletype printer
	int 16 ; print char
	add bx, 1 ; shift to next char
	jmp string_loop ; go back to string loop to print next char or end
printStringDone:
	popa
	ret


Hmsg:
	db 'hello',13,10,0 ; <-- 0=null terminus 13=carriageReturn 10=linefeed
Gmsg:
	db 'goodbye',13,10,0


newline: 

	mov bx, newlinecharacters
	call printString
	ret
newlinecharacters:
	db '  |',13,10,0

[bits 32]
VGA_MEM equ 0xb8000
WHITE_ON_BLACK equ 0x0f

printStringPM:
	pusha
	mov edx, VGA_MEM
printStringPM_loop:
	mov al, [ebx]	;	al char
	mov ah, WHITE_ON_BLACK ; ah attributes

	cmp al,0	; if char is 0 null terminus
	je printStringPM_done

	mov [edx],ax ; store char and attributes and current char cell 

	add ebx, 1	; increment to next char in string
	add edx, 2	; move to next char cell in vga mem

	jmp printStringPM_loop
printStringPM_done:
	popa
	ret
	

