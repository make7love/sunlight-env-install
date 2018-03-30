#!/bin/bash


if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/python"
fi

echo -n "Can this sever connect to The Internet ? [y/n]"
read connect_sure
if [[ "$connect_sure" == "y" || "$connect_sure" == "Y" ]];then
	python "$opt_path/get-pip.py"
fi

echo "install setuptolls......"
python "$opt_path/setuptools-36.6.0/setup.py" install

echo "install pyredis ......"
python "$opt_path/redis-py-master/setup.py" install

echo "install supervisor ......"
python "$opt_path/supervisor-master/setup.py" install

echo "install mysql-python ......"
python "$opt_path/MySQL-python-1.2.5/setup.py" install

echo "python plugins install end ......"