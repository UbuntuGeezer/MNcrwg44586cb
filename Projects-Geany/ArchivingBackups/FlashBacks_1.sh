#!/bin/bash
# FlashBacks - Update flash drive with all incremental dumps.
#	10/17/21.	wmk.
#
# Usage.	bash FlashBacks.sh
#
# Exit. All incremental dumps updated on after user mounted flash drive.
#
# This shell will exit if not interactive from Terminal.
if [ "$HOME" = "/home/ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else 
 folderbase=$HOME
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  bash ~/sysprocs/LOGMSG "   FlashBacks initiated from Make."
  echo "   FlashBacks initiated."
else
  bash ~/sysprocs/LOGMSG "   FlashBacks initiated."
  echo "   FlashBacks initiated."
fi
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) echo "FlashBacks NOT initiated interactively. - abandoned."
	~/sysprocs/LOGMSG "   FlashBacks NOT initiated interactively. - abandoned.";exit 0;;
esac
echo " **WARNING - proceeding will remove all prior RawData incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted FlashBacks."
  echo " Stopping FlashBacks - secure RawData incremental backups.."
  exit 0
fi
#begin proc body
cd $folderbase/Territories/Projects-Geany/ArchiveBackups
./FlashBacks.sh
./RestartIncBizRaw.sh
./RestartIncMainDBs.sh
./RestartIncMaster.sh
./RestartIncRURaw.sh
./RestartIncRawData.sh
./RestartIncSCRaw.sh
./RestartIncTerrData.sh
#end proc body
notify-send "FlashBacks" "  complete."
~/sysprocs/LOGMSG "  FlashBacks complete."
echo "  FlashBacks complete"
# end FlashBacks
