#include <stdio.h>
#include <stdint.h>
#include <string.h>

// Definicja struktury 128-bitowej liczby jako 4 x 32-bit
typedef struct {
    uint32_t part[4]; // part[0] = LSB, part[3] = MSB
} __m128;

// Deklaracja funkcji asemblerowej
void mul_24(__m128* in, __m128* out);

void print128(const __m128* value) {
    printf("0x%08X%08X%08X%08X\n",
        value->part[3],
        value->part[2],
        value->part[1],
        value->part[0]);
}

int main() {
    __m128 input = {
        .part = { 0x00000005, 0x00000000, 0x00000000, 0x00000000 } // 5 as 128-bit
    };
    __m128 output;

    printf("Input:  ");
    print128(&input);
    printf("Output: ");
    print128(&output);

    mul_24(&input, &output);

    printf("Input:  ");
    print128(&input);
    printf("Output: ");
    print128(&output);

    return 0;
}