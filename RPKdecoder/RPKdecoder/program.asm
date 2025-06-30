.686
.model flat


Comment |
 ----------------------------------------------------------------------------
 Function: get_RPK
 Prototype: unsigned int get_RPK(char *PK)
 Calling Convention: __cdecl

 Description:
   Decodes a Product Key (PK) string into a 15-byte base-24 number and extracts
   the Raw Product Key (RPK) from it.

   PK Format:
     - 25 characters split into 5 groups of 5, separated by hyphens ('-')
    - Characters represent digits in base-24 using the following table:
         B C D F G H J K M P Q R T V W X Y 2 3 4 6 7 8 9
         0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23

   Behavior:
     - Parses the 25 valid characters from PK and maps them to base-24 digits
     - Accumulates the value as a 15-byte multi-precision integer (little-endian)
     - Extracts 4 bytes (bytes 5 to 8 inclusive) from this value
     - Interprets them in big-endian order
     - Returns the 32-bit result (RPK)

 Notes:
   - No MMX/SSE instructions are used
   - No static data is accessed
   - All memory used must be from stack or parameters

 Returns:
   EAX = Raw Product Key (RPK)
 ----------------------------------------------------------------------------

| 


public _get_RPK

.data
char_table db 'BCDFGHJKMPQRTVWXY2346789' 

.code

get_char_value PROC
    push edi
    push ecx
    mov ecx, 0
    mov edi, OFFSET char_table
find_loop:
    cmp al, [edi+ecx]
    je found
    inc ecx
    jmp find_loop
found:
    mov eax,ecx

    pop ecx
    pop edi
    ret
get_char_value ENDP

_get_RPK PROC
    push ebp
    mov ebp, esp
    sub esp,32
    push esi
    push edi
    push ebx
    push ecx
    push edx

    mov esi, [ebp+8]     ; ESI = pointer to PK string
    xor eax, eax
    mov ecx, 32

clear_loop:
    mov [ebp+ecx-33], al
    loop clear_loop

    xor ecx, ecx         ; index of base-24 digit
    push ecx


next_char:
    xor eax,eax
    mov al, [esi]
    pop ecx
    inc esi
    inc ecx
    cmp ecx, 20
    je done_parsing
    push ecx
    cmp al, '-'          ; skip hyphens
    je next_char

    call get_char_value


    ; multiply number by 24
    lea ebx, [ebp-32]         ; pointer to input buf1
    push ebx
    lea ebx, [ebp-16]      ; pointer to output buf2
    push ebx
    call _mul_24
    add esp, 8

    push esi

    lea edi, [ebp-16]
    lea esi, [ebp-32]
    call _copyEsiToEdi

    pop esi

    ; add digit (AL) to buffer
    xor ebx, ebx
    mov bl, al
    mov ecx, 0
    xor edx, edx
add_digit:
    mov al, [ebp+ecx-16]
    add al, bl
    mov [ebp+ecx-16],byte ptr al
    cmp al, 0FFh
    jb done_add
    sub al, 24
    mov [ebp+ecx-16],byte ptr al
    inc bl
    dec ecx
    jmp add_digit
done_add:
    jmp next_char

done_parsing:
    ; Extract bytes 5–8 in big-endian
    ; Bytes: edi[5], edi[6], edi[7], edi[8] → EAX = (b5 << 24 | b6 << 16 | b7 << 8 | b8)
    movzx eax, byte ptr [ebp+5-16]
    shl eax, 24
    movzx ebx, byte ptr [ebp+6-16]
    shl ebx, 16
    or eax, ebx
    movzx ebx, byte ptr [ebp+7-16]
    shl ebx, 8
    or eax, ebx
    movzx ebx, byte ptr [ebp+8-16]
    or eax, ebx

    add esp, 32          ; cleanup 128-bit buffer

    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret
_get_RPK ENDP

_mul_24 PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx
    push ebx
    push eax

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

    pop eax
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