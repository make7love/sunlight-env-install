#!/bin/sh
CONF=/etc/sysctl.conf
sysctl -w net.ipv4.conf.all.arp_ignore=1
sysctl -w net.ipv4.conf.all.arp_announce=2

found_cnt=`grep "^net.ipv4.conf.all.arp_ignore" $CONF|wc -l`
if [ $found_cnt -eq 0 ]
then
	echo "net.ipv4.conf.all.arp_ignore = 1" >> $CONF
else
	sed -i "s/^net.ipv4.conf.all.arp_ignore.*$/net.ipv4.conf.all.arp_ignore = 1/" $CONF
fi

found_cnt=`grep "^net.ipv4.conf.all.arp_announce" $CONF|wc -l`
if [ $found_cnt -eq 0 ]
then
	echo "net.ipv4.conf.all.arp_announce = 2" >> $CONF
else
	sed -i "s/^net.ipv4.conf.all.arp_announce.*$/net.ipv4.conf.all.arp_announce = 2/" $CONF
fi

