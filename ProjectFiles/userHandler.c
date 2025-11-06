#include <pwd.h>
#include <stdio.h>
#include <string.h>
#include "userHandler.h"

#define HOMEDIR "/home/";

void listUsers(struct passwd *pw) { //Working
    char homeDir[] = HOMEDIR;
    size_t homeDirLength = strlen(homeDir); 

    setpwent();
    int numOfAccounts = 0;


    printf("\n");

    while ((pw = getpwent()) != NULL) {
        char *currDir = pw->pw_dir;
        for (int i = 0; i<homeDirLength; i++) {
            if (currDir[i] != homeDir[i]) {
                break;
            }
            else if (i == homeDirLength-1) {
                printf("Username: %s, UID: %d, GID: %d, Home Directory: %s, Shell: %s\n",
                    pw->pw_name, pw->pw_uid, pw->pw_gid, pw->pw_dir, pw->pw_shell);
                    numOfAccounts += 1;
            }
        }
    }
    printf("\n");
}


int createUser() {
    char username[100];
    char *password;
    char *confirmPassword;
    int ch;
    //Input User Name
    printf("Choose a User Name: ");

    do {
        ch = getchar();
    } while ((ch != EOF) && (ch != '\n'));
    fgets(username, sizeof(username), stdin);

    printf("%s", username);

    //username[strcspn(username, "\n")] = '\0';

    //Error Handler Works
    if (strchr(username, ' ') != NULL) {
        username[0] = '\0'; //Clears username just in case
        printf("Error: Username cannot contain spaces.\n");
        return -1;
    }

    //Create Password

    //Confirm Password

    //Confirm Success


    return 0;
}