# !/bin/bash
# Date:20180318
# Auth:jumper
# Func:Monitor Nginx service
# Mail:1076099831@qq.com
# Version:v1.0
[ -f /etc/init.d/functions ] && . /etc/init.d/functions || exit 1      #判断系统函数库并加载

if [ $# -ne 2 ];then
    echo "Usage: $0 ip port !"
    exit 1
fi

HttpStatus=$(nmap $1 -p $2 | grep open | wc -l)
if [ ${HttpStatus} -eq 1 ];then     #采用字符串比较
    action "$1 $2 is open !" /bin/true
else
    action "$1 $2 is closed !" /bin/false
    sleep 1
    #/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf &&\
    #action "Nginx is started!" /bin/true
fi