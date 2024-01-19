#!/bin/bash
# RestartBRURaw.sh  - Set up for fresh incremental archiving of BRURaw.
# 	4/23/22.	wmk.
#
#	Usage. bash RestartBRURaw.sh
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/BRURaw.nnn.tar files all deleted after warning;
#	/Territories/log/BRURaw.snar-0 deleted after warning;
#	/Territories/log/BRURawlevel.txt deleted; this sets up next run of
#	IncDumpBRURaw to start at level 0;
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
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
 echo "RestartIncBRURaw <state> <county> <congno> missing parameter(s) - abandoned."
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 exit 1
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
  bash ~/sysprocs/LOGMSG "   RestartIncBRURaw initiated from Make."
  echo "   RestartBRURaw initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncBRURaw initiated from Terminal."
  echo "   RestartBRURaw initiated."
fi
TEMP_PATH=$folderbase/temp
echo " **WARNING - proceeding will remove all prior BRURaw incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncBRURaw."
  echo " Stopping RestartIncBRURaw - secure BRURaw incremental backups.."
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
geany=BRawDataRU
level=level
nextlevel=nextlevel
if test -f ./log/$P1$P2$P3$geany$level.txt;then
 rm ./log/$P1$P2$P3$geany$level.txt
 echo "0" > ./log/$P1$P2$P3$geany$nextlevel.txt
fi
if test -f ./log/$P1$P2$P3$geany.snar-0; then
 rm ./log/$P1$P2$P3$geany.snar-0
fi
if test -f $P1$P2$P3$geany.0.tar; then
 rm $P1$P2$P3$geany*.tar
fi
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "RestartIncBRURaw" " $1 complete."
fi
~/sysprocs/LOGMSG "  RestartIncBRURaw $P1 complete."
echo "  RestartIncBRURaw $P1 complete"
# end RestartBRURawData
