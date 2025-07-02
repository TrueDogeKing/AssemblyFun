#include <stdio.h>

// Declaration of the assembly sorting function
extern void sortuj(long long numbers[], int n);

int main() {
    long long data[] = { 9, -3, 17, 2, -8, 0 };
    int n = sizeof(data) / sizeof(data[0]);

    printf("Before sorting:\n");
    for (int i = 0; i < n; i++) {
        printf("%lld ", data[i]);
    }
    printf("\n");

    sortuj(data, n); // Call the sorting function implemented in assembly

    printf("After sorting:\n");
    for (int i = 0; i < n; i++) {
        printf("%lld ", data[i]);
    }
    printf("\n");

    return 0;
}
