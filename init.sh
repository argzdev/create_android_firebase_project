#!/bin/bash

# Retrieve details from user
source "request-details.sh"

# Retrieve Project ID
source "project-details.txt"

PACKAGE_NAME="com.$OWNER_NAME.$APP_NAME"
ANDROID_API=33
MAX_RETRIES=3
retry_count=0

# Loop until the maximum number of retries is reached
while [ $retry_count -lt $MAX_RETRIES ]; do
  # Run the script
  num_apps=$(firebase --project $PROJECT_ID apps:list 2>&1)
  
  # Check if num_apps contains an error message
  if [[ "$num_apps" == *"Invalid project id"* ]]; then
    echo "$num_apps"
    exit 1
  elif  [[ "$num_apps" == *"Failed to authenticate"* ]]; then
    echo "$num_apps"
    # Try to reauth
    firebase login --reauth
    retry_count=$((retry_count+1))
  else
    # If no error, get count 
    num_apps=$(echo "$num_apps" | grep -oE '[0-9]+ app' | grep -oE '[0-9]+')

    # check if the count is >= 30
    if [ $num_apps -ge 30 ]; then
      echo $'\e[31mError:\e[0m Account has reached the 30 app limit.'
      exit 1
    else
      echo "✔ Account have less than 30 app limit."
      break
    fi
  fi
done

echo "✔ Creating new Android project in Kotlin with name $APP_NAME..."

source "create-android-app.sh" "$OWNER_NAME" "$APP_NAME"

echo "✔ Project $APP_NAME created successfully."

app_id=$(firebase --project $PROJECT_ID apps:create ANDROID --package-name=$PACKAGE_NAME $APP_NAME 2>&1)
if [[ "$app_id" == *"Error"* ]]; then
  echo "$app_id" | grep 'Error: '
  exit 1
else
  app_id=$(echo "$app_id" | grep 'App ID:' | awk '{print $NF}')
  firebase apps:sdkconfig ANDROID $app_id > $APP_NAME/app/google-services.json
fi



