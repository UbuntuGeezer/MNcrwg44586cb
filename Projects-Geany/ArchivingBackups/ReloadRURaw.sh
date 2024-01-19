#!/bin/bash
# ReloadRURaw.sh  - Reload file(s) from archive of RURaw subdirectories.
# 8/15/23.	wmk.
#
#	Usage. bash ReloadRURaw <filelist> [-o] [-u mountname] [<statecountycongo>]
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
#	/Territories/RawDataRU.n.tar - incremental dump of ./RawData/RefUSA folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawDataRU/log/RawDataRU.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/RawDataRUlevel.txt - current level of incremental RawDataRU 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/15/23.	wmk.	adapted for MN/CRWG/44586.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/25/22.	wmk.	modified for CB use from previous original.
# 3/14/23.	wmk.	bug fix if 'o' specified as 'uo'.
# Legacy mods.
# 6/12/22.	wmk.	original code; adapted from ReloadGeany.
# 7/31/22.	wmk.	! support for full reload (see notes).
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadRURaw.sh performs a *tar* reload of the
# RawDataRU subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# RawDataRU, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/RawDataRU.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1.
# P1=<filespec>, P2=-u, P3=<mount-name>, P4=<state><county><congno>. 
isAll=0
P1=$1		# filespec
P2=${2,,}		# -o overwrite
P3=$3		# flashdrive mount name
P4=${4^^}	# state*county*congno
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ReloadRURaw <filespec> -u|-ou|-uo <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" == "!" ];then
 isAll=1
fi
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadRURaw <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  exit 1
fi
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadRURaw <filespec> -u <mountname> [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadRURaw abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  ReloadRURaw abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
  fi
 fi
if [ "${P2:3:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
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
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
echo "P4 = : $P4"
if [ "$P4" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - ReloadRURaw abandoned **"
 exit 1
fi
# debugging code...
echo "P1 = : $P1"
echo "P2 = : $P2"
echo "P3 = : $P3"
echo "isAll = $isAll"
echo "P4 = : $P4"
echo "ReloadRURaw parameter tests complete"
#exit 0
# end debugging code.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadRURaw $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadRURaw initiated."
else
  ~/sysprocs/LOGMSG "   ReloadRURaw $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadRURaw initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P3/$P4
arch_path=${pathbase:1:50}
cd $dump_path
rawdataru=RawDataRU
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if ! test -f $dump_path/log/$P4$rawdataru.snar-0;then
  echo "** cannot locate $P4$rawdataru.snar-0.. abandoned."
  exit 1
fi
# cat ./log/$P4$rawdataru$nextlevel.txt
awk '{$1--; print $0}' $dump_path/log/$P4$rawdataru$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
file=$TEMP_PATH/LastTarLevel.txt
while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
done < $file
seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
echo "Reloading from $P4$rawdataru.*.tar incremental dumps..."
pushd ./ > /dev/null
cd $pathbase
  while read -e;do
   echo " Processing $rawdataru.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    tar --extract \
    --file=$dump_path/$P4$rawdataru.$REPLY.tar \
    --wildcards  \
    $writeover \
    RawData/RefUSA/RefUSA-Downloads/$P1
  else
    tar --extract \
    --file=$dump_path/$P4$rawdataru.$REPLY.tar \
    --wildcards  \
    $writeover \
    RawData/RefUSA/RefUSA-Downloads
  fi
  done < $file
popd > /dev/null
exit 0
# end ReloadRURaw.sh
