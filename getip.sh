#!/bin/sh
#curl -s --interface ppp0 https://www.ip.cn/|grep IP|sed -n 's/.*IP\:\ \([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/p'
ifconfig ppp0|grep "inet addr"|sed -n 's/.*addr\:\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/p'
