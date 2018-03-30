#!/bin/bash


SLT_BACK_UP_DIR="/sunlight/backup/mysql.install.backup"

check_soft=("lamp" "apache" "mariadb" "libmysqlclient18")

send_info "*******system will delete lamp,apache and mariadb*******"

for soft in ${check_soft[@]}
do
	check_soft_number=$(rpm -qa|grep ${soft} | wc -l)
	if [ $check_soft_number -gt 0 ];then
		sv=$(ps -ef | grep ${soft} | grep -v grep | wc -l)
		if [ $sv -gt 0 ];then
			echo "Killing The ${soft} Process......"
			pkill -9 ${soft}
			sleep 1
		fi
		rpm -e `rpm -qa |  grep ${soft}`
		echo "${soft} Has Been Moved!"
	else
		echo "SUCCESS! ${soft} Does Not Exist!"
	fi
done

if [ -d /var/lib/mysql ];then
	if [ ! -d $SLT_BACK_UP_DIR ];then
		mkdir -p $SLT_BACK_UP_DIR
		chmod 755 $SLT_BACK_UP_DIR
	fi
	mv /var/lib/mysql/*  "$SLT_BACK_UP_DIR/"
fi