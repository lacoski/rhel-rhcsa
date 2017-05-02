#!/bin/bash
# This Script write by Lacoski
# Samba bash script install Samba
#
readonly base_file=`readlink -f "$0"` # Lay toan duong link file
readonly base_path=`dirname $base_file` # get path link
. "$base_path/lib/config.base"
echo "Welcome to samba script"

check_installed_yum()
{
	for i in ${packets[*]}
	do
		echo "Checking $i"
		yum list installed | grep "$i"
		if [ $? -ne "0" ]
		then
				echo "Installing $i"
				yum install "$i" -y
				echo "..Done"
		else
				echo "$i has installed!"
				echo "$i updating packets"
				yum install $i -y
				echo "..Done"
		fi
	done
}

run_and_enable()
{
  systemctl enable smb.service
  systemctl enable nmb.service
  systemctl restart smb.service
  systemctl restart nmb.service
}
config_firewalld()
{
  firewall-cmd --permanent --zone=public --add-service=samba
  firewall-cmd --reload
}
config_SELinux()
{
  setenforce 0
}
awk_script_cut_direc() # cut column to read
{
	#name_tmp_file=$path$temp_awk_script
	#touch "$name_tmp_file"
  cat /dev/null > /tmp/tempfile
	awk -f "$base_path/lib/process.awk" "$base_path/lib/direc_share.base"
  awk -f "$base_path/lib/main.config.awk" "$base_path/lib/direc_share.base" > /tmp/tempMain
  setsebool -P samba_enable_home_dirs on
}
create_group()
{
  while read group; do
    echo "Checking $group"
    if grep -q $group /etc/group
      then
           echo "$group exits!"
      else
           echo "$group not exits! Create group"
           groupadd $group
    fi
  done < /tmp/tempfile
  rm -f /tmp/tempfile
}
config_main_path()
{
  cp -n $main_config $main_config.backup
  cat /tmp/tempMain >> $main_config

  systemctl restart smb.service
  systemctl restart nmb.service
}
user_name=`whoami`
if [ ! $user_name = "root" ]
then
	echo "You need root permission to run this script"
	exit 1
fi
echo "Start install Samba server"
check_installed_yum
run_and_enable
config_firewalld
config_SELinux
awk_script_cut_direc
create_group
config_main_path
echo "Done script install Samba server!"
