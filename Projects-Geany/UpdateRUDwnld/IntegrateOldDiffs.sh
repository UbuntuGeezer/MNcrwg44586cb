#!/bin/bash
echo " ** IntegrateOldDiffs.sh out-of-date **";exit 1
echo " ** IntegrateOldDiffs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 6/17/21.	wmk.
#	Usage. bash IntegrateOldDiffs.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
P1=$1
TID=$P1
TN="Terr"
if [ "$HOME" == "/home/ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  ~/sysprocs/LOGMSG "  IntegrateOldDiffs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  IntegrateOldDiffs - initiated from Terminal"
  echo "  IntegrateOldDiffs - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#proc body here

echo "-- IntegrateOldDiffs.sq - Integrate older RU records into newer download."  > SQLTemp.sql
echo "--	9/8/21.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * 7/6/21.	wmk.	original SQL."  >> SQLTemp.sql
echo "-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same"  >> SQLTemp.sql
echo "-- *					UnitAddress after merge."  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * IntegrateOldDiffs - Integrate older RU records into newer download."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** IntegrateOldDiffs **********"  >> SQLTemp.sql
echo "-- *	9/8/21.	wmk."  >> SQLTemp.sql
echo "-- *----------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * IntegrateOldDiffs - Integrate older RU records into newer download."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	junk.db"  >> SQLTemp.sql
echo "-- *	Terr245_RU.db - as db12,"  >> SQLTemp.sql
echo "-- *	Terr245OldDiffs.csv - .csv records of older Bridge entries to"  >> SQLTemp.sql
echo "-- *	  integrate into Terr245_RU.db.Terr245_RUBridge"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	Terr245_RU.db - as db12,"  >> SQLTemp.sql
echo "-- *	  updated with records from Terr245OldDiffs.csv"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * 7/6/21.	wmk.	original SQL."  >> SQLTemp.sql
echo "-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same"  >> SQLTemp.sql
echo "-- *					UnitAddress after merge."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. IntegrateOldDiffs integrates the Terr245OldDiffs.csv Bridge"  >> SQLTemp.sql
echo "-- * records back into the current Terr245_RUBridge table, leaving the"  >> SQLTemp.sql
echo "-- * RecordDate intact from the old record, but changing the Resident1"  >> SQLTemp.sql
echo "-- * field to \"?\" indicating that the address is valid, but there was no"  >> SQLTemp.sql
echo "-- * RefUSA record for it with the latest download. (Note: if the DoNotCall"  >> SQLTemp.sql
echo "-- * status changed, it will not be picked up here.)"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$folderbase/Territories/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ".cd '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads'"  >> SQLTemp.sql
echo "ATTACH './Terr245/Terr245_RU.db'"  >> SQLTemp.sql
echo " AS db12;"  >> SQLTemp.sql
echo "-- pragma db12.table_info(Terr245_RUBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".import './Terr245/Terr245OldDiffs.csv' Terr245_RUBridge"  >> SQLTemp.sql
echo "UPDATE db12.Terr245_RUBridge"  >> SQLTemp.sql
echo "SET UnitAddress = trim(UnitAddress);"  >> SQLTemp.sql
echo "DELETE FROM db12.Terr245_RUBridge"  >> SQLTemp.sql
echo "WHERE rowid NOT IN (SELECT MAX(rowid) from Terr245_RUBridge"  >> SQLTemp.sql
echo "		GROUP BY UnitAddress, Unit, Resident1);"  >> SQLTemp.sql
echo "DETACH db12;"  >> SQLTemp.sql
echo "--DETACH db12;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END IntegrateOldDiffs **********;"  >> SQLTemp.sql

#end proc body
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#notify-send "IntegrateOldDiffs.sh" "IntegrateOldDiffs processing complete. $P1"
echo "  IntegrateOldDiffs complete."
~/sysprocs/LOGMSG "  IntegrateOldDiffs complete."
#end proc
