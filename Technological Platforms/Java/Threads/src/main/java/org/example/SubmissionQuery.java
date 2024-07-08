package org.example;

import java.util.LinkedList;
import java.util.Queue;

public class SubmissionQuery
{
    private static final Queue<Integer> numbersToCheck = new LinkedList<>();

    synchronized void AddNumberToCheck(int number)
    {
        numbersToCheck.add(number);
        notify();
    }

    synchronized int GetNumberToCheck() throws InterruptedException
    {
        while (numbersToCheck.isEmpty())
        {
            wait();
        }
        return numbersToCheck.poll();
    }
    public boolean isEmpty()
    {
        return numbersToCheck.isEmpty();
    }
}
