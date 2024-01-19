#!/bin/bash
# InitFlashDrive.sh - Initialize flash drive for archiving.
#	8/15/23.	wmk.
#
# Usage. bash  InitFlashDrive.sh <state> <county> <congno> -u <mount-name>
#
#	<state>
#	<county>
#	<congno>
#	-u
#	<mount-name> = flash drive mount name
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 8/15/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 7/12/23.	wmk.	original shell.
#
# Notes. 
#
# P1=<state> P2=<county> P3=<congno> P4=-u P5=<mount-name>
#
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4,,}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "InitFlashDrive <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  InitFlashDrive - initiated from Make"
  echo "  InitFlashDrive - initiated from Make"
else
  ~/sysprocs/LOGMSG "  InitFlashDrive - initiated from Terminal"
  echo "  InitFlashDrive - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
if [ "$P4" != "-u" ];then
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
else
    echo "continuing with $P5 mounted..."
fi  #end drive not mounted
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/MNcrwg44586/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > /dev/null
cd $U_DISK/$P5
main_folder=$P1$P2$P3
if ! test -d $main_folder;then
 mkdir $main_folder
fi
cd $main_folder
if ! test -d log;then
 mkdir log
fi
popd > /dev/null
#endprocbody
echo "  InitFlashDrive $P1 $P2 $P3 $P4 $P5 complete."
~/sysprocs/LOGMSG "  InitFlashDrive $P1 $P2 $P3 $P4 $P5 complete."
# end InitFlashDrive.sh
