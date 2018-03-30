#!/bin/bash

echo "start maxscale..."

systemctl restart maxscale.service

echo "set server server1 master..."
maxadmin -uadmin -pmariadb set server server1 master

echo "set server server2 slave..."
maxadmin -uadmin -pmariadb set server server2 slave

echo "set server server3 slave..."
maxadmin -uadmin -pmariadb set server server3 slave