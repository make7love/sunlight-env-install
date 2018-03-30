#!/bin/bash

S12SP2FLAG=`grep "SUSE Linux Enterprise Server 12 SP2" /etc/issue | wc -l`

if [ ! -f /etc/issue ];then
	send_error "`get_current_time_stamp` file /etc/issue does not exist!"
	exit 1
fi

if [ $S12SP2FLAG -lt 1 ];then
	send_error "`get_current_time_stamp` The OS Version Does Not Match!!"
	send_info "need os version : SUSE Linux Enterprise Server 12 SP2"
	exit 1
else
	send_info "System Version: $(cat /etc/issue)"
fi
send_info "check System version finished..."
send_info "------------------------------------------"
