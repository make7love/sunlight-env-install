dir=`pwd`
echo $dir

if [ -f "/usr/local/sunlight/cdn/gslb/bin/startup.sh" ];then
        echo try to start gslb
        /usr/local/sunlight/cdn/gslb/bin/startup.sh
fi

if [ -f "/usr/local/sunlight/cdn/gnm/bin/startup.sh" ];then
        echo try to start gnm
        /usr/local/sunlight/cdn/gnm/bin/startup.sh
fi

if [ -f "/usr/local/sunlight/cdn/nm/bin/startup.sh" ];then
        echo try to start nm
        /usr/local/sunlight/cdn/nm/bin/startup.sh
fi


if [ -f "/usr/local/sunlight/cdn/vms/bin/startup.sh" ];then
        echo try to start vms
        /usr/local/sunlight/cdn/vms/bin/startup.sh
fi