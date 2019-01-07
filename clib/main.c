int main(void){
        char* vga_mem = (char*) 0xb8000 ;// set pointer to beginning vga mem
        *vga_mem = 'X';
        return 0;
}

