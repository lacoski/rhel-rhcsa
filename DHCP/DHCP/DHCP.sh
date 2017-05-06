# This is bash script write by Lacoski
# Script install DHCP
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
  systemctl start dhcpd
  systemctl enable dhcpd
}
config_firewalld()
{
  firewall-cmd --add-service=dhcp --permanent
  firewall-cmd --reload
}
config_main_path()
{
  cp -n $main_config $main_config.backup
  cat $base_path/lib/main.config.temp > $main_config
  systemctl restart dhcpd
}
check_installed_yum
run_and_enable
config_firewalld
config_main_path
