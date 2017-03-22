
#!/bin/bash
    case $1 in
        "www") MOD=www;;
        "admin") MOD=admin;;
        "f") MOD=f;;
        "ask") MOD=ask;;
        "sdk") MOD=sdk;;
        "mob") MOD=mobile;;
        "cron") MOD=cron;;
        #"crm") MOD=crm;;
    esac
DOMAIN=$1
if [ -n "$MOD" ] ;then
    DOMAIN=$MOD
else
    echo "error:no command!"
    exit
fi

logname=`date '+%Y%m%d%H%M%S'`
cp -r /www/web/"$DOMAIN".kuaifawu.com/ /Upload/web_backup/"$DOMAIN"_kuaifawu_com/$DOMAIN.$logname

if [ "www" = "$1" ] ; then
    #rm -rf /www/web/"$DOMAIN"_kuaifawu_com/Public/Image/Product/Productname/*
    rm -rf  /Upload/web_backup/"$DOMAIN"_kuaifawu_com/$DOMAIN.$logname/service      #删除SEO业务产生的临时页面
fi

    echo $DOMAIN

    cd /Upload/git/kuaifawu_"$DOMAIN"/
    git pull origin master
    \cp -rf ./* /www/web/"$DOMAIN".kuaifawu.com/

    chown -R www:www /www/web/"$DOMAIN".kuaifawu.com/
    chmod -R 777 /www/web/"$DOMAIN".kuaifawu.com/

if [ "www" = "$1" ] ; then
    echo "<?php define('CSS_VERSION', md5('$logname'));" > /www/web/www.kuaifawu.com/Common/Conf/defineauto.php
fi
echo "rollback command: sh rollback.sh "$DOMAIN"" $logname
