#include <stdio.h>
#include <stdint.h>

// Prototyp funkcji zaimplementowanej w asemblerze
extern uint32_t get_RPK(char* PK);

// Przyk�adowy klucz produktu (PK) � testowy, zgodny z formatem i tabel�
// Dla przyk�adu: FFFFF-GGGGG-HHHHH-JJJJJ-KKKKK
// gdzie litery nale�� do alfabetu 24-znakowego z zadania
int main() {
    // Prawid�owy ci�g znak�w (25 znak�w + 4 my�lniki = 29 znak�w + 1 null terminator)
    char pk[] = "FFFFF-GGGGG-HHHHH-JJJJJ-KKKKK";

    uint32_t rpk = get_RPK(pk);  // Wywo�anie funkcji asemblerowej

    printf("PK:  %s\n", pk);
    printf("RPK: 0x%08X\n", rpk);  // Wy�wietlenie wyniku w postaci szesnastkowej

    return 0;
}
