#!/bin/bash

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
