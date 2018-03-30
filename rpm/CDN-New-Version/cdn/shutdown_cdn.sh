
dir=`pwd`
echo $dir

if [ -f "/usr/local/sunlight/cdn/gslb/bin/shutdown.sh" ];then
        echo try to shutdown gslb
        /usr/local/sunlight/cdn/gslb/bin/shutdown.sh
fi

if [ -f "/usr/local/sunlight/cdn/gnm/bin/shutdown.sh" ];then
        echo try to shutdown gnm
        /usr/local/sunlight/cdn/gnm/bin/shutdown.sh
fi

if [ -f "/usr/local/sunlight/cdn/nm/bin/shutdown.sh" ];then
        echo try to shutdown nm
        /usr/local/sunlight/cdn/nm/bin/shutdown.sh
fi


if [ -f "/usr/local/sunlight/cdn/vms/bin/shutdown.sh" ];then
        echo try to shutdown vms
        /usr/local/sunlight/cdn/vms/bin/shutdown.sh
fi



cd $dir 