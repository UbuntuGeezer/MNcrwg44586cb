#!/bin/bash
# IncDumpSCRaw.sh  - Incremental archive of RawData subdirectories.
# 5/4/23.	wmk.
#
#	Usage. bash IncDumpSCRaw.sh <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/RawData/SCPA - base directory for Terrxxx folders with
#	  SCPA raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataSC.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawDataSC.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 4/30/22.	wmk.	superfluous P1 removed from file = (tar).
# 9/2/22.	wmk.	-u, <mount-name> support.
# 3/27/23.	wmk.	verify dump prompt added.
# 4/9/23.	wmk.	verify complete message added.
# 5/4/23.	wmk.	bug fix in "continuing message misplaced quotes.
# Legacy mods.
# 9/8/21.	wmk.	original shell; adapted from IncDumpRawDataSC.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpSCRaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file $pathbase/log/RawDataSC.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartRawDataSC.sh is provided to
# reset the RawData dump information so that the next IncDumpSCRaw
# run will produce the level-0 (full) dump.
# The file $pathbase/log/RawDataSC.snar is created as the listed-incremental archive
# information. The file $pathbase/log/RawSClevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpSCRaw calls. The initial archive file is named
# archive.0.tar.
# If the $pathbase/log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawDataSC.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataSC.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
# function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=$5		# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpSCRaw <state> <county> <congno> [-u <mount-name>] missing parameter(s) - abandoned."
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ -z "$P5" ];then
  echo "IncDumpSCRaw <state> <county> <congno> [-u <mount-name>] missing <mount-name> - abandoned."
  exit 1
 fi
 if [ "$P4" != "-U" ];then
  echo "IncDumpSCRaw <state> <county> <congno> [-u <mount-name>] $P4 unrecognized - abandoned."
  exit 1
 fi
 if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpSCRaw abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpSCRaw abandoned."
    exit 1
   else
   echo "continuing with $P5 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
 fi  #end drive not mounted
fi  #end nonempty P4
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
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpSCRaw abandoned **"
 exit 1
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpSCRaw initiated from Make."
  echo "   IncDumpSCRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpSCRaw initiated from Terminal."
  echo "   IncDumpSCRaw initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P5" ];then
 dump_path=$pathbase
else
 dump_path=$U_DISK/$P5/$congterr
fi
cd $dump_path
level=level
nextlevel=nextlevel
newlevel=newlevel
rawsc=RawDataSC
#  if $dump_path/log does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$rawsc$level.txt;then
  # initial archive
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  archname=$congterr$rawsc.0.tar
  echo $archname
  echo "0" > $dump_path/log/$congterr$rawsc$level.txt
  echo "1" > $dump_path/log/$congterr$rawsc$nextlevel.txt
  archname=$congterr$rawsc.0.tar
  echo $archive
  pushd ./
  cd $pathbase
   tar --create \
	  --listed-incremental=$dump_path/log/$congterr$rawsc.snar-0 \
	  --file=$dump_path/$archname \
	  RawData/SCPA
  popd
  ~/sysprocs/LOGMSG "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
  fi
  echo "  $archname verify complete."
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=RawDataSC.snar-$REPLY
# done < $file
  oldsnar=$congterr$rawsc.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$rawsc$nextlevel.txt \
  > $dump_path/log/$congterr$rawsc$newlevel.txt
 file=$dump_path/log/$congterr$rawsc$nextlevel.txt
 while read -e;do
  export archname=$congterr$rawsc.$REPLY.tar
  export snarname=$oldsnar
# snarname=RawDataSC.snar-$REPLY
# cp $dump_path/log/$oldsnar $dump_path/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
  pushd ./
  cd $pathbase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	RawData/SCPA
 popd
done < $file
cp $dump_path/log/$congterr$rawsc$newlevel.txt $dump_path/log/$congterr$rawsc$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
 echo "  $archname verify complete."
fi
# end IncDumpSCRaw
