#include <pwd.h>
#include <stdio.h>
#include <string.h>
#include "userHandler.h"

int main () {
    struct passwd *pw;

    


    int selected = 0;
    int ch;

    printf("Welcome to the user handler!\n");
    while(1) {
        if (selected == 0) {
            printf(
            "Selected an Option to Proceed (1, 2, 3, 4)\n"
            "1. Create New User\n"
            "2. Delete User\n"  
            "3. Modify Existing User\n"
            "4. Show Existing Users\n"
            "5. Exit\n"
            );
        }

        // use &selected because scanf writes into the memory address
        // so it needs the memory location of the variable 'selected'
        scanf("%d", &selected);
        if              (selected == 1) { createUser(); }
        else if         (selected == 4) { listUsers(pw); }
        else if         (selected == 5) { printf("Goodbye :)\n"); break; }


        //The 'do while' loop clears the input stream, stopping an infinite error loop
        else { 
            printf("Error: Illegal input!\n"); 
            do {
                ch = getchar();
            } while ((ch != EOF) && (ch != '\n'));
        }



        selected=0;

    }
    return 0;
}