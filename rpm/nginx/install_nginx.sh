#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/nginx"
fi

if [ -z "$base_server_role" ];then
	send_error "base_server_role config is empty!"
	send_error "配置文件有误，安装中断！"
	exit 1
fi

check_nginx=$(rpm -qa | grep "nginx" | wc -l)
if [ $check_nginx -lt 1 ];then
	if [ "$base_server_role" == "1" ];then
		nginx_install_act=1
		rpm -ivh "$opt_path/nginx/nginx*.rpm"
		mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
		mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak

		cp -rf "$opt_path/conf/nginx-manage-default.conf"  /etc/nginx/conf.d/default.conf
		cp -rf "$opt_path/conf/nginx-manage.conf"  /etc/nginx/nginx.conf
	elif [ "$base_server_role" == "4" ]; then
		nginx_install_act=1
		rpm -ivh "$opt_path/nginx/nginx*.rpm"
		mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
		mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak

		cp -rf "$opt_path/conf/nginx-manage-default.conf"  /etc/nginx/conf.d/default.conf
		cp -rf "$opt_path/conf/nginx-manage.conf"  /etc/nginx/nginx.conf
	elif [ "$base_server_role" == "2" ]; then
		nginx_install_act=1
		rpm -ivh "$opt_path/nginx/nginx*.rpm"
		mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
		mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak

		cp -rf "$opt_path/conf/nginx-app-default.conf"  /etc/nginx/conf.d/default.conf
		cp -rf "$opt_path/conf/http.conf"  /etc/nginx/conf.d/
		cp -rf "$opt_path/conf/nginx-app.conf"  /etc/nginx/nginx.conf

		for((i=0; i<$base_epg_server_number; i++))
		do
			in_ct=$(echo "$i+1" | bc)
			app_ng=$(echo $app_cluster_private_ip | cut -d ',' -f $in_ct)
			epg_bks="server ${app_ng}:81  max_fails=5  fail_timeout=5s;"
			sed -i "/epgservers/a\${epg_bks}"   /etc/nginx/nginx.conf
		done

	elif [ "$base_server_role" == "3" ]; then
		nginx_install_act=1
		rpm -ivh "$opt_path/nginx/nginx*.rpm"
		mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
		mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak

		cp -rf "$opt_path/conf/nginx-app-default.conf"  /etc/nginx/conf.d/default.conf
		cp -rf "$opt_path/conf/http.conf"  /etc/nginx/conf.d/
		cp -rf "$opt_path/conf/nginx-app.conf"  /etc/nginx/nginx.conf

		for((i=0; i<$base_epg_server_number; i++))
		do
			in_ct=$(echo "$i+1" | bc)
			app_ng=$(echo $proxy_backend_private_ip | cut -d ',' -f $in_ct)
			epg_bks="server ${app_ng}:81  max_fails=5  fail_timeout=5s;"
			sed -i "/epgservers/a\${epg_bks}"   /etc/nginx/nginx.conf
		done
	else
		nginx_install_act=0
		send_info "current server need not to install nginx...skipped..."
	fi

	if [ $nginx_install_act -eq 1 ];then
		send_success "nginx install finished!"	
		if [ $(grep "nginx" /etc/passwd | wc -l) -gt 0 ];then
			chown nginx:nginx -R /etc/nginx/
		fi
		systemctl enable nginx
		systemctl start nginx
		send_success "nginx install finished..."
		send_info "------------------------------------------"
		fi
else
	echo "****** Skip! Nginx Has Been Installed ******"
fi