#ifndef low_level_include
#define low_level_include
#include "low_level.c"
unsigned char port_byte_in(unsigned short);
unsigned short port_word_in(unsigned short);
void port_byte_out(unsigned short, unsigned char);
void port_word_out(unsigned short, unsigned short);
void print(int, const char*);

#endif