#!/bin/bash
# ReloadTestBase.sh  - Reload file(s) from archive of TestBase subdirectories.
# 8/9/22.	wmk.
#
#	Usage. bash ReloadTestBase <filelist> [-o | [-ou |-u mountname]]
#
#		<filespec> = file to reload or pattern to reload
#		-o = (optional) overwrite existing file(s) when reloading
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional) = mount name for flashdrive
# Note: ??<statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Territories/TerrData.n.tar - incremental dump of ./RawData/SCPA folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/TerrData/log/TerrData.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/TerrDatalevel.txt - current level of incremental TerrData 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/8/22.	wmk.	original code; adapted from ReloadTerrData.
# 8/9/22.	wmk.	*arch_path introduced for specifying full path for reload
#			 file extraction.
# Legacy mods.
# 6/21/22.	wmk.	original code; adapted from ReloadGeany.
# 7/31/22.	wmk.	! support for full reload (see notes).
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
# ReloadTestBase.sh performs a *tar* reload of the
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
P2=${2^^}	# state*county*congno (subsystem)
P3=${3^^}	# -o overwrite -u flashdrive -ou both
P4=$4		# flashdrive mount name
if [ "$P1" == "!" ];then
 isAll=1
fi
#echo $isAll
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "ReloadTestBase <filespec> <state><county><congno> [-u|-ou|-uo <mountname>] missing parameter(s) - abandoned."
 exit 1
fi
# if P3 is present, P4 must also.
if  [ ! -z "$P3" ];then
 if [ "$P3" != "-O" ] &&[ "$P3" != "-OU" ] && [ "$P3" != "-U" ];then
  echo "ReloadTestBase <filespec> <state><county><congo> [-u <mountname>] unrecognized option $3 - abandoned."
  exit 1
 fi
fi
#
if  [ ! -z "$P3" ];then
 if [ "${P3:1:1}" == "U" ] || [ "${P3:2:1}" == "U" ] ;then
  if ! test -d $U_DISK/$P4;then
   echo "** $P4 not mounted - mount $P4..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadTestBase abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  ReloadTestBase abandoned, drive not mounted."
    exit 0
   fi
   if ! test -d $U_DISK/$P4;then
    echo "** $P4 still not mounted - ReloadTestBase abandoned."
    exit 1
   fi  
  fi
 fi
fi
#
if [ "${P3:1:1}" == "O" ] || [ "${P3:2:1}" == "O" ] ;then
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
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
echo "parameter tests complete."
#exit
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - ReloadTestBase abandoned **"
# exit 1
#fi
# debugging code...
echo "P1 = : $P1"	# filespec
echo "P2 = : $P2"	# subsystem
echo "P3 = : $P3"	# -u -o -uo
echo "P4 = : $P4"	# mount name
echo "isAll = $isAll"
echo "ReloadTestBase parameter tests complete"
#exit 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadTestBase $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadTestBase initiated."
else
  ~/sysprocs/LOGMSG "   ReloadTestBase $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadTestBase initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ ! -z "$P3" ];then
 dump_path=$U_DISK/$P4/$P2
else
 dump_path=$pathbase/$P2
fi
arch_path=${pathbase:1:50}
cd $dump_path
terrdata=TestBase
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if [ -z "$congterr" ];then
 if ! test -f $dump_path/log/$P2$terrdata.snar-0;then
  echo "** cannot locate $P2$terrdata.snar-0.. abandoned."
  exit 1
 fi
else
 if ! test -f $dump_path/log/$P2$terrdata.snar-0;then
  echo "** cannot locate $P2$terrdata.snar-0.. abandoned."
  exit 1
 fi
fi
# cat ./log/$congterr$terrdata$nextlevel.txt
 awk '{$1--; print $0}' ./log/$P2$terrdata$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
 #if [ -z "$P3" ];then
  echo "Reloading from $P2$terrdata.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $terrdata.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    tar --extract \
    --file=$dump_path/$P2$terrdata.$REPLY.tar \
    --wildcards  \
     $writeover --\
   $arch_path/TestBase/$P1
  else
    tar --extract \
    --file=$dump_path/$P2$terrdata.$REPLY.tar \
    --wildcards  \
     $writeover \
   $arch_path/TestBase
  fi
  done < $file
 #else
 # echo "Reloading from $dump_path/$P2$terrdata.*.tar incremental dumps..."
 # while read -e;do
 #  echo " Processing $dump_path/$P2$terrdata.$REPLY.tar."
 #  if [ $isAll -eq 0 ];then
 #   tar --extract \
 #   --file=$dump_path/$P2$terrdata.$REPLY.tar \
 #   --wildcards \
 #    $writeover --\
 #   home/vncwmk3/Territories/FL/SARA/86777/TestBase/$P1
 # else
 #   tar --extract \
 #   --file=$dump_path/$P2$terrdata.$REPLY.tar \
 #   --wildcards \
 #    $writeover \
 #   home/vncwmk3/Territories/FL/SARA/86777/TestBase
 # fi
 # done < $file
 #fi
echo "  ReloadTestBase $P1 $P2 $P3 $P4 complete."
exit 0
# end ReloadTestBase.sh
