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
            #User Creation Working
            read -p "Choose a username: " username
            # echo -n "Choose a user name: " 
            # read username
            echo -n "Choose a password: "
            read -s password #-s hides user input
            printf "\n"
            echo -n "Confirm password: "
            read -s confirm_password
            printf "\n"


            if id "$username" &>/dev/null; then #&>/dev/null sends stdout and stderr to a black hole, only cares about success or failure
                echo "User $username already exists. Aborting User Creation"
            else 
                if [[ "$password" == "$confirm_password" ]]; then
                    echo Passwords Match!
                    sudo useradd -m "$username"
                    hashed_password=$(openssl passwd -6 "$password")
                    sudo usermod --password "$hashed_password" "$username"

                    echo "User Created Successfully!"
                else
                    echo "Passwords don't match!"
                fi
            fi

            # echo "$username"
            # echo "$password"
            # echo "$confirm_password"
            ;;
        "4")
            #Account Output Working
            awk -F: '($3 >= 1000 && $3 <= 65000) {print $1}' /etc/passwd
            ;;
        "5")
            #Exit Command Working
            echo "$input_value"
            break
            ;;
        *)
            echo Incorrect Input;   
    esac
done