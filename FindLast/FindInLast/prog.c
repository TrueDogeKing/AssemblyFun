#include <stdio.h>
#include <stdint.h>
#include <wchar.h>

// External functions implemented in assembly
extern void* create_last(char* tekst, char* wzorzec);
extern unsigned int find_in_last(void* last, short znak);

int main()
{
    // UTF-16 encoded input text and pattern
    uint16_t text[] = u"ABCDEAKADAKOAB";
    uint16_t pattern[] = u"CEKAB";

    // Create the "last" table using the assembly function
    void* last_table = create_last((char*)text, (char*)pattern);

    if (last_table == NULL) {
        printf("Allocation error or missing table\n");
        return 1;
    }

    // Interpret the returned pointer as a byte array
    unsigned char* last = (unsigned char*)last_table;
    unsigned char* ptr = last;

    // Print the contents of the "last" table
    printf("Contents of the 'last' table:\n");
    while (1) {
        uint16_t ch = *(uint16_t*)(ptr);        // UTF-16 character
        int index = *(int*)(ptr + 2);           // Last occurrence index in pattern

        if (ch == 0 && index == 0) break;       // End of table (zero-terminated)

        wprintf(L"Char: %lc (0x%04X), last position in pattern: %d\n", (wint_t)ch, ch, index);

        ptr += 8;  // Move to the next element
    }

    // Lookup test characters
    wchar_t test_chars[] = { u'A', u'B', u'C', u'Z', 0 };  // 'Z' is not in the pattern

    printf("Lookup results in the 'last' table:\n");
    for (int i = 0; test_chars[i] != 0; i++) {
        short znak = test_chars[i];
        unsigned int result = find_in_last(last, znak);

        if (result != (unsigned int)-1) {
            printf("Char '%lc' (0x%04X) last appears at index: %d\n", test_chars[i], test_chars[i], result);
        }
        else {
            printf("Char '%lc' (0x%04X) does not appear in the pattern\n", test_chars[i], test_chars[i]);
        }
    }

    return 0;
}
