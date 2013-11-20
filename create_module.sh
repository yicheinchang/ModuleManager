#!/bin/bash
now_path=`pwd`
binary_path="${now_path}/Binary"
module_name=`echo $now_path | awk -F'\/' '{print $NF}'`
org_name="${now_path}/Source"
module_path="${now_path}/${module_name}"
conf_file="${now_path}/install.conf"
module_conf="${now_path}/System/conf/module.conf"

. "${conf_file}"

function set_global_item(){
  global_item="Name Version Description Key Authors Thanks WebUrl UpdateUrl Reboot HomePage MacStart MacEnd Show Publish Login Icon"

  echo '<?xml version="1.0"?>'
  echo '<rdf:RDF xmlns:md="http://localhost/module/schema#"
         	  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
   	     <md:Install>
   	       <md:ModuleRDF>Install</md:ModuleRDF>
   	       <md:ModuleRDFVer>1.0.0</md:ModuleRDFVer>'
  for item in ${global_item}
  do
    var="\$Module${item}"
    val=`eval "echo $var"`
    if [ "$item" != "Thanks" ] && [ "$item" != "Description" ];then
    	echo "    <md:${item}>${val}</md:${item}>"
    elif [ "$item" == "Thanks" ];then
      echo "    <md:${item}>${ModuleRef}</md:$item>"
    else
      echo "    <md:${item}>${ModuleDesp}</md:$item>"
    fi
  done
  
  echo '    <md:Mode>User</md:Mode>'
  echo '    <md:UI>User</md:UI>'
  echo '  </md:Install>'
}

function set_nas_item(){
  nas_item="TargetNas NasProtol NasVersion"
  
  count=${#ModuleNasProtol[@]}
  
  for ((i=0;i<$count;i++))
  do
    if [ "$ModuleNasProtol[$i]" != "" ];then
      echo '<md:NAS>'
      for item in ${nas_item}
      do
        var="\${Module${item}[$i]}"
        val=`eval "echo $var"`
        echo "  <md:${item}>${val}</md:${item}>"
      done  
      echo '</md:NAS>'
    fi
  done

}

function set_depend_item(){
  depend_item="DependName DependVer DependUrl"
  count=${#ModuleDependName[@]}
  
  for ((i=0;i<$count;i++))
  do
    if [ "$ModuleDependName[$i]" != "" ];then
      echo '<md:DependCom>'
      for item in ${depend_item}
      do
        var="\${Module${item}[$i]}"
        val=`eval "echo $var"`
        echo "  <md:${item}>${val}</md:${item}>"
      done  
      echo '</md:DependCom>'
    fi
  done
}

function set_rdf_file(){
  rdf_file="${module_path}/Configure/install.rdf"  
  set_global_item > $rdf_file
  set_nas_item >> $rdf_file
  set_depend_item >> $rdf_file
}

function mk_module(){
  target_path="${now_path}/target"
  if [ "${ModuleVersion}" == "" ];then
    ModuleVersion="1.0.0"
  fi
  target_file="${target_path}/${module_name}_${ModuleVersion}.mod"

  if [ ! -d "$target_path" ];
  then
    mkdir "$target_path"
  fi
  
  cd ${now_path}
 
  tar="tar"
  where=`which ${tar}`  
  if [ "$where" == "" ];then
    tar="${binary_path}/tar" 
  fi  
  $tar  zcfp "$target_file" ./$module_name
  
  md5sum="md5sum"
  where=`which md5sum`  
  if [ "$where" == "" ];then
    md5sum="${binary_path}/md5sum" 
  fi
  ${md5sum} "$target_file" > "${target_file}.sum"
}

function copy_source(){
  source_path="${module_path}"
  if [ ! -e "${source_path}" ];then
     mkdir -p ${source_path}
  else
    rm -rf ${source_path}/*
  fi
  cp -rd "${now_path}/Binary" "${source_path}/"
  cp -rd "${now_path}/Shell" "${source_path}/"
  cp -rd "${now_path}/Configure" "${source_path}/"
  cp -rd "${now_path}/WWW" "${source_path}/"
  cp -rd "${now_path}/Driver" "${source_path}/"
  cp -rd "${now_path}/System" "${source_path}/"
  cp -rd "${now_path}/Thecus" "${source_path}/"

}

function check_folder_type(){
  ret=`echo "${ModuleKey}" |  awk '/[^a-zA-Z0-9_]/{print $0}'`
  if [ "$ret" != "" ];then
     echo "ModuleFolder value is must a~0 A~Z 0~9 _"
     exit
  fi
}

if [ -f "${conf_file}" ];then
  check_folder_type
  echo "module_name='$ModuleKey'" > ${module_conf}
  copy_source
  set_rdf_file
  mk_module
else
  echo "Please create install.conf"
fi
if [ -e "${org_name}" ];then
  rm -rf "${org_name}"
fi
mv ${module_path} ${org_name} 
