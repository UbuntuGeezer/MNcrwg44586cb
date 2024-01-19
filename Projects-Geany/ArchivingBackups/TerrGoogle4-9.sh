#!/bin/bash
# TerrGoogle4-9.sh  - Archive TerrData 4xx - 9xx publisher terr files.
# 7/1/21.	wmk.
#
#	Usage. bash TerrGoogle4-9.sh
#
# Dependencies.
#	~/Territories/TerrData - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/TerrData/terrgoogle4xx.txt is the file list extracted
#	  from the /Terr4xx .. /Terr9xx folders that will be dumped.
#
# Exit Results.
#	/Territories/TerrData/GTerr4xx-9xx.tar.gx - compressed archive of
#	  TerrData/Terr4xx .. /Terr9xx PubTerr and SuperTerr files.
#
# Modification History.
# ---------------------
# 7/1/21.	wmk.	original shell
#
# Notes. TerrGoogle4-9.sh performs a dump of the publisher territory
# files in folders /Terr4xx - /Terr9xx of the TerrData subdirectories.
# The dump file is GTerr4xx-9xx.tar.gz in the TerrData folder. It will
# subsequently be uploaded into the GoogleDrive folders for distribution.
# function definition
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
  bash ~/sysprocs/LOGMSG "   TerrGoogle4-9 initiated from Make."
  echo "   TerrGoogle4-9 initiated."
else
  bash ~/sysprocs/LOGMSG "   TerrGoogle4-9 initiated from Terminal."
  echo "   TerrGoogle4-9 initiated."
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $folderbase/Territories/TerrData
tar --create \
	  -T targoogle4xx.txt \
	  --file=GTerr4xx-9xx.tar.gz \
	  --gzip . > taroutput.txt
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
notify-send "TerrGoogle4-9" " $1 complete."
~/sysprocs/LOGMSG "  TerrGoogle4-9 $P1 complete."
echo "  TerrGoogle4-9 $P1 complete"
# end TerrGoogle4-9
