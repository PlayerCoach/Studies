#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>
#include <semaphore.h>


#define ST_PORT 10000

typedef struct 
{
    const char* username;
    int id;
    struct User* next;
} User;

struct thread_args 
{
    int user_socket;
};

User* user_list = NULL;
sem_t mutex;
int to_quit = 0;

void delete_line() 
{
    printf("\x1b[1A"); 
    printf("\x1b[2K"); 
}

User* delete_user(User* user, int user_socket)
{
    if(user->id == user_socket)
    {
        User* to_delete = user;
        user = user->next;
        free(to_delete->username);
        free(to_delete);
        return user;
    }
    User* temp = user;
    User* next = temp->next;
    while(next->id != user_socket)
    {
        //user left the chat => komunikat
        temp = temp->next;
        next = next->next;
    }
    User* to_delete = temp->next;
    temp->next = to_delete->next;
    free(to_delete->username);
    free(to_delete);
    return user;
}

void* thread_function(void* arg) {
    struct thread_args* args = (struct thread_args*)arg;
    int user_socket = args->user_socket;
    char buf[200];
    User* user = user_list;
    while (recv(user_socket, buf, sizeof(buf), 0) > 0)
    {
    
        // Use semaphore to protect critical section
        if (strcmp(buf, "KONIEC") == 0) 
        {
            sem_wait(&mutex); // Lock semaphore
            close(user_socket);
            user_list = delete_user(user, user_socket);
            sem_post(&mutex); // Unlock semaphore
            free(arg);
            return EXIT_SUCCESS;
        }
        char old_buf[200];  
        strcpy(old_buf, buf);
        char nick_string[200];
        User* temp = user;
        if(temp == NULL)
        {
            perror("User not found");
            free(arg);
            return EXIT_FAILURE;
        }
        while(temp->id != user_socket)
        {
            temp = temp->next;
        }
       
        sprintf(nick_string, "->[%s]: ", temp->username);
        char merged[200];
        strcat(merged, nick_string);
        strcat(merged, buf);
        strcpy(buf, merged);

        
        printf("%s\n", buf);
        fflush(stdout); 
        
        int length = strlen(buf);
        User* user_temp = user;
        while(user_temp != NULL)
        {
            if(user_temp->id == user_socket)
            {
                char temp[200];
                sprintf(temp, "->[%s]: ", "You");
                char merged[200];
                strcat(merged, temp);
                strcat(merged, old_buf);
                strcpy(old_buf, merged);

                send(user_temp->id, old_buf, strlen(old_buf), 0);
                fflush(stdout);
                user_temp = user_temp->next;
                memset(merged, 0, sizeof(merged));
                continue;
            }
            send(user_temp->id, buf, length, 0);
            fflush(stdout); // Flush the output buffer to ensure the message is displayed immediately
            user_temp = user_temp->next;
        }
        memset(old_buf, 0, sizeof(old_buf)); // Clear the buffer for the next message
        memset(buf, 0, sizeof(buf)); // Clear the buffer for the next message
        memset(merged, 0, sizeof(merged));
        memset(nick_string, 0, sizeof(nick_string));
    }
    free(arg);
    return NULL;
}

void free_list(User* user)
{
    User* temp = user;
    while(temp != NULL)
    {
        User* next = temp->next;
        free(temp->username);
        free(temp);
        temp = next;
    }
    free(user);
}

void* listen_for_admin_message(void* arg)
{
    struct thread_args* args = (struct thread_args*)arg;
    int server_socket = args->user_socket;
    printf("Server is running\n");
    for(;;)
    {
        char buf[200];
        fgets(buf, sizeof(buf), stdin);
        int length = strlen(buf);
        buf[length - 1] = '\0'; // remove newline character
        printf("%s\n", buf);
        delete_line();
        if(strcmp(buf, "ZAMKNIJ") == 0)
        {
            sem_wait(&mutex);
            printf("Server is shutting down\n");
            while(user_list != NULL)
            {
                User* temp = user_list;
                user_list = user_list->next;
                close(temp->id);
                free(temp->username);
                free(temp);
            }
            sem_post(&mutex);
            free(arg);
            to_quit = 1;
            int s, result, length;
            struct sockaddr_in sa;
            s = socket(AF_INET, SOCK_STREAM, 0);
            if (s == -1)  
            {
                perror("Socket creation failed");
                return EXIT_FAILURE;
            }

            // Prepare sockaddr_in structure
            memset(&sa, 0, sizeof(sa));
            sa.sin_family = AF_INET;
            sa.sin_port = htons(10000);
            sa.sin_addr.s_addr = inet_addr("127.0.0.1");

            // Connect
            result = connect(s, (struct sockaddr *)&sa, sizeof(sa));
            return;
        }
        memset(buf, 0, sizeof(buf));
    }
}

int main() {
    sem_init(&mutex, 0, 1);
    int server_socket, user_socket;
    struct sockaddr_in sa, sc;
    int lenc, result;
    char buf[80];

    // Create socket
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("Socket creation failed");
        return EXIT_FAILURE;
    }

    // Prepare sockaddr_in structure
    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = INADDR_ANY;
    sa.sin_port = htons(ST_PORT);

    // Bind
    result = bind(server_socket, (struct sockaddr *)&sa, sizeof(sa));
    if (result < 0) {
        perror("Bind failed");
        close(server_socket);
        return EXIT_FAILURE;
    }

    // Listen
    result = listen(server_socket, 5);
    if (result < 0) {
        perror("Listen failed");
        close(server_socket);
        return EXIT_FAILURE;
    }

    struct thread_args* args = (struct thread_args*)malloc(sizeof(struct thread_args));
    args->user_socket = server_socket;
    pthread_t id_server;
    pthread_create(&id_server, NULL, listen_for_admin_message, args);
    
    // Accept and handle connections
    while(to_quit == 0) 
    {
        lenc = sizeof(sc);
        user_socket = accept(server_socket, (struct sockaddr *)&sc, (socklen_t *)&lenc);
        if(to_quit == 1)
        {
            break;
        }
        if (user_socket < 0) {
            perror("Accept failed");
            close(server_socket);
            return EXIT_FAILURE;
        }

        char username[200];
        recv(user_socket, username, sizeof(username), 0);
        sem_wait(&mutex);
        if(user_list == NULL)
        {
            user_list = (User*)malloc(sizeof(User));
            
            user_list->username = calloc(strlen(username) + 1, sizeof(char));
            strcpy(user_list->username, username);
            user_list->id = user_socket;
            user_list->next = NULL;
        }
        else
        {
            User* temp = user_list;
            while(temp->next != NULL)
            {
                temp = temp->next;
            }
            User* temp_user = (User*)malloc(sizeof(User));
            temp->next = temp_user;
            temp_user->id = user_socket;
            temp_user->username =  calloc(strlen(username) + 1, sizeof(char));
            strcpy(temp_user->username, username);
            temp_user->next = NULL;
        }
        sem_post(&mutex);

        struct thread_args* args = (struct thread_args*)malloc(sizeof(struct thread_args));
        args->user_socket = user_socket;
        pthread_t id;
        pthread_create(&id, NULL, thread_function, args);
        
        memset(username, 0, sizeof(username));
    }
    printf("Server is down\n");
    close(server_socket);
    free_list(user_list);
    pthread_join(id_server, NULL);

    // Free the dynamically allocated memory for args
    free(args);
    return EXIT_SUCCESS;
}
