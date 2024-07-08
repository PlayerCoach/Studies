#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define STATUS_EXIT 1
#define STATUS_CONTINUE 0


int main()
{
    int named_pipe = open("named_pipe", O_RDONLY);
    if (named_pipe == -1)
    {
        perror("open");
        exit(EXIT_FAILURE);
    }

    while(1)
    {
        int status;
        read(named_pipe, &status, sizeof(status));

        if (status == STATUS_EXIT)
        {
            printf("Exiting view\n");
            close(named_pipe);
            break;
        }

        char ouput[100];
        read(named_pipe, ouput, sizeof(ouput));
        printf("Received string: %s\n", ouput);

    }
}



