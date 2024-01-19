#!/bin/bash
echo " ** SetAllDBcsvDate.sh out-of-date **";exit 1
echo " ** SetAllDBcsvDate.sh out-of-date **";exit 1
# SetAllDBcsvDate.sh - Set all SC/Special databases RecordDate fields to .csv date.
# 2/27/23.	wmk.
#
# Usage. bash  SetAllDBcsvDate.sh  [< special-db >]
#
#	< special-db > = (optional) single special db to run SetAllDBcsvDate on.
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
# 2/27/23.	wmk.	original shell; adapted from RefreshAllSCTerrIDs.
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
  ~/sysprocs/LOGMSG "  SetAllDBcsvDate - initiated from Make"
  echo "  SetAllDBcsvDate - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SetAllDBcsvDate - initiated from Terminal"
  echo "  SetAllDBcsvDate - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/SyncAllData
export csvdate=dummy
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$scpath/Special
if [ $doall -eq 0 ];then
 $projpath/DoSed1.sh $pathbase/$scpath/Special $P1 TerrList
 . $projpath/SetCSVDate.sh $P1
 make --silent -f $projpath/MakeSetDBcsvDate
 if ! test -f $projpath/SetDBcsvDate.sh;then
  echo " ** Make SetDBcsvDate FAILED - aborting. **";exit 1;fi
  $projpath/SetDBcsvDate.sh $P1
  echo " RecordDate fields set to $csvdate in $csvname."
else
 ls *.db > $TEMP_PATH/SpecDBList.txt
 file=$TEMP_PATH/SpecDBList.txt
 cd $projpath
 while read -e;do
  $projpath/DoSed1.sh $pathbase/$rupath/Special $REPLY Spec_RUBridge
  make --silent -f $projpath/MakeSetDBcsvDate
  if ! test -f $projpath/SetDBcsvDate.sh;then
   echo " ** MakeSetDBcsvDate FAILED - aborting. **";exit 1; fi
  #$projpath/SetDBcsvDate.sh $REPLY
done < $file
fi	# end doall
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  SetAllDBcsvDate complete."
~/sysprocs/LOGMSG "  SetAllDBcsvDate complete."
# end SetAllDBcsvDate.sh
