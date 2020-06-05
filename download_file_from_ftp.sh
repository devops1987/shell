#!/bin/sh
# author: wupeng
# func: 从xxx.xxx.xxx.xxx ftp下载数据
# cron: * */1 * * * cd /home/overlord/ops && sh -x download_rh_HGUPERIODIC.sh > /dev/null 2>&1

source /etc/profile

T=${1:-"$(date -d 'last hours' +%Y%m%d%H)"}

#if [ -z ${T} ];then
#    T=$(date -d 'last hours' +%Y%m%d%H)
#fi

#printf ${T1}
FTP_IP=${2:-"xxx.xxx.xxx.xxx"}
FTP_U=${3:-"user"}
FTP_P=${4:-"passwd"}
LOCAL_HGUPERIODIC_FILE_PATH="/home/overlord/HGUPERIODIC_rehen_cqba"
DIR_TIMESTAMP=$(date +%Y%m%d)
REMOTE_PERIODIC_PATH="${DIR_TIMESTAMP}/HGUPERIODIC"
DOWNLOAD_FILE_REGX="HGUPERIODIC_${T}*_8*.gz"

echo "------------ 获取 ${T} 周期上报文件 ------------"

cd ${LOCAL_HGUPERIODIC_FILE_PATH}
[ ! -d ${DIR_TIMESTAMP} ] && mkdir ${DIR_TIMESTAMP}

cd ${LOCAL_HGUPERIODIC_FILE_PATH}/${DIR_TIMESTAMP}

timeout 5 ftp -n <<EOF
    open ${FTP_IP}
    user ${FTP_U} ${FTP_P}
    binary
    cd ${REMOTE_PERIODIC_PATH}            #远程服务器文件目录
    lcd ./   #本地存放的文件目录，lcd 应该使用相对路径
    hash
    prompt off    #关闭提示直接下载
    mget ${DOWNLOAD_FILE_REGX}
    close
    bye
EOF

#FTP 超时连接退出
if [ $? != 0 ];then
    echo "############ FTP ${ip} 连接超时 ############"
else
    echo "------------ 成功 获取 ${T} 周期上报数据文件 ------------"
fi
