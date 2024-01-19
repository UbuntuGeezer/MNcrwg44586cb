#!/bin/bash
# ReloadMainDBs.sh  - Reload file(s) from archive of DB-Dev subdirectory.
# 8/16/23.	wmk.
#
#	Usage. bash ReloadMainDB <filelist> [-o] [-u mountname] [<statecountycongo>]
#
#		<filespec> = file to reload or pattern to reload
#		-o = (optional) overwrite existing file(s) when reloading
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional) = mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr*
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Territories/MainDBs.n.tar - incremental dump of ./DB-Dev folder
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/log/MainDBs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/MainDBslevel.txt - current level of incremental DB-Dev
#	  archive files.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.	
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.	wmk.	comments tidied; *pathbase corrected.
# Legacy mods.
# 5/2/22.	wmk.	original code.
#
# Notes. ReloadMainDB.sh performs a *tar* reload of the
# DB-Dev subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/MainDBs.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
P1=$1			# filespec
P2=${2,,}		# -u
P3=$3			# mount-name
P4=${4^^}		# congterr
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ReloadMainDB <filespec> -u|-ou|-uo <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" == "!" ];then
 isAll=1
else
 isAll=0
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadMainDB <filespec> -u <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  exit 1
fi
if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadMainDBs <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
fi
if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadMainDB abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadMainDBs abandoned, drive not mounted."
    exit 0
   fi
   if ! test -d $U_DISK/$P3;then
    echo "$P3 still not mounted - ReloadMainDBs abandoned."q
   fi
   echo "  continuing with $P3 mounted..."
  else
   echo "  continuing with $P3 mounted..."
  fi
fi
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
echo "P4 = : $P4"
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
# exit 1
#fi
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "ReloadMainDB parameter tests complete"
#exit 0
# end debugging code.
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadMainDB $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadMainDB initiated."
else
  ~/sysprocs/LOGMSG "   ReloadMainDB $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadMainDB initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P3/$P4
basic=MainDBs
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
 if ! test -f $dump_path/log/$congterr$basic.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  exit 1
 fi
# cat ./log/$congterr$basic$nextlevel.txt
 awk '{$1--; print $0}' $dump_path/log/$congterr$basic$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
 echo "Reloading from $P4$basic.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $basic.$REPLY.tar."
   pushd ./ > /dev/null
   cd $pathbase
   if [ $isAll -ne 0 ];then
    tar --extract --wildcards \
     $writeover \
    --file=$dump_path/$P4$basic.$REPLY.tar \
    DB-Dev
   else
    tar --extract --wildcards \
     $writeover \
    --file=$dump_path/$P4$basic.$REPLY.tar \
    DB-Dev/$P1
   fi
   popd > /dev/null
  done < $file
exit 0
# end ReloadMainDBs.sh
