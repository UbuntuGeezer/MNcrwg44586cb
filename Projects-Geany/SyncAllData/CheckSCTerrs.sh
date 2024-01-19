# CheckSCTerrs.sh - Flag RU updates to RUtidList.txt
echo " ** CheckSCTerrs.sh out-of-date **";exit 1
echo " ** CheckSCTerrs.sh out-of-date **";exit 1
#	5/14/23.	wmk.
#
# Usage. bash  CheckSCTerrs.sh <startTID> <endTID>
#
#	<startTID> = (optional) starting territory ID
#	<endTID> = (optional, mandaory if <startTID> present) ending territory ID
#
# Entry. 
#
# Dependencies.
#
#	 make --silent -f MakeLatestDwnldDate
#	 ./LatestDwnldDate.sh
#	 make --silent -f MakeGetLatestMaster
#	 MakeGetLatestMaster
#
# 	MakeLatestDwnldDate extracts the MAX(DownloadDate) from the Terrxxx_SC.db.
#	MakeGetLastestMaster extracts the MAX(DownloadDate) from the properties in
#	 Terrxxx in Terr86777.db
#
#	If LatestDownloadDate is < LatestMasterDate, Terrxxx_SC.db is out-of-date.
#	UpdateSCBridge needs to be run for Terrxxx.
#
# Exit.	*thisproj/SCoodList.txt = list of out-of date territories
#		*thisproj/KillSync = semaphore file; if exists RUoodList.txt has entries.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
# 2/17/23.	wmk.	parameters added to termination message.
# 3/16/23.	wmk.	pushd, read -e and popd forced to *bash since *Make problematic.
# 5/14/23.	wmk.	*make calls using --silent mode; BLDMSG messages added.
# Notes. *make* can't handle *pushd/*popd so this goes into a .sh instead
# of a makefile. The former MakeCheckSCTerrs have been modified to throw an
# error if mistakenly used.
#
P1=$1	# start terr ID
P2=$2	# end terr ID
if [ ! -z "$P1" ] && [ -z "$P2" ];then
 echo "CheckSCTerrs [<start-tid> <end-tid>] missing <end-tid> - abandoned."
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
  ~/sysprocs/LOGMSG "  CheckSCTerrs - initiated from Make"
  echo "  CheckSCTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckSCTerrs - initiated from Terminal"
  echo "  CheckSCTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub//TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	export projpath=$codebase/Projects-Geany/SyncAllData
	export thisproj=$codebase/Projects-Geany/SyncAllData
	export sctblsuffx=_SCBridge
	oops=0
	remake=0
	oodcount=0		# out-of-date counter
	namesuffx=_SC.db
	$$(pushd ./ > $TEMP_PATH/scratchfile)
	cd $pathbase/$scpath
	ls -d Terr* > $projpath/SCTerrList.txt
	sed -in '/TerrFix/d' $projpath/SCTerrList.txt
	file=$projpath/SCTerrList.txt
	# loop on all SCPA-Downloads/Terrxxx folders checking Terrxxx_SCdb
	#  date against Terr86777.db date.
	$$(while read -e;do)
	  export Terr=$REPLY
	  export SCdbName=$Terr$namesuffx
	  export SCtblName=$Terr$sctblsuffx
# skip this for mobile home parks.
skip=0
terrno=${REPLY:4:3}
#echo "territory $terrno..."
if (( $terrno >= 261  &&  $terrno <= 264 ))  \
  ||  (($terrno >= 317  &&  $terrno <= 321 )) \
  ||  (($terrno >= 235  &&  $terrno <= 251 ))\
  ||  (($terrno == 268  || $terrno == 269 ));then
 skip=1
# echo "  Skipping $REPLY ..."
fi
if [ $doall -eq 0 ];then 
 if [ $terrno -lt $P1 ] || [ $terrno -gt $P2 ];then
  skip=1
#  echo "  Skipping $REPLY ..."
 fi
fi
if test -f $pathbase/$scpath/$terrno/OBSOLETE;then
 echo " ** Territory $terrno OBSOLETE - skipping..**"
 skip=1
fi
if [ $skip -eq 0 ];then
	 echo "  processing $REPLY ..."
	 $$(pushd ./ > $TEMP_PATH/scratchfile)
	 cd $projpath
	 ./DoSed1.sh $pathbase/$scpath $SCDBname $SCtblName
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
	 if [ $pathbase/$scpath/$Terr/segdefs.csv -nt $pathbase/$scpath/$Terr/$SCdbName ];then
	  echo "** $SCdbName is out-of-date **"; \
	  echo "$SCdbName - older than segdefs.csv" >> $thisproj/SCoodlist.txt;\
	  ~/sysprocs/BLDMSG "$SCdbName - older than segdefs.csv";oodcount=$((oodcount+1));fi
	 #

fi	#end skip=0
	done < $file
	if [ $oodcount -gt 0 ];then \
	 echo " ** $oodcount SCPA territories out-of-date **";echo "  file SCoodList.txt contains list.";\
	 echo " also check *build_log...";fi
	$$(popd > $TEMP_PATH/scratchfile)
echo "  CheckSCTerrs complete."
~/sysprocs/LOGMSG "  CheckSCTerrs complete."
# end CheckSCTerrs.sh
