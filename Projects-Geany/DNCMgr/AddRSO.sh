#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash AddRSO.sh
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
  ~/sysprocs/LOGMSG "  AddRSO - initiated from Make"
  echo "  AddRSO - initiated from Make"
else
  ~/sysprocs/LOGMSG "  AddRSO - initiated from Terminal"
  echo "  AddRSO - initiated from Terminal"
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

echo "-- * AddRSO.sql - Add new RSO entry."  > SQLTemp.sql
echo "-- * 6/1/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	/DB-Dev/TerrIDData.RSOAddress= table of RSO Addresses. (parent)"  >> SQLTemp.sql
echo "-- *				TerrIDData.RSOInfo = table of RSO information. (child)"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Dependencies. RSOAddress.RSOid autoincremented integer RSO id field."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	/DB-Dev/TerrIDData.RSOAddress = new RSO added"  >> SQLTemp.sql
echo "-- *						  .RSOInfo = new RSO information added."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/12/23.	wmk.	original code; adapted from AddDNC.sql."  >> SQLTemp.sql
echo "-- * Legacy mods"  >> SQLTemp.sql
echo "-- * 5/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The archiving process takes all of the DoNotCalls for a given territory"  >> SQLTemp.sql
echo "-- * ID and places them in the AdddDNCs table."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE RSOAddress ("  >> SQLTemp.sql
echo "-- RSOid INTEGER PRIMARY KEY AUTOINCREMENT, PropID TEXT, Unit TEXT, Initials TEXT,"  >> SQLTemp.sql
echo "-- RecDate TEXT, UnitAddress TEXT)"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE RSOInfo ("  >> SQLTemp.sql
echo "-- Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT, "  >> SQLTemp.sql
echo "-- RSOid INTEGER NOT NULL,"  >> SQLTemp.sql
echo "--  PRIMARY KEY(RSOid), "  >> SQLTemp.sql
echo "--  FOREIGN KEY(RSOid) "  >> SQLTemp.sql
echo "--  REFERENCES RSOAddress(RSOid) )"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--* record current max rowid;"  >> SQLTemp.sql
echo "drop table if exists MaxRSOid;"  >> SQLTemp.sql
echo "create TEMPORARY table MaxRSOid(lastrow INTEGER);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--* preserve current last row for downstream insertions;"  >> SQLTemp.sql
echo "INSERT INTO MaxRSOid(lastrow)"  >> SQLTemp.sql
echo "SELECT rowid FROM RSOAddress"  >> SQLTemp.sql
echo "WHERE rowid IN (SELECT MAX(rowid) FROM RSOAddress);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- template for NewRSOs.csv; "  >> SQLTemp.sql
echo "--TerrID|Name|UnitAddress|Unit|Phone|Notes|RecDate|PropID|ZipCode|initials"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS NewRSOs;"  >> SQLTemp.sql
echo "CREATE TEMPORARY TABLE NewRSOs ("  >> SQLTemp.sql
echo "TerrID TEXT NOT NULL DEFAULT '000', \"Name\" TEXT, "  >> SQLTemp.sql
echo "UnitAddress TEXT NOT NULL DEFAULT ' ', Unit TEXT, Phone TEXT, "  >> SQLTemp.sql
echo "Notes TEXT, RecDate TEXT, PropID TEXT, "  >> SQLTemp.sql
echo "ZipCode TEXT, Initials TEXT )"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * add records into RSOAddress, RSOInfo;"  >> SQLTemp.sql
echo "-- * import records to NewRecs;"  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator \"|\""  >> SQLTemp.sql
echo ".import '$codebase/Projects-Geany/DNCMgr/NewRSO.csv' NewRSOs"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- add new record(s) into DoNotCalls;"  >> SQLTemp.sql
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
echo "-- * create new DNC entry corresponding to new RSO entry(ies);"  >> SQLTemp.sql
echo "-- NewRSOs;"  >> SQLTemp.sql
echo "--TerrID|Name|UnitAddress|Unit|Phone|Notes|RecDate|PropID|ZipCode|initials;"  >> SQLTemp.sql
echo "-- * RSOid (automatic),PropID, Unit, initials, RecDate, UnitAddress;"  >> SQLTemp.sql
echo "INSERT INTO DoNotCalls(TerrID, \"Name\", UnitAddress, Unit, Phone, Notes,"  >> SQLTemp.sql
echo " RecDate, PropID, ZipCode, Initials)"  >> SQLTemp.sql
echo "SELECT TerrID, \"Name\", UnitAddress, Unit, Phone, Notes, RecDate, PropID,"  >> SQLTemp.sql
echo " ZipCode, Initials"  >> SQLTemp.sql
echo "FROM NewRSOs;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * add new record(s) into RSOAddress;"  >> SQLTemp.sql
echo "--CREATE TABLE RSOAddress ("  >> SQLTemp.sql
echo "-- RSOid INTEGER PRIMARY KEY AUTOINCREMENT, PropID TEXT, Unit TEXT, Initials TEXT,"  >> SQLTemp.sql
echo "-- RecDate TEXT, UnitAddress TEXT)"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "-- NewRSOs;"  >> SQLTemp.sql
echo "--TerrID|Name|UnitAddress|Unit|Phone|Notes|RecDate|PropID|ZipCode|initials;"  >> SQLTemp.sql
echo "-- * RSOid (automatic),PropID, Unit, initials, RecDate, UnitAddress;"  >> SQLTemp.sql
echo "INSERT INTO RSOAddress(PropID, Unit, initials, RecDate, UnitAddress)"  >> SQLTemp.sql
echo "SELECT PropID, Unit, Initials, RecDate, UnitAddress FROM NewRSOs;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE RSOInfo ("  >> SQLTemp.sql
echo "-- Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT, "  >> SQLTemp.sql
echo "-- RSOid INTEGER NOT NULL,"  >> SQLTemp.sql
echo "--  PRIMARY KEY(RSOid), "  >> SQLTemp.sql
echo "--  FOREIGN KEY(RSOid) "  >> SQLTemp.sql
echo "--  REFERENCES RSOAddress(RSOid) )"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo "-- * add new record(s) into RSOInfo using RSOAddress;"  >> SQLTemp.sql
echo "WITH a AS (SELECT RSOid aRSOid, UnitAddress aUnitAddress, Unit aUnit"  >> SQLTemp.sql
echo " FROM RSOAddress WHERE rowid > (SELECT lastrow FROM MaxRSOid))"  >> SQLTemp.sql
echo "INSERT INTO RSOInfo(Address, Unit, RSOid)"  >> SQLTemp.sql
echo "SELECT aUnitAddress, aUnit, aRSOid "  >> SQLTemp.sql
echo " FROM a;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * update RSOInfo with additional fields from NewRSOs;"  >> SQLTemp.sql
echo "-- * Name, Phone, Notes RecDate;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Name\" aName, Phone aPhone, Notes aNotes, RecDate aRecDate,"  >> SQLTemp.sql
echo " UnitAddress aUnitAddress,  Unit aUnit"  >> SQLTemp.sql
echo " FROM NewRSOs)"  >> SQLTemp.sql
echo "UPDATE RSOInfo"  >> SQLTemp.sql
echo "SET \"Name\" ="  >> SQLTemp.sql
echo "CASE WHEN Address IN (SELECT aUnitAddress FROM a"  >> SQLTemp.sql
echo " WHERE aUnit IS Unit)"  >> SQLTemp.sql
echo " THEN (SELECT aName FROM a"  >> SQLTemp.sql
echo "  WHERE aUnitAddress IS Address"  >> SQLTemp.sql
echo "    AND aUnit IS Unit)"  >> SQLTemp.sql
echo "ELSE \"Name\""  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " Phone ="  >> SQLTemp.sql
echo "CASE WHEN Address IN (SELECT aUnitAddress FROM a"  >> SQLTemp.sql
echo " WHERE aUnit IS Unit)"  >> SQLTemp.sql
echo " THEN (SELECT aPhone FROM a"  >> SQLTemp.sql
echo "  WHERE aUnitAddress IS Address"  >> SQLTemp.sql
echo "    AND aUnit IS Unit)"  >> SQLTemp.sql
echo "ELSE Phone"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " Notes ="  >> SQLTemp.sql
echo "CASE WHEN Address IN (SELECT aUnitAddress FROM a"  >> SQLTemp.sql
echo " WHERE aUnit IS Unit)"  >> SQLTemp.sql
echo " THEN (SELECT aNotes FROM a"  >> SQLTemp.sql
echo "  WHERE aUnitAddress IS Address"  >> SQLTemp.sql
echo "    AND aUnit IS Unit)"  >> SQLTemp.sql
echo "ELSE Notes"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE rowid > (SELECT lastrow FROM MaxRSOid);"  >> SQLTemp.sql
echo "-- * Name, UnitAddress, Unit Phone, Notes, RSOid (from RSOAddress records)"  >> SQLTemp.sql
echo "-- *   ,PropID, Unit, initials, RecDate, UnitAddress;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * update DoNotCalls with RSOid(s) from RSOAddress table;"  >> SQLTemp.sql
echo "WITH a AS (SELECT RSOid, PropID aPropID, Unit aUnit"  >> SQLTemp.sql
echo "FROM RSOAddress WHERE rowid > (SELECT lastrow FROM MaxRSOid))"  >> SQLTemp.sql
echo "UPDATE DoNotCalls"  >> SQLTemp.sql
echo "SET RSO = (SELECT RSOid FROM a"  >> SQLTemp.sql
echo " WHERE aPropID IS PropID"  >> SQLTemp.sql
echo "   AND aUnit IS Unit)"  >> SQLTemp.sql
echo "WHERE PropID IN (SELECT aPropID FROM a"  >> SQLTemp.sql
echo " WHERE aUnit IS Unit);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * create log entries for each new property ID/Unit added;"  >> SQLTemp.sql
echo "WITH a AS (SELECT PropID, Unit FROM NewRSOs)"  >> SQLTemp.sql
echo "INSERT INTO RSOLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "SELECT CURRENT_TIMESTAMP,'imported ' || PropID || '/' || Unit "  >> SQLTemp.sql
echo " || ' from NewRSO.csv' FROM a;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * create RSOLog summary log entry;"  >> SQLTemp.sql
echo "INSERT INTO RSOLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "VALUES(CURRENT_TIMESTAMP,'imported new records from NewRSO.csv.');"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * create log entries for each new DNC added;"  >> SQLTemp.sql
echo "WITH a AS (SELECT PropID, Unit FROM NewRSOs)"  >> SQLTemp.sql
echo "INSERT INTO DNCLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "SELECT CURRENT_TIMESTAMP,'created DNC ' || PropID || '/' || Unit "  >> SQLTemp.sql
echo " || ' from NewRSO.csv' FROM a;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * create DNCLog summary log entry;"  >> SQLTemp.sql
echo "INSERT INTO DNCLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "VALUES(CURRENT_TIMESTAMP,'created new DNC records from NewRSO.csv.');"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * END AddRSO.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  AddRSO complete."
~/sysprocs/LOGMSG "  AddRSO complete."
#end proc
