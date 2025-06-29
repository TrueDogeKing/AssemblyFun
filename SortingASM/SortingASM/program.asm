.686
.model flat


Comment |
 ------------------------------------------------------------
	void sortuj(long long liczby[], int n)

 Description:
 This 32-bit MASM subroutine sorts an array of signed 64-bit
 integers in ascending order (bubble sort).

 - Each 64-bit integer is represented as two 32-bit parts.
 - Only 32-bit registers are used (no 64-bit registers).
 - Static data segments are not used.
 - Sorting is done by comparing the high 32 bits first,
   then the low 32 bits (if high parts are equal).
 - Swaps are performed manually using two 32-bit moves.

 Parameters:
   liczby[] - pointer to array of 64-bit signed integers
   n        - number of elements in the array

 ------------------------------------------------------------
| 

public _sortuj

.code

_sortuj PROC
	    push ebp
		mov ebp,esp
		push esi
		push edi
		push ebx
	 
		mov esi, [ebp + 8]     ; liczby[]
		mov ecx, [ebp + 12]    ; n
		dec ecx                ; n-1
		jl end_sort           ; if n <= 1, skip sorting

outer_loop:
    mov edx, 0            ; edx = inner loop index i = 0

inner_loop:
    mov eax, ecx
    sub eax, edx
    jle next_outer        ; if i >= n - 1 - pass, go to next pass

    ; Calculate address of liczby[i]
    mov ebx, edx
    shl ebx, 3            ; offset = i * 8
    lea edi, [esi + ebx]  ; edi = &liczby[i]

    add ebx,8
    lea ebx, [esi+ebx]    ; ebx = &liczby[i+1]

    call _compare64

    inc edx               ; i++
    jmp inner_loop

next_outer:
    dec ecx
    jge outer_loop

end_sort:
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret

_sortuj ENDP


; compares the 64 bit number from edi=&tab[i] ebx=&tab[i+1] and swaps if needed bubble sort
_compare64 PROC
    push eax
    push esi
    push ecx
    push edx

    ; Load liczby[i] into eax:ecx (low:high)
    mov eax, [edi]        ; low
    mov ecx, [edi + 4]    ; high

    ; Load liczby[i+1] into edx:esi (low:high)
    mov edx, [ebx]        ; low
    mov esi, [ebx + 4]    ; high

    ; Compare high parts
    cmp ecx, esi
    jl no_swap
    jg do_swap

    ; High parts equal -> compare low parts
    cmp eax, edx
    jle no_swap

do_swap:
    ; Swap 64-bit values
    mov [edi], edx
    mov [edi + 4], esi
    mov [ebx], eax
    mov [ebx + 4], ecx

no_swap:
    pop edx
    pop ecx
    pop esi
    pop eax
    ret
_compare64 ENDP


END