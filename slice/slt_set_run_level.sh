#!/bin/bash
#设置开机启动后进入命令行
systemctl set-default multi-user.target

if [ $? -eq 0 ];then
	echo "SUCCESS! Set run level over."
else
	echo "Error! Set run level failed."
fi
