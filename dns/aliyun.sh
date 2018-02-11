#!/bin/sh
# https://www.cnblogs.com/jsp1256/p/7764632.html

##配置信息
host="host"
domain="example.com"
ip_network="wan6"
timestamp=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
ak="your ak"  #你的阿里云app key
sk="your sk&"  #“你的阿里云app secret&”  注意后面多个“&”
 
#读取本地数据库存储的信息，若有
ipfilename=$(echo $(basename $0))  #获取自身文件名
ipfilename=$(cd "$(dirname "$0")"; pwd)/${ipfilename%.*} 
if [ -f "$ipfilename"_ip ] 
   then
    . "$ipfilename"_ip
   else
   saved_ip=""; record_id="" ;saved_host="" ;saved_domain=""
fi
ip=""
RETRY="0"
while [ $RETRY -lt 5 ]; do  #获取本机ipv6地址信息
     ip=$(ubus call network.interface.$ip_network status | grep \"address\" | grep -oE '[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}')
    RETRY=$((RETRY+1))
    if [ -z "$ip" ];then
        sleep 3
    else
        break
    fi
done
 
#获取DNS域名服务器对域名解析的ipv6地址
if [ "$ip" = "$saved_ip" ];then
if [ host="@" -o host="" ];then 
IPDNS=$(nslookup $domain dns16.hichina.com 2>/dev/null | sed -n 's/Address 1: \([0-f.]*\)/\1/p' | sed -n '2p' | grep -oE '[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}')
else
IPDNS=$(nslookup $host.$domain dns16.hichina.com 2>/dev/null | sed -n 's/Address 1: \([0-f.]*\)/\1/p' | sed -n '2p' | grep -oE '[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}\:[0-f]{0,4}')
fi
fi
 
#检查比对本地数据库存储的ip
#也可以与IPDNS进行比较，替换saved_ip为IPDNS即可
if [ "$ip" = "$saved_ip" -a "$host" = "$saved_host" -a "$domain" = "$saved_domain" ];then
    echo "$(date +"%Y-%m-%d %H:%M:%S")--Host:[$host.$domain] Already updated."
    exit 0
fi
urlencode1() {
    local length="${#1}"
    i=0
    out=""
    for i in $(awk "BEGIN { for ( i=0; i<$length; i++ ) { print i; } }")
    do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~'&'=_-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
        i=$(($i + 1))
     done
     echo -n $out
}
urlencode2() {
    local length="${#1}"
    i=0
    out=""
    for i in $(awk "BEGIN { for ( i=0; i<$length; i++ ) { print i; } }")
    do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
        i=$(($i + 1))
     done
     echo -n $out
}
send_request() {   
args="AccessKeyId=$ak&Action=$1&Format=json&$2&Version=2015-01-09"
StringToSign1="$(urlencode1 $args)"
StringToSign2="GET&%2F&$(urlencode2 $StringToSign1)"
    hash=$(urlencode2 $(echo -n "$StringToSign2" | openssl dgst -sha1 -hmac $sk -binary | openssl base64))
RESULT=$(curl -k -s "https://alidns.aliyuncs.com/?$args&Signature=$hash")  ## 2> /dev/null)
echo $RESULT
}
query_recordid() {
 if [ "$host" = "@" ]; then 
echo `send_request "DescribeSubDomainRecords" "SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&SubDomain=$domain&Timestamp=$timestamp"`
 else
echo `send_request "DescribeSubDomainRecords" "SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&SubDomain=$host.$domain&Timestamp=$timestamp"`
 fi
}
update_record() {
    echo `send_request "UpdateDomainRecord" "RR=$host&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&Timestamp=$timestamp&Type=AAAA&Value=$ip"`
}
add_record() {
    echo `send_request "AddDomainRecord&DomainName=$domain" "RR=$host&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&Timestamp=$timestamp&Type=AAAA&Value=$ip"`
}
#查询解析记录信息
RESULT=`query_recordid`
record_id=$(echo $RESULT | grep -o "RR\":\"$host\",\"Status\":\"[a-zA-Z]*\",\"Value\":\"[0-f:]*\",\"Weight\":[0-9]*,\"RecordId\":\"[0-9]*\""|grep -o "RecordId\":\"[0-9]*\""|grep -o "[0-9]*")
if [ "$record_id" = "" ]
  then
#新增解析记录
RESULT=`add_record`
record_id=$(echo $RESULT | grep -o "RecordId\":\"[0-9]*\""|grep -o "[0-9]*")
echo "$RESULT"
if [ "$record_id" != "" ];then
   echo "$(date +"%Y-%m-%d %H:%M:%S") -- Added Host [$host.$domain] (IP: $ip)"
   echo "record_id=$record_id; saved_ip=$ip ;saved_host=$host ;saved_domain=$domain" > "$ipfilename"_ip
 else
echo "Not Find Such Host $host.$domain"
fi
  else
#更新解析记录
RESULT=`update_record $record_id`
#record_id=$(echo $RESULT | grep -o "RecordId\":\"[0-9]*\""|grep -o "[0-9]*")
echo "$RESULT"
echo "$(date +"%Y-%m-%d %H:%M:%S") -- Update Host [$host.$domain] (IP: $ip)"
echo "record_id=$record_id; saved_ip=$ip ;saved_host=$host ;saved_domain=$domain" > "$ipfilename"_ip
fi
