#!/bin/bash
for D in /opt/*;do
  if [ -d "${D}" -a -f "${D}/shell/module.rc" ];then
    module=`echo ${D}|cut -f3 -d'/'`;
    usage=`"${D}/shell/module.rc" | cut -f2 -d'{' | cut -f1 -d'}' | sed 's/ //g'`
    #status="";
    #if [[ "${usage}" =~ "status" ]];then
    #  status=`${D}/shell/module.rc status`
    #fi
    echo -e "${module}\t${D}\t${usage}";
  fi
done
