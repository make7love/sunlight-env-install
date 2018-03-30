#!/bin/bash

FUNC_NAME="Get_Date"

if [ ! "$(type -t $FUNC_NAME)" == "function" ];then
	source ../export.sh
fi

EXE_TIME=$(Get_Date)

if [ -n "$base_path/ini/$slt_ini_params" ];then
	for (( i=0; i<${#slt_ini_params[@]}; i++ ))
	do
		slt_ini_str=$(grep ${slt_ini_params[i]} "${base_path}/ini/${slt_ini_file}")
		if [ -z "$slt_ini_str" ];then
			send_error "`get_current_time_stamp` ${slt_ini_params[i]}  is not defined! Please check!"
			exit 1
		fi
		slt_ini_param_value=$(echo ${slt_ini_str} | cut -d "=" -f 2)
		if [ -z "$slt_ini_param_value" ];then
			send_error "`get_current_time_stamp` ${slt_ini_params[i]}  is empty! Please check!"
			exit 1
		fi
		echo $slt_ini_str
		eval "export ${slt_ini_str}"
	done
else
	send_error "`get_current_time_stamp` The variable slt_ini_params is empty."
	exit 1
fi

if [  `echo $server_hostname | grep -E "^[A-Za-z0-9_-]+$"` ];then
	echo "Yes! server_hostname is configed right."
else
	echo "Error! server_hostname is configed wrong."
	Write_Log "Error! server_hostname is configed wrong."
	exit 1
fi