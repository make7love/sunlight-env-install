#!/bin/bash

#检查常用端口是否被占用；

port_number=(80 3306 4567 4006 9333 8180)

for port in ${port_number[@]}
do
	if [ $(netstat -nltp | grep -E "\:${port}\b" | wc -l) -gt 0 ];then
		send_error "port nuber : $port , has been used!"
		exit 1
	else
		send_info "$port => pass..." 
	fi
done
