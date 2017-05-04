#!/bin/bash
# this script write by Lacoski
# script install FTP
readonly base_file=`readlink -f "$0"` # Lay toan duong link file
readonly base_path=`dirname $base_file` # get path link
. "$base_path/lib/config.base"
user_name=`whoami`
if [ ! $user_name = "root" ]
then
	echo "You need root permission to run this script"
	exit 1
fi
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
  systemctl enable vsftpd
  systemctl start vsftpd
}
config_firewalld()
{
  firewall-cmd --permanent --add-port=21/tcp
  firewall-cmd --permanent --add-service=ftp
  firewall-cmd --reload
}
checking_user_exist()
{
  echo "checking user exit!"
  for i in ${user_lists[*]}
	do
    id $i 2>/dev/null 1>/dev/null
    if [ ! $? -eq "0" ]
      then
      echo "Adding user: $i"
      useradd $i
      echo "Type passwd $i:"
      passwd $i
    fi
	done
}
config_main_path()
{
  cp -n $main_config $main_config.backup
  cp -n $user_list_config $user_list_config.backup
  echo "Adding user to $user_list_config"
  for i in ${user_lists[*]}
	do
    echo "Adding user: $i"
		echo "$i" >> $user_list_config
	done

  cat $base_path/lib/tempConfig > $main_config

  #systemctl restart vsftpd
}
check_installed_yum
checking_user_exist
config_main_path
run_and_enable
config_firewalld
#config_main_path
#run_and_enable
