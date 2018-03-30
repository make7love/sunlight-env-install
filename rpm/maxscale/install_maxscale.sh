#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/maxscale"
fi

check_maxscale=$(rpm -qa|grep maxscale | wc -l)
if [ $check_maxscale -lt 1 ];then
	if [ $base_server_role -eq 2 ];then
		rpm -ivh "$opt_path/maxscale/maxscale*.rpm"
		cp "$opt_path/conf/maxscale.cnf"  /etc/

		for((i=0; i<$base_epg_server_number; i++))
		do
			in_ct=$(echo "$i+1" | bc)
			app_server=$(echo $app_cluster_private_ip | cut -d ',' -f $in_ct)

			if [ "$app_server" == "$app_private_ip" ];then
				swht=1
			else
				swht=$(echo "$base_epg_server_number*$base_epg_server_number" | bc)
			fi
			sed -i "5a\sunlight_weight=$swht" /etc/maxscale.cnf
			sed -i '5a\protocol=MySQLBackend' /etc/maxscale.cnf
			sed -i '5a\port=3306' /etc/maxscale.cnf
			sed -i "5a\address=${app_server}" /etc/maxscale.cnf
			sed -i "5a\type=server" /etc/maxscale.cnf
			sed -i "5a\[server${in_ct}]" /etc/maxscale.cnf
			sed -i '5G' /etc/maxscale.cnf
		done

		send_success "maxscale install finished..."
	elif [ $base_server_role -eq 3 ];then
		rpm -ivh "$opt_path/maxscale/maxscale*.rpm"
		cp "$opt_path/conf/maxscale.cnf"  /etc/

		for((i=0; i<$base_epg_server_number; i++))
		do
			in_ct=$(echo "$i+1" | bc)
			app_server=$(echo $proxy_backend_private_ip | cut -d ',' -f $in_ct)
			sed -i "5a\sunlight_weight=$base_epg_server_number" /etc/maxscale.cnf
			sed -i '5a\protocol=MySQLBackend' /etc/maxscale.cnf
			sed -i '5a\port=3306' /etc/maxscale.cnf
			sed -i "5a\address=${app_server}" /etc/maxscale.cnf
			sed -i "5a\type=server" /etc/maxscale.cnf
			sed -i "5a\[server${in_ct}]" /etc/maxscale.cnf
			sed -i '5G' /etc/maxscale.cnf
		done

		send_success "maxscale install finished..."
	else
		send_info ">>>>>>>> This server need not to install maxscale..."
	fi
else
	send_info "Skip. Maxscale Has Been Installed."
fi