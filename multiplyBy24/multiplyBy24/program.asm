.686
.model flat


Comment |
void _shl_128(__m128* a, char n)

 Description:
 This 32-bit assembly subroutine performs a logical left shift
 of a 128-bit unsigned integer (stored as four 32-bit parts)
 by n bits. The shift is done entirely using 32-bit registers.

 Notes:
 - No 64-bit registers or MMX/SSE instructions are used.
 - No static data segment is used.
 - The number is shifted in-place inside the struct pointed to by a.

 Registers used: eax, ebx, ecx, edx, esi
 Calling convention: __cdecl (parameters on stack)

| 
public _mul_24

.code

_mul_24 PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx
    push ebx

    mov esi, [ebp + 8]     ; ESI = pointer to in __m128
    mov edi, [ebp + 12]    ; EDI = pointer to out __m128

    ; copy the input to the second variable
    call _copyEsiToEdi

    ; multiply by 8
    push byte ptr 3
    push edi
    call _shl_128
    add esp, 8        ; clean up both arguments

    mov eax, [edi]         ; part0
    mov ebx, [edi + 4]     ; part1
    mov edx, [edi + 8]     ; part2
    mov ecx, [edi + 12]    ; part3

    push eax
    push ebx
    push edx
    push ecx

    call _copyEsiToEdi

    ; multiply by 16
    ;push edi
    push byte ptr 4
    push edi
    call _shl_128
    add esp, 8   

    ; add both numbers to get multiplication by 24
    pop ecx
    pop edx
    pop ebx
    pop eax

    add [edi],eax
    adc [edi+4],ebx
    adc [edi+8],edx
    adc [edi+12],ecx

    pop ebx
    pop ecx
    pop edi
    pop esi
    pop ebp
    ret
_mul_24 ENDP

_copyEsiToEdi PROC
    push eax
    push ebx
    push edx
    push ecx

    mov eax, [esi]         ; part0
    mov ebx, [esi + 4]     ; part1
    mov edx, [esi + 8]     ; part2
    mov ecx, [esi + 12]    ; part3

    mov [edi], eax
    mov [edi + 4], ebx
    mov [edi + 8], edx
    mov [edi + 12], ecx

    pop ecx
    pop edx
    pop ebx
    pop eax
    ret
_copyEsiToEdi ENDP



_shl_128 PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx
    push ebx
    push eax
    push edx

    mov esi, [ebp + 8]     ; ESI = pointer to __m128
    movzx ecx, byte ptr [ebp + 12] ; ECX = shift count (0–127)
    cmp ecx, 0
    je done

    ; Load the 128-bit number into registers:
    ; [esi]      = part0 (least significant)
    ; [esi+4]    = part1
    ; [esi+8]    = part2
    ; [esi+12]   = part3 (most significant)

    mov eax, [esi]         ; part0
    mov ebx, [esi + 4]     ; part1
    mov edx, [esi + 8]     ; part2
    mov edi, [esi + 12]    ; part3

shift_loop:
    shl eax, 1             ; shift lowest 32 bits left
    rcl ebx, 1             ; rotate carry into next dword
    rcl edx, 1
    rcl edi, 1
    loop shift_loop        ; ECX--

    ; Store back the result
    mov [esi], eax
    mov [esi + 4], ebx
    mov [esi + 8], edx
    mov [esi + 12], edi

done:
pop edx
    pop eax
    pop ebx
    pop ecx
    pop edi
    pop esi
    pop ebp
    ret
_shl_128 ENDP


END


