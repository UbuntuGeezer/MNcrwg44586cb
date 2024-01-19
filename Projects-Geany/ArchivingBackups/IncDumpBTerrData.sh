#!/bin/bash
# IncDumpBTerrData.sh  - Incremental archive of TerrData subdirectories.
# 5/11/22.	wmk.
#
#	Usage. bash IncDumpBTerrData
#
# Dependencies.
#	~/Territories/TerrData - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/TerrData.n.tar - incremental dump of ./TerrData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/TerrData/log/TerrData.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/TDlevel.txt - current level of incremental TerrData 
#	  archive files.
#
# Modification History.
# ---------------------
# 5/11/22.	wmk.	original code; adapted from IncDumpTerrData.
#
# Notes. IncDumpBTerrData.sh performs an incremental archive (tar) of the
# BTerrData subdirectories. If the folder $pathbase/log does not exist under
# *pathbase*, it is created and a level-0 incremental dump is performed.
# A shell utility RestartBTerrData.sh is provided to reset the BTerrData dump
# information so that the next IncDumpBTerrData run will produce the level-0
# (full) dump.
# The file $pathbase/log/*congterr*BTerrData.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpBTerrData calls. The initial archive file is named
# TerrData.0.tar.
# If the $pathbase/log folder exists under TerrData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named TerrData.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/TDlevel.txt. tar will be
# invoked with this new TerrData.snar-n file as the "listed-incremental"
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
 echo "IncDumpBTerrData <state> <county> <congno> missing parameter(s) - abandoned."
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
  bash ~/sysprocs/LOGMSG "   IncDumpBTerrData initiated from Make."
  echo "   IncDumpBTerrData initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpBTerrData initiated from Terminal."
  echo "   IncDumpBTerrData initiated."
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
level=level
nextlevel=nextlevel
newlevel=newlevel
td=BTerrData
# if $pathbase/log/TerrData.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $pathbase/log/$congterr$td.snar-0;then
  # initial archive 
 if ! test -d $pathbase./log;then
  mkdir log
 fi
  archname=$congterr$td.0.tar
  echo $archname
  echo "0" > $pathbase/log/$congterr$td$level.txt
  echo "1" > $pathbase/log/$congterr$td$nextlevel.txt
  archive=$congterr$td.0.tar
  echo $archive
  tar --create \
	  --listed-incremental=$pathbase/log/$congterr$td.snar-0 \
	  --file=$pathbase/$congterr$td.0.tar \
	  BTerrData
  if [ "$USER" != "vncwmk3" ];then
   notify-send "IncDumpBTerrData" " $P1 $P2 $P3 complete."
  fi
  ~/sysprocs/LOGMSG "  IncDumpBTerrData $P1 $P2 $P3 complete."
  echo "  IncDumpBTerrData $P1 $P2 $P3 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=TerrData.snar-$REPLY
# done < $file
  oldsnar=$congterr$td.snar-0
 awk '{$1++; print $0}' $pathbase/log/$congterr$td$nextlevel.txt > $pathbase/log/$congterr$td$newlevel.txt
 file=$pathbase/log/$congterr$td$nextlevel.txt
 while read -e;do
  export archname=$congterr$td.$REPLY.tar
  export snarname=$oldsnar
# snarname=$td.snar-$REPLY
# cp $pathbase/log/$oldsnar $pathbase/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 tar --create \
	--listed-incremental=$pathbase/log/$snarname \
	--file=$pathbase/$archname \
	BTerrData
done < $file
cp $pathbase/log/$congterr$td$newlevel.txt $pathbase/log/$congterr$td$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  IncDumpBTerrData $P1 $P2 $P3 complete."
echo "  IncDumpBTerrData $P1 $P2 $p3 complete"
# end IncDumpBTerrData
