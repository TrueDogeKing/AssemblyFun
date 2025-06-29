.686
.model flat


extern  _ExitProcess@4 : proc
extern _MessageBoxW@16 : proc
extern _MessageBoxA@16 : proc
Comment |
Write a subroutine in 32-bit x86 assembly, designed to be called from a C program.
The prototype of the "_numerPartycjiAktywnej"
The argument MBR is a pointer to a memory area containing a Master Boot Record (MBR), read from a boot device (e.g., hard disk) as a structured byte array.

This table consists of four 16-byte entries (one for each partition). Each entry begins with a 1-byte field that indicates whether the partition is active.
An active partition is marked with the value 0x80.

The function should return the index (0–3) of the first active partition, or -1 if none are active.

| 
public _numerPartycjiAktywnej

.code

_numerPartycjiAktywnej PROC
		push ebp
		mov ebp,esp
		push ecx
		push edx
		push ebx
	 
		mov eax,[ebp+8] ; adres tablicy
		mov ecx,0

	searchloop:
		cmp ecx,4
		jge notExist
		mov edx, ecx
		imul edx, ecx, 16		  ; przesuniêcie rekordu partycji: 16 * i
		mov bl, byte PTR [eax + edx]  
		cmp bl,80h
		je activeFound

		inc ecx
		jmp searchloop
	
	
	activeFound:
		mov eax, ecx              ; numer partycji
		jmp programEnd

	notExist:
		mov eax, -1               ; brak aktywnej partycji
		
	programEnd:
		pop ebx
		pop edx
		pop ecx
		pop ebp
		ret
 _numerPartycjiAktywnej ENDP

  END