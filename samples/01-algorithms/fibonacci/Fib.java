public class Fib {
    static int fib(int n) {
        if (n < 2) return n;
        return fib(n - 1) + fib(n - 2);
    }

    public static void main(String[] args) {
        long start = System.nanoTime();
        int result = fib(35);
        double elapsed = (System.nanoTime() - start) / 1e9;
        System.out.println(result);
        System.out.printf("%.3f seconds%n", elapsed);
    }
}
