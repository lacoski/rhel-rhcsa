ip_list=`hostname -I`
echo $ip_list
for ip in ${ip_list[*]}
do
  echo "$ip"
done
