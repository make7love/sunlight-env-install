#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/tools/shell"
fi

if [ ! -d /sunlight/shell/monitor ];then
	mkdir -p /sunlight/shell/monitor
	chmod 755 /sunlight/shell/monitor
fi

if [ ! -d /sunlight/python ];then
	mkdir /sunlight/python
	chmod 755 /sunlight/python
fi

if [ ! -f "$opt_path/tools/shell/mail/send_mail.py" ];then
	send_error "$opt_path/tools/shell/mail/send_mail.py not found..."
	exit 1
else
	cp "$opt_path/tools/shell/mail/send_mail.py"  /sunlight/python/
fi

if [ ! -f /sunlight/shell/main.sh ];then
	if [ -f "$opt_path/scripts/main.sh" ];then
		cp "$opt_path/scripts/main.sh"  /sunlight/shell/
	fi
fi

#首先准备monitor配置文件；
if [ ! -d /usr/local/sunlight/conf ];then
	mkdir /usr/local/sunlight/conf
fi

monitor_ini="/usr/local/sunlight/conf/monitor.ini"

if [ -f $monitor_ini ];then
	rm -r $monitor_ini
fi

if [[ $base_server_role -ne 2 && $base_server_role -ne 1 ]];then
	send_error "服务器角色不正确，只支持管理节点和应用节点！"
	exit 1
fi

if [ $base_server_role -eq 1 ];then
	appliction_ini="$opt_path/ini/appliction.ini"
	if [ ! -f  $appliction_ini ];then
		send_error "$appliction_ini not found..."
		exit 1
	fi

	while read line;
	do
		if [ $(echo $line | grep "=" | wc -l) -eq 1 ];then
			eval "$line"
		fi
	done < $appliction_ini

	if [ -z "$app_cluster_private_ip" ];then
		send_error "app_cluster_private_ip not found..."
		exit 1
	fi
	

#管理节点，安装weedfs监控；
	echo "[sp]" >> $monitor_ini
	echo "sp_name=$base_sp_name" >> $monitor_ini
	echo "sp_node_role=$base_server_role" >> $monitor_ini
	echo "sp_manage_node=" >> $monitor_ini
	echo ""  >> $monitor_ini
	echo "[appliction node]" >> $monitor_ini
	for((i=0; i<$base_epg_server_number; i++))
	do
		in_ct=$(echo "$i+1" | bc)
		app_node=$(echo $app_cluster_private_ip | cut -d ',' -f $in_ct)
		echo "sp_app${in_ct}=$app_node" >> $monitor_ini
	done

	echo "[smtp]" >> $monitor_ini
	echo "smtp_server=smtp.exmail.qq.com"  >> $monitor_ini
	echo "smtp_user=Spmonitor@sunlight-tech.com" >> $monitor_ini
	echo "smtp_pass=Bv3nIrc8g5geCgQd" >> $monitor_ini

	echo "" >> $monitor_ini
	echo "[weedfs]" >> $monitor_ini
	echo "sp_weed_monitor=1" >> $monitor_ini
	echo "sp_weed_vip=$base_weedfs_vip" >> $monitor_ini

	if [ -f  "$opt_path/tools/shell/monitor/check_disk_mem_cpu.sh" ];then
		cp  "$opt_path/tools/shell/monitor/check_disk_mem_cpu.sh"  /sunlight/shell/monitor/
	fi

	if [ -f  "$opt_path/tools/shell/monitor/check_path_space.sh" ];then
		cp  "$opt_path/tools/shell/monitor/check_path_space.sh"  /sunlight/shell/monitor/
	fi

	if [ -f  "$opt_path/tools/shell/monitor/check_weed.sh" ];then
		cp  "$opt_path/tools/shell/monitor/check_weed.sh"  /sunlight/shell/monitor/
	fi

fi


if [ $base_server_role -eq 2 ];then
#管理节点，安装weedfs监控；
#
	manage_ini="$opt_path/ini/manage.ini"
	if [ ! -f  $manage_ini ];then
		send_error "$manage_ini not found..."
		exit 1
	fi

	while read line;
	do
		if [ $(echo $line | grep "=" | wc -l) -eq 1 ];then
			eval "$line"
		fi
	done < $manage_ini

	if [ -z "$manage_private_ip" ];then
		send_error "manage_private_ip not found..."
		exit 1
	fi

	echo "[sp]" >> $monitor_ini
	echo "sp_name=$base_sp_name" >> $monitor_ini
	echo "sp_node_role=$base_server_role" >> $monitor_ini
	echo "sp_manage_node=$manage_private_ip" >> $monitor_ini

	echo "" >> $monitor_ini
	echo "smtp_server=smtp.exmail.qq.com" >> $monitor_ini
	echo "smtp_user=Spmonitor@sunlight-tech.com" >> $monitor_ini
	echo "smtp_pass=Bv3nIrc8g5geCgQd" >> $monitor_ini

	echo "" >> $monitor_ini
	echo "[mysqld]" >> $monitor_ini
	echo "sp_mysqld_monitor=1" >> $monitor_ini
	echo "sp_mysqld_host=127.0.0.1" >> $monitor_ini
	echo "sp_mysqld_user=root" >> $monitor_ini
	echo "sp_mysqld_pwd=sunlight2010" >> $monitor_ini

	if [ -f  "$opt_path/tools/shell/monitor/check_disk_mem_cpu.sh" ];then
		cp  "$opt_path/tools/shell/monitor/check_disk_mem_cpu.sh"  /sunlight/shell/monitor/
	fi

	if [ -f  "$opt_path/tools/shell/monitor/check_path_space.sh" ];then
		cp  "$opt_path/tools/shell/monitor/check_path_space.sh"  /sunlight/shell/monitor/
	fi

	
fi


