#!/bin/sh

res='fail'

module_name='Basic'
upgrade_list="/raid/data/tmp/module/System/conf/upgrade.list"

cat "${upgrade_list}" | \
while read list
do
  if [ "${list}" != "" ];then
    source=`echo "${list}" | awk -F',' '{print $1}'`
    target=`echo "${list}" | awk -F',' '{print $2}'`
    deep_path=`echo "${target}" | awk -F'\/' '{print NF}'`
    last_name_len=`echo "${target}" | awk -F'\/' '{print length($NF)}'`
    last_value=`echo "${target}" | awk '{print substr($0,length($0))}'`
    if [ "$deep_path" != "1" ];then
      if [ "${last_value}" != "/" ];then
        str="echo '${target}' | awk '{print substr(\$0,1,length(\$0)-$last_name_len)}'"
      else
        str="echo '${target}' | awk '{print \$0}'"
      fi
      folder_path=`eval "$str"`
      if [ ! -e "${target_folder}/${folder_path}" ];then
        mkdir -p "${target_folder}/${folder_path}"
      fi
    fi
    cp -rf /raid/data/tmp/module/${source} /raid/data/module/$module_name/${target}	> /dev/null 2>&1
  fi
done

res='pass'

echo $res
