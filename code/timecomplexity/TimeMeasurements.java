package code.timecomplexity;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;


public class TimeMeasurements {

    private static final int RUNS = 10;
    private static final int INPUT_SIZE = 45;

    public static void main(String[] args) {
        save(timeMeasurementSeries());
    }

    public static String timeMeasurementSeries(){
        String result = "";
        for(int i = 0; i < INPUT_SIZE; i++) {
            System.out.println(i);
            result += timeMeasurementMeans(i);
        }
        return result;
    }

    public static void save(String str) {
        Path path
            = Paths.get("measurement.csv");
        try {
            Files.writeString(path, str,
                              StandardCharsets.UTF_8);
        }
        catch (IOException ex) {
            System.out.print("Invalid Path");
        }
    }


    public static String timeMeasurementMeans(int n) {
        long sum = 0;
        for(int i = 0; i < RUNS; i++) {
            long start = System.nanoTime();
            fibIt(n);
            long end = System.nanoTime();
            sum += (end-start);
        }
        return n + ";" + (sum/RUNS) + "\n";
    }


    public static long fibIt(int n){
        long x = 1;
        long y = 1;
        long result = 1;
        for (int i=3; i<=n; i++){
           result = x + y;
           x = y;
           y = result;
        }
        return result;
     }


    public static long fibRek(int n) {
        if (n < 3) {
          return 1;
        } else {
          return fibRek(n-1) + fibRek(n-2);
        }
      }


    public static void timeMeasurement() {
        long start = System.nanoTime();
        fibIt(5000);
        long end = System.nanoTime();
        System.out.println("The measurement took " + (end - start) + " nanoseconds");
    }
}