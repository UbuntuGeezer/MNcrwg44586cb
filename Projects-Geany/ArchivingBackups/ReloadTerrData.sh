#!/bin/bash
# ReloadTerrData.sh  - Reload file(s) to CB from archive of TerrData subdirectories.
# 8/15/23.	wmk.
#
#	Usage. bash ReloadTerrData <filelist> [-o] [-u mountname] [<statecountycongo>]
#
#		<filespec> = file to reload or pattern to reload
#			e.g. Terrxxx
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
# Exit. ~/Territories/TerrData/<filespec>
#
# Modification History.
# ---------------------
# 8/15/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 9/25/22.	wmk.	original code; adapted from HP version.
# Legacy mods.
# 6/21/22.	wmk.	original code; adapted from ReloadGeany.
# 7/31/22.	wmk.	! support for full reload (see notes).
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
# ReloadTerrData.sh performs a *tar* reload of the
# TerrData subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# TerrData, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/TerrData.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
isAll=0
P1=$1		# filespec
P2=${2,,}	# -o overwrite
P3=$3		# flashdrive mount name
P4=${4^^}	# *state*county*congno
if [ "$P1" == "!" ];then
 isAll=1
fi
#echo $isAll
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ReloadTerrData <filespec> -u|-ou|-uo <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadTerrData <filespec> -u <mountname> [<state><county><congo>] unrecognized '-' option - abandoned."
  exit 1
fi
if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadTerrData abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadTerrData abandoned, drive not mounted."
    exit 0
   fi
  fi
fi
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$HOME/GitHub/TerritoriesCB/MNcrwg44586
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
# echo "** $P1$P2$P3 mismatch with *congterr* - ReloadTerrData abandoned **"
# exit 1
#fi
# debugging code...
echo "P1 = : $P1"
echo "P2 = : $P2"
echo "P3 = : $P3"
echo "P4 = : $P4"
echo "isAll = $isAll"
echo "ReloadTerrData parameter tests complete"
#exit 0
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadTerrData $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadTerrData initiated."
else
  ~/sysprocs/LOGMSG "   ReloadTerrData $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadTerrData initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ >  /dev/null
dump_path=$U_DISK/$P3/$P4
arch_path=${pathbase:1:50}
cd $dump_path
terrdata=TerrData
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
 if ! test -f $dump_path/log/$P4$terrdata.snar-0;then
  echo "** cannot locate $congterr$terrdata.snar-0.. abandoned."
  exit 1
 fi
# cat ./log/$congterr$terrdata$nextlevel.txt
 awk '{$1--; print $0}' $dump_path/log/$P4$terrdata$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
  echo "Reloading from $dump_path/$P4$terrdata.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $terrdata.$REPLY.tar."
   pushd ./ > /dev/null
   cd $pathbase
   if [ $isAll -eq 0 ];then
    tar --extract \
    --file=$dump_path/$P4$terrdata.$REPLY.tar \
    --wildcards  \
     $writeover \
   TerrData/$P1
   else
    tar --extract \
    --file=$dump_path/$P4$terrdata.$REPLY.tar \
    --wildcards  \
     $writeover \
   TerrData
   fi
   popd > /dev/null
  done < $file
exit 0
# end ReloadTerrData.sh
