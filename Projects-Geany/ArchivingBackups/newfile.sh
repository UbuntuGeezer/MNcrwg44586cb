#!/bin/bash
# RestartIncRURaw.sh  - Set up for fresh incremental archiving of RawDataRU.
#   4/6/22.   wmk.
#
#	Usage. bash RestartIncRURaw.sh
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataRU.nnn.tar files all deleted after warning;
#	/Territories/log/RawDataRU.snar-0 deleted after warning;
#	/Territories/log/RawRUlevel.txt deleted; this sets up next run of
#	IncDumpRawData to start at level 0;
#
# Modification History.
# ---------------------
# 9/8/21.     wmk.   original shell; adapted from RestartIncRawDataRU.
TEMP_PATH=$HOME/temp
# 11/16/21.   wmk.   WARNING message clarified.
# 12/24/21.   wmk.   notify-send conditional for multihost.
# 4/6/22.     wmk.   use *pathbase* and passed <state> <county> <congo> in paths.
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
if [ "$USER" == "ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else 
 folderbase=$HOME
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncRURaw initiated from Make."
  echo "   RestartIncRURaw initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncRURaw initiated from Terminal."
  echo "   RestartIncRURaw initiated."
fi
TEMP_PATH=$HOME/temp
echo " **WARNING - proceeding will remove all prior RU RawData incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncRURaw."
  echo " Stopping RestartIncRURaw - secure RawData incremental backups.."
  exit 0
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
cd $pathbase
if test -f ./log/RawRUlevel.txt;then
 rm ./log/RawRUlevel.txt
 echo "0" > ./log/RawRUnextlevel.txt
fi
if test -f ./log/RawDataRU.snar-0; then
 rm ./log/RawDataRU.snar-0
fi
if test -f RawDataRU.0.tar; then
 rm RawDataRU*.tar
fi
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "RestartIncRURaw" " $1 complete."
fi
~/sysprocs/LOGMSG "  RestartIncRURaw $P1 complete."
echo "  RestartIncRURaw $P1 complete"
# end RestartIncRURaw
