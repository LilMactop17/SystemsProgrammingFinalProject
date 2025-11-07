#!/bin/bash
while true 
do
    printf "Select a menu option: 1, 2, 3, 4, 5\n"
    printf "1. Create New User\n"
    printf "2. Delete User\n"
    printf "3. Modify User\n"
    printf "4. View Existing Users\n"
    printf "5. Exit\n"
    read input_value
    case "$input_value" in 
        "2" | "3")
            echo "$input_value"
            ;;
        "1")
            echo Choose a user name: 
            read username

            if [[ "$username" = *[[:space:]]* ]]; then
                echo "Invalid Username -> No spaces allowed!"
            fi
            if [[ "$username" = -* ]]; then
                echo "Invalid Username -> Username cannot start with '-'"
            fi

            echo "$username"
            ;;
        "4")
            awk -F: '($3 >= 1000 && $3 <= 65000) {print $1}' /etc/passwd
            ;;
        "5")
            echo "$input_value"
            break
            ;;
        *)
            echo Incorrect Input;   
    esac
done