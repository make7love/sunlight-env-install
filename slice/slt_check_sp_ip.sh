#!/bin/bash


#检查配置文件和系统配置的IP是否一致；
ips=$(ip addr | grep -E 'inet\b' | awk '{print $2}' | cut -d "/" -f 1 )

target_check_ip=""
if [ $base_server_role -eq 1 ];then
	target_check_ip=$manage_private_ip
elif [ $base_server_role -eq 2 ];then
	target_check_ip=$app_private_ip
elif [ $base_server_role -eq 3 ];then
	target_check_ip=$proxy_private_ip
elif [ $base_server_role -eq 4 ];then
	target_check_ip=$epg_private_ip
elif [ $base_server_role -eq 2 ];then
	target_check_ip=$db_private_ip
else
	send_error "config error, please check!"
fi


if [ $(echo $ips | grep -o "$target_check_ip" | wc -l) -lt 1 ];then
	send_error	"Find Error!"
	send_error	"IP In The File config.ini:    ${target_check_ip}"
	echo "---------------------------------------------"
	echo "IP Configed In The System:"
	echo "$(ip addr | grep -E 'inet\b' | awk '{print $2}' | cut -d "/" -f 1)"
	exit 1
fi