#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash DeleteDNC.sh
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
  ~/sysprocs/LOGMSG "  DeleteDNC - initiated from Make"
  echo "  DeleteDNC - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DeleteDNC - initiated from Terminal"
  echo "  DeleteDNC - initiated from Terminal"
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
echo "-- * DeleteDNC.sql - module description."  > SQLTemp.sql
echo "-- * 6/1/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	/DB-Dev/TerrIDData.DeletedDNCs = table or archived DoNotCalls"  >> SQLTemp.sql
echo "-- *				TerrIDData.DoNotCalls = table of DoNotCalls"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Dependencies. < propid >, < unit >, < initials > fields replaced by "  >> SQLTemp.sql
echo "-- *	DoSedDelete.sh"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	/DB-Dev/TerrIDData.DeletedDNCs = updated with DoNotCall"  >> SQLTemp.sql
echo "-- *	removed from DoNotCalls table < propid > < unit >"  >> SQLTemp.sql
echo "-- *	DoNotCalls table records < propid > < unit > marked for deletion"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	adapted from ArchiveDNCs.psq."  >> SQLTemp.sql
echo "-- * 6/8/23.	wmk.	bug fix - was deleting where DelPending <> 1; changed"  >> SQLTemp.sql
echo "-- *			 to only set DelPending on record."  >> SQLTemp.sql
echo "-- * Legacy mods"  >> SQLTemp.sql
echo "-- * 5/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The archiving process takes all of the DoNotCalls for a given territory"  >> SQLTemp.sql
echo "-- * ID and places them in the DeletedDNCs table."  >> SQLTemp.sql
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
echo "--CREATE TABLE DeletedDNCs ("  >> SQLTemp.sql
echo "-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, "  >> SQLTemp.sql
echo "-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, "  >> SQLTemp.sql
echo "-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, "  >> SQLTemp.sql
echo "-- ArchDate TEXT, Initials TEXT );"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * add records into Deleted DNCs;"  >> SQLTemp.sql
echo "INSERT INTO DeletedDNCs"  >> SQLTemp.sql
echo "SELECT TerrID, Name, UnitAddress, Unit, Phone, Notes, RecDate, RSO,"  >> SQLTemp.sql
echo "\"Foreign\", PropID, ZipCode, '0', '$TODAY', 'wmk'"  >> SQLTemp.sql
echo "FROM DoNotCalls"  >> SQLTemp.sql
echo "WHERE PropID IS '0429021395' AND (Unit ISNULL"  >> SQLTemp.sql
echo " OR Unit IS '')"  >> SQLTemp.sql
echo " AND DelPending <> 1; "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * Set DelPending on DeleteDoNotCalls records;"  >> SQLTemp.sql
echo "UPDATE DoNotCalls"  >> SQLTemp.sql
echo "SET DelPending = 1,"  >> SQLTemp.sql
echo "DelDate = '$TODAY'"  >> SQLTemp.sql
echo "WHERE PropID is '0429021395' AND (Unit ISNULL"  >> SQLTemp.sql
echo " OR Unit IS '');"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--INSERT INTO DNCLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "--VALUES(CURRENT_TIMESTAMP,'0429021395 <unit> DNC deleted.');"  >> SQLTemp.sql
echo "INSERT INTO DNCLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "SELECT CURRENT_TIMESTAMP,'0429021395 <nounit> deleted.' || initials FROM Admin;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * END DeleteDNC.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  DeleteDNC complete."
~/sysprocs/LOGMSG "  DeleteDNC complete."
#end proc
