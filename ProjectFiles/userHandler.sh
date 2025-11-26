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
    # clear, if i want to clear terminal each time, but I don't think that's practical for the nature of this program
    case "$input_value" in 
        "1")
            #User Creation Working
            read -p "Choose a username: " username
            # echo -n "Choose a user name: " 
            # read username
            read -s -r -p "Choose a password: " password; printf "\n"
            read -s -r -p "Confirm password: " confirm_password; printf "\n"


            if id "$username" &>/dev/null; then #&>/dev/null sends stdout and stderr to a black hole, only cares about success or failure
                echo "2 : User $username already exists. Returning to menu..."
            else 
                if [[ "$password" == "$confirm_password" ]]; then
                    echo Passwords Match!
                    sudo useradd -m "$username"
                    hashed_password=$(openssl passwd -6 "$password")
                    printf '%s:%s\n' "$username" "$hashed_password" | sudo chpasswd -e
                    unset -v hashed_password
                    echo "0 : User Created Successfully!"
                else
                    echo "2 : Passwords don't match!"
                fi
            fi
            unset -v password confirm_password

            # echo "$username"
            # echo "$password"
            # echo "$confirm_password"
            ;;
        "2")
            read -p "Choose User to Delete: " username

            #prevent deletion of important uid's
            uid="$(id -u "$username")" || { echo "Cannot resolve UID for $username"; continue; }
            if [[ "$username" = "root" || "$uid" -eq 0 ]]; then
                echo "2 : Refusing to delete root."
                continue
            fi
            if [[ "$uid" -lt 1000 ]]; then
                echo "1 : Refusing to delete system accounts (UID < 1000)."
                continue
            fi
            if [[ "$username" = "$(id -un)" ]]; then
                echo "1 : Refusing to delete the currently logged-in user."
                continue
            fi

            #delete function
            if ! id "$username" &>/dev/null; then #checks if username doesn't exist
                echo "User $username does not exist.Returning to menu..."
            else
                read -p "Do you want to remove $username's home directory? (Y/N)" remove_home_input
                case $remove_home_input in
                    "y" | "Y")
                        remove_home="-r"
                        ;;
                    "n" | "N")
                        remove_home=""
                        ;;
                    *)
                        echo "2 : Invalid Input"
                        continue
                        ;;
                    esac
                sudo pkill -u "$username" 2>/dev/null || true
                if sudo userdel ${remove_home:+-r} "$username"; then
                    echo "0 : Successfully deleted user: $username"
                else
                    echo "1 : Failed to delete user: $username"
                fi

            fi
            ;;
        "3")
            read -p "Select user to modify: " username

            if ! id "$username" &>/dev/null; then
                echo "2 : User does not exist. Returning to menu..."
            else
                printf "What would you like to modify for $username: 1, 2, 3, \n"
                printf "1. Change Full Name\n"
                printf "2. Change Password\n"
                printf "3. Add to Group\n"
                printf "4. Change Default Shell\n"
                read modify_this


                # $modify_this="${modify_this,,}" #sets modify_this to all lowercase
                case $modify_this in
                    "1")
                        read -p "Select real name for $username " fullname
                        sudo chfn -f "${fullname:+$fullname}" "$username" 
                        echo $fullname
                        echo $username
                        echo "0 : Successfully Changed Full Name to $fullname"
                        ;;
                    "2")
                        sudo passwd $username
                        printf "0 : Successfully Changed Password"
                        ;;
                    "3")
                        read -p "Input groups you would like to add the user into, separated by spaces: " groups
                        # read -r -a groups_array <<< "groups"
                        group_csv="$(tr -s '[:space:]' ',' <<<"$groups" | sed 's/^,\|,$//g')"
                        sudo usermod -aG  "$groups_csv" "$username"
                        echo "0 : Added $username to groups $groups"
                        ;;
                    "4")
                        
                        cat /etc/shells
                        echo "Enter one of the abouve shells to change to "
                        read shellname
                        sudo chsh -s $shellname $username
                        ;;
                    *)
                        echo "2 : Not an Option"
                        ;;
                    
                    esac
            fi
            ;;
        "4")
            #Account Output Working
            awk -F: '($3 >= 1000 && $3 <= 65000) {print $1}' /etc/passwd
            ;;
        "5")
            #Exit Command Working
            break
            ;;
        *)
            echo "2 : Incorrect Input";   
    esac
    printf "\n"
done