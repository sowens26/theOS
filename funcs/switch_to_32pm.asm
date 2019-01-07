[bits 16]
switch_to_32pm:
    cli ; block interrupts
    lgdt [gdt_descriptor]   ; load gdt defined in gdt.asm
    mov eax, cr0 ; to go prtctd 32, 
    or eax, 0x1 ;set bit1 of cr0 to 1 by moving it to a gen reg 
    mov cr0, eax ; updating that register then redumping back to cr0

    ; now we are in p32 mode
    ; clear pipeline to ensure no 16bits instructions attempt to run
    ; far jumps/ segment jumps for pipeline flushes
    ; far jump = jmp <segment>:<address offset>
    sti
    jmp CODE_SEGMENT:init32pm

[bits 32]
init32pm:
    cli
    ; reinit seg regs and stack
    ;seg regs
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    ;stack
    mov ebp, 0x90000   ; extended stack base
    mov esp, ebp        ; top = base == empty stack
    sti
    call begin_32pm
    ;create begin_32pm :: back to boots.asm

