#include "low_level.h"

//MAIN===========
int main(void){
        print(0xd4ac0d,"Currently in C kernel");

        return 0;
}
/*
the fact that there is more than one element means the start
point of the compiled asm binary may not be main() but some 
other element.

[extern main]   ; in 32 bit pm section of boots.asm
                ;informs compiler that external symbol will
                ; referenced.
call main       ;  to invoke main from boots
*/



