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
        "3")
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
        "2")
            read -p "Choose User to Delete: " username
            if ! id "$username" &>/dev/null; then #checks if username doesn't exist
                echo "User $username does not exist. No user to delete!"
            else
                read -p "Do you want to remove $username's home directory? (Y/N)" remove_home_input
                case $remove_home_input in
                    "y" | "Y")
                        remove_home="--remove-home"
                        ;;
                    "n" | "N")
                        remove_home=""
                        ;;
                    *)
                        echo Invalid Input
                        continue
                        ;;
                    esac
                sudo pkill -u "$username" 2>/dev/null || true
                sudo deluser ${remove_home:+$remove_home} "$username"
            fi
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