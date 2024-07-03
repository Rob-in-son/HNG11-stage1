#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "Switch to root to run this script" 
   exit 1
fi

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "You need to provide the employees.txt file"
    exit 1
fi

#Define variables
FILE_NAME=$1
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"


# Create log file if it doesn't exist
touch "$LOG_FILE"

# Define function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Ensure the directory for PASSWORD_FILE exists
PASSWORD_DIR=$(dirname "$PASSWORD_FILE")
if [ ! -d "$PASSWORD_DIR" ]; then
    mkdir -p "$PASSWORD_DIR"
    chmod 700 "$PASSWORD_DIR"
    log_message "Created $PASSWORD_DIR directory."
fi

# Create password file if it doesn't exist and set permissions
touch "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"


# Function to generate password
gen_pass() {
    < /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()_+' | head -c 12
}

# Read each line in the file
while IFS=';' read -r username groups;
    do
        # Remove leading & trailing whitespace
        username=$(echo "$username" | xargs)
        groups=$(echo "$groups" | xargs)

        # Check if user already exists
        if id -u "$username" >/dev/null 2>&1; then
            log_message "User '$username' already exists. Skipping creation."
            continue
        fi

        # Create user with the home directory
        useradd -m $username
        log_message "Created user: $username" || log_message "Failed to create user: $username"

        # Set random password
        password=$(gen_pass)
        echo "$username,$password" | chpasswd
        echo "$username,$password" >> "$PASSWORD_FILE"
        log_message "Set password for user: $username"

        # Add user to additional groups
        IFS=',' read -ra group_array <<< "$groups"
        for group in "${group_array[@]}"; do
            group=$(echo "$group" | xargs)
            if ! getent group "$group" >/dev/null; then
                groupadd "$group"
                log_message "Created group: $group"
            fi
            usermod -a -G "$group" "$username"
            log_message "Added user $username to group: $group"
        done

        log_message "Completed setup for user: $username"
    done < $FILE_NAME

echo "User creation process completed. Check $LOG_FILE for details."