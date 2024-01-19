#!/bin/bash
# RestartIncTerr.sh  - Set up for fresh incremental archiving of IncTerr.
# 	7/12/23.	wmk.
#
#	Usage. bash RestartIncTerr.sh  <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/IncTerr.nnn.tar files all deleted after warning;
#	/Territories/log/IncTerr.snar-0 deleted after warning;
#	/Territories/log/IncTerrlevel.txt deleted; this sets up next run of
#	IncDumpIncTerr to start at level 0;
#
# Modification History.
# ---------------------
# 7/12/23.	wmk.	shell disabled.
# Legacy mods.
# 8/7/22.	wmk.	original shell; adapted from RestartIncGeany.
# 8/9/22.	wmk.	mod to use *dump_path instead of *flashbase; use
#			 folder *congterr for base dump path; add -u parameter
#			 for utility consistency.
# 8/11/22.	wmk.	bug fix P4, P5 not being set on entry.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used throughout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional; name change
#			 from IncTerr to RawDataRU.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
echo "** RestartIncTerr shell disabled - exiting.**"
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
P4=${4^^}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "RestartIncTerr <state> <county> <congno> [-u <mount-name>] missing parameter(s) - abandoned."
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
 echo "** $P1$P2$P3 mismatch with *congterr* - RestartIncTerr abandoned **"
 exit 1
fi
if [ ! -z $P4 ];then
 if [ "$P4" != "-U" ];then
  echo "RestartIncTestBase <state> <county> <congno> [-u <mount-name>] unrecognized option - abandoned."
  exit 1
 fi
fi  # end -u specified
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   RestartIncTerr initiated from Make."
  echo "   RestartIncTerr initiated."
else
  ~/sysprocs/LOGMSG "   RestartIncTerr initiated from Terminal."
  echo "   RestartIncTerr initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior IncTerr incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncTerr."
  echo " Stopping RestartIncTerr - secure IncTerr incremental backups.."
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
if [ ! -z "$P5" ];then
 dump_path=$U_DISK/$P5/$congterr
 if ! test -d $dump_path;then
  pushd ./
  cd $U_DISK/$P5
  mkdir $congterr
  popd
 fi
else
 dump_path=$pathbase/$congterr
 if ! test -d $dump_path;then
  pushd ./
  cd $pathbase
  mkdir $congterr
  popd
 fi
fi
cd $dump_path
terr=Terr
if ! test -d $dump_path/log;then
 mkdir log
fi
level=level
nextlevel=nextlevel
if test -f $dump_path/log/$congterr$terr$level.txt;then
 rm $dump_path/log/$congterr$terr$level.txt
fi
echo "0" > $dump_path/log/$congterr$terr$nextlevel.txt
if test -f $dump_path/log/$congterr$terr.snar-0; then
 rm $dump_path/log/$congterr$terr.snar-0
fi
if test -f $dump_path/$congterr$terr.0.tar; then
 rm $dump_path/$congterr$terr*.tar
fi
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  RestartIncTerr $P1 $P2 $P3 $P4 complete."
echo "  RestartIncRURaw $P1 $P2 $P3 $P4 complete."
# end RestartIncTerr
