.686
.model flat


Comment |
 ------------------------------------------------------------
 Function: unsigned int search(char *text, char *pattern)

 Description:
 This 32-bit assembly function implements the Boyer-Moore (BM) 
 substring search algorithm for UTF-16 encoded text.

 Parameters:
   text    - pointer to UTF-16 encoded text string (null-terminated)
   pattern - pointer to UTF-16 encoded pattern string (null-terminated)

 Behavior:
   - The function searches for the first occurrence of the pattern in the text.
   - It uses the Boyer-Moore algorithm to improve efficiency (e.g., using bad character shift).
   - The pattern and text are both processed as sequences of 16-bit characters.

 Return:
   - If the pattern is found in the text, returns its 1-based index.
   - If the pattern is not found, returns -1 (0xFFFFFFFF).

 Notes:
   - Uses only 32-bit registers; no SSE/MMX/64-bit instructions.
   - Assumes null-terminated UTF-16 strings.
 ------------------------------------------------------------
| 

public _search

.code

_search PROC
	    push ebp
		mov ebp,esp
		push esi
		push edi
		push ebx
        push ecx
        push edx
	 
		mov esi, [ebp + 8]     ; text[]
		mov edi, [ebp + 12]    ; pattern[]

        xor edx, edx           ; ECX = counter = 0

length_loop:
        mov ax, [edi + edx*2]  ; Load UTF-16 character (2 bytes)
        cmp ax, 0              ; Is it null terminator?
        je length_done
        inc edx                ; Move to next UTF-16 char
        jmp length_loop

length_done:
        dec edx
    

        xor eax,eax
outer_loop:
    mov ecx, edx            ; edx = inner loop index i = 0

inner_loop:
    mov bx,word ptr [esi+2*ecx]
    cmp bx,0
    je end_search
    cmp bx,word ptr [edi+2*ecx]
    jne next_outer
    loop inner_loop
    ;calculate the esi now
    jmp end_search

next_outer:
    inc esi
    inc esi
    inc eax
    jmp outer_loop

end_search:
    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret

_search ENDP





END