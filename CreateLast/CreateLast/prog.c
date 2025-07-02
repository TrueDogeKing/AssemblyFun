#include <stdio.h>
#include <stdint.h>
#include <wchar.h>

extern void* create_last(char* tekst, char* wzorzec);

int main()
{
    uint16_t text[] = u"ABCDEAKADAKOAB";
    uint16_t pattern[] = u"CEKAB";

    void* last_table = create_last((char*)text, (char*)pattern);

    if (last_table == NULL) {
        printf("Allocation error or missing table\n");
        return 1;
    }

    unsigned char* ptr = (unsigned char*)last_table;

    printf("Contents of the 'last' table:\n");
    while (1) {
        uint16_t ch = *(uint16_t*)(ptr);       // UTF-16 character
        int index = *(int*)(ptr + 2);          // last occurrence index in pattern

        if (ch == 0 && index == 0) break;      // end of table

        wprintf(L"Character: %lc (0x%04X), last position in pattern: %d\n", (wint_t)ch, ch, index);

        ptr += 8;  // next element
    }

    return 0;
}
