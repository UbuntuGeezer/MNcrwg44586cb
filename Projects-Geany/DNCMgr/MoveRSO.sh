#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash MoveRSO.sh
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
  ~/sysprocs/LOGMSG "  MoveRSO - initiated from Make"
  echo "  MoveRSO - initiated from Make"
else
  ~/sysprocs/LOGMSG "  MoveRSO - initiated from Terminal"
  echo "  MoveRSO - initiated from Terminal"
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

# adminpreamble.sh - check for admnistrator logged in.
#	6/8/23.	wmk.
projpath=$codebase/Projects-Geany/DNCMgr
. $projpath/WhosLoggedIn.sh
if [ "$adminwho" == "" ];then 
 echo " ** No administrator logged in - MakeCleanupDNCs exiting. **"
 exit 2
fi
echo "-- * MoveRSO.psq/sql - Move RSO within TerrIDData."  > SQLTemp.sql
echo "-- * 6/14/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	/DB-Dev/TerrIDData.DeletedRSOs = table or archived DoNotCalls"  >> SQLTemp.sql
echo "-- *				TerrIDData.DoNotCalls = table of DoNotCalls"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Dependencies. -1, 424   ARMADA RD S, 2, 34285 000 wmk fields replaced by "  >> SQLTemp.sql
echo "-- *	DoSedMove.sh"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	/DB-Dev/TerrIDData.RSOAddress, .RSOInfo = updated with move info."  >> SQLTemp.sql
echo "-- *	DoNotCalls table records -1 marked for deletion"  >> SQLTemp.sql
echo "-- *	RSOLog entry made"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/13/23.	wmk.	original code; adapted from DeleteRSO."  >> SQLTemp.sql
echo "-- * 6/14/23.	wmk.	selections corrected to use *rsoid."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	adapted from ArchiveRSOs.psq."  >> SQLTemp.sql
echo "-- * 6/8/23.	wmk.	bug fix - was deleting where DelPending <> 1; changed"  >> SQLTemp.sql
echo "-- *			 to only set DelPending on record."  >> SQLTemp.sql
echo "-- * Legacy mods"  >> SQLTemp.sql
echo "-- * 5/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The archiving process takes all of the DoNotCalls for a given territory"  >> SQLTemp.sql
echo "-- * ID and places them in the DeletedRSOs table."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE DoNotCalls ("  >> SQLTemp.sql
echo "-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, "  >> SQLTemp.sql
echo "-- UnitAddress TEXT NOT NULL DEFAULT ' ', Unit TEXT, Phone TEXT, "  >> SQLTemp.sql
echo "-- Notes TEXT, RecDate TEXT, RSO INTEGER, Foreign INTEGER, PropID TEXT, "  >> SQLTemp.sql
echo "-- ZipCode TEXT, DelPending INTEGER, DelDate TEXT, Initials TEXT, "  >> SQLTemp.sql
echo "-- LangID INTEGER, "  >> SQLTemp.sql
echo "-- FOREIGN KEY (TerrID) "  >> SQLTemp.sql
echo "-- REFERENCES Territory(TerrID) "  >> SQLTemp.sql
echo "-- ON UPDATE CASCADE "  >> SQLTemp.sql
echo "-- ON DELETE SET DEFAULT);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE DeletedRSOs ("  >> SQLTemp.sql
echo "-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, "  >> SQLTemp.sql
echo "-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, "  >> SQLTemp.sql
echo "-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, "  >> SQLTemp.sql
echo "-- ArchDate TEXT, Initials TEXT );"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * add record into Deleted RSOs;"  >> SQLTemp.sql
echo "INSERT INTO DeletedRSOs"  >> SQLTemp.sql
echo "SELECT TerrID, Name, UnitAddress, Unit, Phone, Notes, RecDate, RSO,"  >> SQLTemp.sql
echo "\"Foreign\", PropID, ZipCode, '0', '$TODAY', 'wmk'"  >> SQLTemp.sql
echo "FROM DoNotCalls"  >> SQLTemp.sql
echo "WHERE RSO = -1"  >> SQLTemp.sql
echo " AND DelPending <> 1; "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * create temp tabbe with new address, new unit, propid placeholder;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS NewPropID;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE NewPropID(NewID TEXT, UnitAddress TEXT, Unit TEXT);"  >> SQLTemp.sql
echo "INSERT INTO NewPropID(NewID,UnitAddress,Unit)"  >> SQLTemp.sql
echo "VALUES('9999999999','424   ARMADA RD S','2');"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * attempt to match up Property ID from address;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" Acct, "  >> SQLTemp.sql
echo " TRIM(SUBSTR(\"situs address (property address)\",1,35)) StreetAddr,"  >> SQLTemp.sql
echo " TRIM(SUBSTR(\"situs address (property address)\",36)) SCUnit"  >> SQLTemp.sql
echo "  FROM Terr86777)"  >> SQLTemp.sql
echo "UPDATE NewPropID"  >> SQLTemp.sql
echo "SET NewID ="  >> SQLTemp.sql
echo "CASE WHEN UPPER(UnitAddress) IN (SELECT StreetAddr FROM a"  >> SQLTemp.sql
echo " WHERE SCUnit IS Unit)"  >> SQLTemp.sql
echo " THEN (SELECT Acct FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(UnitAddress)"  >> SQLTemp.sql
echo "   AND SCUnit IS UNIT)"  >> SQLTemp.sql
echo "ELSE NewID"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "-- * Set Update address, unit, zipcode, RecDate in DoNotCalls record for RSOid;"  >> SQLTemp.sql
echo "-- * set PropID = '9999999999' since unknown at this point;"  >> SQLTemp.sql
echo "WITH a AS (SELECT NewID FROM NewPropID)"  >> SQLTemp.sql
echo "UPDATE DoNotCalls"  >> SQLTemp.sql
echo "SET TerrID = '000', "  >> SQLTemp.sql
echo " UnitAddress = '424   ARMADA RD S',"  >> SQLTemp.sql
echo " Unit = '2',"  >> SQLTemp.sql
echo " ZipCode = '34285',"  >> SQLTemp.sql
echo " RecDate = '$TODAY',"  >> SQLTemp.sql
echo " PropID = (SELECT NewID FROM a)"  >> SQLTemp.sql
echo "WHERE RSO = -1;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * issue RSOLog message;"  >> SQLTemp.sql
echo "--INSERT INTO RSOLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "--VALUES(CURRENT_TIMESTAMP,'RSO < rsoid > address moved.');"  >> SQLTemp.sql
echo "INSERT INTO RSOLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "SELECT CURRENT_TIMESTAMP,'RSO -1 address moved.' || initials FROM Admin;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE RSOInfo ("  >> SQLTemp.sql
echo "-- Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT, "  >> SQLTemp.sql
echo "-- RSOid INTEGER NOT NULL,"  >> SQLTemp.sql
echo "--  PRIMARY KEY(RSOid), "  >> SQLTemp.sql
echo "--  FOREIGN KEY(RSOid) "  >> SQLTemp.sql
echo "--  REFERENCES RSOAddress(RSOid) )"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo "-- * update RSOInfo first, since RSOAddress is parent;"  >> SQLTemp.sql
echo "UPDATE RSOInfo"  >> SQLTemp.sql
echo "SET Address = '424   ARMADA RD S',"  >> SQLTemp.sql
echo " Unit = '2'"  >> SQLTemp.sql
echo "WHERE RSOid = -1;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE RSOAddress ("  >> SQLTemp.sql
echo "-- RSOid INTEGER PRIMARY KEY AUTOINCREMENT, PropID TEXT, Unit TEXT, Initials TEXT,"  >> SQLTemp.sql
echo "-- RecDate TEXT, UnitAddress TEXT)"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "-- * update RSOAddress parent record;"  >> SQLTemp.sql
echo "WITH a AS (SELECT NewID FROM NewPropID)"  >> SQLTemp.sql
echo "UPDATE RSOAddress"  >> SQLTemp.sql
echo "SET Initials = 'wmk',"  >> SQLTemp.sql
echo " RecDate = '$TODAY$',"  >> SQLTemp.sql
echo " Unit = '2',"  >> SQLTemp.sql
echo " UnitAddress = '424   ARMADA RD S',"  >> SQLTemp.sql
echo " PROPID = (SELECT NewID FROM a)"  >> SQLTemp.sql
echo "WHERE RSOid = -1;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END MoveRSO.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  MoveRSO complete."
~/sysprocs/LOGMSG "  MoveRSO complete."
#end proc
