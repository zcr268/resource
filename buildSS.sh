#!/bin/bash
# wget https://raw.githubusercontent.com/zcr268/resource/master/buildSS.sh && chmod u+x buildSS.sh && ./buildSS.sh
sudo apt-get update
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
sudo -H pip install shadowsocks
read -p "Enter your password : " password 
sudo ssserver -p 8000 -k $password -m rc4-md5 -d start
echo "rc4-md5 password : $password"
