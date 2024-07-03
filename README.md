# User Management Script

## Description

This Bash script automates the process of creating user accounts, setting passwords, and managing group memberships based on input from a text file. It's designed to be run on Unix-like systems with root privileges.

## Features

- Creates user accounts with home directories
- Generates random passwords for each user
- Adds users to specified groups (creates groups if they don't exist)
- Logs all actions for auditing purposes
- Stores user passwords in a secure file

## Prerequisites

- Root access on a Unix-like system (e.g., Linux)
- Bash shell

## Usage

1. Prepare an input file (e.g., `employees.txt`) with the following format:
Each line should contain a username, followed by a semicolon, and then a comma-separated list of groups.

2. Run the script as root:
## Script Behavior

- Checks for root privileges
- Verifies the input file is provided
- Creates a log file at `/var/log/user_management.log`
- Creates a password file at `/var/secure/user_passwords.txt`
- For each user in the input file:
- Checks if the user already exists (skips if so)
- Creates the user with a home directory
- Generates and sets a random 12-character password
- Adds the user to specified groups (creates groups if necessary)
- Logs all actions

## Security Considerations

- The script must be run as root
- Passwords are stored in `/var/secure/user_passwords.txt` with restricted permissions (600)
- The directory `/var/secure` is created with restricted permissions (700) if it doesn't exist

## Log File

The log file (`/var/log/user_management.log`) contains timestamped entries for all actions performed by the script, including:
- User creation
- Password setting
- Group creation
- Adding users to groups
- Any errors encountered

## Password File

The password file (`/var/secure/user_passwords.txt`) stores the generated passwords for each user in the format:
## Error Handling

- Exits if not run as root
- Exits if no input file is provided
- Skips user creation if the user already exists

## Customization

You can modify the following variables in the script to customize its behavior:
- `LOG_FILE`: Location of the log file
- `PASSWORD_FILE`: Location of the password file
- `gen_pass()` function: Modify to change password generation criteria

## Limitations

- Does not handle user deletion or modification
- Does not enforce password policies beyond the 12-character random generation
- Does not handle special characters in usernames or group names

## Caution

This script generates and stores passwords in plaintext. It's recommended to use this for initial account setup only and require users to change their passwords upon first login.

## License

[Specify the license under which this script is distributed]

## Author

[Robinson Uche]


