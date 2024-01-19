#!/bin/bash
# IncDumpRURaw.sh  - Incremental archive of RawData/RefUSA subdirectories.
# 8/15/23.	wmk.
#
#	Usage. bash IncDumpRURaw.sh <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataRU.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawDataRU.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 8/15/23.	wmk.	adpated for MN/CRWG/44586.
# Legacy mods.
# 12/17/22.	wmk.	jumpto references removed.
# 3/27/23.	wmk.	verify dump prompt added.
# 4/9/23.	wmk.	verify complete message added.
# 4/24/23.	wmk.	verify complete message added to level-0 dump sequence.
# Legacy mods.
# 9/4/22.	wmk.	bug fix unquoted echo in drive mount tests.
# 9/2/22.	wmk.	-u, <mount-name> support.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 4/26/22.	wmk.	P1 prefix in archname (level-1) removed.
# 5/5/22.	wmk.	residual P1 cleared from dump path.
# 5/6/22.	wmk.	newlevel *congterr* fixed in level-1.
# Legacy mods.
# 9/8/21.	wmk.	original shell; adapted from IncDumpRawDataRU.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpRURaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file $pathbase/log/RawDataRU.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartRawDataRU.sh is provided to
# reset the RawData dump information so that the next IncDumpRURaw
# run will produce the level-0 (full) dump.
# The file $pathbase/log/RawDataRU.snar is created as the listed-incremental archive
# information. The file $pathbase/log/RawRUlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpRURaw calls. The initial archive file is named
# archive.0.tar.
# If the $pathbase/log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawDataRU.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
# function definition
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=$5		# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpRURaw <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "IncDumpRURaw <state> <county> <congno> [-u <mount-name>] $P4 unrecognized - abandoned."
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpRURaw abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpRURaw abandoned."
    exit 1
   else
    echo "continuing with $P5 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
else
 echo "continuing with $P5 mounted..."
fi  #end drive not mounted
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpRURaw abandoned **"
 exit 1
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpRURaw initiated from Make."
  echo "   IncDumpRURaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpRURaw initiated from Terminal."
  echo "   IncDumpRURaw initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
level=level
nextlevel=nextlevel
newlevel=newlevel
rawdataru=RawDataRU
# if $dump_path/log does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$rawdataru$level.txt;then
  # initial archive
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  archname=$congterr$rawdataru.0.tar
  echo $archname
  echo "0" > $dump_path/log/$congterr$rawdataru$level.txt
  echo "1" > $dump_path/log/$congterr$rawdataru$nextlevel.txt
  pushd ./ > /dev/null
  cd $pathbase
   tar --create \
	  --listed-incremental=$dump_path/log/$congterr$rawdataru.snar-0 \
	  --file=$dump_path/$archname \
	  RawData/RefUSA
  popd > /dev/null
  ~/sysprocs/LOGMSG "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   echo "  $archname verify complete."
  fi
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=$congterr$rawdataru.snar-$REPLY
# done < $file
  oldsnar=$congterr$rawdataru.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$rawdataru$nextlevel.txt > $dump_path/log/$congterr$rawdataru$newlevel.txt
 file=$dump_path/log/$congterr$rawdataru$nextlevel.txt
 while read -e;do
  export archname=$congterr$rawdataru.$REPLY.tar
  export snarname=$oldsnar
# snarname=RawDataRU.snar-$REPLY
# cp $dump_path/log/$oldsnar $dump_path/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
  pushd ./ > /dev/null
  cd $pathbase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	RawData/RefUSA
  popd > /dev/null
done < $file
cp $dump_path/log/$congterr$rawdataru$newlevel.txt \
 $dump_path/log/$congterr$rawdataru$nextlevel.txt
#
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
 echo "  $archname verify complete."
fi
# end IncDumpRURaw
