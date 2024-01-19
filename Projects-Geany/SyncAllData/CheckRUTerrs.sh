#!/bin/bash
echo " ** CheckRUTerrs.sh out-of-date **";exit 1
echo " ** CheckRUTerrs.sh out-of-date **";exit 1
# CheckRUTerrs.sh - Flag RU updates to RUtidList.txt
#	6/6/23.	wmk.
#
# Usage. bash  CheckRUTerrs.sh <startTID> <endTID>
#
#	<startTID> = (optional) starting territory ID
#	<endTID> = (optional, mandaory if <startTID> present) ending territory ID
#
# Entry. 
#
# Dependencies.
#
# Exit.	*thisproj/RUoodList.txt = list of out-of date territories
#		*thisproj/KillSync = semaphore file; if exists RUoodList.txt has entries.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
# 2/17/23.	wmk.	parameters added to termination message.
# 3/12/23.	wmk.	*batchrun support.
# 6/6/23.	wmk.	OBSOLETE terrtiory detection added.
#
# Notes. *make* can't handle *pushd/*popd so this goes into a .sh instead
# of a makefile.
#
P1=$1	# start terr ID
P2=$2	# end terr ID
if [ ! -z "$P1" ] && [ -z "$P2" ];then
 echo "CheckRUTerrs [<start-tid> <end-tid>] missing <end-tid> - abandoned."
 exit 1
fi
doall=1		# do all territories flag
if [ ! -z "$P1" ];then
 doall=0
fi
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
if [ -z "rupath" ];then
 export rupath=RawData/RefUSA/RefUSA-Downloads
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  CheckRUTerrs - initiated from Make"
  echo "  CheckRUTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckRUTerrs - initiated from Terminal"
  echo "  CheckRUTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	export projpath=$codebase/Projects-Geany/SyncAllData
	export thisproj=$codebase/Projects-Geany/SyncAllData
	if [ $batchrun -eq 0 ];then
	 if test -f $projpath/RUtidList.txt;then rm $projpath/RUtidList.txt;fi
	 if test -f $projpath/RUoodList.txt;then rm $projpath/RUoodList.txt;fi
	fi
	touch $projpath/RUtidList.txt
	rusuffx=_RU.db
	mapsuffx=_RU.csv
	oodcount=0
	# loop checking all /RefUSA-Downloads/Terryyy folders.
	pushd ./ > $TEMP_PATH/scratchfile
	cd $pathbase/$rupath
	if test -f $TEMP_PATH/AllRUTerrs.txt;then rm $TEMP_PATH/AllRUTerrs.txt;fi
	if [ $doall -gt 0 ];then
	 ls -d Terr* > $TEMP_PATH/AllRUTerrs.txt
	else
	 seq $P1 $P2 > $TEMP_PATH/NumList.txt
	 file=$TEMP_PATH/NumList.txt
	 while read -e;do
	  echo "Terr$REPLY" > $TEMP_PATH/AllRUTerrs.txt
	 done < $file
	fi
	file=$TEMP_PATH/AllRUTerrs.txt
	echo "0" > $TEMP_PATH/counter
	while read -e;do
	 TID=${REPLY:4:3}
  skip=0
  if [ $doall -eq 0 ];then
   if [ $TID -lt $P1 ] || [ $TID -gt $P2 ];then
    skip=1
   fi
  fi
  if test -f $pathbase/$rupath/$TID/OBSOLETE;then
   echo "   ** Territory $TID is OBSOLETE - CheckRUTerrs skipping..."
   skip=1
  fi
  if [ $skip -eq 0 ];then
	 Terr=Terr$TID
	 Map=Map$TID
	 RUdbName=$Terr$rusuffx
	 justdid=0
	 # check against Map .csv
	 if [ $pathbase/$rupath/Terr$TID/Terr$TID$rusuffx \
	  -ot $pathbase/$rupath/Terr$TID/Map$TID$rusuffx ];then \
	   echo "  ** $RUdbName out-of-date **";\
	   ~/sysprocs/BLDMSG "$RUdbName - older than $Map$mapsuffx"; \
	   echo "$RUdbName - older than $Map$mapsuffx" >> $thisproj/RUoodList.txt;oodcount=$((oodcount+1));\
	  echo "$TID" >> $projpath/RUtidList.txt;oodcount=$((oodcount+1));justdid=1;fi
	 # check against latest SC master Terr86777.db
	 if [ $pathbase/$rupath/Terr$TID/Terr$TID$rusuffx \
	  -ot $pathbase/DB-Dev/Terr86777.db ];then \
	   echo "  ** $RUdbName out-of-date **";\
	   ~/sysprocs/BLDMSG "$RUdbName - older than Terr86777.db"; \
	   echo "$RUdbName - older than Terr86777.db" >> $thisproj/RUoodList.txt;\
	   if [ $justdid -eq 0 ];then \
	    echo "$TID" >> $projpath/RUtidList.txt;oodcount=$((oodcount+1));fi;fi
  fi # skip
	done < $file
	if [ $oodcount -gt 0 ];then \
	 echo " ** $oodcount RefUSA territories out-of-date **";echo "  file RUoodList.txt contains list.";\
	 echo " also check *build_log...";\
	 echo " CheckRUTerrs FAILED - list on RUoodList.txt" >> $thisproj/KillSync;fi
	popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  CheckRUTerrs $P1 $P2 complete."
~/sysprocs/LOGMSG "  CheckRUTerrs $P1 $P2 complete."
# end CheckRUTerrs.sh
