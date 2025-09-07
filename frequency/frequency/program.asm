.686
.model flat


Comment |
void _shl_128(__m128* a, char n)

 Description:
 This 32-bit assembly subroutine creates a table of character
 occurrences in a given memory region. The size of this region
 is specified by the second parameter (n).

 The source region consists of bytes with values in the range
 0–255. Each row in the occurrences table consists of:
 - an 8-bit input character
 - a 32-bit counter of its occurrences

 The function allocates the occurrences table dynamically
 using malloc and returns a pointer to it.

 Notes:
 - The table contains 256 rows (for all possible byte values).
 - Each row has 5 bytes (1 for the character, 4 for the counter).
 - Total allocated size = 1280 bytes.
 - The function follows the __cdecl calling convention.

| 
public _wystapienia
extern _malloc : proc

.code

_wystapienia PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    push ecx
    push edx


    mov esi, [ebp + 8] ; pointer to input data
    mov ecx, [ebp + 12] ; size of input data
    mov eax,ecx
    lea eax,[eax*4+eax] ; calculate size for occurrences table
    push eax
    call _malloc ; allocate memory for occurrences table
    add esp,4
    mov edi,eax ; edi points to occurrences table
    xor ebx,ebx ; ebx = 0 (index for occurrences table)
    xor edx,edx ; edx = 0 (data iterator)

    mov [edi], al
    mov [edi+1], dword ptr 1
    inc edx

    mov ecx, [ebp + 12] ; size of input data
    xor eax,eax
searchloop:
	mov al,[esi+ebx] ; load byte from input data]
    inc ebx
    push ebx
    push ecx
    mov ecx,edx
    xor ebx,ebx ; ebx = 0 (index for occurrences table)
check:
    cmp al,[edi+ebx]
    je found
    add ebx,5
	loop check ; loop until ecx = 0
    mov [edi][ebx], al
    mov [edi][ebx+1], dword ptr 1
    inc edx
    pop ecx
    pop ebx
    loop searchloop
found:
    add dword ptr [edi+ebx+1],1
    pop ecx
    pop ebx
    loop searchloop




    mov eax, edi

    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret
_wystapienia ENDP

END