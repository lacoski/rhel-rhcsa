#!/bin/bash
# This script write by Lacoski
# this script use to remote script NFS
#
readonly base_file=`readlink -f "$0"` # Lay toan duong link file
readonly base_path=`dirname $base_file` # get path link
. "$base_path/lib/config.base"
user_name=`whoami`
if [ ! $user_name = "root" ]
then
	echo "You need root permission to run this script"
	exit 1
fi

remove_stop_service()
{
  echo "Unshare all service"
  systemctl disable rpcbind
  systemctl disable nfs-server
  systemctl stop rpcbind
  systemctl stop nfs-server
  systemctl stop rpc-statd
  systemctl stop nfs-idmapd
  echo "..Done"
}
remove_config_firewalld()
{
  echo "remove config firewall"
		firewall-cmd --permanent --zone=public --remove-service=mountd
		firewall-cmd --permanent --zone=public --remove-service=rpc-bind
		firewall-cmd --permanent --zone=public --remove-service=nfs
		firewall-cmd --reload
    echo "..Done"
}
remove_content_main_config()
{
  echo "remove main config"
  cat /dev/null > $main_config
  echo "..Done"
}
stop_direc_share()
{
  echo "Stop share direc"
  exportfs -u
  echo "..Done"
}

echo "Remove NFS script"

stop_direc_share
remove_content_main_config
remove_stop_service
remove_config_firewalld
