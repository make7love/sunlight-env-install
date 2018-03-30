#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/sshkey"
fi

if [ $(grep "sunlight" /etc/group | wc -l) -lt 1 ];then
	groupadd sunlight
fi

if [ $(grep "sunlight" /etc/passwd | wc -l) -lt 1 ];then
	useradd -g sunlight -G wheel -d /home/sunlight/ -m sunlight
fi

if [ ! -d /usr/local/sunlight/sshkeys ]; then
	mkdir -p /usr/local/sunlight/sshkeys
	cp "$opt_path/pk/init.pk" /usr/local/sunlight/sshkeys/
	chmod a+r /usr/local/sunlight/sshkeys/init.pk
	chown sunlight:sunlight /usr/local/sunlight/sshkeys/init.pk
fi


# install init public key
if  [ ! -d /root/.ssh ]; then
	mkdir -p /root/.ssh
fi


if [ ! -f /root/.ssh/authorized_keys ];then
	touch /root/.ssh/authorized_keys
fi

found_sl_key=`grep sunlightsvrkey /root/.ssh/authorized_keys|wc -l`
if [ $found_sl_key -eq 0 ]; then
	cat "$opt_path/pk/init.pub" >> /root/.ssh/authorized_keys
	sed -i '/^$/d' /root/.ssh/authorized_keys
	chmod 0600 /root/.ssh/authorized_keys
	chown root:root /root/.ssh/authorized_keys
fi