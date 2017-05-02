#!/bin/bash
# This Script write by Lacoski
# Samba bash script install Samba
#

readonly base_file=`readlink -f "$0"` # Lay toan duong link file
readonly base_path=`dirname $base_file` # get path link
. "$base_path/lib/config.base"
echo "Welcome to samba script"

user_name=`whoami`
if [ ! $user_name = "root" ]
then
	echo "You need root permission to run this script"
	exit 1
fi

stop_and_disable()
{
  systemctl disable  smb.service
  systemctl disable  nmb.service
  systemctl stop smb.service
  systemctl stop nmb.service
  echo "re systemctl done!"
}
re_config_firewalld()
{
  firewall-cmd --permanent --zone=public --remove-service=samba
  firewall-cmd --reload
  echo "re firewall done!"
}

re_config_main_path()
{
  \cp $main_config.backup $main_config
  echo "re main path done!"
}
echo "Re-install Samba server"
stop_and_disable
re_config_firewalld
re_config_main_path

echo "Done Re-install script Samba server"
