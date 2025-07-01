#include <stdio.h>
#include <stdint.h>

extern unsigned int search(uint16_t* text, uint16_t* pattern);

int main() {
    uint16_t text[] = u"ABCDEAKADAKOAB";
    uint16_t pattern[] = u"OA";

    unsigned int result = search(text, pattern);

    if (result != (unsigned int)-1)
        printf("Znaleziono wzorzec na pozycji: %u\n", result);
    else
        printf("Nie znaleziono wzorca\n");

    return 0;
}
