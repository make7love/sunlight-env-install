#!/bin/bash

#此安装脚本用来搭建管理节点的EPG环境；

base_path=$(cd `dirname $0`;pwd)

source "./tools/shell/scripts/main.sh"

if [ -f /var/sunlight/version ];then
	send_info "这台服务器已经安装过集群环境，不能重复安装!"
	send_info "This server has installed sunlight epg env, stopped!"
	exit 0
fi

send_info "检查系统版本信息.."
send_info "Check System Version."
source "./slice/slt_check_sys_version.sh"
sleep 2

send_info "Check IP Number."
send_info "检查IP配置情况.."
source "./slice/slt_check_ip_number.sh"
sleep 2

send_info "check general port..."
send_info  "检查常用端口开启情况..."
source "./slice/slt_check_port.sh"
sleep 2

send_info "读取基础配置文件..."
send_info "Begin to read base config file..."

if [ ! -f ./config.ini ];then
	send_error "未在当前目录下，找到config.ini 配置文件！"
	send_error "config.ini not found...!"
	exit 1
fi

while read line
do
	if [ $(echo $line | grep -E "^base_" | wc -l) -eq 1 ];then
		eval "$line"
		echo $line
	fi
done < ./config.ini
send_info "----------------------------------------------"
sleep 2

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
sleep 2

send_info "解析配置文件信息..."
send_info "parse config file..."
source "./slice/slt_parse_config_file.sh"
sleep 2

source "./slice/slt_sys_info.sh"
sleep 2

send_info "检查配置文件中的IP和本机是否一致..."
send_info "Check IP configed in config.ini with your system ip Configure."
source "./slice/slt_check_sp_ip.sh"
sleep 2

send_info "写入运营商基础信息..."
send_info "begin to write base information to /usr/local/sunlight/conf/spinfo.ini"
source "./slice/slt_write_base.sh"

send_info "检查完毕！是否继续？"
echo -n "Do You Want To Continue To Install This Cluster Environment ? [y/n]"
read ctus

if [ "$ctus" != "y" ] &&  [ "$ctus" != "Y" ];then
	send_info "You Terminated The Procedure Of Installation! "
	exit 0
fi

send_info "Waiting..............................;"
sleep 3

send_info "检查系统中LNMP安装情况..."
send_info "安装脚本将删除系统自带的apache, mariadb等软件..."
send_info "First Detect Whether  LAMP softwares Have Been Installed....................."
source "./slice/slt_check_lamp.sh"
sleep 2

send_info "设置hostname值..."
send_info "set hostname value..."
source "./slice/slt_set_hostname.sh"

send_info "安装nginx服务器.."
send_info "Install Nginx......"
source "./rpm/nginx/install_nginx.sh"
sleep 2

send_info "安装php.."
send_info "Install PHP......"
source "./rpm/php/install_php.sh"
sleep 2

send_info "安装mariadb数据库.."
send_info "Install Mariadb......"
source "./rpm/mysql/install_mariadb.sh"
sleep 2


send_info "开始安装maxscale..."
send_info "begin to install maxscale..."
source "./rpm/maxscale/install_maxscale.sh"
sleep 2

send_info "开始安装keepalived..."
send_info "begin to install keepalived..."
source "./rpm/keepalived/install_keepalived.sh"
sleep 2

send_info "开始安装weed..."
send_info "begin to install weed..."
source "./rpm/weed/install_weed.sh"
sleep 2

send_info "安装文件上传下载工具..."
send_info "Install szrz..."
source "./rpm/rzsz/install_rzsz.sh"
sleep 2

send_info "安装数据库备份工具..."
send_info "Begin to install db backup tools..."
source "./rpm/xtrabackup/install_xtra.sh"
sleep 2

send_info "管理节点，安装squid..."
source "./rpm/squid/install_squid.sh"
sleep 2

send_info "修改server.conf..."
source "./slice/slt_config_server.sh"
sleep 2

send_info "部署Mysql备份工具..."
send_info "begin to deploy mysql backup tools..."
source "./tools/shell/mysql_backup_install.sh"
sleep 2

send_info "部署Weedfs备份工具..."
send_info "begin to deploy weedfs backup tools..."
source "./tools/shell/weedfs_backup_install.sh"
sleep 2

send_info "部署快捷命令..."
send_info "begin to deploy quick command..."
source "./tools/shell/write_cmd_install.sh"
sleep 2

send_info "检查ntpd校时服务..."
send_info "begin to start ntpd.service..."
source "./rpm/ntpd/install_ntp.sh"
sleep 2

send_info "安装redis..."
send_info "install redis..."
source "./rpm/redis/install_redis.sh"
sleep 2

send_info "开始安装smon,sagent..."
source "./rpm/app/install_app.sh"
sleep 2

if [ ! -d /var/sunlight ];then
	mkdir /var/sunlight
fi

echo "sunlight-tech.com" >> /var/sunlight/version
send_info "`date "+%Y/%m/%d %H:%M:%S"` 脚本执行完毕！"