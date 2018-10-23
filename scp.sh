# !/bin/bash
# Auth: wp
# Date: 20180301
# Version: v1.0
# 每天凌晨2点复制34.145当天切割的日志到16.49
#
REMOTE_DIR=/data/bakup/ngx_log
LOCAL_DIR=/data/count/cq_edu_access_log
YESTERDAY=$(date -d "yesterday" +%F)
LOG_FILE=access_${YESTERDAY}.log
#/usr/bin/scp -P55400 root@192.168.34.145:${REMOTE_DIR}/${LOG_FILE} ${LOCAL_DIR}
/usr/bin/rsync -avzP -e "ssh -p55400" root@192.168.34.145:${REMOTE_DIR}/${LOG_FILE} ${LOCAL_DIR}
#cd ${LOCAL_DIR}
/bin/find ${LOCAL_DIR} -mtime +7 -type f -name "*.log" | xargs rm -f

sleep 10
cd /data/count/data_count
if [ $? -eq 0 ];then
	/usr/bin/python3 /data/count/data_count/count_by_day.py > /dev/null 2>&1 &&\
	echo "$(date +%F)\tThe count_by_day.py success!" >> /tmp/py.log
else
	echo "$(date +%F)\tThe count_by_day.py failed!" >> /tmp/py.log
fi


