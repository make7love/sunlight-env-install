#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/php"
fi

check_php=$(rpm -qa | grep "php7-fpm" | wc -l)
if [ $check_php -lt 1 ];then
	if [[ $base_server_role -eq 1 ||  $base_server_role -eq 2 || $base_server_role -eq 4 ]];then
		rpm -ivh "$opt_path/php/libmcrypt-2.5.8-115.87.x86_64.rpm"
		rpm -ivh "$opt_path/php/php*.rpm"
		cp -rf "$opt_path/conf/str_message.so" /usr/lib64/php7/extensions
		cp -rf "$opt_path/conf/str_message.ini" /etc/php7/conf.d/
		cp -rf "$opt_path/conf/php-fpm.conf" /etc/php7/fpm/php-fpm.conf
		cp -rf "$opt_path/conf/www.conf" /etc/php7/fpm/php-fpm.d/www.conf
		cp -rf "$opt_path/conf/php.ini"  /etc/php7/fpm/php.ini
		cp -rf "$opt_path/conf/php-cli.ini"  /etc/php7/cli/php.ini 
		
		if [ ! -d /var/log/php ];then
			mkdir /var/log/php
		fi
		chown nobody:nobody /var/log/php
		chmod 700 /var/log/php
		echo "****** PHP Has Been Installed ******"
		
		#sagent使用时需要设置
		if [ -f  /usr/lib/systemd/system/php-fpm.service ];then
			cp /usr/lib/systemd/system/php-fpm.service   /usr/lib/systemd/system/php-fpm.service.bak
			sed -i '/PrivateTmp/c\PrivateTmp=false' /usr/lib/systemd/system/php-fpm.service
		fi

		echo "starting php-fpm ..."
		systemctl enable php-fpm
		systemctl start php-fpm
		send_success "PHP7 install finished"
		send_info "------------------------------------------"
	else
		send_info "This server need not to install php, skipped..."
	fi
	
else
	echo "Yes,You Have Installed PHP,Skipping."
fi
