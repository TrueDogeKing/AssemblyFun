#include <stdio.h>
#include <stdint.h>

// Prototype of the function implemented in assembly
extern uint32_t get_RPK(char* PK);

// Example Product Key (PK) — test key that follows the expected format and character set.
// Format: FFFFF-GGGGG-HHHHH-JJJJJ-KKKKK
// where characters come from a 24-character alphabet defined in the task
int main() {
    // Valid key string: 25 characters + 4 dashes = 29 characters + 1 null terminator
    char pk[] = "FFFFF-GGGGG-HHHHH-JJJJJ-KKKKK";

    uint32_t rpk = get_RPK(pk);  // Call the assembly function

    printf("PK:  %s\n", pk);
    printf("RPK: 0x%08X\n", rpk);  // Display result in hexadecimal format

    return 0;
}
