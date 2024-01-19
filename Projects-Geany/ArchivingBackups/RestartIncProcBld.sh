#!/bin/bash
# RestartProcBld.sh  - Set up for fresh incremental archiving of Proc-Builds.
#	7/12/23.	wmk.
#
#	Usage. bash RestartProcBld.sh
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/ProcBld.nnn.tar files all deleted after warning;
#	/Territories/log/ProcBld.snar-0 deleted after warning;
#	/Territories/log/ProcBldlevel.txt deleted; this sets up next run of
#	IncDumpProcBld to start at level 0;
#
# Modification History.
# ---------------------
# 6/27/22.	wmk.	original code; adapted from RestartIncProcs.
# 7/12/23.	wmk.	shell disabled.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used througout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# 5/5/22.	wmk.	mod eliminating .0.tar check before removing old
#			 dump files.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
echo "** RestartProcBld shell disabled - exiting.**"
read -p "Enter ctrl-c to remain in Terminal: "
exit 1
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
 echo "RestartIncProcBld <state> <county> <congno> missing parameter(s) - abandoned."
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
  bash ~/sysprocs/LOGMSG "   RestartIncProcBld initiated from Make."
  echo "   RestartProcBld initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncProcBld initiated from Terminal."
  echo "   RestartProcBld initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
echo " **WARNING - proceeding will remove all prior ProcBld incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncProcBld."
  echo " Stopping RestartIncProcBld - secure ProcBld incremental backups.."
  exit 0
fi
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
geany=ProcBld
level=level
nextlevel=nextlevel
if test -f $pathbase/log/$congterr$geany$level.txt;then
 rm $pathbase/log/$congterr$geany$level.txt
fi
rm $pathbase/log/$congterr$geany$nextlevel.txt
echo "0" > $pathbase/log/$congterr$geany$nextlevel.txt
if test -f $pathbase/log/$congterr$geany.snar-0; then
 rm $pathbase/log/$congterr$geany.snar-0
fi
rm $pathbase/$congterr$geany*.tar
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  RestartIncProcBld $P1 complete."
echo "  RestartIncProcBld $P1 complete"
# end RestartProcBld.
