#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/dstat"
fi

if [ ! -d /usr/local/dstat ];then
  cp -rf "$opt_path/dstat"  /usr/local/
fi
if [ -d /usr/local/dstat ];then
	chmod 0755 -R /usr/local/dstat
fi

rpm -ivh "$opt_path/sysstat/sysstat*.rpm"

echo "Statistic Tool Dstat Has Been Installed."