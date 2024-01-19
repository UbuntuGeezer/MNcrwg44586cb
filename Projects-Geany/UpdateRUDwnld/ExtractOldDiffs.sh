#!/bin/bash
echo " ** ExtractOldDiffs.sh out-of-date **";exit 1
echo " ** ExtractOldDiffs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 6/17/21.	wmk.
#	Usage. bash ExtractOldDiffs.sh
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
  ~/sysprocs/LOGMSG "  ExtractOldDiffs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ExtractOldDiffs - initiated from Terminal"
  echo "  ExtractOldDiffs - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#proc body here

echo "-- ExtractOldDiffs.sq - Extract older RU records not in newer download."  > SQLTemp.sql
echo "--	7/6/21.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * ExtractOldDiffs - Extract older RU records not in newer download."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** ExtractOldDiffs **********"  >> SQLTemp.sql
echo "-- *	7/6/21.	wmk."  >> SQLTemp.sql
echo "-- *----------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * ExtractOldDiffs - Extract older RU records not in newer download."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	junk.db"  >> SQLTemp.sql
echo "-- *	Terr245_RU.db - as db12,"  >> SQLTemp.sql
echo "-- *	./Previous/Terr245_RU.db - as db32,"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	Terr245OldDiffs.csv - extracted _RUBridge records from ./Previous"  >> SQLTemp.sql
echo "-- *	  .db where UnitAddress not in current .db"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$folderbase/Territories/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ".cd '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads'"  >> SQLTemp.sql
echo "ATTACH './Terr245/Terr245_RU.db'"  >> SQLTemp.sql
echo " AS db12;"  >> SQLTemp.sql
echo "-- pragma db12.table_info(Terr245_RUBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH './Terr245/Previous/Terr245_RU.db'"  >> SQLTemp.sql
echo " AS db32;"  >> SQLTemp.sql
echo "-- pragma db32.table_info(Terr245_RUBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".output './Terr245/Terr245OldDiffs.csv'"  >> SQLTemp.sql
echo "UPDATE db12.Terr245_RUBridge"  >> SQLTemp.sql
echo "SET UnitAddress = trim(UnitAddress);"  >> SQLTemp.sql
echo "UPDATE db32.Terr245_RUBridge"  >> SQLTemp.sql
echo "SET UnitAddress = trim(UnitAddress);"  >> SQLTemp.sql
echo "WITH a AS (SELECT UnitAddress FROM db12.Terr245_RUBridge)"  >> SQLTemp.sql
echo "SELECT * FROM db32.Terr245_RUBridge"  >> SQLTemp.sql
echo " WHERE UnitAddress NOT IN (SELECT UnitAddress FROM a);"  >> SQLTemp.sql
echo "--DETACH db12;"  >> SQLTemp.sql
echo "--DETACH db32;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END ExtractOldDiffs **********;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#end proc body
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#notify-send "ExtractOldDiffs.sh" "ExtractOldDiffs processing complete. $P1"
echo "  ExtractOldDiffs complete."
~/sysprocs/LOGMSG "  ExtractOldDiffs complete."
#end proc
