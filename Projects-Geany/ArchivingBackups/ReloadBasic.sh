#!/bin/bash
# Note. remove /bin/bash line if this code is placed in functions in CBArchiving.sh.
# ReloadBasic.sh  - Reload file(s) from archive of Basic subdirectories.
# 8/16/23.	wmk.
#
# Usage. bash ReloadBasic <filelist> [-o] [-u mountname] [<statecountycongo>]
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
#	/Territories/Basic.n.tar - incremental dump of ./Basic folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/Basic/log/Basic.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/Basiclevel.txt - current level of incremental Basic 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 9/20/22.	wmk.	modified for Chromebook.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support for CB; *U_DISK env var definition
#			 ensured; comments tidied.
# Legacy mods.
# 5/2/22.	wmk.	original code.
# 7/31/22.	wmk.	! support for full reload (see notes).
# 9/20/22.	wmk.	-u, <mountname> support.
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadBasic.sh performs a *tar* reload of the
# Basic subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# Basic, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Basic.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
P1=$1
P2=${2,,}
P3=$3
P4=${4^^}
if [ -z "$P1" ] || [ -z "$P2" ]|| [ -z "$P3" ];then
 echo "ReloadBasic <filespec> -u|-ou|-uo <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
isAll=0
if [ "$P1" == "!" ];then
 isAll=1
fi
if [ -z "$P4" ];then
 P4=$congterr
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadBasic <filespec> -u <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  exit 1
fi
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadBasic <filespec> -u <mountname> [<state><county><congo>] unrecognized '-' option - abandoned."
fi
if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadBasic abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadBasic abandoned, drive not mounted."
    exit 0
   fi
   if ! test -d $U_DISK/$P3;then
    echo "  $P3 still not mounted - ReloadBasic abandoned."
    exit 1
   fi
   echo "  continuing with $P3 mounted..."
else
 echo "  continuing with $P3 mounted..."
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
#echo "isAll = $isAll"
#echo "ReloadBasic parameter tests complete"
#exit 0
# end debugging code.
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadBasic $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadBasic initiated."
else
  ~/sysprocs/LOGMSG "   ReloadBasic $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadBasic initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P3/$P4
gitpath=/home/vncwmk3/GitHub/Libraries-Project/MNcrwg44586
basic=Basic
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if ! test -f $dump_path/log/$congterr$basic.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  exit 1
fi
mawk '{$1--; print $0}' $dump_path/log/$congterr$basic$nextlevel.txt \
  > $TEMP_PATH/LastTarLevel.txt
file=$TEMP_PATH/LastTarLevel.txt
while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
done < $file
seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
file=$TEMP_PATH/TarLevelList.txt
echo "Reloading from $P4$basic.*.tar incremental dumps..."
# loop on .tar files.
while read -e;do
  pushd ./ > /dev/null
  cd $gitpath
  echo " Processing $basic.$REPLY.tar."
  if [ $isAll -ne 0 ];then
    tar --extract --wildcards \
     $writeover \
     --file=$dump_path/$P4$basic.$REPLY.tar \
     Basic
  else
    tar --extract --wildcards \
     $writeover \
     --file=$dump_path/$P4$basic.$REPLY.tar \
     Basic/$P1
  fi
  popd > /dev/null
done < $file
if [ ! -z "${DIRSTACK[1]}" ];then popd > /dev/null;fi
exit 0
# end ReloadBasic.sh
