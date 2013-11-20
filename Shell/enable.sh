#!/bin/sh
res='fail'
module_name=$1
module_enable=$2
opath=`pwd`
if [ "${module_enable}" == "No" ];then
	cd /raid/data/module/cfg/
	/raid/data/module/cfg/module.rc/"$module_name.rc" start "${module_name}"
	if [ $? -eq 0 ];then
		res='pass'
	fi
elif [ "${module_enable}" == "Yes" ];then
	cd /raid/data/module/cfg/
	/raid/data/module/cfg/module.rc/"$module_name.rc" stop "${module_name}"
	if [ $? -eq 0 ];then
		res='pass'
	fi
fi
cd $opath
echo $res
