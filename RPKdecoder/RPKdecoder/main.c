#include <stdio.h>
#include <stdint.h>

// Prototyp funkcji zaimplementowanej w asemblerze
extern uint32_t get_RPK(char* PK);

// Przyk³adowy klucz produktu (PK) — testowy, zgodny z formatem i tabel¹
// Dla przyk³adu: FFFFF-GGGGG-HHHHH-JJJJJ-KKKKK
// gdzie litery nale¿¹ do alfabetu 24-znakowego z zadania
int main() {
    // Prawid³owy ci¹g znaków (25 znaków + 4 myœlniki = 29 znaków + 1 null terminator)
    char pk[] = "FFFFF-GGGGG-HHHHH-JJJJJ-KKKKK";

    uint32_t rpk = get_RPK(pk);  // Wywo³anie funkcji asemblerowej

    printf("PK:  %s\n", pk);
    printf("RPK: 0x%08X\n", rpk);  // Wyœwietlenie wyniku w postaci szesnastkowej

    return 0;
}
