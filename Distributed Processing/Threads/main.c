#include <windows.h>
#include <stdio.h>
#include <limits.h>
#include <time.h>
#ifdef _DEBUG
#define DEBUG_PRINT(fmt, ...) fprintf(stderr, fmt, __VA_ARGS__)
#else
#define DEBUG_PRINT(fmt, ...) do {} while (0)
#endif

typedef struct PARAMETERS PARAMETERS;
struct PARAMETERS
{
    int* array;
    int star_index;
    int end_index;
};

DWORD WINAPI ThreadRoutine(LPVOID lpParameter)
{
    PARAMETERS* params = (PARAMETERS*)lpParameter;
    for (int i = params->star_index; i < params->end_index; i++) {
        params->array[i] = params->array[i] + 1;
    }
    return 0;
}

int main()
{
    const int maxLength = 1e8;
    SYSTEM_INFO sysInfo;
    GetSystemInfo(&sysInfo);
    printf("Maximum number of threads: %d \n", sysInfo.dwNumberOfProcessors);
    int maxThreads = sysInfo.dwNumberOfProcessors;

    for (int number_of_threads = 1; number_of_threads <= maxThreads; number_of_threads++)
    {
        printf("Number of threads: %d\t", number_of_threads);
        int* array = (int*)calloc(maxLength, sizeof(int));
        clock_t start = clock();

        HANDLE* hHandles = (HANDLE*)malloc(number_of_threads * sizeof(HANDLE));
        DWORD ThreadId;
        PARAMETERS** params = (PARAMETERS**)malloc(number_of_threads * sizeof(PARAMETERS*));

        for (int i = 0; i < number_of_threads; i++)
        {
            params[i] = (PARAMETERS*)malloc(sizeof(PARAMETERS));
            params[i]->array = array;
            params[i]->star_index = (maxLength / number_of_threads) * i;
            params[i]->end_index = maxLength / number_of_threads * (i + 1);

            hHandles[i] = CreateThread(NULL, 0, ThreadRoutine, params[i], 0, &ThreadId);
            if (hHandles[i] == NULL) {
                DEBUG_PRINT("Could not create Thread\n", NULL);
                exit(0);
            }
        }

        for (int i = 0; i < number_of_threads; i++) 
        {
            WaitForSingleObject(hHandles[i], INFINITE);
        }

        clock_t end = clock();
        double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
        printf("Time spent: %f\n", time_spent);
        
        free(hHandles);
        free(params);
        free(array);
    }

    return 0;
}
