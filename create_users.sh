#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "You need to provide the employees.txt file"
    exit 1
fi

#Get and store filename as a variable
FILE_NAME=$1

# Read each line in the file
while IFS= read -r line;
    do
        #extract username from the line
        user=$(cut -d';' -f1)

        #Add user with the home directory
        useradd -m $user

        #check if user is created
        if id -u $user &> /dev/null; then
            echo "User '$user' exists."
        else
            echo "User '$user' does not exist."
        fi
        # cut -d';' -f2- 
    done < $FILE_NAME

# Light; sudo,dev,www-data
