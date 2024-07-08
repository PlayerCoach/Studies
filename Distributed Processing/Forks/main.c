#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>

#ifndef NDEBUG
#define DEBUG 1
#else
#define DEBUG 0
#endif



int main() {
   
    pid_t pid;
    pid_t zombie;
    int n = 8; // depth of the tree
    while(n > 0) 
    {
        pid = fork();

        if(pid == -1) 
        {
            #if DEBUG
                perror("fork");
            #endif
            
            return 1;
        }

        if(pid == 0) 
        {
            n--;
           
        } 

        else 
        {
            if(n%2 == 0)
            {
                zombie = fork();
                if(zombie == -1)
                {
                    #if DEBUG
                        perror("fork");
                    #endif
                    return 1;
                }
                  
            }
            waitpid(pid, NULL, 0);
            break;
        }

         if(n == 0) 
        {
            execlp("ps", "-u olaf", "--forest", NULL);
        } 
    }

  
    
    return 0;
}
