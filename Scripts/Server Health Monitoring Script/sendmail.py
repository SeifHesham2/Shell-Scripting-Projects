#!/usr/bin/env python3

import argparse
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def send_email(sender_email, sender_password, recipient_email, subject, message):
    # Setup the MIME
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = recipient_email
    msg['Subject'] = subject

    # Attach the message to the MIMEMultipart object
    msg.attach(MIMEText(message, 'plain'))

    # Create SMTP session for sending the email
    try:
        session = smtplib.SMTP('smtp.gmail.com', 587)
        session.starttls() # enable security
        session.login(sender_email, sender_password) # login with mail_id and password
        text = msg.as_string()
        session.sendmail(sender_email, recipient_email, text)
    except Exception as e:
        print("An error occurred:", e)
    finally:
        session.quit()  # close the session

def main():
    parser = argparse.ArgumentParser(description='Send email script')
    parser.add_argument('--sender-email', required=True, help='Sender email address')
    parser.add_argument('--sender-password', required=True, help='Sender email password')
    parser.add_argument('--recipient-email', required=True, help='Recipient email address')
    parser.add_argument('--subject', required=True, help='Subject of the email')
    parser.add_argument('--message', required=True, help='Body of the email message')
    args = parser.parse_args()

    send_email(args.sender_email, args.sender_password, args.recipient_email, args.subject, args.message)

if __name__ == "__main__":
    main()

