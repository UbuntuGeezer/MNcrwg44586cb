#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash IntegrateOldDiffs.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
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
P1=$1
TID=$P1
TN="Terr"
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
  ~/sysprocs/LOGMSG "  IntegrateOldDiffs - initiated from Make"
  echo "  IntegrateOldDiffs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  IntegrateOldDiffs - initiated from Terminal"
  echo "  IntegrateOldDiffs - initiated from Terminal"
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

echo "-- IntegrateOldDiffs.sq - Integrate older RU records into newer download."  > SQLTemp.sql
echo "-- *	6/7/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * 5/28/22.	wmk.	(automated) *pathbase* integration."  >> SQLTemp.sql
echo "-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777."  >> SQLTemp.sql
echo "-- * 6/7/22.	wmk.	code check migrating to FL/SARA/86777"  >> SQLTemp.sql
echo "-- * Legacy  mods."  >> SQLTemp.sql
echo "-- * 7/6/21.	wmk.	original SQL."  >> SQLTemp.sql
echo "-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same"  >> SQLTemp.sql
echo "-- *					UnitAddress after merge."  >> SQLTemp.sql
echo "-- * 9/9/21.	wmk.	cloned into UpdateMHPDwnld from UpdateRUDwnld project."  >> SQLTemp.sql
echo "-- * 11/14/21.	wmk.	bug fix where newly inserted ? records with older "  >> SQLTemp.sql
echo "-- *					dates supplanting newer records with valid names;"  >> SQLTemp.sql
echo "-- *					add code to delete duplicate rows after getting"  >> SQLTemp.sql
echo "-- *					newest records."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * IntegrateOldDiffs - Integrate older RU records into newer download."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** IntegrateOldDiffs **********"  >> SQLTemp.sql
echo "-- *	6/7/22.	wmk."  >> SQLTemp.sql
echo "-- *----------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * IntegrateOldDiffs - Integrate older RU records into newer download."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	junk.db"  >> SQLTemp.sql
echo "-- *	Terr262_RU.db - as db12,"  >> SQLTemp.sql
echo "-- *	Terr262OldDiffs.csv - .csv records of older Bridge entries to"  >> SQLTemp.sql
echo "-- *	  integrate into Terr262_RU.db.Terr262_RUBridge"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	Terr262_RU.db - as db12,"  >> SQLTemp.sql
echo "-- *	  updated with records from Terr262OldDiffs.csv"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/7/22.	wmk.	code check migrating to FL/SARA/86777"  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 7/6/21.	wmk.	original SQL."  >> SQLTemp.sql
echo "-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same"  >> SQLTemp.sql
echo "-- *					UnitAddress after merge."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. IntegrateOldDiffs integrates the Terr262OldDiffs.csv Bridge"  >> SQLTemp.sql
echo "-- * records back into the current Terr262_RUBridge table, leaving the"  >> SQLTemp.sql
echo "-- * RecordDate intact from the old record, but changing the Resident1"  >> SQLTemp.sql
echo "-- * field to \"?\" indicating that the address is valid, but there was no"  >> SQLTemp.sql
echo "-- * RefUSA record for it with the latest download. (Note: if the DoNotCall"  >> SQLTemp.sql
echo "-- * status changed, it will not be picked up here.)"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ".cd '$pathbase/RawData/RefUSA/RefUSA-Downloads'"  >> SQLTemp.sql
echo "ATTACH './Terr262/Terr262_RU.db'"  >> SQLTemp.sql
echo " AS db12;"  >> SQLTemp.sql
echo "-- pragma db12.table_info(Terr262_RUBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo "CREATE TEMP TABLE OldRecs"  >> SQLTemp.sql
echo "( \"OwningParcel\" TEXT NOT NULL, \"UnitAddress\" TEXT NOT NULL, \"Unit\" TEXT,"  >> SQLTemp.sql
echo " \"Resident1\" TEXT, \"Phone1\" TEXT, \"Phone2\" TEXT, \"RefUSA-Phone\" TEXT,"  >> SQLTemp.sql
echo " \"SubTerritory\" TEXT, \"CongTerrID\" TEXT, \"DoNotCall\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RSO\" INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RecordDate\" REAL DEFAULT 0, \"SitusAddress\" TEXT, \"PropUse\" TEXT,"  >> SQLTemp.sql
echo "  \"DelPending\" INTEGER DEFAULT 0, \"RecordType\" TEXT);"  >> SQLTemp.sql
echo ".import './Terr262/Terr262OldDiffs.csv' OldRecs"  >> SQLTemp.sql
echo "INSERT INTO Terr262_RUBridge"  >> SQLTemp.sql
echo "SELECT"  >> SQLTemp.sql
echo " \"OwningParcel\" , \"UnitAddress\" , \"Unit\" ,"  >> SQLTemp.sql
echo " \"?\" , \"Phone1\" , \"Phone2\" , \"\" ,"  >> SQLTemp.sql
echo " \"SubTerritory\" , \"CongTerrID\" , \"DoNotCall\" ,"  >> SQLTemp.sql
echo " \"RSO\" , \"Foreign\" ,"  >> SQLTemp.sql
echo " \"RecordDate\" , \"SitusAddress\" , \"PropUse\" ,"  >> SQLTemp.sql
echo "  \"DelPending\" , \"RecordType\""  >> SQLTemp.sql
echo " FROM OldRecs;"  >> SQLTemp.sql
echo "UPDATE db12.Terr262_RUBridge"  >> SQLTemp.sql
echo "SET UnitAddress = trim(UnitAddress);"  >> SQLTemp.sql
echo "DELETE FROM db12.Terr262_RUBridge"  >> SQLTemp.sql
echo "WHERE RecordDate NOT IN (SELECT MAX(RecordDate) from Terr262_RUBridge"  >> SQLTemp.sql
echo "	GROUP BY UnitAddress, Unit, Resident1);"  >> SQLTemp.sql
echo "DELETE FROM db12.Terr262_RUBridge"  >> SQLTemp.sql
echo "WHERE rowid NOT IN (SELECT MAX(rowid) from Terr262_RUBridge"  >> SQLTemp.sql
echo "	GROUP BY UnitAddress, Unit, Resident1);"  >> SQLTemp.sql
echo "-- * set ? in older records not in current download;"  >> SQLTemp.sql
echo "with a as (SELECT MAX(recorddate) AS MaxDate"  >> SQLTemp.sql
echo " FROM Terr262_RUBridge)"  >> SQLTemp.sql
echo "Update Terr262_RUBridge"  >> SQLTemp.sql
echo "SET Resident1 = '?'"  >> SQLTemp.sql
echo "where recorddate not in (select MaxDate from a);"  >> SQLTemp.sql
echo "DETACH db12;"  >> SQLTemp.sql
echo "--DETACH db12;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END IntegrateOldDiffs **********;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  IntegrateOldDiffs complete."
~/sysprocs/LOGMSG "  IntegrateOldDiffs complete."
#end proc
