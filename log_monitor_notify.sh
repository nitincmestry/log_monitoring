#!/bin/bash

# Configuration
logfile="/path/to/your/log/file.log"
error_keywords=("error" "failed" "exception")
warning_keywords=("warning" "caution")
email_subject="Log Monitoring Alert"
email_body="A new log entry matching the criteria has been detected:"
smtp_server="smtp.gmail.com"
smtp_port=465
sender_email="your_email@gmail.com"
receiver_email="recipient_email@gmail.com"
password="your_email_password"  # Replace with your Gmail app password

# Function to send email
send_email() {
  echo "$2" | mail -s "$1" -a -f "$sender_email" "$receiver_email" -S smtp=$smtp_server:$smtp_port -o smtp_auth_user=$sender_email -o smtp_auth_password=$password
}

# Continuously monitor the log file
while true; do
  # Tail the log file to get the latest lines
  tail -n 100 "$logfile" | while read line; do
    # Check for error or warning keywords
    for keyword in "${error_keywords[@]}"; do
      if [[ "$line" =~ "$keyword" ]]; then
        send_email "$email_subject" "$email_body $line"
        break
      fi
    done

    for keyword in "${warning_keywords[@]}"; do
      if [[ "$line" =~ "$keyword" ]]; then
        send_email "$email_subject" "$email_body $line"
        break
      fi
    done
  done
  sleep 60  # Check every 60 seconds
done
