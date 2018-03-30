#!bin/bash

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
echo "net.ipv4.conf.all.arp_ignore = 1 >> /etc/sysctl.conf"


found_cnt=`grep "^net.ipv4.conf.all.arp_announce" $CONF|wc -l`
if [ $found_cnt -eq 0 ]
then
	echo "net.ipv4.conf.all.arp_announce = 2" >> $CONF
else
	sed -i "s/^net.ipv4.conf.all.arp_announce.*$/net.ipv4.conf.all.arp_announce = 2/" $CONF
fi
echo "net.ipv4.conf.all.arp_announce = 2 >> /etc/sysctl.conf"

fileMax=$(grep "fs.file-max" /etc/sysctl.conf | wc -l)
if [ $fileMax -eq 1 ];then
	sed -i '/fs.file-max/c\fs.file-max = 65535' $CONF
else
	sed -i '$a\fs.file-max = 65535' $CONF
fi
echo "fs.file-max = 65535 >> /etc/sysctl.conf"

ret=$(grep '#! /bin/sh' /etc/init.d/after.local |wc -l)
if ( test $ret -lt  1)
then
	echo "#! /bin/sh" > /etc/init.d/after.local
	echo "" >> /etc/init.d/after.local
fi
echo "Check #! /bin/bash In /etc/init.d/after.local"

ret=$(grep 'ethtool -A eth0' /etc/init.d/after.local |wc -l)
if ( test $ret -lt  1)
then
	echo "ethtool -A eth0 autoneg off rx off tx off" >> /etc/init.d/after.local
fi
echo "ethtool -A eth0 autoneg off rx off tx off >> /etc/init.d/after.local"


ret=$(grep 'ethtool -A eth1' /etc/init.d/after.local |wc -l)
if ( test $ret -lt  1)
then
	echo "ethtool -A eth1 autoneg off rx off tx off" >> /etc/init.d/after.local
fi
echo "ethtool -A eth1 autoneg off rx off tx off >> /etc/init.d/after.local"
#ethtool -A eth0 autoneg off rx off tx off
#ethtool -A eth1 autoneg off rx off tx off

SECT="/etc/security/limits.conf"

nofileMax=$(grep "soft nofile" /etc/security/limits.conf | wc -l)
if [ $nofileMax -eq 1 ];then
	sed -i '/soft nofile/c\* soft nofile 10240' $SECT
else
	sed -i '$a\* soft nofile 10240' $SECT
fi
echo "* soft nofile 10240 >> /etc/security/limits.conf"

hdfileMax=$(grep "hard nofile" /etc/security/limits.conf | wc -l)
if [ $hdfileMax -eq 1 ];then
	sed -i '/hard nofile/c\* hard nofile 10240' $SECT
else
	sed -i '$a\* hard nofile 10240' $SECT
fi
echo "* hard nofile 10240 >> /etc/security/limits.conf"

check_max_tasks=$(awk '/^DefaultTasksMax/' /etc/systemd/system.conf | wc -l)
if [ $check_max_tasks -lt 1 ];then
	sed -i '$a\DefaultTasksMax=1024' /etc/systemd/system.conf
else
	sed -i '/^DefaultTasksMax/c\DefaultTasksMax=1024' /etc/systemd/system.conf
fi
#echo "DefaultTasksMax=1024 >> /etc/systemd/system.conf"

echo -e "\n"
echo "System parameters have been configed over."