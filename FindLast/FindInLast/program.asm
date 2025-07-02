.686
.model flat

extern _VirtualAlloc@16 : proc    

Comment |
 Function: find_in_last

 Prototype in C:
     unsigned int find_in_last(void* last, short znak)

 Description:
    Searches for a UTF-16 character `znak` in the dynamically allocated
    `last` table (created by `create_last`). This table contains entries of
    8 bytes each:

         - 2 bytes: UTF-16 character code (uint16_t)
         - 4 bytes: index of last occurrence in pattern (int)
         - 2 bytes: padding (ignored)

     The table is terminated by an entry with both character and index == 0.

 Return:
     - If the character is found: returns the corresponding index (unsigned int).
     - If not found: returns -1 (0xFFFFFFFF).

 How it works:
     - Iterates through the table, comparing the character field with `znak`.
     - On match, loads and returns the associated index.
     - Stops when a zeroed element is reached.
| 
public _create_last
public _find_in_last

.code

    ; Parametry:
    ; [esp+4] - void* last (wskaŸnik na tablicê)
    ; [esp+8] - short int znak (2B)
_find_in_last PROC

    push ebp
    mov ebp, esp
    push esi
    push ebx
    push ecx

    xor ecx,ecx 
    mov esi, [ebp+8]     ; esi = last (tablica)
    mov cx,  [ebp+12]    ; cx = znak do znalezienia (short int)

search_loop:
    mov bx, [esi]        ; odczytaj znak UTF-16 z elementu tablicy
    mov eax, [esi+2]     ; odczytaj indeks (4B) do eax

    cmp bx, 0            ; sprawdŸ koniec tablicy (znak == 0)
    je not_found         ; jeœli koniec, nie znaleziono

    cmp bx, cx           ; porównaj znak z szukanym
    jne next_element     ; jeœli ró¿ne, idŸ dalej

    ; znaleziono znak - zwróæ indeks (w eax ju¿ jest)
    jmp end_function

next_element:
    add esi, 8           ; przejdŸ do kolejnego elementu (8 bajtów)
    jmp search_loop

not_found:
    mov eax, -1          ; wartoœæ zwracana -1 = nie znaleziono
end_function:
	pop ecx
    pop ebx
    pop esi
    pop ebp
    ret

_find_in_last ENDP

 


 _create_last PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    ; tekst = [ebp+8], wzorzec = [ebp+12]
    mov esi, [ebp+8]     ; ESI = tekst
    mov edi, [ebp+12]    ; EDI = wzorzec

    ; Oblicz d³ugoœæ tekstu (UTF-16, zakoñczony 0)
    xor ecx, ecx
count_text_len:
    mov ax, [esi + ecx*2]
    cmp ax, 0
    je text_done
    inc ecx
    jmp count_text_len
text_done:
    mov ebx, ecx         ; EBX = length of text

    ; Alokuj pamiêæ: (text_len + 1) * 8 bajtów
    mov eax, ebx
    inc eax
    shl eax, 3           ; eax = liczba bajtów
    push 04h
    push 1000h
    push eax
    push 0
    call _VirtualAlloc@16
    mov edx, eax         ; edx = wskaŸnik do zaalokowanej pamiêci

    ; ECX = index w tekœcie
    xor ecx, ecx
next_char:
    push edx
    mov ax, [esi + ecx*2]
    cmp ax, 0
    je done_loop

    push ecx
    movzx ebx, ax        ; EBX = znak z tekstu

    ; policz d³ugoœæ wzorca
    xor ecx, ecx
count_pat_len:
    mov dx, [edi + ecx*2]
    cmp dx, 0
    je got_pat_len
    inc ecx
    jmp count_pat_len
got_pat_len:
    dec ecx             ; indeks ostatniego znaku

    mov eax, -1         ; domyœlnie -1
search_pattern:
    cmp ecx, -1
    jl no_match
    mov dx, [edi + ecx*2]
    cmp dx, bx
    je match_found
    dec ecx
    jmp search_pattern

match_found:
    mov eax, ecx
no_match:

    pop ecx
    pop edx

    ; zapisz: [char (2B)] + [int index (4B)] + 2B padding = 8B
    mov [edx + ecx*8], bx         ; znak
    mov [edx + ecx*8 + 2], eax    ; indeks

    inc ecx
    jmp next_char

done_loop:
    pop edx
    ; zakoñcz zerowym elementem
    mov dword ptr [edx + ecx*8], 0
    mov dword ptr [edx + ecx*8 + 4], 0

    mov eax, edx    ; wynik = wskaŸnik

    pop ebx
    pop edi
    pop esi
    pop ebp
    ret
_create_last ENDP


	

END