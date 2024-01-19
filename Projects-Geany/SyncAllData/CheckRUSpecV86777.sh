#!/bin/bash
echo " ** CheckRUSpecV86777.sh out-of-date **";exit 1
echo " ** CheckRUSpecV86777.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash CheckRUSpecV86777.sh
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
  ~/sysprocs/LOGMSG "  CheckRUSpecV86777 - initiated from Make"
  echo "  CheckRUSpecV86777 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckRUSpecV86777 - initiated from Terminal"
  echo "  CheckRUSpecV86777 - initiated from Terminal"
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

echo "-- * CheckRUSpecV86777.psq/sql - Compare <spec-db> record dates against Terr86777.db dates."  > SQLTemp.sql
echo "-- * 3/22/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 3/22/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. CheckRUSpecVTerr86777 gets the OwningParcel and RecordDate fields "  >> SQLTemp.sql
echo "-- * from the <spec-db>.db.Spec_RUBridge table and compares them against the "  >> SQLTemp.sql
echo "-- * \"Account #\" and DownloadDate fields from Terr86777 where "  >> SQLTemp.sql
echo "-- * OwningParcel = \"Account #\". If any corresponding Terr86777 record is newer,"  >> SQLTemp.sql
echo "-- * the <spec-db>.db will be considered out-of-date because the SC data has"  >> SQLTemp.sql
echo "-- * been udpated since the last <spec-db>.db download."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/$rupath/Special/TheEsplanade.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "-- PRAGMA table_info(Terr86777);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS OutofDates;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE OutofDates("  >> SQLTemp.sql
echo " PropID TEXT,"  >> SQLTemp.sql
echo " RUDate TEXT,"  >> SQLTemp.sql
echo " SCDate TEXT)"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "INSERT INTO OutofDates(PropID, RUDate, SCDate)"  >> SQLTemp.sql
echo "SELECT OwningParcel, RecordDate, Terr86777.DownloadDate"  >> SQLTemp.sql
echo "FROM Spec_RUBridge"  >> SQLTemp.sql
echo "INNER JOIN db2.Terr86777"  >> SQLTemp.sql
echo "ON \"Account #\" IS OwningParcel"  >> SQLTemp.sql
echo " AND DownloadDate > RecordDate;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- somehow output the below select...;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".mode list"  >> SQLTemp.sql
echo ".output '/home/vncwmk3/temp/RUoodResults.sh'"  >> SQLTemp.sql
echo "SELECT CASE WHEN Count(PropID) > 0"  >> SQLTemp.sql
echo " THEN CASE WHEN LENGTH(PropID) > 0"  >> SQLTemp.sql
echo "  THEN 'dbokay=0'"  >> SQLTemp.sql
echo "  ELSE 'dbokay=1'"  >> SQLTemp.sql
echo "  END"  >> SQLTemp.sql
echo " ELSE 'dbokay=1'"  >> SQLTemp.sql
echo " END valid8"  >> SQLTemp.sql
echo " FROM OutofDates LIMIT 1;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * END RUSpecV86777.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  CheckRUSpecV86777 complete."
~/sysprocs/LOGMSG "  CheckRUSpecV86777 complete."
#end proc
