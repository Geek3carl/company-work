#!/bin/bash

echo '' > /etc/asterisk/operasip.conf
echo '' > /etc/asterisk/operaextensions.conf
echo '' > /etc/asterisk/operavoicemail.conf
cat voicemail.cfg > /etc/asterisk/voicemail.conf
echo '' > log


while read line

do

# echo $line


emailaccount=`echo $line | awk '{print $1}' `
username=`echo $line | awk '{print $1}' | cut -d '@' -f 1 `
exten=`echo $line | awk '{print $2}'  `
password=`echo $line | awk '{print $3}'  `
mail_password=`echo $line | awk '{print $4}'  `

wc_num=` cat person.list | grep -w $emailaccount | wc -l `

if test $wc_num != 1
then echo "Found a duplicated user"
echo -e "\n"
echo "User $emailaccount duplicated" >> log


fi

echo putting... "username:$username" 
 echo -e "\n"
 echo Adding ...."extern:$exten"




echo "[$username]" >> /etc/asterisk/operasip.conf
echo "type=friend"  >> /etc/asterisk/operasip.conf
echo "username=$username" >> /etc/asterisk/operasip.conf
echo "dtmfmode=rfc2833" >> /etc/asterisk/operasip.conf
echo "secret=$password" >> /etc/asterisk/operasip.conf
echo "host=dynamic" >> /etc/asterisk/operasip.conf
echo "context=intranet" >> /etc/asterisk/operasip.conf
echo "nat=yes"  >> /etc/asterisk/operasip.conf  
echo "callerid=5667$exten"  >> /etc/asterisk/operasip.conf
echo "canreinvite=no"  >> /etc/asterisk/operasip.conf
echo "disallow=all"  >> /etc/asterisk/operasip.conf
echo "allow=g722"  >> /etc/asterisk/operasip.conf
echo "allow=ulaw"  >> /etc/asterisk/operasip.conf
echo "insecure=no"  >> /etc/asterisk/operasip.conf
echo "qualify=60000"  >> /etc/asterisk/operasip.conf

echo -e "\n\n"  >> /etc/asterisk/operasip.conf

# operaextensions.conf
echo "5667$exten=SIP/$username"  >> /etc/asterisk/operaextensions.conf

echo -e "\n" 

# OperaVoice Mial adding
echo "$exten=$username"  >> /etc/asterisk/operavoicemail.conf
echo "8$exten=$username"  >> /etc/asterisk/operavoicemail.conf


# voicemail.conf

echo "8$exten => $mail_password, $username , $username@tianler.com,attach=yes|servermail=voicemailtest@tianler.com|tz=Asia/Shanghai|saycid=yes|dialout=fromvm|callback=fromvm|review=yes|operator=yes|envelope=yes|moveheard=yes|sayduration=yes|saydurationm=1" >> /etc/asterisk/voicemail.conf


done < person.list


echo -e "\n"
echo "Reloading Asterisk Configuration files"
echo -e "\n"

/etc/init.d/asterisk reload

cat log | grep -v -i null

#asterisk -rvvvvvv

