#!/bin/bash

#此脚本用于初始化操作系统；
#
base_path=$(cd `dirname $0`;pwd)
log_file="$base_path/sys-init.log"

source "./tools/shell/scripts/main.sh"

source "$base_path/export.sh"

echo "checking system version......"
sleep 2
source "./slice/slt_check_sys_version.sh"

echo "checking system information......"
sleep 2
source "./slice/slt_sys_info.sh"

echo "Whether to change ssh port to 2222?[y/n]:"
read weather_set_ssh_port
if [[ "$weather_set_ssh_port" == "y" || "$weather_set_ssh_port" == "Y" ]];then
	echo "1). change ssh port to 2222......"
	sleep 2
	source "./slice/slt_change_ssh_port.sh"
fi

echo "2). checking lamp softwares......"
sleep 2
source "./slice/slt_check_lamp.sh"

echo "3). Complete System Init Operations...................."
sleep 2
source "./slice/slt_init_boss.sh"

echo "4). set system run time level......"
sleep 2
source "./slice/slt_set_run_level.sh"

#echo "5). set hostname......"
#sleep 2
#source "./slice/slt_set_host_name.sh"

#echo "6). adjust time."
#sleep 2
#source "./rpm/ntpd/adjust_time.sh"


echo "7). Config System Openfiles Parameters......"
sleep 2
source "./slice/slt_config_sys_params.sh"

echo "8). Install Dstat Tool......"
sleep 2
source "./rpm/dstat/dstat_install.sh"

echo "9). Copy And Set Permission For init.pk......"
sleep 2
source "./rpm/sshkey/install_ssh_keys.sh"

echo "10). Copy shell tool box......"
sleep 2
echo "======================Init Complete!============================="
exit 0