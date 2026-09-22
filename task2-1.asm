global _main
extern _printf

section .data
    format1 db "AH = 0x%02X, AL = 0x%02X-> AX = 0x%04X", 10, 0
    format2 db "Full EAX after packing = 0x%08X", 10, 0

section .text
_main:
    ; Step 1: Start with clean registers
    xor eax, eax
    mov ah, 0x12
    mov al, 0x34

    ; Step 2: Read sub-registers into volatile registers for printf
    movzx ecx, ax        ; ECX = AX (0x1234)
    movzx edx, ah        ; EDX = AH (0x12)
    movzx eax, al        ; Reusing EAX as scratch for AL (0x34)

    ; Step 3: Push arguments for format1 (cdecl: Right to Left)
    push ecx             ; AX
    push eax             ; AL
    push edx             ; AH
    push format1
    call _printf
    add esp, 16          ; Clean up stack

    ; Step 4: Reconstruct and pack into EAX
    ; (Since printf overwrote EAX, we rebuild or preserve it)
    mov eax, 0x1234
    shl eax, 16          ; EAX = 0x12340000

    mov ah, 0x56
    mov al, 0x78         ; EAX = 0x12345678

    ; Step 5: Print full 32-bit register
    push eax
    push format2
    call _printf
    add esp, 8

    ; Return 0
    xor eax, eax
    ret