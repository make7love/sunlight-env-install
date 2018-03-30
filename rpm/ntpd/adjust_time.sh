#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path/conf"
else
	opt_path="$base_path/rpm/ntpd/conf"
fi


ntpdate_cmd=$(whereis ntpdate | awk '{print $2}' | grep -o ntpdate)

function Create_Weed_Install_Log()
{
	echo -e "$*" >> ./operate.log
}

function_name="Write_Log"
if [ "$(type -t $function_name)" != "function" ];then
	write_install_log="Create_Weed_Install_Log"
else
	write_install_log="Write_Log"
fi

if [ -z "$ajust_time_url" ];then
	ajust_time_url="ntp.api.bz"
fi

echo "Next To Adjust Time......."

eval "$write_install_log $(date '+%Y-%m-%d %H:%M:%S') Begin To Adjust Time ......"

if [ -z "$ntpdate_cmd" ];then
	echo "Error! We Cann't Find commands 'ntpdate' And Stop Adjustting Time......"
	eval "$write_install_log  Error! We Cann't Find commands 'ntpdate' Skipping"
elif [ -z "$(ping -c 1 baidu.com | grep -o ttl)" ];then
	echo "Error! Your Server Cann't Connect To The Internet.Skipp......"
	eval "$write_install_log  Error! Your Server Cann't Connect To The Internet.Skipping......"
elif [ -z "$(ping -c 1 $ajust_time_url | grep -o ttl)" ];then
	echo "Error! Your Server Cann't Connect To $ajust_time_url    Skipping..............."
	eval "$write_install_log  Error! Your Server Cann't Connect To $ajust_time_url Skipping......"
else
	if [ -f /etc/ntp.conf ];then
		mv /etc/ntp.conf /etc/ntp.conf.bak
	fi
	cp -f "$opt_path/ntp.conf"   /etc/
	chmod 0755 /etc/ntp.conf
	ntpdate $ajust_time_url
	eval "$write_install_log  chmod 0755 /etc/ntp.conf "
	systemctl start ntpd.service
	eval "$write_install_log  systemctl start ntpd.service "
	systemctl enable ntpd.service
	eval "$write_install_log  systemctl enable ntpd.service "
	
	ntpq -p
	
	echo "Adjust Time Over."
	eval "$write_install_log  Adjust Time Over."
fi



