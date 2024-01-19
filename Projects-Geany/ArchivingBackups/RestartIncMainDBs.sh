#!/bin/bash
# RestartMainDBs.sh  - Set up for fresh incremental archiving of MainDBs.
# 	8/16/23.	wmk.
#
#	Usage. bash RestartMainDBs.sh
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/MainDBs.nnn.tar files all deleted after warning;
#	/Territories/log/MainDBs.snar-0 deleted after warning;
#	/Territories/log/MainDBslevel.txt deleted; this sets up next run of
#	IncDumpMainDBs to start at level 0;
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MN/CRWG/44586.
# Legacy mods.
# 11/27/22.	wmk.	jumpto references eliminated; error message corrections; exit
#			 processing to allow Terminal to continue; *codebase support; CB code
#			 check.
# 12/19/22.	wmk.	bug fix where drive not tested for being mounted.
# Legacy mods.
# 8/11/22.	wmk.	-u, <mount-name> support.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* env var used throughout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -u
P5=$5			# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncMainDBs <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
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
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - RetartIncMainDBs abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "RestartIncMainDBs <state> <county> <congno> [-u <mount-name>] unrecognized option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncMainDBs abandoned at user request."
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
else 
 echo "continuing with $P5 mounted..."
fi  #end drive not mounted
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   RestartIncMainDBs initiated from Make."
  echo "   RestartMainDBs initiated."
else
  ~/sysprocs/LOGMSG "   RestartIncMainDBs initiated from Terminal."
  echo "   RestartMainDBs initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior MainDBs incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncMainDBs."
  echo " Stopping RestartIncMainDBs - secure MainDBs incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > /dev/null
cd $U_DISK/$P5
if ! test -d $congterr;then
 mkdir $congterr
fi
cd $U_DISK/$P5/$congterr
if ! test -d log;then
 mkdir log
fi
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
MainDBs=MainDBs
level=level
nextlevel=nextlevel
if test -f $dump_path/log/$congterr$MainDBs$level.txt;then
 rm $dump_path/log/$congterr$MainDBs$level.txt
fi
echo "0" > $dump_path/log/$congterr$MainDBs$nextlevel.txt
if test -f $dump_path/log/$congterr$MainDBs.snar-0; then
 rm $dump_path/log/$congterr$MainDBs.snar-0
fi
if test -f $dump_path/$congterr$MainDBs.0.tar; then
 rm $dump_path/$congterr$MainDBs*.tar
fi
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  RestartIncMainDBs $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncMainDBs $P1 $P2 $P3 $P4 $P5 complete."
# end RestartMainDBs
