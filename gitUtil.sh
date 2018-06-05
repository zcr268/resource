#!/bin/bash


. ~/my.cfg

namespace_id=`curl "${git_url}/api/v3/groups?private_token=${private_token}&statistics=true" 2>/dev/null|sed 's/.*id":\(.*\),"name":"'$gruop_name'.*/\1/'`

echo_cmd ()
{
    if $echo_cmd
    then
        echo $*
    fi
}

search_project ()
{
    echo_cmd $FUNCNAME $*
    local project_name=$1;
    curl "${git_url}/api/v3/projects?private_token=${private_token}&search=${projectName/./-}&simple=true" 2>&1|grep -i "\"${gruop_name}/${project_name}\""
}

create_project ()
{
    echo_cmd $FUNCNAME $*
    local project_name=$1;
    local project=`search_project $project_name|grep -i "${gruop_name}/${project_name}" `
    while [ ! -n "$project" ]
    do
        echo 创建项目 $project_name
        curl "${git_url}/api/v3/projects" -d "namespace_id=${namespace_id}&name=${project_name}&description=${project_name}&visibility_level=0&private_token=${private_token}" 2>&1
        #|cat > /dev/null
        sleep 1
        project=`search_project $project_name|grep -i "\"${gruop_name}/${project_name}\""`
    done
}

delete_project(){
    echo_cmd $FUNCNAME $*
    local project_name=$1;
    local project=`search_project $project_name|grep -i "${gruop_name}/${project_name}" `
    while [ -n "$project" ]
    do
        echo 删除项目 $project_name
        curl -X DELETE "${git_url}/api/v3/projects/${gruop_name}%2F${projectName/./-}?private_token=${private_token}" 2>&1
        echo
        sleep 1
        project=`search_project $project_name|grep -i "\"${gruop_name}/${project_name}\""`
    done
}

echo_name(){
	name=$1
	line="============== ${name} =============="    
    num=${#line}
    if (( num <= 50 ));then
        (( num = 50 - num ))
        line+=${xxx:0:num}
    fi
    echo $line
}

cloneOne(){
    projectName=$1
    echo_name $projectName
    if [ ! -d "${projectName}.git" ];then
        echo new ${projectName}
        git clone --mirror https://gitlab.vdian.net/pay/${projectName}.git
        sleep 1;
    else
        echo update ${projectName}
        cd ${projectName}.git
        git fetch
        check=$?
        cd ..
        if [ $check != 0 ];then
            error_projectName="${error_projectName},${projectName}"
            echo new ${projectName}
            rm -rf ${projectName}.git
            git clone --mirror https://gitlab.vdian.net/pay/${projectName}.git
            sleep 1;
        fi
    fi
    
    push_One $projectName
    echo ${line//?/=}
    #sleep 1;
}

push_One(){
    projectName=$1
    create_project ${projectName}
    cd ${projectName}.git
    check=$?
    if [ $check != 0 ];then
        error_projectName="${error_projectName},${projectName}"
        pwd
        ls ${projectName}.git
        exit
    fi
    git push --mirror ${git_url}/${gruop_name}/${projectName/./-}.git
    check=$?
    if [ $check != 0 ];then
        error_projectName="${error_projectName},${projectName}"
        delete_project ${projectName}
        create_project ${projectName}
        git push --mirror ${git_url}/${gruop_name}/${projectName/./-}.git
    fi
    cd ..
}

push_All(){
    for git_name in `find . -name "*.git" -d -maxdepth 1` ;
    do
        projectName=`basename ${git_name%\.*}`;
        echo_name $projectName
        push_One $projectName
    done
}

error_projectName=""
cloneAll ()
{
    echo cloneAll
    pages=`curl https://gitlab.vdian.net/groups/pay?private_token=${src_private_token} 2>&1|grep '<li class="page' |wc -l`
    xxx="================================================================================================================="
    for((i=1;i<=pages;i++))
    do
        for projectName in `curl https://gitlab.vdian.net/groups/pay?page=$i\&private_token=${src_private_token} 2>&1 |grep '<a class="project" href="/pay/'|cut -d '/' -f 3|cut -d '"' -f 1 |grep -v vdianpay`;
        do
            cloneOne ${projectName}
        done
    done
    echo "发生过异常项目: ${error_projectName}"
    create_project mvn
    rm -rf settleplatform.git
    git clone --mirror https://gitlab.vdian.net/trade/settleplatform.git
    cd settleplatform.git
    git push --mirror ${git_url}/zcr268/settleplatform.git
}

case $1 in
    "-c"|"create_project") create_project $2;;
    "-s"|"search_project") search_project $2;;
    "-d"|"delete_project") delete_project $2;;
    "-co"|"cloneOne") cloneOne $2;;
    "-p"|"push_One") push_One $2;;
	"-pa"|"push_All") push_All $2;;
    *) echo_cmd=false;cloneAll;;
esac
