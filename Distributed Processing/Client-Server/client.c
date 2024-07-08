#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>

struct thread_args 
{
    int server_socket;

};

void delete_line() {
    printf("\x1b[1A"); // Move cursor up one line
    printf("\x1b[2K"); // Erase line
}

void* thread_function(void* arg) {
    int s = ((struct thread_args*)arg)->server_socket;
    char buf2 [80];
        while (recv(s, buf2, sizeof(buf2), 0) > 0) {
            
            printf("\n%s", buf2);
            printf("\n");
            fflush(stdout); // Flush the output buffer to ensure the message is displayed immediately
            memset(buf2, 0, sizeof(buf2)); // Clear the buffer for the next message
        }
    free(arg);
  
}

int main(int argc, char *argv[]) {
    int s, result, length;
    struct sockaddr_in sa;
    char buf[80];

    // Check for command line arguments
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <server_ip>  <usern_name>\n", argv[0]);
        return EXIT_FAILURE;
    }
    //SET USERNAME
    const char* username = argv[2]; 

    // Create socket
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s == -1) {
        perror("Socket creation failed");
        return EXIT_FAILURE;
    }

    // Prepare sockaddr_in structure
    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons(10000);
    sa.sin_addr.s_addr = inet_addr(argv[1]);

    // Connect
    result = connect(s, (struct sockaddr *)&sa, sizeof(sa));
    if (result == -1) {
        perror("Connection failed");
        close(s);
        return EXIT_FAILURE;
    }

    struct thread_args* args = (struct thread_args*)malloc(sizeof(struct thread_args));
        args->server_socket = s;
        pthread_t id;
        pthread_create(&id, NULL, thread_function, args);
    // Send data
    send(s, username, strlen(username), 0);
    fflush(stdout);
    for (;;) {
        fgets(buf, sizeof(buf), stdin);
        delete_line();
        length = strlen(buf);
        buf[length - 1] = '\0'; // remove newline character
        send(s, buf, length, 0);
        if (strcmp(buf, "KONIEC") == 0) break;

        
    }

    // Close socket
    pthread_join(id, NULL);
    free(args);
    close(s);

    return EXIT_SUCCESS;
}
