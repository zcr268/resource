#!/bin/bash
# wget https://raw.githubusercontent.com/zcr268/resource/master/buildSS.sh && chmod u+x buildSS.sh && ./buildSS.sh
sudo apt-get update
sudo apt-get -y install shadowsocks
read -p "Enter your password : " password 
sudo ssserver -p 8000 -k $password -m rc4-md5 -d start
echo "rc4-md5 password : $password"
