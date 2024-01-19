#!/bin/bash
echo " ** CheckSpecSCTerrs.sh out-of-date **";exit 1
echo " ** CheckSpecSCTerrs.sh out-of-date **";exit 1
# CheckSpecSCTerrs.sh - Check Special SC territories up-to-date.
# 5/14/23.	wmk.
#
# Usage. bash  CheckSpecSCTerrs.sh [<start-tid> <end-tid>]
#
#	<start-tid> = (optional) starting territory ID to check
#	<end-tid> = (optional, mandatory if <start-tid> present) ending territory
#				 ID to check
#
# Entry.  SyncTerrData/SCTerrList.txt contains list of territories that use a
#			given SCPA-Downloads/<spec-db>.db
#			 
# Dependencies.
#
# Exit.	*thisproj/SCoodList.txt = list of out-of date territories
#		*thisproj/KillSync = semaphore file; if exists SCoodList.txt has entries.
#
# Modification History.
# ---------------------
# 2/19/23.	wmk.	original shell; adpated from CheckSCTers.
# 5/14/23.	wmk.	BLDMSG messages added; dead code block removed.
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1		# <start-tid>
P2=$2
if [ ! -z "$P1" ] && [ -z "$P2" ];then
 echo " ** CheckSpecSCTerrs.sh [<start-tid> <end-tid>] missing <end-tid> - abandoned. **"
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
  ~/sysprocs/LOGMSG "  CheckSpecSCTerrs - initiated from Make"
  echo "  CheckSpecSCTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckSpecSCTerrs - initiated from Terminal"
  echo "  CheckSpecSCTerrs - initiated from Terminal"
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
	namesuffx=_SC.db
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
  if ! test -f $pathbase/$scpath/$Terr/SPECIAL;then
   skip=1
  fi
  if [ $skip -eq 0 ];then
	  Terr=Terr$TID
	  Spec=Spec$TID
	  SCdbName=$Spec$namesuffx
	  SCtblName=Spec_RUBridge
	 echo "  processing $REPLY ..."
	 pushd ./ > $TEMP_PATH/scratchfile
	 cd $projpath
	 ./DoSed1.sh $pathbase/$scpath $SCdbName $SCtblName
	 make --silent -f MakeLatestDwnldDate
	 ./LatestDwnldDate.sh
	 make --silent -f MakeGetLatestMaster
	 ./GetLatestMaster.sh
	 # *TEMP_PATH/LatestDwnldDate.txt is newest from <db-name>
	 popd > $TEMP_PATH/scratchfile
	 #ls -lh $pathbase/DB-Dev/Terr86777.db > $projpath/Terr86777Date.txt
	 mawk -F "," '{print "export date1="$1}' $TEMP_PATH/LatestDwnldDate.txt > set1.sh
	 mawk -F "," '{print "export date2="$2}' $TEMP_PATH/LatestMasterDate.txt > set2.sh
	 # mawk '{print "export date2="$6}' $projpath/Terr86777Date.txt > set2.sh
	 chmod +x set1.sh
	 chmod +x set2.sh
	 . ./set1.sh
	 . ./set2.sh
#	 echo "($specname) date1 = $date1;  (Terr86777.db) date2 = $date2"
	 ndate1=$(date --date=$date1 '+%s')
	 ndate2=$(date --date=$date2 '+%s')
#	 echo "($specname) date1 = $ndate1;  (Terr86777.db) date2 = $ndate2"
	 #read -p "Enter ctrl-c to remain in terminal: "
	 if [ $ndate1 -lt $ndate2 ];then \
	  echo "** $SCdbName is out-of-date **"; \
	  echo "$specname - older than Terr86777.db" >> $thisproj/SCoodlist.txt;\
	  ~/sysprocs/BLDMSG "$specname - older than Terr86777.db";oodcount=$((oodcount+1));fi

  fi # skip
	done < $file
	if [ $oodcount -gt 0 ];then \
	 echo " ** $oodcount SCPA special territories out-of-date **";echo "  file SCoodList.txt contains list.";\
	 echo " CheckSpecSCTerrs FAILED - list on SCoodList.txt" >> $thisproj/KillSync;\
	 echo " also check *build_log...";fi
	popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  CheckSpecSCTerrs $P1 $P2complete."
~/sysprocs/LOGMSG "  CheckSpecSCTerrs $P1 $P2 complete."
# end CheckSpecSCTerrs.sh
