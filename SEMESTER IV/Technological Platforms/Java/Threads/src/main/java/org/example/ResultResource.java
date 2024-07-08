package org.example;

import java.util.HashMap;
import java.util.Map;

public class ResultResource
{

    private static final Map<Integer, Boolean> resultsMap = new HashMap<>();

    synchronized void addResult(int number, boolean isPrime)
    {
        resultsMap.put(number, isPrime);
    }

    synchronized void displayResults() {
        System.out.println("Results:");

        StringBuilder primeNumbers = new StringBuilder("Prime: ");
        StringBuilder notPrimeNumbers = new StringBuilder("Not Prime: ");

        for (Map.Entry<Integer, Boolean> entry : resultsMap.entrySet()) {
            int number = entry.getKey();
            String result = entry.getValue() ? "prime" : "not prime";

            if ("prime".equals(result)) {
                primeNumbers.append(number).append(" ");
            } else {
                notPrimeNumbers.append(number).append(" ");
            }
        }

        System.out.println(primeNumbers.toString().trim());
        System.out.println(notPrimeNumbers.toString().trim());
    }


}
