#!/bin/sh -
USER="zcr268"
PASS="070707"
DOMAIN="zcr268.imwork.net"
#DOMAIN="zcr268.iok.la"
#DOMAIN="167518pe75.iask.in"
URL="http://${USER}:${PASS}@ddns.oray.com:80/ph/update?hostname=${DOMAIN}"

sudo rm -rf /tmp/ddns
if [ -f /tmp/ddns ]; then
    current_ip=$(curl  "http://2017.ip138.com/ic.asp" 2>&1|iconv -fgb2312 -t utf-8|grep "您的IP是："|awk -F "[" '{print $2}'|awk -F "]" '{print $1}')
    req=`cat /tmp/ddns| grep "${current_ip}"`
    if [ ! -z "${req}" ]; then
        old_ip=`echo ${req}| awk '{ print $2}'`
        if [ "${old_ip}" = "${current_ip}" ]; then
            exit
        fi
    fi
fi

sudo wget -q -O /tmp/ddns -q ${URL}
