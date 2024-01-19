#!/bin/bash
# IncDumpMaster.sh  - Incremental archive of DB-Dev databases.
# 9/17/21.	wmk.
#
#	Usage. bash IncDumpMaster.sh [drive-spec]
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/MasterDB.n.tar - incremental dump of ./DB-Dev databases
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/MasterDB.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 9/17/21.	wmk.	original shell; adapted from IncDumpRawRU; jumpto
#					function eliminated.
#
# Notes. IncDumpMaster.sh performs an incremental archive (tar) of the
# DB-Dev databases. If the file ./log/MasterDB.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartMasterDB.sh is provided to
# reset the MasterDB dump information so that the next IncDumpMaster
# run will produce the level-0 (full) dump.
# The file ./log/MasterDB.snar is created as the listed-incremental archive
# information. The file ./log/MasterDBlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpMaster calls. The initial archive file is named
# MasterDB.0.tar.
# If the ./log folder exists under Territories a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named MasterDB.snar-n, where n is the
# next level # obtained by incrementing ./log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named MasterDB.n.tar.
echo "IncDumpMaster is out-of-date - abandoned."
exit 1
if [ "$HOME" = "/home/ubuntu" ]; then
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
  bash ~/sysprocs/LOGMSG "   IncDumpMaster initiated from Make."
  echo "   IncDumpMaster initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpMaster initiated from Terminal."
  echo "   IncDumpMaster initiated."
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
cd $folderbase/Territories
# if ./log does not exist, initialize and perform level 0 tar.
if ! test -f ./log/MasterDBlevel.txt;then
  # initial archive
 if ! test -d ./log;then
  mkdir log
 fi
  echo "0" > ./log/MasterDBlevel.txt
  echo "0" > ./log/MasterDBnextlevel.txt
  if [ -z "$P1" ];then
   tar --create \
	  --listed-incremental=./log/MasterDB.snar-0 \
	  --file=MasterDB.0.tar \
	  DB-Dev/*.db
  else
   tar --create \
	  --listed-incremental=./log/MasterDB.snar-0 \
	  --file=$P1/MasterDB.0.tar \
	  DB-Dev/*.db
  fi
  notify-send "IncDumpMaster" " $P1 complete."
  ~/sysprocs/LOGMSG "  IncDumpMaster $P1 complete."
  echo "  IncDumpMaster $P1 complete"
  exit 0
fi
# this is a level-1 tar incremental.
 file='./log/MasterDBlevel.txt'
# while read -e; do
#  oldsnar=MasterDB.snar-$REPLY
# done < $file
  oldsnar=MasterDB.snar-0
 awk '{$1++; print $0}' ./log/MasterDBlevel.txt > ./log/MasterDBnextlevel.txt
 cp ./log/MasterDBnextlevel.txt ./log/MasterDBlevel.txt
 file='./log/MasterDBlevel.txt'
 while read -e;do
  archname=MasterDB.$REPLY.tar
  snarname=$oldsnar
 # snarname=RawDataRU.snar-$REPLY
# cp ./log/$oldsnar ./log/$snarname
# echo "./log/$snarname"
# echo "$archname"
 if [ -z "$P1" ];then
  tar --create \
	--listed-incremental=./log/$snarname \
	--file=$archname \
	DB-Dev/*.db
 else
  tar --create \
	--listed-incremental=./log/$snarname \
	--file=$P1/$archname \
	DB-Dev/*.db
 fi
done < $file
#
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
notify-send "IncDumpMaster" " $P1 complete."
~/sysprocs/LOGMSG "  IncDumpMaster $P1 complete."
echo "  IncDumpMaster $P1 complete"
# end IncDumpMaster
