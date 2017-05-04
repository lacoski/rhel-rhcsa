readonly base_file=`readlink -f "$0"` # Lay toan duong link file
readonly base_path=`dirname $base_file` # get path link
. "$base_path/lib/config.base"
user_name=`whoami`
if [ ! $user_name = "root" ]
then
	echo "You need root permission to run this script"
	exit 1
fi
stop_and_disable()
{
  systemctl disable vsftpd
  systemctl stop vsftpd
  echo "re systemctl done!"
}
re_config_firewalld()
{
  firewall-cmd --permanent --remove-port=21/tcp
  firewall-cmd --permanent --remove-service=ftp
  firewall-cmd --reload
  echo "re firewall done!"
}

re_config_main_path()
{
  \cp $main_config.backup $main_config
  \cp $user_list_config.backup $user_list_config
  echo "re main path done!"
}
echo "Re-install FTP server"
stop_and_disable
re_config_firewalld
re_config_main_path

echo "Done Re-install script FTP server"
