#include <stdio.h>
#include <stdint.h>


extern int numerPartycjiAktywnej(void* MBR);


void main()
{
    uint8_t MBR[512] = { 0 };

    MBR[ 16 * 1 + 0] = 0x80; // Ustawienie flagi aktywnej partycji (dla partycji nr 2)

    int nr = numerPartycjiAktywnej(MBR);
    if (nr >= 0)
        printf("Pierwsza aktywna partycja: %d\n", nr);
    else
        printf("Nie znaleziono aktywnej partycji.\n");

    return 0;

}