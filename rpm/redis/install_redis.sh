#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/redis"
fi

rpm -ivh "$opt_path/*.rpm"

if [ -f /etc/redis/default.conf.example ];then
	cp /etc/redis/default.conf.example  /etc/redis/6379.conf
fi

if [ $(grep -E "^# requirepass" /etc/redis/6379.conf | wc -l) -eq 1 ];then
	sed -i '/^# requirepass/c\requirepass sunlight2017' /etc/redis/6379.conf
fi

if [ $? -eq 0 ];then
	chown redis:root /usr/sbin/redis-server
	chown redis:root /etc/redis/*
	sudo -u redis redis-server  /etc/redis/6379.conf &
	if [ $? -eq 0 ];then
		send_success "redis start ok..."
		send_info "------------------------------------------"
	fi
fi