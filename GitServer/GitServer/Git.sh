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
create_user()
{
		id -u "git"
		if [ "$?" -eq "1" ]
		then
			echo "Create user git"
			useradd git
			echo "Type passwd user git"
			passwd git
		else
			echo "user git already exist!"
		fi

}

check_installed_yum
create_user
