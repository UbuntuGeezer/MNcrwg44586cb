#!/bin/bash
echo " ** CheckQTerrs.sh out-of-date **";exit 1
echo " ** CheckQTerrs.sh out-of-date **";exit 1
# CheckQTerrs.sh - Check for QTerrxxx.csv files out-of-date.
# 4/2/23.	wmk.
#
# Usage. bash  CheckQTerrs.sh [<start-tid> <end-tid>]
#
#	<start-tid> = (optional) starting territory ID to synchronize
#	<end-tid> = (optional, mandatory if <start-tid> present) ending territory
#
# Entry. *RefUSA-Downloads/TerrData/WorkingFiles/QTerrxxx.csv must exist.
#		 *RefUSA-Downloads/Terryyy_RU.db must exist.
#		 *SCPA-Downlloads/Terryyy_SC.db must exist.
#
# Dependencies.
#
# Exit.	*thisproj/SCoodList.txt = list of out-of date territories
#		*thisproj/KillSync = semaphore file; if exists SCoodList.txt has entries.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell.
# 2/5/23.	wmk.	parameters documented in header; KillSync semaphore
#			 support added.
# 2/16/23.	wmk.	<start_tid> <end-tid> support.
# 2/17/23.	wmk.	parameters added to termination message.
# 4/2/23.	wmk.	bug fix *scpath incorrect in QTerrxxx date comparison.
#
# Notes. If either *RefUSA-Downloads/Terrxxx/Terrxxx_RU.db or
# *SCPA-Downloads/Terrxxx/Terrxxx_SC.db is newer than 
# TerrData/Terrxxx/Working-Files/QTerrxxx.csv, then QTerrxxx.csv
# is out-of date.
#
# set parameters P1..Pn here..
#
P1=$1		# <start-tid>
P2=$2		# <end-tid>
if [ ! -z "$P1" ] && [ -z "$P2" ];then
 echo "CheckQTerrs [<start-tid> <end-tid>] missing <end-tid> - abandoned."
 exit 1
fi
doall=1		# do all territories flag
if [ ! -z "$P1" ];then
 doall=0
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
  ~/sysprocs/LOGMSG "  CheckQTerrs - initiated from Make"
  echo "  CheckQTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckQTerrs - initiated from Terminal"
  echo "  CheckQTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	thisproj=$codebase/Projects-Geany/SyncAllData
	oops=0
	remake=0
	oodcount=0		# out-of-date counter
	SCsuffx=_SC.db
	RUsuffx=_RU.db
	pushd ./ > $TEMP_PATH/scratchfile
	cd $pathbase/$scpath
	ls -d Terr* > $thisproj/SCTerrList.txt
	sed -in '/TerrFixList/d' $thisproj/SCTerrList.txt
	file=$thisproj/SCTerrList.txt
	# loop on all SCPA-Downloads/Terrxxx folders checking Terrxxx_SCdb
	#  date against Terr86777.db date.
	while read -e;do
	  TID=${REPLY:4:3}
  skip=0
  if [ $doall -eq 0 ];then
   if [ $TID -lt $P1 ] || [ $TID -gt $P2 ];then
    skip=1
   fi
  fi
  if [ $skip -eq 0 ];then
	  Terr=Terr$TID
	  SCdbName=$Terr$SCsuffx
	  RUdbName=$Terr$RUsuffx
	  QTName=QTerr$TID.csv
	  if [ $pathbase/$rupath/$Terr/$RUdbName -nt $pathbase/TerrData/$Terr/Working-Files/$QTName ] \
	   || [ $pathbase/$scpath/$Terr/$SCdbName -nt $pathbase/TerrData/$Terr/Working-Files/$QTName ];then \
	   echo "  ** $QTName out-of-date **";\
	   echo "$QTName - older than $RUdbName or $SCdbName" >> $thisproj/QToodList.txt;oodcount=$((oodcount+1));fi
  fi # skip
	done < $file
	if [ $oodcount -gt 0 ];then \
	 echo " ** $oodcount TerrData territories out-of-date **";echo "  file QToodList.txt contains list.";\
	 echo " CheckQTerrs FAILED - list on QToodList.txt" >> $thisproj/KillSync;fi
	popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  CheckQTerrs $P1 $P2 complete."
~/sysprocs/LOGMSG "  CheckQTerrs $P1 $P2 complete."
# end CheckQTerrs.sh
