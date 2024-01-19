#!/bin/bash
# UpdateGoogleTerrs.sh  - Update GoogleDrive territories via upload.
# 12/24/21.	wmk.
#
#	Usage. bash UpdateGoogleTerrs.sh
#
# Dependencies.
#	~/Territories/TerrData - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/TerrData/GTerr101-199.tar.gz, GTerr201-299.tar.gz,
#	  GTerr301-399.tar.gz and GTerr4xx-9xx.tar.gz are the compressed
#	  publisher territory data for the territories in their numbered
#	  range.
#	gcloud: registered with rclone as drive spec for GoogleDrive
#	  belonging to vnc.wmk3@gmail.com
#
# Exit Results.
#	gcloud:/CongInfoExchange/Territories/Terrs 101-199,
#	  ./Terrs 201-299, ./Terrs301-299, ./Terrs4xx-9xx updated with
#	  upload of GTerrxxx-yyy.tar.gz compressed archives.
#
# Modification History.
# ---------------------
# 7/2/21.	wmk.	original shell
# 12/24/21.	wmk.	notify-send conditional for multihost.
#
# Notes. rclone is configured in the file ~/.config/rclone/rclone.conf
# by the rclone config command. This sets up the authorization by
# GoogleDrive for this computer to transfer files to/from the
# GoogleDrive system using a meta-drive name. "gcloud:" is the
# meta-drive name for vnc.wmk3@gmail.com on GoogleDrive.
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ "$HOME" = "/home/ubuntu" ]; then
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
  TEMP_PATH="$folderbase/temp"
  bash ~/sysprocs/LOGMSG "   UpdateGoogleTerrs initiated from Make."
  echo "   UpdateGoogleTerrs initiated."
else
  bash ~/sysprocs/LOGMSG "   UpdateGoogleTerrs initiated from Terminal."
  echo "   UpdateGoogleTerrs initiated."
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if ! test -f GTerr4xx-9xx.tar.gz;then 
  touch GTerr4xx-9xx.tar.gz
fi
cd $folderbase/Territories/TerrData
~/sysprocs/LOGMSG "   rclone copy ./GTerr101-199.tar.gz gcloud:/CongInfoExchange/'Terrs 101-199'"
echo "   rclone copy ./GTerr101-199.tar.gz gcloud:/CongInfoExchange/'Terrs 101-199'"
rclone --include GTerr101*.gz copy ./ gcloud:/CongInfoExchange/'Terrs 101-199'
echo "   rclone copy ./GTerr201-299.tar.gz gcloud:/CongInfoExchange/'Terrs 201-299'"
~/sysprocs/LOGMSG "   rclone copy ./GTerr201-299.tar.gz gcloud:/CongInfoExchange/'Terrs 201-299'"
rclone --include GTerr201*.gz copy ./ gcloud:/CongInfoExchange/'Terrs 201-299'
echo "   rclone copy ./GTerr301-399.tar.gz gcloud:/CongInfoExchange/'Terrs 301-399'"
~/sysprocs/LOGMSG "   rclone copy ./GTerr301-399.tar.gz gcloud:/CongInfoExchange/'Terrs 301-399'"
rclone --include GTerr301*.gz copy ./ gcloud:/CongInfoExchange/'Terrs 301-399'
echo"   rclone copy ./GTerr4xx-9xx.tar.gz gcloud:/CongInfoExchange/'Terrs 4xx-9xx'"
~/sysprocs/LOGMSG "   rclone copy ./GTerr4xx-9xx.tar.gz gcloud:/CongInfoExchange/'Terrs 4xx-9xx'"
rclone --include GTerr4xx*.gz copy ./ gcloud:/CongInfoExchange/'Terrs 4xx-9xx'
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "UpdateGoogleTerrs" " $1 complete."
fi
~/sysprocs/LOGMSG "  UpdateGoogleTerrs $P1 complete."
echo "  UpdateGoogleTerrs $P1 complete"
# end UpdateGoogleTerrs
