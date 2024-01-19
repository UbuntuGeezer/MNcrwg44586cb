#!/bin/bash
# RestartIncBizTerr.sh  - Set up for fresh incremental archiving of RawDataBiz.
# 	4/23/22.	wmk.
#
#	Usage. bash RestartIncBizTerr.sh
#
# Dependencies.
#	~/Territories/BRawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataBiz.nnn.tar files all deleted after warning;
#	/Territories/log/RawDataBiz.snar-0 deleted after warning;
#	/Territories/log/RawBizlevel.txt deleted; this sets up next run of
#	IncDumpBizTerr to start at level 0;
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# Legacy mods.
# 10/17/21.	wmk.	original shell; adapted from RestartIncBizRaw.
# 12/24/21.	wmk.	notify-send conditional for multihost.
#
# Notes. The entire incremental dump collection for BRawData/BTerrData will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
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
 echo "RestartIncBizTerr <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
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
  bash ~/sysprocs/LOGMSG "   RestartIncBTerrData initiated from Make."
  echo "   RestartIncBTerrData initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncBTerrData initiated from Terminal."
  echo "   RestartIncBizTerr initiated."
fi
TEMP_PATH="$folderbase/temp"
echo " **WARNING - proceeding will remove all prior BTerrData incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncBTerrData."
  echo " Stopping RestartIncBTerrData - secure BTerrData incremental backups.."
  exit 0
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
terrdata=BTerrData
level=level
nextlevel=nextlevel
newlevel=newlevel
if test -f ./log/$P1$P2$P3$terrdata$level.txt;then
 rm ./log/$P1$P2$P3$terrdata$level.txt
 echo "0" > ./log/$P1$P2$P3$terrdata$nextlevel.txt
fi
if test -f ./log/$P1$P2$P3$terrdata.snar-0; then
 rm ./log/$P1$P2$P3$terrdata.snar-0
fi
if test -f $P1$P2$P3$terrdata.0.tar; then
 rm $P1$P2$P3$terrdata*.tar
fi
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  RestartIncBTerrData $P1 $P2 $P3 complete."
echo "  RestartIncBTerrData $P1 $P2 $P3 complete"
# end RestartIncBTerrData
