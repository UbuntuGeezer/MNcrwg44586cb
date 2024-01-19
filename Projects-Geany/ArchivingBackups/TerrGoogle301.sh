#!/bin/bash
# TerrGoogle301.sh  - Incremental archive of RawData subdirectories.
# 6/29/21.	wmk.
#
#	Usage. bash TerrGoogle301
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawData.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawData.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 6/29/21.	wmk.	original shell; adapted from IncDumpTerrData.
#
# Notes. TerrGoogle301.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file ./log/RawData.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed.
# The file ./log/RawData.snar is created as the listed-incremental archive
# information. The file ./log/Rawlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent TerrGoogle301 calls. The initial archive file is named
# archive.0.tar.
# If the ./log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawData.snar-n, where n is the
# next level # obtained by incrementing ./log/level.txt. tar will be
# invoked with this new RawData.snar-n file as the "listed-incremental"
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
  bash ~/sysprocs/LOGMSG "   TerrGoogle301 initiated from Make."
  echo "   TerrGoogle301 initiated."
else
  bash ~/sysprocs/LOGMSG "   TerrGoogle301 initiated from Terminal."
  echo "   TerrGoogle301 initiated."
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
	  -T targoogle301.txt \
	  --file=GTerr301-399.tar.gz \
	  --gzip . > taroutput.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
notify-send "TerrGoogle301" " $1 complete."
~/sysprocs/LOGMSG "  TerrGoogle301 $P1 complete."
echo "  TerrGoogle301 $P1 complete"
# end TerrGoogle301
