#!/bin/bash
echo " ** RefreshSCTerrIDs.sh out-of-date **";exit 1
echo " ** RefreshSCTerrIDs.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash RefreshSCTerrIDs.sh
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
  ~/sysprocs/LOGMSG "  RefreshSCTerrIDs - initiated from Make"
  echo "  RefreshSCTerrIDs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RefreshSCTerrIDs - initiated from Terminal"
  echo "  RefreshSCTerrIDs - initiated from Terminal"
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

echo "-- * RefreshSCTerrIDs.psq/sql - Refresh SC/Special/<spec-db> TerrList table."  > SQLTemp.sql
echo "-- * 2/20//23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry. *sed (DoSed1) has modified < db-name > to be special (full) datbase name."  >> SQLTemp.sql
echo "-- *	    SCPA-Downloads/Special/< spec-db >.db exists - special download database."  >> SQLTemp.sql
echo "-- * 		< spec-db >.db.TerrList = list of territory IDs and Counts"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	< spec-db >.db.TerrList updated with list of territory ID counts from"  >> SQLTemp.sql
echo "-- *		 .Spec_SCBridge table."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/20/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. "  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/$scpath/Special/WhitePineTreeRd.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS TerrList;"  >> SQLTemp.sql
echo "CREATE TABLE TerrList("  >> SQLTemp.sql
echo " TerrID TEXT,"  >> SQLTemp.sql
echo " Counts INTEGER DEFAULT 0"  >> SQLTemp.sql
echo " );"  >> SQLTemp.sql
echo "INSERT INTO TerrList(TerriD)"  >> SQLTemp.sql
echo "SELECT DISTINCT CongTerrID FROM Spec_SCBridge;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT TerrID TID FROM TerrList)"  >> SQLTemp.sql
echo "UPDATE TerrList"  >> SQLTemp.sql
echo "SET Counts ="  >> SQLTemp.sql
echo "CASE WHEN TerrID IN (SELECT TID FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT COUNT() CongTerrID FROM Spec_SCBridge"  >> SQLTemp.sql
echo " INNER JOIN a"  >> SQLTemp.sql
echo " ON a.TID IS CongTerrID"  >> SQLTemp.sql
echo "  WHERE TerrID IS a.TID)"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * END RefreshSCTerrIDs.sql;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  RefreshSCTerrIDs complete."
~/sysprocs/LOGMSG "  RefreshSCTerrIDs complete."
#end proc
