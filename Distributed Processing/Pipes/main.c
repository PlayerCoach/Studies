#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define READ 0
#define WRITE 1
#define STATUS_EXIT 1
#define STATUS_CONTINUE 0
#define SIGKILL 9

char change_case(char c)
{
    if (islower(c))
    {
        return toupper(c);
    }
    else if (isupper(c))
    {
        return tolower(c);
    }
    else
    {
        return c;
    }
}

void change_case_string(char* str)
{
    for (int i = 0; i < strlen(str); i++)
    {
        str[i] = change_case(str[i]);
    }

}

void change_number_to_dot(char* str)
{
    for (int i = 0; i < strlen(str); i++)
    {
        if (isdigit(str[i]))
        {
            str[i] = '.';
        }
    }
}

void insert(int* input_transform_pipe, int* transform_transform_pipe, pid_t pid)
{
    close(input_transform_pipe[READ]);
    close(transform_transform_pipe[WRITE]);
    close(transform_transform_pipe[READ]);

    while(1)
    {
        int status = STATUS_CONTINUE;
        char input[100];
        fgets(input, 100, stdin);

        printf("\n");

        if(strcmp(input, "exit\n") == 0)
        {
            status = STATUS_EXIT;
        }

        write(input_transform_pipe[WRITE], &status, sizeof(status));
      
        if(status == STATUS_EXIT)
        {
            printf("Exiting...\n");
            close(input_transform_pipe[WRITE]);
            waitpid(pid, NULL, 0);
            exit(0);
        }

        write(input_transform_pipe[WRITE], input, strlen(input) + 1);
    }
}

void first_transform(int* input_transform_pipe, int* transform_transform_pipe, int pid)
{
    close(input_transform_pipe[WRITE]);
    close(transform_transform_pipe[READ]);

    while(1)
    {
        int status;
        read(input_transform_pipe[READ], &status, sizeof(status));

        if(status == STATUS_EXIT)
        {
            printf("Transform_one exiting...\n");
            write(transform_transform_pipe[WRITE], &status, sizeof(status));
            close(input_transform_pipe[READ]);
            close(transform_transform_pipe[WRITE]);
            waitpid(pid, NULL, 0);
            exit(0);
        }

        char input[100];
        read(input_transform_pipe[READ], input, sizeof(input));
        printf("Input that was received by thread one: %s \n", input);

        change_number_to_dot(input);
        sleep(1);
        printf("Input after transformation by thread one: %s \n", input);
        
        write(transform_transform_pipe[WRITE], &status, sizeof(status));
        write(transform_transform_pipe[WRITE], input, strlen(input) + 1);
    }
}


void second_transform(int* transform_transform_pipe, int* input_transform_pipe)
{
    int named_pipe = open("named_pipe", O_WRONLY);
    close(input_transform_pipe[READ]);
    close(input_transform_pipe[WRITE]);
    close(transform_transform_pipe[WRITE]);

    while(1)
    {
        int status;
        read(transform_transform_pipe[READ], &status, sizeof(status));

        if(status == STATUS_EXIT)
        {
            printf("Transform_two exiting...\n");
            write(named_pipe, &status, sizeof(status));
            close(transform_transform_pipe[READ]);
            close(named_pipe);
            exit(0);
        }
        
        char input[100];
        read(transform_transform_pipe[READ], input, sizeof(input));
        printf("Input that was received by thread two: %s \n", input);

        change_case_string(input);
        sleep(5);
        printf("Input after transformation by thread two, that will be send to new process: %s \n", input);
        
        write(named_pipe, &status, sizeof(status));
        write(named_pipe, input, strlen(input) + 1);
    }
}

int main()
{
    int input_transform_pipe[2];
    pipe(input_transform_pipe);
    int transform_transform_pipe[2];
    pipe(transform_transform_pipe);
    int transform_output_pipe[2];
    pipe(transform_output_pipe);

    pid_t pid = fork();

    if(pid == -1)
    {
        fprintf(stderr, "Fork failed");
        exit(1);
    }

    if(pid != 0)
    {
        printf("Enter a string or type exit: ");
        insert(input_transform_pipe, transform_transform_pipe, pid);
        
    }
    else
    {
        pid_t pid2 = fork();
        if(pid2 == -1)
        {
            fprintf(stderr, "Fork failed");
            exit(1);
        }

        if(pid2 != 0)
        {
            first_transform(input_transform_pipe, transform_transform_pipe, pid2);
        }
        else
        {
            second_transform(transform_transform_pipe, input_transform_pipe);
        }
    }
    
    return 0;


}