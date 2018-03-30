#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/mysql"
fi

function kill_mysql()
{
	check_mysql_pid=$(ps -ef|grep mysqld | grep -v grep | wc -l)
	if [ $check_mysql_pid -gt 0 ];then
		systemctl stop mysql.service
		mysqladmin shutdown
		killall mysqld
		sleep 3
		pkill -9 mysqld
		sleep 3
	fi
}

function clean_sys_for_mysql()
{
	local clean_target=("libmysqlclient18", "mariadb")
}


if [ -z "$base_server_role" ];then
	echo "Sooory! Cann't detect this server role...,Install terminate!!!"
	exit 1
fi

if [ $(rpm -qa | grep "Maria" | wc -l ) -gt 0 ];then
	echo "MariaDB Has Been Installed ~!"
	echo "Skipping Install MariaDB......"
elif [[ $base_server_role -ne 1 && $base_server_role -ne 2 && $base_server_role -ne 5 ]];then
	send_info "This server need not to install mysql server, skipped..."
else
	echo "Checking Mysql Pid......"
	if [ $(ps -ef | grep mysqld | grep -v grep | wc -l) -gt 0 ];then
		kill_mysql
	fi

	if [ $(rpm -qa|grep mariadb | wc -l) -gt 0 ];then
		rpm -e `rpm -qa|grep mariadb`
	fi

	if [ $(rpm -qa|grep libmysqlclient18 | wc -l) -gt 0 ];then
		rpm -e `rpm -qa|grep libmysqlclient18`
	fi
	
	
	if [ ! -d /var/log/mysql ];then
		mkdir /var/log/mysql
		chmod 755 /var/log/mysql
	fi

	echo "Begin To Install MariaDB......"
	echo "Copy mysql lib files......"
	if  [ ! -f /usr/lib64/libssl.so.0.9.8 ];then
		cp -f "$opt_path/lib/libssl.so.0.9.8" /usr/lib64/
	fi
	if [ ! -f /usr/lib64/libcrypto.so.0.9.8 ];then
		cp -f "$opt_path/lib/libcrypto.so.0.9.8" /usr/lib64/
	fi

	if [ ! -f /usr/lib64/libmysqlclient.so.16 ]; then
		cp -f "$opt_path/lib/libmysqlclient.so.16.0.0" /usr/lib64/
		cp -f "$opt_path/lib/libmysqlclient_r.so.16.0.0" /usr/lib64/
		ln -s /usr/lib64/libmysqlclient.so.16.0.0 /usr/lib64/libmysqlclient.so.16
		ln -s /usr/lib64/libmysqlclient_r.so.16.0.0 /usr/lib64/libmysqlclient_r.so.16
	fi

	if [ ! -d /usr/lib64/mysql/plugin ];then
		mkdir -p /usr/lib64/mysql/plugin
	fi

	if [ ! -f /usr/lib64/mysql/plugin/lib_mysqludf_sys.so ];then
		cp -f "$opt_path/lib/lib_mysqludf_sys.so" /usr/lib64/mysql/plugin/lib_mysqludf_sys.so
	fi

	rpm -ivh "$opt_path/maria/galera-25.3.19-1.sles12.sle12.x86_64.rpm"
	rpm -ivh "$opt_path/maria/MariaDB-10.1.22-sles12-x86_64-common.rpm"
	rpm -ivh "$opt_path/maria/MariaDB-10.1.22-sles12-x86_64-shared.rpm"
	rpm -ivh "$opt_path/maria/MariaDB-10.1.22-sles12-x86_64-devel.rpm"
	rpm -ivh "$opt_path/maria/MariaDB-10.1.22-sles12-x86_64-client.rpm"
	rpm -ivh "$opt_path/maria/MariaDB-10.1.22-sles12-x86_64-cracklib-password-check.rpm"
	rpm -ivh "$opt_path/maria/MariaDB-10.1.22-sles12-x86_64-server.rpm"

	
	
	if [ "$base_server_role" == "2" ];then
		this_node_ip=$app_private_ip
		this_cluster_ip=$app_cluster_private_ip
	fi
	if [ "$base_server_role" == "5" ];then
		this_node_ip=$db_private_ip
		this_cluster_ip=$db_cluster_private_ip
	fi

	if [ "$base_server_role" == "1" ];then
		cp -rf "$opt_path/conf/mysql-server-manage.cnf" /etc/my.cnf.d/server.cnf
		systemctl enable mysql.service
		systemctl start mysql

		sleep 2
		mysql < "$opt_path/conf/install_mysql_udf_functions.sql"
	else
		cp -rf "$opt_path/conf/mysql-server.cnf" /etc/my.cnf.d/server.cnf
		
		sed -i "/^wsrep_node_address=/c\wsrep_node_address=\"$this_node_ip\"" /etc/my.cnf.d/server.cnf
		sed -i "/^wsrep_cluster_address=/c\wsrep_cluster_address=\"gcomm://$this_cluster_ip\"" /etc/my.cnf.d/server.cnf
		
		echo "Checking Mysql Pid......"
		
		if [ $(ps -ef | grep mysqld | grep -v grep | wc -l) -gt 1 ];then
			kill_mysql
		fi
		echo "Is this the first node to start?[Y/n]"
		read x
		if [ "$x" == "Y" -o "$x" == 'y' ]; then
			galera_new_cluster
		else
			systemctl start mysql
		fi
		sleep 3
		mysql < "$opt_path/conf/all_host_privileges.sql"
		mysql < "$opt_path/conf/install_mysql_udf_functions.sql"
	fi


	if [ $(grep mysql /etc/passwd | wc -l) -gt 1 ];then
		if [ -d /var/log/mysql ];then
			chown -R mysql:mysql /var/log/mysql
			chmod -R 700 /var/log/mysql
		fi
	fi
	send_success "****** Mysql Server Has Been Installed ******"
	send_info "------------------------------------------"
fi