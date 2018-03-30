#!/bin/bash

#海南-有线-安装脚本；
#初始化日期：2017/09/20 

log_file="./hn_yx_install.log"
source "./export.sh"

#check system version 
echo "Check System Version."
source "./slice/slt_check_sys_version.sh"
Write_Log $slt_check_sys_version_info
Go_To_Sleep

source "./slice/slt_sys_info.sh"
Write_Log $sysinfo
Go_To_Sleep

echo "检查完毕！是否继续？"
echo -n "Do You Want To Continue To Install This Cluster Environment ? [y/n]"
read ctus

if [ "$ctus" != "y" ] &&  [ "$ctus" != "Y" ];then
	echo "You Terminated The Procedure Of Installation! "
	exit 0
else
	echo "                      盛阳科技-海南有线-运行环境-安装配置"
	echo "-----------------------------------------------------------------------------------------------------"
	echo "构建日期：2017/09/20"
	echo -n "是否继续？[y/n]"
	read conok
	if [ "$conok" != "y" ] && [ "$conok" != "Y" ];then
		echo "You Terminated The Procedure Of Installation! "
		exit 0
	else
		echo "Waiting..............................;"
		sleep 3

		echo "中心节点R230 : 1"
		echo "中心节点R430 : 2"
		echo "酒店端R230 : 3"


		echo -n "Please Input This Server's Role:[1/2/3]:"
		read hn_role
		if [ "$hn_role" == "1" ];then
			echo "服务器角色：中心机房-R230-管理节点"
			Write_Log "服务器角色：中心机房-R230-管理节点"
		elif [ "$hn_role" == "2" ]; then
			echo "服务器角色：中心机房-R430-CDN节点"
			Write_Log "服务器角色：中心机房-R430-CDN节点"
		elif [ "$hn_role" == "3" ]; then
			echo "服务器角色：酒店端服务器-R230"
			Write_Log "服务器角色：酒店端服务器-R230"
		else
			echo "错误！输入有误！"
			Write_Log  "错误！输入有误！"
			exit 1
		fi

		echo "change ssh port to 2222"
		ssh_port=2222
		source "./slice/slt_change_ssh_port.sh"
		Write_Log "$slt_ssh_port_info"
		Go_To_Sleep


		echo "First Detect Whether  LAMP softwares Have Been Installed....................."
		source "./slice/slt_check_lamp.sh"
		Write_Log "$slt_check_lamp_info"
		Go_To_Sleep

		#Complete Server Init Configure;
		echo "Complete System Init Operations...................."
		source "./slice/slt_init_boss.sh"
		Write_Log "Check Directory /root/bin"
		Write_Log "Check Directory /root/.profile"
		Write_Log "Check Directory /root/.bashrc"
		Write_Log "Check group sunlight"
		Write_Log "Check Directory /var/log/mysql"
		Write_Log "Check Directory /var/log/sweed"
		Write_Log "Check Directory /var/www"
		Write_Log "Check Directory /var/www/html"
		Write_Log "Check Directory /var/www/upload"
		Write_Log "Check Directory /root/.ssh"
		Write_Log "Check Directory /usr/local/sunlight/conf/"
		Write_Log "Check file /usr/local/sunlight/conf/server.conf"

		Write_Log "Directory /usr/local/content Has Been Installed."
		Write_Log "Directory /usr/local/content/upload Has Been Installed."
		Write_Log "Directory  /usr/local/content/upload/adv Has Been Installed."
		Write_Log "Directory  /usr/local/content/upload/audit Has Been Installed."
		Write_Log "Directory  /usr/local/content/upload/media Has Been Installed."
		Write_Log "Directory  /usr/local/content/upload/music Has Been Installed."
		Write_Log "Directory  /usr/local/content/upload/trailer Has Been Installed."
		

		echo "set system run time level."
		source "./slice/slt_set_run_level.sh"
		Write_Log "$slt_set_run_level_info"
		Go_To_Sleep

		#echo "The Default Time Adjust Url Is : ntp.api.bz"
		#echo  -n "Please input ajust_time_url:"
		#read adjust_ip
		#ajust_time_url=$adjust_ip

		#echo "adjust time."
		#source "./rpm/ntpd/adjust_time.sh"
		#Write_Log "$slt_adjust_time_info"
		#Go_To_Sleep


		echo "Config System Openfiles Parameters......"
		source "./slice/slt_config_sys_params.sh"
		Write_Log "$slt_sys_parameters_info"
		Go_To_Sleep

		echo "Install Dstat Tool......"
		source "./rpm/dstat/dstat_install.sh"
		Write_Log "$slt_sys_dstat_info"
		Go_To_Sleep

		echo "Copy And Set Permission For init.pk......"
		source "./rpm/sshkey/install_ssh_keys.sh"
		Write_Log "$slt_sshkey_info"
		Go_To_Sleep

		if [ "$hn_role"=="1" ] || [ "$hn_role"=="3" ];then
			echo "Install Nginx......"
			source "./rpm/nginx/install_nginx.sh"
			Write_Log $slt_nginx_info
			Go_To_Sleep


			echo "Install PHP......"
			source "./rpm/php/install_php.sh"
			Write_Log $slt_php_info
			Go_To_Sleep
		fi
	fi
fi

echo "Install Complete!"
echo $slt_time_stamp
exit 0

