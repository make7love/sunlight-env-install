#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/rzsz"
fi

rpm -ivh "$opt_path/*.rpm"
send_info "rzsz install finished..."
send_info "------------------------------------------"
