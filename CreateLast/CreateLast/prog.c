#include <stdio.h>
#include <stdint.h>


extern void* create_last(char* tekst, char* wzorzec);

void main()
{
    uint16_t text[] = u"ABCDEAKADAKOAB";
    uint16_t pattern[] = u"CEKAB";

    void* last_table = create_last(text, pattern);

    if (last_table == NULL) {
        printf("B³¹d alokacji lub brak tablicy\n");
        return 1;
    }

    unsigned char* ptr = (unsigned char*)last_table;

    printf("Zawartoœæ tablicy last:\n");
    while (1) {
        uint16_t ch = *(uint16_t*)(ptr);       // znak UTF-16
        int index = *(int*)(ptr + 2);           // indeks ostatniego wyst¹pienia

        if (ch == 0 && index == 0) break;       // koniec tablicy

        wprintf(L"Znak: %lc (0x%04X), ostatnia pozycja we wzorcu: %d\n", (wint_t)ch, ch, index);

        ptr += 8;  // nastêpny element
    }



    return 0;
}