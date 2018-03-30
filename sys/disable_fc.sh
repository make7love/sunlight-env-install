#! /bin/sh

touch /etc/init.d/after.local
ret=$(grep '#! /bin/sh' /etc/init.d/after.local |wc -l)
if ( test $ret -lt  1)
then
    echo "#! /bin/sh" > /etc/init.d/after.local
    echo "" >> /etc/init.d/after.local
fi

ret=$(grep 'ethtool -A eth0' /etc/init.d/after.local |wc -l)
if ( test $ret -lt  1)
then
    echo "ethtool -A eth0 autoneg off rx off tx off" >> /etc/init.d/after.local
fi

ret=$(grep 'ethtool -A eth1' /etc/init.d/after.local |wc -l)
if ( test $ret -lt  1)
then
    echo "ethtool -A eth1 autoneg off rx off tx off" >> /etc/init.d/after.local
fi

ethtool -A eth0 autoneg off rx off tx off
ethtool -A eth1 autoneg off rx off tx off
