BEGIN{
  printf "Script process direc_share.base \n"
}
{
  name_file = $1
  create_cmd = "mkdir -p " $1
  create_2_cmd = "chmod 777 " $1
  printf "Check file %s and create if not exist \n",name_file
  system(create_cmd)
  system(create_2_cmd)
  config_file_cmd = "echo \"" $1 " " $2 "(rw,sync,no_root_squash)\" >> /tmp/tempawk"
  system(config_file_cmd)
}
END{
  printf "End script process direc_share.base \n"
}
