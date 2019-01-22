#include "low_level.h"

unsigned char port_byte_in(unsigned short port ){
    //reads byte from port
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    //put reg dx in al // load dx with port, dump a into result after
    return result;
}
unsigned short port_word_in(unsigned short port ){
    //reads byte from port
    unsigned char result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    //put reg dx in al // load dx with port, dump a into result after
    return result;
}

void port_byte_out(unsigned short port, unsigned char data){
    //writes byte to port
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port)); //dump nothing 
    //load data 
}
void port_word_out(unsigned short port, unsigned short data){
    //writes byte to port
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port)); //dump nothing 
    //load data 
}


void print(int color, const char *string)
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


