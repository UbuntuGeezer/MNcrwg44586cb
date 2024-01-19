#!/bin/bash
# IncDumpHCRaw.sh  - Incremental archive of RawData subdirectories.
# 3/3/22.	wmk.
#
#	Usage. bash IncDumpHCRaw.sh
#
# Dependencies.
#	~/Territories/RawData/HCPA - base directory for Terrxxx folders with
#	  HCPA raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataHC.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawDataHC.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 3/3/22.	wmk.	original shell; adapted from IncDumpRawDataHC.
#
# Notes. IncDumpHCRaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file ./log/RawDataHC.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartRawDataHC.sh is provided to
# reset the RawData dump information so that the next IncDumpHCRaw
# run will produce the level-0 (full) dump.
# The file ./log/RawDataHC.snar is created as the listed-incremental archive
# information. The file ./log/RawHClevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpHCRaw calls. The initial archive file is named
# archive.0.tar.
# If the ./log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawDataHC.snar-n, where n is the
# next level # obtained by incrementing ./log/level.txt. tar will be
# invoked with this new RawDataHC.snar-n file as the "listed-incremental"
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
echo "IncDumpHCRaw is out-of-date - abaondoned."
exit 1
if [ "$USER" = "ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else 
 folderbase=$HOME
fi
P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  bash ~/sysprocs/LOGMSG "   IncDumpHCRaw initiated from Make."
  echo "   IncDumpHCRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpHCRaw initiated from Terminal."
  echo "   IncDumpHCRaw initiated."
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $folderbase/Territories
# if ./log does not exist, initialize and perform level 0 tar.
if ! test -f ./log/RawHClevel.txt;then
  # initial archive
 if ! test -d ./log;then
  mkdir log
 fi
  echo "0" > ./log/RawHClevel.txt
  echo "0" > ./log/RawHCnextlevel.txt
  if [ -z "$P1" ];then
   tar --create \
	  --listed-incremental=./log/RawDataHC.snar-0 \
	  --file=RawDataHC.0.tar \
	  RawData/HCPA
  else
   tar --create \
	  --listed-incremental=./log/RawDataHC.snar-0 \
	  --file=$P1/RawDataHC.0.tar \
	  RawData/HCPA
  fi
  notify-send "IncDumpHCRaw" " $P1 complete."
  ~/sysprocs/LOGMSG "  IncDumpHCRaw $P1 complete."
  echo "  IncDumpHCRaw $P1 complete"
  exit 0
fi
# this is a level-1 tar incremental.
 file='./log/RawHClevel.txt'
# while read -e; do
#  oldsnar=RawDataHC.snar-$REPLY
# done < $file
  oldsnar=RawDataHC.snar-0
 awk '{$1++; print $0}' ./log/RawHClevel.txt > ./log/RawHCnextlevel.txt
 cp ./log/RawHCnextlevel.txt ./log/RawHClevel.txt
 file='./log/RawHClevel.txt'
 while read -e;do
  archname=RawDataHC.$REPLY.tar
  snarname=$oldsnar
 # snarname=RawDataHC.snar-$REPLY
# cp ./log/$oldsnar ./log/$snarname
# echo "./log/$snarname"
# echo "$archname"
 if [ -z "$P1" ];then
  tar --create \
	--listed-incremental=./log/$snarname \
	--file=$archname \
	RawData/HCPA
 else
  tar --create \
	--listed-incremental=./log/$snarname \
	--file=$P1/$archname \
	RawData/HCPA
 fi
done < $file
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "IncDumpHCRaw" " $1 complete."
fi
~/sysprocs/LOGMSG "  IncDumpHCRaw $P1 complete."
echo "  IncDumpHCRaw $P1 complete"
# end IncDumpHCRaw
