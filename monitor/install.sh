#!/bin/bash

#此脚本用于部署监控程序；
#

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/tools/shell"
fi

source "$opt_path/../tools/shell/scripts/main.sh"

if [ $? -ne 0 ];then
	echo "[ Error ] main.sh  not found..."
	exit 1
fi

#解析参数，新建监控配置文件；
config_file="$opt_path/../config.ini"
if [ ! -f $config_file ];then
	send_error "$config_file not found..."
	exit 1
fi

while read line
do
	if [ $(echo "$line" | grep "=" | wc -l) -eq 1 ];then
		eval "$line"
	fi
done < $config_file

if [ -z "$base_server_role" ];then
	send_error "基础配置文件中，base_server_role配置为空，请检查！"
	send_error "base_server_role is empty, Please check!"
	exit 1
fi

if [ -z "$base_maxscale_vip" ];then
	send_error "基础配置文件中，base_maxscale_vip配置为空，请检查！"
	send_error "base_maxscale_vip is empty, Please check!"
	exit 1
fi


if [ -z "$base_epg_server_number" ];then
	send_error "base_epg_server_number is empty!"
	send_error "install stopped..."
	exit 1
fi

if [ $base_server_role -eq 1 ];then
	send_info "此服务器将安装管理节点的运行环境..."
	send_info "This will install manage server's run env..."

	var_prefix="manage_"
	ini_file="manage.ini"
elif [ $base_server_role -eq 2 ]; then
	send_info "此服务器将安装应用节点的运行环境..."
	send_info "This will install application server's run env..."

	var_prefix="app_"
	ini_file="application.ini"
elif [ $base_server_role -eq 3 ]; then
	send_info "此服务器将安装代理节点的运行环境..."
	send_info "This will install proxy server's run env..."

	var_prefix="proxy_"
	ini_file="proxy.ini"
elif [ $base_server_role -eq 4 ]; then
	send_info "此服务器将安装epg节点的运行环境..."
	send_info "This will install epg server's run env..."

	var_prefix="epg_"
	ini_file="epg.ini"
elif [ $base_server_role -eq 5 ]; then
	send_info "此服务器将安装单点数据库的运行环境..."
	send_info "This will install mysql-db server's run env..."

	var_prefix="db_"
	ini_file="db.ini"
else
	send_error "base_server_role 参数配置错误！"
	send_error "config item: base_server_role is error!"
	send_info "配置值只能是[1, 2, 3, 4, 5] 其中之一；"
	exit 1
fi
waiting 3

send_info "解析配置文件信息..."
send_info "parse config file..."
source "$opt_path/../slice/slt_parse_config_file.sh"
waiting 3







#部署weed监控工具；

#部署cpu,mem,disk监控工具；
#部署maxscale监控工具；
#部署Mysql进程监控工具；
#部署运行环境参数收集工具；