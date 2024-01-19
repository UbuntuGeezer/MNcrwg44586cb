#!/bin/bash
# TerrFullData.sh  - Full archive of Territory data subdirectories.
# 7/1/21.	wmk.
#
#	Usage. bash TerrFullData <target-drive>
#
#		<target-drive> - mounted flash drive ID
#
# Dependencies.
#	~/Territories/TerrData - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#	/ArchivingBackups/tarfullist - list of files to include in dump
#	/ArchivingBackups/tarxcptlist - list of files to exclude from dump
#
# Exit Results.
#	/Territories/TerrData.n.tar - incremental dump of ./TerrData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/TerrData/log/TerrData.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/TDlevel.txt - current level of incremental TerrData 
#	  archive files.
#
# Modification History.
# ---------------------
# 7/1/21.	wmk.	original shell.
#
# Notes. TerrFullData.sh performs an incremental archive (tar) of the
# TerrData subdirectories. If the folder ./log does not exist under
# TerrData, it is created and a level-0 incremental dump is performed.
# The file ./log/TerrData.snar is created as the listed-incremental archive
# information. The file ./log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent TerrFullData calls. The initial archive file is named
# archive.0.tar.
# If the ./log folder exists under TerrData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named TerrData.snar-n, where n is the
# next level # obtained by incrementing ./log/TDlevel.txt. tar will be
# invoked with this new TerrData.snar-n file as the "listed-incremental"
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
P1=$1
if [ -z "$P1" ];then
  echo "  TerrFullData - must specify <drive-spec> - abandoned."
  exit 0
fi
if ! test -d $U_DISK/$P1;then
  echo "  TerrFullData - flash drive $P1 not mounted - abandoned."
  exit 0
fi
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  bash ~/sysprocs/LOGMSG "   TerrFullData initiated from Make."
  echo "   TerrFullData initiated."
else
  bash ~/sysprocs/LOGMSG "   TerrFullData initiated from Terminal."
  echo "   TerrFullData initiated."
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#
tarbase=$folderbase/Territories/Projects-Geany/ArchivingBackups
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $folderbase/Territories
if ! test -f $tarbase/tarfulllist.txt || ! test -f $tarbase/tarxcptlist.txt;then
  ~/sysprocs/LOGMSG "   TerrFullData - missing full or exclude list file(s) - abandoned."
  echo "   TerrFullData - missing full or exclude list file(s) - abandoned."
  exit 0
fi

#tar --create 
#  -f $U_DISK/$P1/TerrFullData.tar.gz -z
#  -T $tarbase/tarfulllist.txt -X $tarbase/tarxcptlist.txt 
#  --verbose

tar --create --file=$U_DISK/$P1/TerrFullData.tar.gz --gzip \
  --exclude-from $tarbase/tarxcptlist.txt \
  --verbose .
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
notify-send "TerrFullData" " $1 complete."
~/sysprocs/LOGMSG "  TerrFullData $P1 complete."
echo "  TerrFullData $P1 complete"
# end TerrFullData
