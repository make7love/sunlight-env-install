#!/bin/bash

#检查配置文件是否存在


if [ ! -f "${base_path}/ini/manage.ini" ];then
	send_error "`get_current_time_stamp` ${base_path}/ini/manage.ini not found."
	exit 1
else
	send_info "`get_current_time_stamp` config file found! file path : ${base_path}/ini/manage.ini"
fi

send_info "check config.ini finished!"
send_info "------------------------------------------"