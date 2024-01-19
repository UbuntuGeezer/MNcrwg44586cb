#!/bin/bash
# IncDumpBizTerr.sh  - Incremental archive of TerrData subdirectories.
# 4/23/22.	wmk.
#
#	Usage. bash IncDumpBizTerr
#
# Dependencies.
#	~/Territories/BTerrData - base directory for Terrxxx folders with
#	  business territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/BizTerr.n.tar - incremental dump of ./BTerrData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/log/BizTerr.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/BizTerrlevel.txt - current level of incremental BizTerr 
#	  archive files.
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# Legacy mods.
# 9/26/21.	wmk.	original shell; adapted from IncDumpTerrData.
# 10/17/21.	wmk.	bug fix change Bizlevel, Biznextlevel to BizTerrlevel,
#					BizTerrnextlevel.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpBizTerr.sh performs an incremental archive (tar) of the
# BTerrData subdirectories. If the folder ./log does not exist under
# Terrritories, it is created and a level-0 incremental dump is performed.
# A shell utility RestartBizTerr.sh is provided to reset the BizTerr dump
# information so that the next IncDumpBizTerr run will produce the level-0
# (full) dump.
# The file ./log/BizTerr.snar is created as the listed-incremental archive
# information. The file ./log/Bizlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpBizTerr calls. The initial archive file is named
# BizTerr.0.tar.
# If the ./log folder exists under Territories a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named TerrData.snar-n, where n is the
# next level # obtained by incrementing ./log/Bizlevel.txt. tar will be
# invoked with this new TerrData.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named BizTerr.n.tar.
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
 echo "IncDumpBizTerr <state> <county> <congno> missing parameter(s) - abandoned."
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
  bash ~/sysprocs/LOGMSG "   IncDumpBizTerr initiated from Make."
  echo "   IncDumpBizTerr initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpBizTerr initiated from Terminal."
  echo "   IncDumpBizTerr initiated."
fi
TEMP_PATH=$folderbase/temp
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
# if ./log/BizTerr.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f ./log/BizTerr.snar-0;then
  # initial archive
 if ! test -d ./log;then
  mkdir log
 fi
  echo "0" > ./log/BizTerrlevel.txt
  echo "1" > ./log/BizTerrnextlevel.txt
  tar --create \
	  --listed-incremental=./log/BizTerr.snar-0 \
	  --file=BizTerr.0.tar \
	  BTerrData
  if [ "$USER" != "vncwmk3" ];then
   notify-send "IncDumpBizTerr" " $1 complete."
  fi
  ~/sysprocs/LOGMSG "  IncDumpBizTerr $P1 complete."
  echo "  IncDumpBizTerr $P1 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=BizTerr.snar-$REPLY
# done < $file
  oldsnar=BizTerr.snar-0
 awk '{$1++; print $0}' ./log/BizTerrnextlevel.txt > ./log/BizTerrnewlevel.txt
 file='./log/BizTerrnextlevel.txt'
 while read -e;do
  archname=BizTerr.$REPLY.tar
  snarname=$oldsnar
 # snarname=BizTerr.snar-$REPLY
# cp ./log/$oldsnar ./log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 tar --create \
	--listed-incremental=./log/$snarname \
	--file=$archname \
	BTerrData
done < $file
cp ./log/BizTerrnewlevel.txt ./log/BizTerrnextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "IncDumpBizTerr" " $1 complete."
fi
~/sysprocs/LOGMSG "  IncDumpBizTerr $P1 complete."
echo "  IncDumpBizTerr $P1 complete"
# end IncDumpBizTerr
