#!/bin/bash


if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path"
fi

if [ ! -f /etc/init.d/after.local ];then
	touch /etc/init.d/after.local
fi

if [ ! -d /root/bin ];then
	mkdir /root/bin
fi


if [ ! -f /root/.profile ];then
	touch /root/.profile
fi


if [ ! -f /root/.bashrc ];then
	touch /root/.bashrc
fi


if [ $(grep "sunlight" /etc/group | wc -l) -lt 1 ];then
		groupadd sunlight
fi


if [ $(grep "sunlight" /etc/passwd | wc -l) -lt 1 ];then
	useradd -g sunlight -G wheel -d /home/sunlight/ -m sunlight
fi


if [ ! -d /var/log/mysql ];then
	mkdir /var/log/mysql
fi
chmod 777 /var/log/mysql

if [ ! -d /var/log/sweed ];then
	mkdir /var/log/sweed
fi
chmod 777 /var/log/sweed
chown sunlight:sunlight -R /var/log/sweed

if [ ! -d /var/www ];then
	mkdir /var/www
fi
chmod -R 755 /var/www



if [ ! -d /var/www/html ];then
	mkdir /var/www/html
fi
chmod -R 755 /var/www/html


if [ ! -d /var/www/upload ];then
	mkdir /var/www/upload
fi
chmod -R 777 /var/www/upload



#touch /var/www/html/httpchk.php
#echo '<?php echo "Hello world!";?>' > /var/www/html/httpchk.php


if [ ! -d /root/.ssh ];then
	mkdir /root/.ssh
fi

if [ ! -d /usr/local/sunlight/conf ];then
	mkdir -p /usr/local/sunlight/conf/
fi

if [ ! -f /usr/local/sunlight/conf/server.conf ];then
	cp -rf "$opt_path/sys/server.conf"  /usr/local/sunlight/conf/
	if [ -f /usr/local/sunlight/conf/server.conf ];then
		chmod 755 /usr/local/sunlight/conf/server.conf
	fi
fi


if [ ! -d /usr/local/content ];then
	mkdir /usr/local/content
fi
chmod 777 /usr/local/content


if [ ! -d /usr/local/content/upload ];then
	mkdir /usr/local/content/upload
fi
chmod 777 /usr/local/content/upload


if [ ! -d /usr/local/content/upload/adv ];then
	mkdir /usr/local/content/upload/adv
fi
chmod 777 /usr/local/content/upload/adv

if [ ! -d /usr/local/content/upload/audit ];then
	mkdir /usr/local/content/upload/audit
fi
chmod 777 /usr/local/content/upload/audit

if [ ! -d /usr/local/content/upload/media ];then
	mkdir /usr/local/content/upload/media
fi
chmod 777 /usr/local/content/upload/media

if [ ! -d /usr/local/content/upload/music ];then
	mkdir /usr/local/content/upload/music
fi
chmod 777 /usr/local/content/upload/music

if [ ! -d /usr/local/content/upload/trailer ];then
	mkdir /usr/local/content/upload/trailer
fi
chmod 777 /usr/local/content/upload/trailer

if [ ! -e /sunlight  ];then
	mkdir /sunlight
	chmod 755 /sunlight
fi

if [ ! -d /sunlight/shell  ];then
	mkdir /sunlight/shell
	chmod 755 /sunlight/shell
fi

if [ ! -d /sunlight/python  ];then
	mkdir /sunlight/python
	chmod 755 /sunlight/python
fi

echo "Init Boss End."
