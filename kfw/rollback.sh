#!/bin/bash
    case $1 in
        "www") MOD=www;;
        "admin") MOD=admin;;
        "f") MOD=f;;
        "ask") MOD=ask;;
        "sdk") MOD=sdk;;
        "mob") MOD=mobile;;
        "cron") MOD=cron;;
    esac
DOMAIN=$1
if [ -n "$MOD" ] ;then
    DOMAIN=$MOD
else
    echo -e "\033[47;31;1mError:This param don't exist!\033[0m"
    exit
fi
\cp -rf /Upload/web_backup/"$DOMAIN"_kuaifawu_com/$DOMAIN.$2/*  /www/web/"$DOMAIN".kuaifawu.com/
if [ `echo $?` -eq 0 ] ;
        then
        echo -e "\033[47;31;5mRollback $DOMAIN.$2 to /www/web/"$DOMAIN".kuaifawu.com/ finished!\033[0m"
else
        echo -e "\033[46;37;5mRollback is Failure!!!!!!!!\033[0m"
fi
