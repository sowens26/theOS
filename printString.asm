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
	

