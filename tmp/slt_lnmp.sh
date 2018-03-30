#!/bin/bash


base_path=$(cd `dirname $0`;pwd)

sleep 2

echo "10). Install Nginx......"
sleep 2
source "./rpm/nginx/install_nginx.sh"

echo "11). Install PHP......"
sleep 2
source "./rpm/php/install_php.sh"

echo "12). Install Mariadb......"
sleep 2
source "./rpm/mysql/install_mariadb.sh"

echo "===============LNMP Install Complete======================="
exit 0