#!/bin/bash
# IncDumpDoNotCalls.sh  - Incremental archive of DoNotCalls subdirectories.
# 4/25/22.	wmk.
#
#	Usage. bash IncDumpDoNotCalls
#
# Dependencies.
#	~/Territories/DoNotCalls - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/DoNotCalls.n.tar - incremental dump of ./DoNotCalls folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/DoNotCalls/log/DoNotCalls.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/DoNotCallslevel.txt - current level of incremental DoNotCalls 
#	  archive files.
#
# Modification History.
# ---------------------
# 4/23/22.	wmk.	original code;adapted from IncDumpTerrData;*congterr* env
#			 var used througout.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	bug fix P1 P2 P3 not being set;bug fix 's removed from
#		  file=';bug fix level missing $.
#
# Notes. IncDumpDoNotCalls.sh performs an incremental archive (tar) of the
# DoNotCalls subdirectories. If the folder $pathbase/log does not exist under
# DoNotCalls, it is created and a level-0 incremental dump is performed.
# A shell utility RestartDoNotCalls.sh is provided to reset the DoNotCalls dump
# information so that the next IncDumpDoNotCalls run will produce the level-0
# (full) dump.
# The file $pathbase/log/DoNotCalls.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpDoNotCalls calls. The initial archive file is named
# DoNotCalls.0.tar.
# If the $pathbase/log folder exists under DoNotCalls a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named DoNotCalls.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/$basiclevel.txt. tar will be
# invoked with this new DoNotCalls.snar-n file as the "listed-incremental"
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
P1=${1^^}
P2=${2^^}
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpDoNotCalls <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
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
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpDoNotCalls initiated from Make."
  echo "   IncDumpDoNotCalls initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpDoNotCalls initiated from Terminal."
  echo "   IncDumpDoNotCalls initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
basic=DoNotCalls
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $pathbase/log/DoNotCalls.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $pathbase/log/$congterr$basic.snar-0;then
  # initial archive 
 if ! test -d $pathbase/log;then
  mkdir log
 fi
  echo "0" > $pathbase/log/$congterr$basic$level.txt
  echo "1" > $pathbase/log/$congterr$basic$nextlevel.txt
  archname=$congterr$basic.0.tar
  echo $archname
  tar --create \
	  --listed-incremental=$pathbase/log/$congterr$basic.snar-0 \
	  --file=$congterr$basic.0.tar \
	  DoNotCalls
  if [ "$USER" != "vncwmk3" ];then
   notify-send "IncDumpDoNotCalls" " $P1 $P2 $P3complete."
  fi
  ~/sysprocs/LOGMSG "  IncDumpDoNotCalls $P1 $P2 $P3 complete."
  echo "  IncDumpDoNotCalls $P1 $P2 $P3 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=DoNotCalls.snar-$REPLY
# done < $file
  oldsnar=DoNotCalls.snar-0
 awk '{$1++; print $0}' $pathbase/log/$congterr$basic$nextlevel.txt > $pathbase/log/$congterr$basic$newlevel.txt
 file=$pathbase/log/$congterr$basic$nextlevel.txt
 while read -e;do
  export archname=$congterr$basic.$REPLY.tar
  export snarname=$oldsnar
# snarname=DoNotCalls.snar-$REPLY
# cp $pathbase/log/$oldsnar $pathbase/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 tar --create \
	--listed-incremental=$pathbase/log/$snarname \
	--file=$archname \
	DoNotCalls
done < $file
cp $pathbase/log/$congterr$basic$newlevel.txt $pathbase/log/$congterr$basic$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "IncDumpDoNotCalls" " $P1 $P2 $P3 complete."
fi
~/sysprocs/LOGMSG "  IncDumpDoNotCalls $P1 $P2 $P3 complete."
echo "  IncDumpDoNotCalls $P1 complete"
# end IncDumpDoNotCalls
