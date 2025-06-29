#include <stdio.h>

extern void sortuj(long long liczby[], int n); // deklaracja funkcji asemblerowej

int main() {
    long long dane[] = { 9, -3, 17, 2, -8, 0 };
    int n = sizeof(dane) / sizeof(dane[0]);

    printf("Przed sortowaniem:\n");
    for (int i = 0; i < n; i++) {
        printf("%lld ", dane[i]);
    }
    printf("\n");

    sortuj(dane, n); // wywo³anie funkcji w asemblerze

    printf("Po sortowaniu:\n");
    for (int i = 0; i < n; i++) {
        printf("%lld ", dane[i]);
    }
    printf("\n");

    return 0;
}
