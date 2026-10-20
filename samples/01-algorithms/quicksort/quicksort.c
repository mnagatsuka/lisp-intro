#include <stdio.h>

static void swap(int *x, int *y) {
    int t = *x;
    *x = *y;
    *y = t;
}

static void quicksort(int a[], int lo, int hi) {
    if (lo >= hi) return;
    int pivot = a[lo];
    int i = lo;
    for (int j = lo + 1; j <= hi; j++) {
        if (a[j] < pivot) {
            i++;
            swap(&a[i], &a[j]);
        }
    }
    swap(&a[lo], &a[i]);
    quicksort(a, lo, i - 1);
    quicksort(a, i + 1, hi);
}

int main(void) {
    int a[] = {3, 1, 4, 1, 5, 9, 2, 6};
    int n = sizeof a / sizeof a[0];
    quicksort(a, 0, n - 1);
    for (int i = 0; i < n; i++) printf("%d ", a[i]);
    printf("\n");
    return 0;
}
