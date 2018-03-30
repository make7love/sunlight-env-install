#!/bin/bash

#sunlight sp monitor system 
#created on 2018/01/07
#by chao.dong
#used by sp servers consist of 1 manage server and 3 application servers



function get_current_time_stamp()
{
	echo `date "+%Y/%m/%d %H:%M:%S"`
}

function send_error()
{
	echo -e "\e[1;45m [ Error ] `get_current_time_stamp` -  $1  -\e[0m"
}

function send_success()
{
	echo -e "\e[1;32m [ Success ] `get_current_time_stamp` -  $1  -\e[0m"
}

function send_info()
{
	echo -e "\e[1;34m [ Info ] `get_current_time_stamp` -  $1  -\e[0m"
}

function send_warn()
{
	echo -e "\e[1;33m [ Warn ] `get_current_time_stamp` -  $1  -\e[0m"
}

#倒计时函数；
#实现提示后操作等待;
function  waiting()
{
	if [ $1 -lt 1 ];then
		send_error "function:waiting, msg: param passed error!"
		exit 1
	fi
	
	seconds_left=$1  
	while [ $seconds_left -gt 0 ];do
		echo -ne "\e[1;33m -  Please waiting $seconds_left S  -\e[0m"
		sleep 1  
		seconds_left=$(($seconds_left - 1))
		echo -ne "\r     \r" #清除本行文字  
	done  
	
}

export get_current_time_stamp
export send_error
export send_success
export send_info
export send_warn
export waiting
