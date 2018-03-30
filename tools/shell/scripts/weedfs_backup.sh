#!/bin/bash

weedfs_date=$(date "+%Y%m%d")
weedfs_log="/home/weedfs/weedfs.log"

if [ -f /usr/local/sunlight/conf/server.conf ];then
	while read line
	do
		eval "$line"
	done</usr/local/sunlight/conf/server.conf
fi

if [ -z "$dbhost" ];then
	echo " [ Error ] dbhost is empty!"
	exit 1
fi

if [ -z "$dbport" ];then
	echo " [ Error ] dbport is empty!"
	exit 1
fi

if [ -z "$dbuser" ];then
	echo " [ Error ] dbuser is empty!"
	exit 1
fi

if [ -z "$dbpass" ];then
	echo " [ Error ] dbpass is empty!"
	exit 1
fi

if [ -d "/home/weedfs/$weedfs_date" ];then
	mv "/home/weedfs/$weedfs_date" "/home/weedfs/${weedfs_date}.bak"
fi

if [ -e "/home/weedfs/${weedfs_date}.tar.gz" ];then
	mv "/home/weedfs/${weedfs_date}.tar.gz"  "/home/weedfs/${weedfs_date}.tar.gz.bak"
fi

if [ ! -d "/home/weedfs/$weedfs_date" ];then
	mkdir -p /home/weedfs/$weedfs_date
	chmod 755 /home/weedfs/$weedfs_date
fi

weedfs_ip=$(mysql -h$dbhost -P$dbport -u$dbuser -p$dbpass -e "use cdb20;select paramvalue from systemparameters where paramname='seaweedfs_ip'" | awk -F "|" 'NR==2 {print }')
if [[ $? -eq 0  && ${#weedfs_ip} -gt 1 ]];then
	mysql -h$dbhost -P$dbport -u$dbuser -p$dbpass -e "use cdb20;select imageurl from imageauditlist;" | awk -F "|" '{print $1}' | while read line
	do
		#echo ${line##*/}
		fid=${line##*/}
		cd /home/weedfs/$weedfs_date
		wget -T 2 -c 2  --append-output=/home/weedfs/$weedfs_date/$weedfs_date.log  "http://${weedfs_ip}:8180/$fid" 
	done
	
	if [ -d /home/weedfs/$weedfs_date ];then
		tar zcvf "/home/weedfs/${weedfs_date}.tar.gz"  "/home/weedfs/${weedfs_date}"
		echo "[ Success ] $weedfs_date   /home/weedfs/${weedfs_date}.tar.gz has been created! " >> $weedfs_log
		exit 0
	fi
else
	echo "[ Error ] $weedfs_date We can not get weedfs_ip"
	echo "[ Error ] $weedfs_date We can not get weedfs_ip" >> $weedfs_log
	exit 1
fi
