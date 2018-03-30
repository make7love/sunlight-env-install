#!/bin/bash

#注意：
#source 和  sh 执行不同路径下脚本的不同；
#二者会有不同的表现；
#推荐使用source引入其他需要执行的脚本；
#使用source,可以将异地脚本引入本地目录执行，"exit 1" 这种命令有效
#使用sh执行异地脚本，"exit 1" 这种命令无效；
#此安装脚本只适用于运营商；


#此脚本针对一台服务器，安装管理节点和应用节点所有软件；

base_path=$(cd `dirname $0`;pwd)

source "./export.sh"

Create_New_Log $slt_test_begin_string

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
	echo "                      盛阳科技-运营商-运行环境-安装配置程序"
	echo "-----------------------------------------------------------------------------------------------------"
	echo "构建日期：2017/08"
	echo "联系人：董超，郑叶涛"
	echo "联系方式：185-6561-8568"
	echo "请注意：此脚本只适用于盛阳科技-运营商客户"
	echo -n "是否继续？[y/n]"
	read conok
	if [ "$conok" != "y" ] && [ "$conok" != "Y" ];then
		echo "You Terminated The Procedure Of Installation! "
		exit 0
	else
		echo "Waiting..............................;"
		sleep 3

		echo "change ssh port to $ssh_port"
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
		


		echo "本服务器将安装管理节点+应用节点的运行环境..........................."
		Go_To_Sleep

		echo "Hostname: ${server_hostname}"
		source ./slice/slt_set_host_name_by_ini.sh "${server_hostname}"
		Write_Log "$slt_set_hostname_info"
		Go_To_Sleep

		#Set Run Level;
		echo "set system run time level."
		source "./slice/slt_set_run_level.sh"
		Write_Log "$slt_set_run_level_info"
		Go_To_Sleep

		echo "adjust time."
		source "./rpm/ntpd/adjust_time.sh"
		Write_Log "$slt_adjust_time_info"
		Go_To_Sleep


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


		echo "Install Nginx......"
		source "./rpm/nginx/install_nginx.sh"
		Write_Log $slt_nginx_info
		Go_To_Sleep


		echo "Install PHP......"
		source "./rpm/php/install_php.sh"
		Write_Log $slt_php_info
		Go_To_Sleep


		echo "Install Mariadb......"
		source "./rpm/mysql/install_mariadb.sh"
		Write_Log $slt_mysql_info
		Go_To_Sleep

		
		source "./rpm/app/install_app.sh"
		Write_Log $slt_app_info
		Go_To_Sleep

	fi
fi

exit 0