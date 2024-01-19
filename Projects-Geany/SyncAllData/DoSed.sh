#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# DoSed.sh - *sed modify makefiles for SyncAllData.
#	2/19/23.	wmk.
#
# Usage. bash  DoSed.sh  <mm> <dd> [<start-tid> <end-tid>]
#
#	<mm> = month of lastest SCPA download
#	<dd> = day of latest SCPA download
#	<start-tid> = (optional) starting territory ID to synchronize
#	<end-tid> = (optional, mandatory if <start-tid> present) ending territory
#
# Entry. *PWD/MakeCheckMaster.tmp = makefile for CheckMaster
#		 *PWD/MakeSyncAllData.tmp = makefile for SyncAllData
#
# Dependencies.
#
# Exit.	*PWD/MakeCheckMaster = CheckMaster.sh makefile
#		*PWD/MakeSyncAllData = SyncAllData makefile
#
# Modification History.
# ---------------------
# 2/4/23.	wmk.	original shell.
# 2/5/23.	wmk.	modified to edit MakeSyncAllData.tmp
# 2/16/23.	wmk.	<start-tid>, <end-tid> support; documentation improved.
# 2/19/23.	wmk.	MakePubTerr added to edit list; .tmp suffixes removed
#			 from *sed target file headers.
#
# Notes. DoSed udpates all of the SyncAllData *make* files with the newest
# SCPA download month/day and, if specified, the range of territories to
# synchronize. The MakeSyncAllData build will then move through each
# "Check" process and will halt at any point where data needs to be brought
# up-to-date. CheckMaster and SyncAllData handle the downstream processes.
#
# set parameters P1..Pn here..
P1=$1		# mm
P2=$2		# dd
P3=$3		# <start-tid>
P4=$4		# <end-tid>
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSed <mm> <dd> [<start-tid> <end-tid>] missing parameter(s) - abandoned."
 exit 1
fi
if [ ! -z "$P3" ] && [ -z "$P4" ];then
 echo "DoSed <mm> <dd> [<start-tid> <end-tid>] missing <end-tid> - abandoned."
 exit 1
fi
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  DoSed - initiated from Make"
  echo "  DoSed - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSed - initiated from Terminal"
  echo "  DoSed - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?mm?$P1?g;s?dd?$P2?g;s?yyy?$P3?g" MakePubTerr.tmp > MakePubTerr
sed -i "s?<start-tid>?$P3?g;s?<end-tid>?$P4?g" MakePubTerr
sed -i "s?MakePubTerr.tmp?MakePubTerr?" MakePubTerr
sed "s?mm?$P1?g;s?dd?$P2?g" MakeCheckMaster.tmp > MakeCheckMaster
sed -i "s?MakeCheckMaster.tmp?MakeCheckMaster?" MakeCheckMaster
sed "s?@@?$P1?g;s?zz?$P2?g" MakeSyncAllData.tmp > MakeSyncAllData
sed -i "s?<start-tid>?$P3?g;s?<end-tid>?$P4?g" MakeSyncAllData
sed -i "s?MakeSyncAllData.tmp?MakeSyncAllData?" MakeSyncAllData
if [ "$P3" == "$P4" ];then
 echo "** Be sure to 'export batchrun=0' before *make MakePubTerr **"
fi
#endprocbody
echo "  DoSed complete."
~/sysprocs/LOGMSG "  DoSed complete."
# end DoSed.sh
