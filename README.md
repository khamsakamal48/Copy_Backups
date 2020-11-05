# Basic copy tool from Windows to Ubuntu

This is a basic mirroring script to copy files/backup between Windows (source) & Ubuntu (destination).

The script will run on Ubuntu machhine.

## Pre-requisite

Install rsync for windows. I personally used [cwrsync](https://www.itefix.net/cwrsync) for my setup.

## Usage
* Dowload or Git Clone this package
* Create new cred.txt and api_key.txt file
* Install sshpass to read password from file

  ```bash
   touch cred.txt
   touch api_key.txt

   sudo apt install sshpass curl jq
  ```
* Save the SSH password of your Windows machine into cred.txt file
* Create a new account in Pastebin & get an API key
* Add the api key ino api_key.txt file
* Set a cronjob or manually run the script after setting up source and destination of your files

  ```bash
   ./Clone.sh
  ```

## Acknowledgement
Folks at StackOverflow, Ubuntu and Linux community
