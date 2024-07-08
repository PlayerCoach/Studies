package org.example;

public class ThreadOperation implements Runnable
{
    private final SubmissionQuery submissionQuery;
    private final ResultResource resultResource;

    public ThreadOperation(SubmissionQuery submissionQuery, ResultResource resultResource)
    {
        this.submissionQuery = submissionQuery;
        this.resultResource = resultResource;
    }
    @Override
    public void run() {

        while(true) {
            int numberToCheck = 0;
            try
            {
                numberToCheck = submissionQuery.GetNumberToCheck();
            }
            catch (InterruptedException e)
            {
                return;
            }

            try
            {
                resultResource.addResult(numberToCheck, isPrime(numberToCheck));
            }
            catch (InterruptedException e)
            {
                return;
            }
            resultResource.displayResults();
        }

    }

    private boolean isPrime(int number) throws InterruptedException {

        if(number > 1000)
        {
            Thread.sleep(10000);
        }
        if (number <= 1)
        {
            return false;
        }
        if(number == 2)
        {
            return true;
        }
        if(number % 2 == 0)
        {
            return false;
        }
        for(int i = 3; i <= Math.floor(Math.sqrt(number)); i++)
        {
            if(number % i == 0)
            {
                return false;
            }
        }
        return true;
    }
}
