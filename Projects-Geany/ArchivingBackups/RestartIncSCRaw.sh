#!/bin/bash
# RestartSCRaw.sh  - Set up for fresh incremental archiving of SCRaw.
#	6/16/23.	wmk.
#
#	Usage. bash RestartSCRaw.sh  <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state
#		<county> = 4 char county
#		<congno> = congregation number
#		-u = (optional) use USB flash drive
#		<mount-name> (mandatory with -u) USB mount name
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/SCRaw.nnn.tar files all deleted after warning;
#	/Territories/log/SCRaw.snar-0 deleted after warning;
#	/Territories/log/SCRawlevel.txt deleted; this sets up next run of
#	IncDumpSCRaw to start at level 0;
#
# Modification History.
# ---------------------
# 11/24/22.	wmk.	exit handling improved to allow reamining in Terminal;
#			 jumpto function removed; -u, <mount-name> support.
# 6/16/23.	wmk.	bug fixes iif fixed, P5 unshifted.
# Legacy mods.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used througout.
# 4/30/22.	wmk.	explicitly use *pathbase* in paths; bug where
#			 .newlevel var initialization inside if block.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
# P1=<state> P2=<county> P3=<congno> P4=-u P5=<mount-name>
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}
P5=$5	
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "RestartIncSCRaw <state> <county> <congno> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-U" ];then
  echo "** RestartIncSCRaw <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "** RestartIncSCRaw <state> <county> <congno> <terrid> [-u <mount-name>] missing <mount-name> - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
fi
if [ ! -z "$P4" ];then
 if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncSCRaw abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - RestartIncSCRaw abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 fi
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
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncSCRaw initiated from Make."
  echo "   RestartSCRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncSCRaw initiated from Terminal."
  echo "   RestartSCRaw initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior SCRaw incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncSCRaw."
  echo " Stopping RestartIncSCRaw - secure SCRaw incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P5" ];then
 dump_path=$pathbase
else
 cd $U_DISK/$P5
 if ! test -d ./$congterr;then
  mkdir $congterr
 fi
 dump_path=$U_DISK/$P5/$congterr
fi
cd $dump_path
scraw=RawDataSC
level=level
nextlevel=nextlevel
if test -f $dump_path/log/$congterr$scraw$level.txt;then
 rm $dump_path/log/$congterr$scraw$level.txt
fi
echo "0" > $dump_path/log/$congterr$scraw$nextlevel.txt
if test -f $dump_path/log/$congterr$scraw.snar-0; then
 rm $dump_path/log/$congterr$scraw.snar-0
fi
if test -f $dump_path/$congterr$scraw.0.tar; then
 rm $dump_path/$congterr$scraw*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncSCRaw $P1 complete."
echo "  RestartIncSCRaw $P1 complete"
# end RestartIncSCRaw
