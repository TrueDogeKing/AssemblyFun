#include <stdio.h>
#include <stdint.h>

// Struktura reprezentuj¹ca 128-bitow¹ liczbê jako 4 x 32-bitowe s³owa
typedef struct {
    uint32_t part0;  // najm³odsze 32 bity
    uint32_t part1;
    uint32_t part2;
    uint32_t part3;  // najstarsze 32 bity
} __m128;

// Prototyp funkcji w asemblerze
void shl_128(__m128* a, char n);

void print_128(__m128* a) {
    printf("128-bit: %08X %08X %08X %08X\n", a->part3, a->part2, a->part1, a->part0);
}

int main() {
    __m128 liczba = { 0xAAAAAAAA, 0xBBBBBBBB, 0xCCCCCCCC, 0xDDDDDDDD };
    char przesuniecie = 1;

    printf("Przed przesunieciem:\n");
    print_128(&liczba);

    shl_128(&liczba, przesuniecie);

    printf("Po przesunieciu w lewo o %d bity:\n", przesuniecie);
    print_128(&liczba);

    return 0;
}
