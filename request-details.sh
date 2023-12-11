#!/bin/bash

# Retrieve arguments
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "Options:"
            echo "-h, --help                  Show brief help"
            echo "-a, --appname               Specify an app name being generated"
            exit 0
            ;;
        -a|--appname*)
            shift
            APP_NAME=$1
            shift
            ;;
        *)
            break
            ;;
    esac
done

CREDENTIALS_FILE="./project-details.txt"

# If credential file does not exist
# Ask for details then store in credentials.txt
if [ ! -f $CREDENTIALS_FILE ]; then
# Ask for project ID
read -p $'\e[32m?\e[0m Please input the project ID you would like to use: \e[36m' PROJECT_ID

# Create credentials.txt
cat <<EOF > $CREDENTIALS_FILE
PROJECT_ID=$PROJECT_ID
EOF

# Ask for owner name
read -p $'\e[32m?\e[0m Please input the owner name for your projects: \e[36m' OWNER_NAME

# Add owner name in credentials.txt
cat <<EOF >> $CREDENTIALS_FILE
OWNER_NAME=$OWNER_NAME
EOF
fi

# If app name argument is not provided, then request from user
if [ -z "$APP_NAME" ]; then
    read -p $'\e[32m?\e[0m Please input the app name you would like to use: \e[36m' APP_NAME
fi

echo '\033[0m'