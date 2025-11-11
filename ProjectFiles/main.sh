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
        "1")
            #User Creation Working
            read -p "Choose a username: " username
            # echo -n "Choose a user name: " 
            # read username
            read -s -r -p "Choose a password: " password; printf "\n"
            read -s -r -p "Confirm password: " confirm_password; printf "\n"


            if id "$username" &>/dev/null; then #&>/dev/null sends stdout and stderr to a black hole, only cares about success or failure
                echo "User $username already exists. Returning to menu..."
            else 
                if [[ "$password" == "$confirm_password" ]]; then
                    echo Passwords Match!
                    sudo useradd -m "$username"
                    hashed_password=$(openssl passwd -6 "$password")
                    printf '%s:%s\n' "$username" "$hashed_password" | sudo chpasswd -e
                    unset -v hashed_password
                    echo "User Created Successfully!"
                else
                    echo "Passwords don't match!"
                fi
            fi
            unset -v password confirm_password

            # echo "$username"
            # echo "$password"
            # echo "$confirm_password"
            ;;
        "2")
            read -p "Choose User to Delete: " username
            if ! id "$username" &>/dev/null; then #checks if username doesn't exist
                echo "User $username does not exist.Returning to menu..."
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
        "3")
            read -p "Select user to modify" $username
            if ! id $username &>/dev/null; then
                echo "User does not exist. Returning to menu..."
            else
                read -p "What do you want to modify for user $username" modify_this
                $modify_this="${modify_this,,}" #sets modify_this to all lowercase
                case $modify_this in
                    "full name")
                        read -p "Select real name for $username?" full_name
                        sudo chfn -f ${fullname:+$fullname} "$username" 
                        ;;
                    
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