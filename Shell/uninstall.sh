#!/bin/sh

res='fail'
module_name=$1
. /raid/data/module/${module_name}/sys/lib/libsys
/raid/data/module/cfg/module.rc/"$module_name.rc" stop

/usr/bin/sqlite /raid/data/module/cfg/module.db "delete from module where name = '$module_name'"
/usr/bin/sqlite /raid/data/module/cfg/module.db "delete from mod where module = '$module_name'"

cd /raid/data/module/cfg/

#remove module apache configuration from apache.conf
for i in httpd.disable ssl.disable
do
	apache_start=`grep ^#$mod_name\ start -n $i|cut -d ':' -f1`
	apache_end=`grep ^#$mod_name\ end -n $i|cut -d ':' -f1`
	apache_total=`cat $i|wc -l`
	if [ "$apache_start" != "" ] && [ "$apache_end" != "" ]; then
		head -n $(($apache_start-1)) $i > front.conf
		tail -n $(($apache_total-$apache_end)) $i > back.conf
		cat back.conf >> front.conf
		mv front.conf $i
		rm back.conf
	fi
done

cd -
set_msg_log "$module_name" "unistall for message"
set_event "$module_name" "1002" "info" "no" 
rm -rf "/raid/data/module/cfg/module.rc/$module_name.rc"
rm -rf "/raid/data/module/$module_name"
rm -f "/tmp/modules/$module_name"

res='pass'

echo $res
