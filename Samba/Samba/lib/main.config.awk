BEGIN{
  count = 0
}
{
  count++
  printf "["$2" "count "]""\n"
  printf "comment = shared-directory""\n"
  printf "path = "$1"\n"
  printf "public = no""\n"
  printf "valid users = @"$2"\n"
  printf "writable = yes""\n"
  printf "browseable = yes""\n"
  printf "create mask = 0765""\n"
  cmd_make = "chcon -t samba_share_t "$1
  cmd_make_2 = "semanage fcontext -a -t samba_share_t "$1
  system(cmd_make)
  system(cmd_make_2)
}
