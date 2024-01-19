#!/bin/bash
# RestartIncDoNotCalls.sh  - Set up for fresh incremental archiving of DoNotCalls.
# 	7/13/22.	wmk.
#
#	Usage. bash RestartIncDoNotCalls.sh <state> <county> <congno> -u <mount-name>
#
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/DoNotCalls.nnn.tar files all deleted after warning;
#	/Territorie$pathbase/log/DoNotCalls.snar-0 deleted after warning;
#	/Territorie$pathbase/log/DoNotCallslevel.txt deleted; this sets up next run of
#	IncDumpDoNotCalls to start at level 0;
#
# Modification History.
# ---------------------
# 7/12/23.	wmk.	-u <mount-name> support; jumpto references removed.
# Legacy mods.
# 7/10/22.	wmk.	original code; adapted from RestartBasic.
# 7/13/22.	wmk.	*rm* path missing / corrected; notify-send removed.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncDoNotCalls <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
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
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   RestartIncDoNotCalls initiated from Make."
  echo "   RestartDoNotCalls initiated."
else
  ~/sysprocs/LOGMSG "   RestartIncDoNotCalls initiated from Terminal."
  echo "   RestartDoNotCalls initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior DoNotCalls incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncDoNotCalls."
  echo " Stopping RestartIncDoNotCalls - secure DoNotCalls incremental backups.."
  exit 0
 fi
fi	# NOPROMPT
#
if [ $local_debug = 1 ]; then
 pushd ./ > /dev/null
 cd ~/Documents		# write files to Documents folder
fi
 if [ "$P4" != "-U" ];then
  echo "InitFlashDrive <state> <county> <congno> -u <mount-name> unrecognized option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "InitFlashDrive abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - RestartIncMainDBs abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
    echo "continuing with $P5 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
 fi  #end drive not mounted
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
geany=DoNotCalls
level=level
nextlevel=nextlevel
if test -f $dump_path/log/$congterr$geany$level.txt;then
 rm $dump_path/log/$congterr$geany$level.txt
fi
echo "0" > $dump_path/log/$congterr$geany$nextlevel.txt
if test -f $dump_path/log/$congterr$geany.snar-0; then
 rm $dummp_path/log/$congterr$geany.snar-0
fi
if test -f $dump_path$congterr$geany.0.tar; then
 rm $dump_path/$congterr$geany*.tar
fi
popd > /dev/null
#endprocbody
if [ $local_debug = 1 ]; then
  popd
fi
#jumpto EndProc
#EndProc:
~/sysprocs/LOGMSG "  RestartIncDoNotCalls $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncDoNotCalls $P1 $P2 $P3 $P4 $P5 complete."
# end RestartDoNotCalls
