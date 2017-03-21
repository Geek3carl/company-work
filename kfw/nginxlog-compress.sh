#!/bin/bash
#nginx下域名access日志切割归档脚本
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)

#==================================================Definition array====================================================
catalogue=(
	www_logs
	f_logs
	admin_logs
	api_logs
	mob_logs
	att0_logs
	cron_logs
)

#============================================Definition dealwith log function==========================================
function pigeonhole(){
cd /Upload/nginx_logs/$1
presentpath=`pwd`
masterdir=${presentpath##*/}
domain=`echo $masterdir | awk -F_ '{print$1}'`
if [ -e ./$domain.access.log ];
then
	cp ./$domain.access.log ./$domain.access-$YESTERDAY.log
	tar zcvf ./$domain.access-$YESTERDAY.tar.gz ./$domain.access-$YESTERDAY.log 
	res=`echo $?`
	if [ $res -eq 0 ];
		then
	        echo " " > ./$domain.access.log
		rm -rf ./$domain.access-$YESTERDAY.log
	else echo "$domain access log compression failed!"
	fi
else 
    echo "$domain access log inexistence!"
    break	
fi
}

#==============================================Definition Main function===============================================
function ipoll(){
        for ((i=0;i<8;i++))
	do
		pigeonhole ${catalogue[$i]}
	done
}

#====================================================Main process======================================================
ipoll
exit
