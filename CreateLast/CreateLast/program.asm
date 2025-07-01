.686
.model flat

extern _VirtualAlloc@16 : proc     ; <-- declare function
includelib kernel32.lib  

Comment |
 _create_last:
  - Parameters:
     char* tekst   - pointer to a UTF-16 encoded text string (terminated with 0)
     char* wzorzec - pointer to a UTF-16 encoded pattern string (terminated with 0)

  - Function:
      Creates a dynamically allocated array "last" using VirtualAlloc.
      The array contains elements corresponding only to the characters in "tekst".
      Each element is 8 bytes:
         - 2 bytes: UTF-16 character code from "tekst"
         - 4 bytes: last occurrence index of this character in "wzorzec" (or -1 if not found)
         - 2 bytes: padding for alignment
      The array is terminated by an element filled with zeros.
      Returns a pointer to this allocated "last" array.

  - Notes:
      Uses WinAPI VirtualAlloc to allocate memory dynamically.
      Iterates through "tekst" to build the array.
      Searches "wzorzec" for each character's last occurrence index.

| 
public _create_last

.code

 


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