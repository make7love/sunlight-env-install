#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/keepalived"
fi


check_keepalived=$(rpm -qa|grep keepalived | wc -l)
if [ $check_keepalived -lt 1 ];then
	if [ $base_server_role -eq 2 ];then
		rpm -ivh "$opt_path/keepalived/keepalived*.rpm"
		cp "$opt_path/keepalived-config/keepalived.common.conf"  /etc/keepalived/keepalived.conf

		if [[ -n "$base_maxscale_vip" && -n "$app_maxscale_state" && -n "$app_maxscale_weight" ]];then
			echo "" >>  /etc/keepalived/keepalived.conf
			echo "vrrp_instance VI_MAXSCALE {"    >>  /etc/keepalived/keepalived.conf
			echo "    state $app_maxscale_state"  >>  /etc/keepalived/keepalived.conf
			echo "    interface eth1"  >>  /etc/keepalived/keepalived.conf
			echo "    virtual_router_id 60"  >>  /etc/keepalived/keepalived.conf
			echo "    priority $app_maxscale_weight"  >>  /etc/keepalived/keepalived.conf
			echo "     advert_int 1"  >>  /etc/keepalived/keepalived.conf
			echo "    authentication {"  >>  /etc/keepalived/keepalived.conf
			echo "        auth_type PASS"  >>  /etc/keepalived/keepalived.conf
			echo "        auth_pass 1111"  >>  /etc/keepalived/keepalived.conf
			echo "     }"  >>  /etc/keepalived/keepalived.conf
			echo "    virtual_ipaddress {"  >>  /etc/keepalived/keepalived.conf
			echo "         $base_maxscale_vip/24 dev eth1 scope global"  >>  /etc/keepalived/keepalived.conf
			echo "    }"  >>  /etc/keepalived/keepalived.conf
			echo "}"  >>  /etc/keepalived/keepalived.conf
		fi

		if [[ -n "$base_epg_vip" && -n "$app_epg_state" && -n "$app_epg_weight" ]];then
			echo "" >>  /etc/keepalived/keepalived.conf
			echo "vrrp_instance VI_EPG {" >>  /etc/keepalived/keepalived.conf
			echo "    state $app_epg_state" >>  /etc/keepalived/keepalived.conf
			echo "    interface eth0" >>  /etc/keepalived/keepalived.conf
			echo "    virtual_router_id 61" >>  /etc/keepalived/keepalived.conf
			echo "    priority $app_epg_weight" >>  /etc/keepalived/keepalived.conf
			echo "    advert_int 1" >>  /etc/keepalived/keepalived.conf
			echo "    authentication {" >>  /etc/keepalived/keepalived.conf
			echo "         auth_type PASS" >>  /etc/keepalived/keepalived.conf
			echo "         auth_pass 1111" >>  /etc/keepalived/keepalived.conf
			echo "    }" >>  /etc/keepalived/keepalived.conf
			echo "    virtual_ipaddress {" >>  /etc/keepalived/keepalived.conf
			echo "        $base_epg_vip/24 dev eth0 scope global" >>  /etc/keepalived/keepalived.conf
			echo "    }" >>  /etc/keepalived/keepalived.conf
			echo "}" >>  /etc/keepalived/keepalived.conf
		fi

		if [[ -n "$base_weedfs_vip" && -n "$app_weedfs_state" && -n "$app_weedfs_weight" ]];then
			echo "" >>  /etc/keepalived/keepalived.conf
			echo "vrrp_instance VI_WEEDFS {" >>  /etc/keepalived/keepalived.conf
			echo "    state $app_weedfs_state" >>  /etc/keepalived/keepalived.conf
			echo "    interface eth0" >>  /etc/keepalived/keepalived.conf
			echo "    virtual_router_id 62" >>  /etc/keepalived/keepalived.conf
			echo "    priority $app_weedfs_weight" >>  /etc/keepalived/keepalived.conf
			echo "    advert_int 1" >>  /etc/keepalived/keepalived.conf
			echo "    authentication {" >>  /etc/keepalived/keepalived.conf
			echo "         auth_type PASS" >>  /etc/keepalived/keepalived.conf
			echo "         auth_pass 1111" >>  /etc/keepalived/keepalived.conf
			echo "    }" >>  /etc/keepalived/keepalived.conf
			echo "    virtual_ipaddress {" >>  /etc/keepalived/keepalived.conf
			echo "        $base_weedfs_vip/24 dev eth0 scope global" >>  /etc/keepalived/keepalived.conf
			echo "    }" >>  /etc/keepalived/keepalived.conf
			echo "}" >>  /etc/keepalived/keepalived.conf
		fi

		int_keep=1
	elif [ $base_server_role -eq 3 ]; then
		rpm -ivh "$opt_path/keepalived/keepalived*.rpm"
		cp "$opt_path/keepalived-config/keepalived.proxy.maxscale.conf"  /etc/keepalived/keepalived.conf

		if [[ -n "$base_maxscale_vip" && -n "$proxy_maxscale_state" && -n "$proxy_maxscale_weight" ]];then
			echo "" >>  /etc/keepalived/keepalived.conf
			echo "vrrp_instance VI_MAXSCALE {"    >>  /etc/keepalived/keepalived.conf
			echo "    state $proxy_maxscale_state"  >>  /etc/keepalived/keepalived.conf
			echo "    interface eth1"  >>  /etc/keepalived/keepalived.conf
			echo "    virtual_router_id 60"  >>  /etc/keepalived/keepalived.conf
			echo "    priority $proxy_maxscale_weight"  >>  /etc/keepalived/keepalived.conf
			echo "     advert_int 1"  >>  /etc/keepalived/keepalived.conf
			echo "    authentication {"  >>  /etc/keepalived/keepalived.conf
			echo "        auth_type PASS"  >>  /etc/keepalived/keepalived.conf
			echo "        auth_pass 1111"  >>  /etc/keepalived/keepalived.conf
			echo "     }"  >>  /etc/keepalived/keepalived.conf
			echo "    virtual_ipaddress {"  >>  /etc/keepalived/keepalived.conf
			echo "         $base_maxscale_vip/24 dev eth1 scope global"  >>  /etc/keepalived/keepalived.conf
			echo "    }"  >>  /etc/keepalived/keepalived.conf
			echo "}"  >>  /etc/keepalived/keepalived.conf
		fi
		int_keep=1
	elif [ $base_server_role -eq 4 ]; then
		rpm -ivh "$opt_path/keepalived/keepalived*.rpm"
		cp "$opt_path/keepalived-config/keepalived.epg.weed.conf"  /etc/keepalived/keepalived.conf
		
		if [[ -n "$base_weedfs_vip" && -n "$epg_weedfs_state" && -n "$epg_weedfs_weight" ]];then
			echo "" >>  /etc/keepalived/keepalived.conf
			echo "vrrp_instance VI_WEEDFS {" >>  /etc/keepalived/keepalived.conf
			echo "    state $epg_weedfs_state" >>  /etc/keepalived/keepalived.conf
			echo "    interface eth0" >>  /etc/keepalived/keepalived.conf
			echo "    virtual_router_id 62" >>  /etc/keepalived/keepalived.conf
			echo "    priority $epg_weedfs_weight" >>  /etc/keepalived/keepalived.conf
			echo "    advert_int 1" >>  /etc/keepalived/keepalived.conf
			echo "    authentication {" >>  /etc/keepalived/keepalived.conf
			echo "         auth_type PASS" >>  /etc/keepalived/keepalived.conf
			echo "         auth_pass 1111" >>  /etc/keepalived/keepalived.conf
			echo "    }" >>  /etc/keepalived/keepalived.conf
			echo "    virtual_ipaddress {" >>  /etc/keepalived/keepalived.conf
			echo "        $base_weedfs_vip/24 dev eth0 scope global" >>  /etc/keepalived/keepalived.conf
			echo "    }" >>  /etc/keepalived/keepalived.conf
			echo "}" >>  /etc/keepalived/keepalived.conf
		fi
		int_keep=1
	else
		int_keep=0
		send_info ">>>>>>> This server node need not to install keepalived, skip..."
	fi

	if [ $int_keep -eq 1 ];then
		chown keepalived:keepalived  -R /etc/keepalived
		if [ ! -d /var/log/keepalived ];then
			mkdir /var/log/keepalived
			chown keepalived:keepalived  /var/log/keepalived
			chmod 700 /var/log/keepalived
		fi

		if [ -f /etc/sysconfig/keepalived ];then
			sed -i 's/KEEPALIVED_OPTIONS/#KEEPALIVED_OPTIONS/' /etc/sysconfig/keepalived
			sed -i '$a\KEEPALIVED_OPTIONS="-D -d -S 0"' /etc/sysconfig/keepalived
		fi

		if [ -f /etc/rsyslog.conf ];then
			sed -i '$a\local0.*            /var/log/keepalived/keeplived.log'  /etc/rsyslog.conf 
		fi

		systemctl start rsyslog.service
		#systemctl enable keepalived
		#systemctl start keepalived
		echo "keepalived log path : /var/log/keepalived/"

		send_success "keepalived install finished..."
	fi
else
	echo "YES! Keepalived Has Existed.Skipped."
fi