#!/bin/bash

*/1 * * * * root flock -xn /tmp/rsync-welcomepage.lock  -c '/root/bin/pushfile /var/www/html/app/epggroup_default/welcomepage/'