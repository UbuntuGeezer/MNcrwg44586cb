#!/bin/bash
# RestartProcs.sh  - Set up for fresh incremental archiving of Procs.
#	11/27/22.	wmk.
#
#	Usage. bash RestartProcs.sh <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Procs.nnn.tar files all deleted after warning;
#	/Territories/log/Procs.snar-0 deleted after warning;
#	/Territories/log/Procslevel.txt deleted; this sets up next run of
#	IncDumpProcs to start at level 0;
#
# Modification History.
# ---------------------
# 11/2/22.	wmk.	!! *sysid environment var support for all archiving
#			 operations; this will keep code segment dumps separated in the
#			 archiving system to avoid unwanted overwriting of macros/modules
#			 with the same name; *codebase support; -u, <mount-name> support.
# 11/27/22.	wmk.	rescind *sysid environment var support; improve error handling
#			 to allow Terminal to continue; jumpto references removed.
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
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=$5		# mount-name
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "RestartIncProcs <state> <county> <congno> [-u <mount-name>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-U" ];then
  echo "** RestartIncProcs <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "** RestartIncProcs <state> <county> <congno> <terrid> [-u <mount-name>] missing <mount-name> - abandoned. **"
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
   echo "RestartIncProcs abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - RestartIncProcs abandoned."
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
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
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
  bash ~/sysprocs/LOGMSG "   RestartIncProcs initiated from Make."
  echo "   RestartProcs initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncProcs initiated from Terminal."
  echo "   RestartIncProcs initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior Procs incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncProcs."
  echo " Stopping RestartIncProcs - secure Procs incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P5" ];then
 dump_path=$codebase
else
 cd $U_DISK/$P5
 if ! test -d ./$congterr;then
  mkdir $congterr
 fi
 dump_path=$U_DISK/$P5/$congterr
fi
cd $dump_path
if ! test -d $dump_path/log;then
 mkdir log
fi
geany=Procs
level=level
nextlevel=nextlevel
if test -f $dump_path/log/$congterr$geany$level.txt;then
 rm $dump_path/log/$congterr$geany$level.txt
fi
rm $dump_path/log/$congterr$geany$nextlevel.txt
echo "0" > $dump_path/log/$congterr$geany$nextlevel.txt
if test -f $dump_path/log/$congterr$geany.snar-0; then
 rm $dump_path/log/$congterr$geany.snar-0
fi
rm $dump_path/$congterr$geany*.tar
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncProcs $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncProcs $P1 $P2 $P3 $P4 $P5 complete."
# end RestartIncProcs
