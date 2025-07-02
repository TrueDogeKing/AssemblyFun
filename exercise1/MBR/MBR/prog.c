#include <stdio.h>
#include <stdint.h>

// External function implemented in assembly
extern int numerPartycjiAktywnej(void* MBR);

int main()
{
    uint8_t MBR[512] = { 0 };  // Simulated Master Boot Record (MBR)

    // Set the "bootable" flag (0x80) for the 2nd partition (index 1)
    MBR[16 * 1 + 0] = 0x80;

    int partition = numerPartycjiAktywnej(MBR);

    if (partition >= 0)
        printf("First active partition: %d\n", partition);
    else
        printf("No active partition found.\n");

    return 0;
}
