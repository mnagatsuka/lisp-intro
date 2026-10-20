import java.util.Arrays;

public class Quicksort {
    static void quicksort(int[] a, int lo, int hi) {
        if (lo >= hi) return;
        int pivot = a[lo];
        int i = lo;
        for (int j = lo + 1; j <= hi; j++) {
            if (a[j] < pivot) {
                i++;
                int t = a[i]; a[i] = a[j]; a[j] = t;
            }
        }
        int t = a[lo]; a[lo] = a[i]; a[i] = t;
        quicksort(a, lo, i - 1);
        quicksort(a, i + 1, hi);
    }

    public static void main(String[] args) {
        int[] a = {3, 1, 4, 1, 5, 9, 2, 6};
        quicksort(a, 0, a.length - 1);
        System.out.println(Arrays.toString(a));
    }
}
