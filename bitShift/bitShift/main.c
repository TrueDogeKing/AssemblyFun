#include <stdio.h>
#include <stdint.h>

// structur of 128-bit number as 4 x 32-bit 
typedef struct {
    uint32_t part0;  // least significant 32 bity
    uint32_t part1;
    uint32_t part2;
    uint32_t part3;  // most significant 32 bity
} __m128;

extern void shl_128(__m128* a, char n);

void print_128(__m128* a) {
    printf("128-bit: %08X %08X %08X %08X\n", a->part3, a->part2, a->part1, a->part0);
}

int main() {
    __m128 number = { 0xAAAAAAAA, 0xBBBBBBBB, 0xCCCCCCCC, 0xDDDDDDDD };
    char shift = 1;

    printf("Before shift:\n");
    print_128(&number);

    shl_128(&number, shift);

    printf("After left shift by %d bit(s):\n", shift);
    print_128(&number);

    return 0;
}
