#!/bin/bash

authToken="eclffgnmtw7art08608qvld2"
rootId="8db662d66e"
ipprefix="192.168.177"
ip="${ipprefix}.0/24"

networkId="${rootId}000001"
memberId="8a9f58dc0f"

ipAssignmentPools='"ipAssignmentPools":[{"ipRangeStart":"'${ipprefix}'.2","ipRangeEnd":"'${ipprefix}'.254"}]'
routes='"routes":[{"target":"'${ip}'","via":null}]"'
authorized='"authorized" : "true"'

install(){
    curl -s https://install.zerotier.com/ | sudo bash
}
getEnv(){
    echo -e "authToken=${authToken}\nnetworkId=${networkId}\nmemberId=${memberId}"
}

getNetwork(){
    curl  --header "X-ZT1-Auth: ${authToken}" http://localhost:9993/controller/network
}

getNetwork(){
    curl  --header "X-ZT1-Auth: ${authToken}" http://localhost:9993/controller/network/${networkId}
}

getMember() {
    curl --header "X-ZT1-Auth: ${authToken}" http://localhost:9993/controller/network/${networkId}/member
}

createNetwork(){
    curl -X POST --header "X-ZT1-Auth: ${authToken}" -d "{\"name\":\"$1\",${ipAssignmentPools},${routes}}"http://localhost:9993/controller/network/${networkId}
}


ipAssignments='"ipAssignments":["192.168.177.110"]'
authorized() {
    curl -X POST --header "X-ZT1-Auth: ${authToken}" -d "{${authorized}}" http://localhost:9993/controller/network/${networkId}/member/${memberId}
}

deleteMember() {
    curl -X DELETE --header "X-ZT1-Auth: ${authToken}" http://localhost:9993/controller/network/${networkId}/member/${memberId}
}
