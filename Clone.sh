#!/usr/bin/env bash
# 
# Copyright (c) 2020 Kamal Hamza
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#Change directory for cronjob
cd "$(dirname "$0")";

#Log Backup Start time
start_time=$(date +%c)

#Mirror Backup
sshpass -f cred.txt rsync -avzh --stats KamalH@10.198.53.2:/cygdrive/e/IITBApplication/Backup/ /mnt/f1da210e-6a0d-4bd2-95e6-f79f3e37af55/10.198.53.2/Backup/ | sed '0,/^$/d' > /mnt/f1da210e-6a0d-4bd2-95e6-f79f3e37af55/10.198.53.2/log.txt;

#Log Backup End time
end_time=$(date +%c)

cp /mnt/f1da210e-6a0d-4bd2-95e6-f79f3e37af55/10.198.53.2/log.txt log.txt;

#Upload detailed log in Pastebin
log=$(cat log.txt)
key=$(cat api_key.txt)

curl --request POST -sL \
    --url 'https://pastebin.com/api/api_post.php' \
    --data "api_dev_key=${key}" \
    --data 'api_option=paste' \
    --data "api_paste_code=${log}" \
    --data 'api_paste_private=1' \
    --data 'api_paste_format=prolog' \
    --data 'api_paste_name=Log Summary' \
    --data 'api_paste_expire_date=2W'
> log_upload.txt;

log_link=$(cat log_upload.txt)

#Get Backup size
backup_size=$(du -h /mnt/f1da210e-6a0d-4bd2-95e6-f79f3e37af55/10.198.53.2/Backup/ | sort -rh | head -1 | cut -f1 -d "/" | sed 's/[[:blank:]]//g')

#Prepare JSON file for email
jq -n --arg start_time "$start_time" --arg end_time "$end_time" --arg log_link "$log_link" --arg backup_size "$backup_size" '{ "start_time": $start_time, "end_time": $end_time, "log_link": $log_link, "backup_size": $backup_size }' > email_details.json;

#Send Emails
cp email_details.json Email/email_details.json;
cd Email;
./Email_Sender.sh;
sleep 5;
exit