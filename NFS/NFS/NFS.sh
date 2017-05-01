#!/bin/bash
# Welcome my first install script.
# Write by Lacoski
# Install NFS

# var
readonly base_file=`readlink -f "$0"` # Lay toan duong link file
readonly base_path=`dirname $base_file` # get path link
# set script in env
. "$base_path/lib/config.base"
# function
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
				yum update $i -y
				echo "..Done"
		fi
	done
}
run_and_enable()
{
		systemctl enable rpcbind
		systemctl enable nfs-server
		systemctl start rpcbind
		systemctl start nfs-server
		systemctl start rpc-statd
		systemctl start nfs-idmapd
}
config_firewalld()
{
		firewall-cmd --permanent --zone public --add-service=mountd
		firewall-cmd --permanent --zone public --add-service=rpc-bind
		firewall-cmd --permanent --zone=public --add-service=nfs
		firewall-cmd --reload
}
awk_script_cut_direc() # cut column to read
{
	#name_tmp_file=$path$temp_awk_script
	#touch "$name_tmp_file"
	awk -f "$base_path/lib/process.awk" "$base_path/lib/direc_share.base"
}
config_share_direc()
{
	# create backup file
	name_tmp_file=$path_tmp$temp_awk_script
	touch "$name_tmp_file"
	cp "$main_config" "$main_config".backup
	cat "$path_tmp$temp_awk_script" > "$main_config"
	rm -f "$path_tmp$temp_awk_script"
	exportfs -r
}
# body
user_name=`whoami`
if [ ! $user_name = "root" ]
then
	echo "You need root permission to run this script"
	exit 1
fi

echo "Welcome to NFS fast install"
#echo "$base_file $base_path"
# run script
	check_installed_yum
	run_and_enable
	config_firewalld
	awk_script_cut_direc
	config_share_direc
