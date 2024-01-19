#!/bin/bash
echo " ** QCheckSCSpecDBs.sh out-of-date **";exit 1
echo " ** QCheckSCSpecDBs.sh out-of-date **";exit 1
# QCheckSCSpecDBs.sh -QuickCheck all SC /Special/<spec-db>.dbs against Terr86777.db
#	2/5/23.	wmk.
#
# Usage. bash  CheckSCSpecDBs.sh
#
# Entry.  /RefUSA-Downloads/Special/<spec-db1>.db .. <spec-dbn>.db present
#		  /DB-Dev/Terr86777.db = up-to-date SC county master data 
#
# Dependencies.
#
# Exit.	*thisproj/SCSpecOODlist.txt = list of out-of date RU <spec-db>.db,s
#		*thisproj/KillSync = semaphore file; if exists SCSpecOODlist.txt has entries.
#
# Modification History.
# ---------------------
# 2/5/23.	wmk.	original shell; adapted from CheckRUTerrs.
# 2/27/23.	wmk.	name change to "QCheck.." indicating "quick" check.
#
# Notes. QCheckSCSpecDBs tests the latest RecordDate found in <spec-db>.db
# against the latest DownloadDate found in Terr86777. If the latest date
# in Terr86777 is newer than the <spec-db>.db latest date, the <spec-db>.db
# is condidered out-of-date and reported to SCSpedOODlist.txt.
# 
# *make* can't handle *pushd/*popd so this goes into a .sh instead
# of a makefile.
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
if [ -z "rupath" ];then
 export rupath=RawData/RefUSA/RefUSA-Downloads
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  CheckSCSpecDBs - initiated from Make"
  echo "  CheckSCSpecDBs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckSCSpecDBs - initiated from Terminal"
  echo "  CheckSCSpecDBs - initiated from Terminal"
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
	if test -f $projpath/SCSpecOODlist.txt;then rm $projpath/SCSpecOODlist.txt;fi
	rusuffx=_RU.db
	mapsuffx=_RU.csv
	oodcount=0
	# loop checking all /RefUSA-Downloads/Special/<spec-db>.db files.
	pushd ./ > $TEMP_PATH/scratchfile
	cd $pathbase/$scpath/Special
	if test -f $TEMP_PATH/AllSCSpecDBs.txt;then rm $TEMP_PATH/AllSCSpecDBs.txt;fi
	ls -d *.db > $TEMP_PATH/AllSCSpecDBs.txt
	file=$TEMP_PATH/AllSCSpecDBs.txt
	echo "0" > $TEMP_PATH/counter
	while read -e;do
	 len=${#REPLY}
	 len1=$((len-1))
	 #specname=${REPLY:0:len-1}
	 specname=$REPLY
	 justdid=0
	 # check against latest SC master Terr86777.db
	 pushd ./ > $TEMP_PATH/scratchfile
	 cd $projpath
	 ./DoSed1.sh $pathbase/$scpath/Special $specname Spec_SCBridge
	 make --silent -f MakeLatestDwnldDate
	 ./LatestDwnldDate.sh
	 make --silent -f MakeGetLatestMaster
	 ./GetLatestMaster.sh
	 # *TEMP_PATH/LatestDwnldDate.txt is newest from <db-name>
	 popd > $TEMP_PATH/scratchfile
	 ls -lh $pathbase/DB-Dev/Terr86777.db > $projpath/Terr86777Date.txt
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
	  echo "** $specname is out-of-date **"; \
	  echo "$specname - older than Terr86777.db" >> $thisproj/SCSpecOODlist.txt;\
	   oodcount=$((oodcount+1));fi
	 if [ 1 -eq 0 ];then
	 #-------- old code --------------
	 if [ $pathbase/$scpath/Special/$specname \
	  -ot $pathbase/DB-Dev/Terr86777.db ];then \
	   echo "  ** $specname out-of-date **";\
	   echo "$specname - older than Terr86777.db" >> $thisproj/SCSpecOODlist.txt;\
	   oodcount=$((oodcount+1));fi
	 #-------- end old code ----------
	 fi
	 
	done < $file
	if [ $oodcount -gt 0 ];then \
	 echo " ** $oodcount /Special/<spec-db>.db,s out-of-date **"; \
	 echo "  file SCSpecOODlist.txt contains list.";\
	 echo " CheckSCSpecDBs FAILED - list on SCSpecOODlist.txt" >> $thisproj/KillSync;fi
	popd > $TEMP_PATH/scratchfile
	echo "  $oodcount <spec-db>.db,s out-of-date; *cat* SCSpecOODlist.txt for list." 
#endprocbody
echo "  CheckSCSpecDBs complete."
~/sysprocs/LOGMSG "  CheckSCSpecDBs complete."
# end CheckSCSpecDBs.sh
