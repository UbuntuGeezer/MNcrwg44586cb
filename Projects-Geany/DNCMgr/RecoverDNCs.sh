#!/bin/bash
# RecoverDNCs.sh - Recover archived DoNotCalls.
# 12/12/22.	wmk.
#	Usage. bash RecoverDNCs.sh
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
  ~/sysprocs/LOGMSG "  RecoverDNCs - initiated from Make"
  echo "  RecoverDNCs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RecoverDNCs - initiated from Terminal"
  echo "  RecoverDNCs - initiated from Terminal"
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

echo "-- * RecoverDNCs.sql - module description."  > SQLTemp.sql
echo "-- * 5/31/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	/DB-Dev/TerrIDData.ArchivedDNCs = table or archived DoNotCalls"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Dependencies. < terrid > and < initials > fields replaced by DoSedRecover.sh"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	/DB-Dev/TerrIDData.DoNotCalls = updated with recovered DoNotCall"  >> SQLTemp.sql
echo "-- *	records from ArchivedDNCs table"  >> SQLTemp.sql
echo "-- *	ArchivedDNCs table recovered records marked for deletion"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/XTerrIDData.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/$scpath/Terr101/Terr101_SC.db'"  >> SQLTemp.sql
echo " AS db11;"  >> SQLTemp.sql
echo "--pragma db11.table_info(Terr101_SCBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE ArchivedDNCs ("  >> SQLTemp.sql
echo "-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, "  >> SQLTemp.sql
echo "-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, "  >> SQLTemp.sql
echo "-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, "  >> SQLTemp.sql
echo "-- ArchDate TEXT, Initials TEXT );"  >> SQLTemp.sql
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
echo " "  >> SQLTemp.sql
echo "-- * insert ArchivedDNC records;"  >> SQLTemp.sql
echo "WITH a AS (SELECT OwningParcel Acct, Unit s_Unit"  >> SQLTemp.sql
echo " FROM db11.Terr101_SCBridge),"  >> SQLTemp.sql
echo "b AS (SELECT"  >> SQLTemp.sql
echo " TerrID, Name , UnitAddress, Unit,  Phone, Notes, RecDate, RSO, "  >> SQLTemp.sql
echo " \"Foreign\", PropID, ZipCode, 0, Initials"  >> SQLTemp.sql
echo " FROM ArchivedDNCs"  >> SQLTemp.sql
echo " WHERE PropID IN (SELECT Acct FROM a"  >> SQLTemp.sql
echo "  WHERE s_Unit IS Unit) )"  >> SQLTemp.sql
echo "INSERT INTO DoNotCalls( TerrID, Name , UnitAddress, Unit,  Phone, Notes, RecDate, RSO, "  >> SQLTemp.sql
echo " \"Foreign\", PropID, ZipCode, DelPending, "  >> SQLTemp.sql
echo " Initials)"  >> SQLTemp.sql
echo "SELECT"  >> SQLTemp.sql
echo " TerrID, Name , UnitAddress, Unit,  Phone, Notes, RecDate, RSO, "  >> SQLTemp.sql
echo " \"Foreign\", PropID, ZipCode, 0,"  >> SQLTemp.sql
echo " 'wmk'"  >> SQLTemp.sql
echo "FROM b;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * set DelPending on ArchivedDNCs records = 1;"  >> SQLTemp.sql
echo "UPDATE ArchivedDNCs"  >> SQLTemp.sql
echo "SET DelPending = 1"  >> SQLTemp.sql
echo "WHERE TerrID IS '101';"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * END RecoverDNCs.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  RecoverDNCs complete."
~/sysprocs/LOGMSG "  RecoverDNCs complete."
#end proc
