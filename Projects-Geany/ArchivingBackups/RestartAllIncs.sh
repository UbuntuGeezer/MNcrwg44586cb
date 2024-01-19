#!/bin/bash
# RestartAllIncs.sh  - Set up for fresh incremental archiving of all.
# 	7/12/23.	wmk.
#
# Usage. bash	RestartAllIncs.sh -u|-l <mount-name>
#
#	<-l> = only list restarts to perform
#				 otherwise run all shells starting with *Restart*
#	-u = restart dump files on USB flash drive
#	<mount-name> = mount name of flash drive
#
# Dependencies.
#	~/Territories/DB-Dev - base directory for master databases
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
# 7/12/23.	wmk.	*codebase support; -u <mount-name> support.
# Legacy mods.
# 5/5/22.	wmk.	RestartInc* list provides list of "restarts" to 
#			 execute.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777; *pathbase*
#			 support.
# Legacy mods.
# 9/17/21.	wmk.	original shell; adapted from RestartIncRawData;
#					jumpto function and references removed.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME env var changed to USER;RestartIncGeany added.
#
# Notes. The entire incremental dump collection for RawData will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}
P2=$2
if [ -z "$P1" ];then
 echo "RestartAllInc -l|-u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ "$P1" != "-L" ] && [ "$P1" != "-U" ];then
 echo "RestartAllInc -l|-u <mount-name> unrecognized option '$P1' - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
listonly=0
if [ "$P1" == "-L" ];then
 listonly=1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartAllIncs $P1 initiated from Make."
  echo "   RestartAllIncs $P1 initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartAllIncs $P1 initiated from Terminal."
  echo "   RestartAllIncs $P1 initiated."
fi
TEMP_PATH="$folderbase/temp"
 if ! test -d $U_DISK/$P2;then
  echo "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartAllIncs abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    echo "$P2 still not mounted - RestartAllIncs abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
    echo "continuing with $P2 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
 else
  echo "continuing with $P2 mounted..."
 fi  #end drive not mounted
cd $codebase/Projects-Geany/ArchivingBackups
ls Restart*.sh > RestartList.txt
# remove RestartAll and Biz territories for now..
sed -i '/RestartAll/ d' RestartList.txt
sed -i '/RestartIncBRURaw/ d' RestartList.txt
sed -i '/RestartIncBSCRaw/ d' RestartList.txt
sed -i '/RestartIncBTerrData/ d' RestartList.txt
if [ $listonly -ne 0 ];then
 echo "The following restarts will be performed..."
 cat RestartList.txt
 exit 0
else
 echo " **WARNING - proceeding will restart all incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
#  exit 0
  # insert code to process RestartList.txt here...
  file=$codebase/Projects-Geany/ArchivingBackups/RestartList.txt
  export NOPROMPT=1
  while read -e;do
   echo "Processing $REPLY ..."
   $codebase/Projects-Geany/ArchivingBackups/$REPLY fl sara 86777 -u $P2
  done < $file
 else
  ~/sysprocs/LOGMSG "  User halted RestartAllIncs."
  echo " Stopping RestartAllIncs - secure all incremental backups.."
  exit 0
 fi
fi		# listonly
#endprocbody
if [ $local_debug = 1 ]; then
  popd > /dev/null
fi
~/sysprocs/LOGMSG "  RestartAllIncs $P1 $P2 $P3 complete."
echo "  RestartAllIncs $P1 $P2 $P3 complete."
# end RestartAllIncs
