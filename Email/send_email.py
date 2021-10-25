import smtplib, ssl, json, time, imaplib

from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

recipient = "amol.rathod@acriitb.ac.in"
cc = "dhananjay.satale@acr.iitb.ac.in"
subject = "Information regarding the Backup activity of Server at 10.198.53.2"

# Read server setting and credentials of email account from credentials.json
with open('credentials.json') as f:
  cred = json.load(f)
  sender_email = cred["from"]
  imap_address = cred["imap_server"]
  smtp_address = cred["smtp_server"]
  i_port = cred["imap_port"]
  o_port = cred["smtp_port"]
  login = cred["username"]
  password = cred["password"]
  reply_to = cred["reply_to"]

message = MIMEMultipart("alternative")
message["Subject"] = subject
message["From"] = sender_email
message["To"] = recipient
message["Cc"] = cc

# Adding Reply-to header
message.add_header('reply-to', reply_to)

body = open('Email.html')
html_email = body.read()
# Turn these into html MIMEText objects
emailbody = MIMEText(html_email, "html")
# Add HTML parts to MIMEMultipart message
# The email client will try to render the last part first
message.attach(emailbody)
emailcontent = message.as_string()

# Create secure connection with server and send email
context = ssl.create_default_context()
with smtplib.SMTP_SSL(smtp_address, o_port, context=context) as server:
    server.login(login, password)
    server.sendmail(
        sender_email, sender_email,  emailcontent
    )

# Save copy of the sent email to sent items folder
with imaplib.IMAP4_SSL(imap_address, i_port) as imap:
    imap.login(login, password)
    imap.append('Sent', '\\Seen', imaplib.Time2Internaldate(time.time()), emailcontent.encode('utf8'))
    imap.logout()