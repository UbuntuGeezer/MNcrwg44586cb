#!/bin/bash
echo " ** RefreshAllSCTerrLists.sh out-of-date **";exit 1
echo " ** RefreshAllSCTerrLists.sh out-of-date **";exit 1
# RefreshAllSCTerrLists.sh - Refresh all SC/Special databases TerrList tables.
# 2/20/23.	wmk.
#
# Usage. bash  RefreshAllSCTerrLists.sh  [< special-db >]
#
#	< special-db > = (optional) single special db to run RefreshAllSCTerrLists on.
#
# Entry. SCPA-Downloads/Special/< special -db >.dbs are SC special downloads.
#		 < special-db >.db.TerrList is territory list and counts table.
#
# Exit.	< special-db >.db.TerrList tables rebuilt.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/20/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
doall=1
if [ ! -z "$P1" ];then
 doall=0
 if [[ "$P1" =~ /.*\.db/ ]];then
  dbname=$P1
 else
  dbname=$P1.db
 fi
fi # nonempty P1
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
  ~/sysprocs/LOGMSG "  RefreshAllSCTerrLists - initiated from Make"
  echo "  RefreshAllSCTerrLists - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RefreshAllSCTerrLists - initiated from Terminal"
  echo "  RefreshAllSCTerrLists - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/SyncAllData
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$scpath/Special
if [ $doall -eq 0 ];then
 $projpath/DoSed1.sh $pathbase/$scpath/Special $P1 TerrList
 make --silent -f $projpath/MakeRefreshSCTerrIDs
 if ! test -f $projpath/RefreshSCTerrIDs.sh;then
  echo " ** MakeRefreshSCTerrIDs FAILED - aborting. **";exit 1;fi
 $projpath/RefreshSCTerrIDs.sh
else
 ls *.db > $TEMP_PATH/SpecDBList.txt
 file=$TEMP_PATH/SpecDBList.txt
 cd $projpath
 while read -e;do
  $projpath/DoSed1.sh $pathbase/$scpath/Special $REPLY TerrList
  make --silent -f $projpath/MakeRefreshSCTerrIDs
  if ! test -f $projpath/RefreshSCTerrIDs.sh;then
   echo " ** MakeRefreshSCTerrIDs FAILED - aborting. **";exit 1; fi
  $projpath/RefreshSCTerrIDs.sh
done < $file
fi	# end doall
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  RefreshAllSCTerrLists complete."
~/sysprocs/LOGMSG "  RefreshAllSCTerrLists complete."
# end RefreshAllSCTerrLists.sh
