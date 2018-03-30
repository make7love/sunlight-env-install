#!/bin/bash

export slt_begin_string="--------------------------\nSP Environment Begin To Run Install.\n--------------------------\n"

export slt_test_begin_string="SP Environment Install One Test Node Begin To Run Install.\n"

export slt_time_stamp=$(date "+%Y-%m-%d %H:%M:%S")

export slt_ini_file="sp.ini"

export slt_sleep_time=3

export slt_ini_params=("server_role" "server_ip" "server_name" "server_hostname" "server_manage_ip" "cluster_ip" "sp_name" "ssh_port")

export slt_check_ini_info="[ info ] $slt_time_stamp $slt_ini_file has been checked."

export slt_check_sys_version_info="[ info ] $slt_time_stamp system version has been checked."

export slt_check_ip_number_info="[ info ] $slt_time_stamp IP number has been checked."

export slt_ssh_port_info="[ info ] $slt_time_stamp SSH Port has been changed!"

export slt_check_lamp_info="[ info ] $slt_time_stamp Check LAMP softwares over."

export slt_set_hostname_info="[ info ] $slt_time_stamp Hostname set over."

export slt_set_run_level_info="[ info ] $slt_time_stamp run level set over."

export slt_adjust_time_info="[ info ] $slt_time_stamp Adjust Time over."

export slt_sys_parameters_info="[ info ] $slt_time_stamp System parameters have been configed over."

export slt_sys_dstat_info="[ info ] $slt_time_stamp install dstat over."

export slt_sshkey_info="[ info ] $slt_time_stamp Install sshkey over."

export slt_nginx_info="[ info ] $slt_time_stamp Install nginx over."

export slt_php_info="[ info ] $slt_time_stamp Install php over."

export slt_mysql_info="[ info ] $slt_time_stamp Install mysql over."

export slt_maxscale_info="[ info ] $slt_time_stamp Install maxscale over."

export slt_keepalived_info="[ info ] $slt_time_stamp Install keepalived over."

export slt_weed_info="[ info ] $slt_time_stamp Install weed over."

export slt_gofile_info="[ info ] $slt_time_stamp Install go_file over."

export slt_app_info="[ info ] $slt_time_stamp Install app over."

export slt_python_info="[ info ] $slt_time_stamp Install python plugins over."

function Get_Date()
{
	dt=$(date "+%Y-%m-%d_%H:%M:%S")
	echo ${dt}
}

function Write_Log()
{
	if [ -n "$log_file" ];then
		echo -e "$*" >> "${base_path}/$log_file"
		echo -e "\n" >> "${base_path}/$log_file"
	else
		echo -e "$*" >> "${base_path}/sp-install.log"
		echo -e "\n" >> "${base_path}/sp-install.log"
	fi
}

function Create_New_Log()
{
	echo -e "--------------------Notice! New Log Created!--------------------\n"
	create_log_time=$(Get_Date)
	if [ -n "$log_file" ];then
		echo -e "$*" > "${base_path}/$log_file"
		echo "Log Location : ${base_path}/$log_file "
	else
		echo -e "$*" > "${base_path}/sp-install.log"
		echo "Log Location : ${base_path}/sp-install.log"
	fi
}

function Go_To_Sleep()
{
	sleep $slt_sleep_time
	echo -e "\n"
}

export -f Write_Log
export -f Create_New_Log
export -f Go_To_Sleep
export -f Get_Date



#以下为海南有线-安装内容；
#2017/09/20