#!/bin/bash
while true 
do
    echo "Select a menu option: 1, 2, 3, 4, 5"
    read input_value
    case "$input_value" in 
        "1" | "2" | "3" | "4")
            echo "$input_value";;
        "5")
            echo "$input_value"
            break;;
        *)
            echo Incorrect Input;   
    esac
done