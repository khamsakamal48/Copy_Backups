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

̦#Change directory for cronjob
cd "$(dirname "$0")";

#Get values
start_time=$(jq -r '.start_time' email_details.json)
end_time=$(jq -r '.end_time' email_details.json)
log_link=$(jq -r '.log_link' email_details.json)
backup_size=$(jq -r '.backup_size' email_details.json)

#Replace variables in HTML File
rm -rf Email.html;
cp Email.html.bak Email.html;
sed -i "s|start_time|$start_time|g" Email.html;
sed -i "s|end_time|$end_time|g" Email.html;
sed -i "s|log_link|$log_link|g" Email.html;
sed -i "s|backup_size|$backup_size|g" Email.html;

#Let's send mail now
python main.py;
sleep 2;
rm -rf email_details.json;