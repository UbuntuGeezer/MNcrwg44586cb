#!/bin/bash
# IncDumpBizRaw.sh  - Incremental archive of BRawData/BRefUSA subdirectories.
# 4/23/22.	wmk.
#
#	Usage. bash IncDumpBizRaw.sh [drive-spec]
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataBiz.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawDataBiz.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for generaly use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# Legacy mods.
# 9/25/21.	wmk.	original shell; adapted from IncDumpRawDataBiz.
# 11/24/21	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpBizRaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file ./log/RawDataBiz.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartRawDataBiz.sh is provided to
# reset the RawData dump information so that the next IncDumpBizRaw
# run will produce the level-0 (full) dump.
# The file ./log/RawDataBiz.snar is created as the listed-incremental archive
# information. The file ./log/RawBizlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpBizRaw calls. The initial archive file is named
# archive.0.tar.
# If the ./log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawDataBiz.snar-n, where n is the
# next level # obtained by incrementing ./log/level.txt. tar will be
# invoked with this new RawDataBiz.snar-n file as the "listed-incremental"
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
 echo "IncDumpBizRaw <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$foldergbase" ];then
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
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpBizRaw initiated from Make."
  echo "   IncDumpBizRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpBizRaw initiated from Terminal."
  echo "   IncDumpBizRaw initiated."
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
# if ./log does not exist, initialize and perform level 0 tar.
if ! test -f ./log/RawBizlevel.txt;then
  # initial archive
 if ! test -d ./log;then
  mkdir log
 fi
  echo "0" > ./log/RawBizlevel.txt
  echo "1" > ./log/RawBiznextlevel.txt
  if [ -z "$P1" ];then
   tar --create \
	  --listed-incremental=./log/RawDataBiz.snar-0 \
	  --file=RawDataBiz.0.tar \
	  BRawData/BRefUSA
  else
   tar --create \
	  --listed-incremental=./log/RawDataBiz.snar-0 \
	  --file=$P1/RawDataBiz.0.tar \
	  BRawData/BRefUSA
  fi
  if [ "$USER" != "vncwmk3" ];then
   notify-send "IncDumpBizRaw" " $P1 complete."
  fi
  ~/sysprocs/LOGMSG "  IncDumpBizRaw $P1 complete."
  echo "  IncDumpBizRaw $P1 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=RawDataBiz.snar-$REPLY
# done < $file
  oldsnar=RawDataBiz.snar-0
 awk '{$1++; print $0}' ./log/RawBiznextlevel.txt > ./log/RawBiznewlevel.txt
 file='./log/RawBiznextlevel.txt'
 while read -e;do
  export archname=RawDataBiz.$REPLY.tar
  export snarname=$oldsnar
# snarname=RawDataBiz.snar-$REPLY
# cp ./log/$oldsnar ./log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 if [ -z "$P1" ];then
  tar --create \
	--listed-incremental=./log/$snarname \
	--file=$archname \
	BRawData/BRefUSA
 else
  tar --create \
	--listed-incremental=./log/$snarname \
	--file=$P1/$archname \
	BRawData/BRefUSA
 fi
done < $file
cp ./log/RawBiznewlevel.txt ./log/RawBiznextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "IncDumpBizRaw" " $P1 complete."
fi
~/sysprocs/LOGMSG "  IncDumpBizRaw $P1 complete."
echo "  IncDumpBizRaw $P1 complete"
# end IncDumpBizRaw
