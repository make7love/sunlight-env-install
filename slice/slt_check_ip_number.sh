#!/bin/bash

#检查系统配置的IP个数；

ip_number=$(ip addr | grep -E 'inet\b' | awk '{print $2}' | cut -d "/" -f 1 | wc -l)
if [ $ip_number -lt 2 ];then
	send_error "`get_current_time_stamp` IP Did Not Be Configed! Install break off!"
	exit 1
else
	send_info "YES! IP has been configed!"
fi
send_info "check ip finished..."
send_info "------------------------------------------"