#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash  AllSpecDiffs.sh
#		
# Dependencies.
#	SCPA-Downloads/Special/SpecialDBNames = list of special DB names.
#
#
# Modification History.
# ---------------------
# 1/31/23.	wmk.	original code; adapted from OutofDates.sh
# Legacy mods.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# 12/11/22.	wmk.	run SetToday.sh to export TODAY env var.
# 12/12/22.	wmk.	SetTody.sh path corrected.
# Legacy mods.
# 4/23/22.	wmk.	modified for FL/SARA/86777.
# 4/22/22.	wmk.	HOME changed to USER in host check.
# Legacy mods.
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 4/8/22.	wmk.	HOME changed to USER in host test.	
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
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  AllSpecDiffs - initiated from Make"
  echo "  AllSpecDiffs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  AllSpecDiffs - initiated from Terminal"
  echo "  AllSpecDiffs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere
# loop reading /Special/SpecialDBNames..
file=$pathbase/$scpath/Special/SpecialDBList.txt
projpath=$codebase/Projects-Geany/FlagSpecSCUpdates
cd $projpath
while read -e;do
 echo "processing $REPLY..."
 len=${#REPLY}
 len1=$((len-1))
 dbname=${REPLY:0:len}
 sed "s?<spec-db>?$dbname?g" $projpath/OutofDates.psq > $projpath/OutofDates.sql
 pushd ./ > $TEMP_PATH/scratchfile
 cd $codebase/Projects-Geany/AnySQLtoSH
 ./DoSed.sh $projpath OutofDates
 make -f ./MakeAnySQLtoSH
 popd > $TEMP_PATH/scratchfile
 $projpath/OutofDates.sh
done <$file
exit 0
echo "-- * OutOfDates.sql - search DBList databases for out-of-date records."  > SQLTemp.sql
echo "-- * 1/31/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 1/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. OutOfDates compares records from <special-db> against the corresponding"  >> SQLTemp.sql
echo "-- * records in Terr86777, building an OutofDates table in SCPA.Special/SpecialDBs.db."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/SpecialDBs.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Special/VillageCir.db'"  >> SQLTemp.sql
echo " AS db29;"  >> SQLTemp.sql
echo "CREATE TABLE IF NOT EXISTS OutOfDates("  >> SQLTemp.sql
echo " DBName TEXT, PropID TEXT,"  >> SQLTemp.sql
echo " PRIMARY KEY(PropID) );"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  OutofDates complete."
~/sysprocs/LOGMSG "  OutofDates complete."
#end proc
