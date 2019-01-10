void writeString(int color, const char *string)
{        // *string is addr of 1st byte in string
        char* vga_mem = (char*)0xb8000;//init vga_mem to start locale 0xb8000
        while(*string != 0)//iterate so long as currently loaded char is not 0
        {               //( null terminus )
                *vga_mem++ = *string++; //place current char at current vga_mem site
                                        //increment each locale by 1 byte afterwards
                *vga_mem++ = color; //place color at 2nd byte to define color of char
                                //increment vga_mem to be ready to place next char
        }
}






//MAIN===========
int main(void){
        writeString(0xd4ac0d,"Currently in C kernel");
        return 0;
}
/*
the fact that there is more than one element makes the start
point of the compiled asm binary may not be main() but some 
other element.

[extern main]   ; in 32 bit pm section of boots.asm
                ;informs compiler that external symbol will
                ; referenced.
call main       ;  to invoke main from boots
*/



