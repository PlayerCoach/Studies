package org.example;

import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;

public class Main
{
    public static void main(String[] args) throws InterruptedException
    {
        SubmissionQuery submissionQuery = new SubmissionQuery();
        ResultResource resultResource = new ResultResource();
        Thread[] threads = new Thread[Integer.parseInt(args[0])];
        for (int i = 0; i < threads.length; i++)
        {
            threads[i] = new Thread(new ThreadOperation(submissionQuery, resultResource));
            threads[i].start();
        }

        int numbersOfThreads = Integer.parseInt(args[0]);
        Scanner scanner = new Scanner(System.in);

        do {

            if (scanner.hasNextInt()) {
                submissionQuery.AddNumberToCheck(scanner.nextInt());
            } else {
                String input = scanner.nextLine().trim();
                if ("exit".equalsIgnoreCase(input))
                {
                    break;
                }
            }
        } while (true);

        for (Thread thread : threads) {

            thread.interrupt();
        }

    }


}