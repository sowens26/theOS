
#THIS IS A SCRIPT TO COMPILE THE CODE AND BUILD THE IMAGE
#

#ccgcc and ccld are cross-compile-gcc and cross-compile-ld resepctively
#they were necessary because mac gcc(clang) does not support -Ttext or --oformat
#if you are on windows or linux you should be able to simply use your regular gcc toolkit


alias gcc="/usr/local/gcc-4.8.1-for-linux32/bin/i586-pc-linux-gcc"
alias ld="/usr/local/gcc-4.8.1-for-linux32/bin/i586-pc-linux-ld"

#compile bootload
nasm boots.asm -o boots.bin
#compile kernel-bootloader link
nasm kernel-boots.asm -f elf -o kernel-boots.o 
#compile kernel
gcc clib/kernel.c -c -ffreestanding -o kernel.o
#link kernel with kernel-bootloader link
ld -o kernel.bin -Ttext 0x1000 --oformat binary kernel-boots.o kernel.o
#write the actual image file
cat boots.bin kernel.bin > os-image
#clean up directory
rm *.o *.bin 

#dd if=os-image of=/dev/disk2 conv=notrunc bs=512
#the above line will write the image to a usb drive as usb emulated floppy partition, 
#it is configured to write to the 1st usb loaded to a mac, the drive must be unmounted 