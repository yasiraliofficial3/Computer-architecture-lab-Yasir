global _main
extern _printf

section .data
    formatRaw   db "Raw EFLAGS = 0x%08X", 10, 0
    formatFlags db "Zero Flag (ZF) = %d, Carry Flag (CF) = %d", 10, 0

section .text
_main:
    ; Step 1: Perform an operation that sets ZF = 1 and CF = 0
    mov eax, 5
    sub eax, 5          ; 5 - 5 = 0 -> Sets ZF = 1, clears CF = 0

    ; Step 2: Push EFLAGS onto the stack
    pushfd

    ; Step 3: Pop flags into EAX (scratch register, safe to overwrite)
    pop eax

    ; Step 4: Display the raw 32-bit flags register
    ; Note: printf clobbers EAX, so push a copy or preserve it
    push eax            ; Save flags across the printf call
    push eax            ; Argument for printf (%08X)
    push formatRaw
    call _printf
    add esp, 8          ; Clean up formatRaw and the printed argument
    pop eax             ; Restore flags into EAX

    ; Step 5: Extract Zero Flag (Bit 6)
    mov ecx, eax
    shr ecx, 6
    and ecx, 1          ; ECX = 1

    ; Step 6: Extract Carry Flag (Bit 0)
    mov edx, eax
    and edx, 1          ; EDX = 0

    ; Step 7: Print flag values (push in reverse order: CF then ZF)
    push edx            ; %d -> CF
    push ecx            ; %d -> ZF
    push formatFlags
    call _printf
    add esp, 12         ; Clean up 3 arguments (3 * 4 = 12 bytes)

    ; Return 0
    xor eax, eax
    ret