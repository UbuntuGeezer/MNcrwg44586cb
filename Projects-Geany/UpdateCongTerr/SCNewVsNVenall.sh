#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/30/21.	wmk.
#	Usage. bash SCNewVsNVenall.sh
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
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 12/30/21.	wmk.	$ HOME changed to USER; TODAY env var export removed.
P1=$1
TID=$P1
TN="Terr"
if [ "$USER" == "ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  ~/sysprocs/LOGMSG "  SCNewVsNVenall - initiated from Make"
  echo "  SCNewVsNVenall - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SCNewVsNVenall - initiated from Terminal"
  echo "  SCNewVsNVenall - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

echo "--SCNewVsNVenall.psq.sql- Difference SC download with NVenAll."  > SQLTemp.sql
echo "--	11/3/21.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit "  >> SQLTemp.sql
echo "-- *    SCNVenDiff_02-05.db - database of differences between"  >> SQLTemp.sql
echo "-- *	  SCPA_02-05.db and VeniceNTerritory.db records"  >> SQLTemp.sql
echo "-- *		Diff0205 - extracted new records from SCPA_02-05"  >> SQLTemp.sql
echo "-- *		DiffAccts - table of difference property IDs"  >> SQLTemp.sql
echo "-- *	VeniceNTerritory.db - active territories database"  >> SQLTemp.sql
echo "-- *		NVenAll - udpated with newer records from SCPA_02-05.db.Data0205"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Dependencies."  >> SQLTemp.sql
echo "-- * 	sed must perform the following modifications to this query:"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- *		m m and d d replaced with month and day of latest SCPA download"  >> SQLTemp.sql
echo "-- *	"  >> SQLTemp.sql
echo "-- *	the sed-edited query will reside in file SCNewVsNVenall.sql"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/28/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/25/21.	wmk.	multihost support."  >> SQLTemp.sql
echo "-- * 11/3/21.	wmk.	name change to SCNewVsNVenall.psq; revert to"  >> SQLTemp.sql
echo "-- *					using $ prefix with folderbase;"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * SCNewVsNVenall.sql - Difference SC download with NVenAll."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** SCNewVsNVen **********"  >> SQLTemp.sql
echo "-- *	11/3/21.	wmk."  >> SQLTemp.sql
echo "-- *------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * SCNewVsNVen.sql - Difference SC download with NVenAll."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *    SCNVenDiff_02-05.db - as main, empty .db for difference records"  >> SQLTemp.sql
echo "-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory"  >> SQLTemp.sql
echo "-- *		NVenAll - SCPA property records"  >> SQLTemp.sql
echo "-- *	SCPA_02-05.db - as db15, SCPA (new) full download from date m2/d2/2021"  >> SQLTemp.sql
echo "-- *		Data0205 - SCPA download records from date m2/d2/2021"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results"  >> SQLTemp.sql
echo "-- *    SCNVenDiff_02-05.db - as main, populated .db with difference records"  >> SQLTemp.sql
echo "-- *		Diff0205 - table of differences between db2, db15"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/28/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/25/21.	wmk.	multihost support."  >> SQLTemp.sql
echo "-- * 11/3/21.	wmk.	rewrite using MiscQueries; revert folderbase to"  >> SQLTemp.sql
echo "-- *					use leading $."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The Diff0205 table is the latest differences (assuming that"  >> SQLTemp.sql
echo "-- * things have been kept up-to-date) that can be INSERT OR REPLACEd"  >> SQLTemp.sql
echo "-- * into the NVenAll SCPA data used for the territories. Diffm2md"  >> SQLTemp.sql
echo "-- * contains all records that need to be updated for the entire county."  >> SQLTemp.sql
echo "-- * The table \"AcctsNVen\" in the AuxSCPAData.db provides the criteria"  >> SQLTemp.sql
echo "-- * for any accounts within the VeniceNTerritory.db NVenAll territory."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/SCPADiff_02-05.db'"  >> SQLTemp.sql
echo "attach '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo "|| '/SCPA_02-05.db'"  >> SQLTemp.sql
echo "as db15;"  >> SQLTemp.sql
echo "attach '$folderbase/Territories'"  >> SQLTemp.sql
echo "|| '/DB-Dev/VeniceNTerritory.db'"  >> SQLTemp.sql
echo "as db2;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * create DiffAccts;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS DiffAccts;"  >> SQLTemp.sql
echo "CREATE TABLE DiffAccts"  >> SQLTemp.sql
echo "(DiffAcct TEXT,"  >> SQLTemp.sql
echo " DiffHstead TEXT,"  >> SQLTemp.sql
echo " DiffYr TEXT,"  >> SQLTemp.sql
echo " DiffMo TEXT,"  >> SQLTemp.sql
echo " DiffDa TEXT,"  >> SQLTemp.sql
echo " DelFlag INTEGER DEFAULT 1,"  >> SQLTemp.sql
echo " PRIMARY KEY(DiffAcct) );"  >> SQLTemp.sql
echo "-- * populate DiffAccts;"  >> SQLTemp.sql
echo "WITH a AS (SELECT Account FROM NVenAccts)"  >> SQLTemp.sql
echo "INSERT INTO DiffAccts"  >> SQLTemp.sql
echo "SELECT \"ACCOUNT#\" AS PropID,"  >> SQLTemp.sql
echo " \"homesteadexemption(yesorno)\" AS DiffAcct,"  >> SQLTemp.sql
echo " cast(substr(\"lastsaledate\",7,4) AS INTEGER)"  >> SQLTemp.sql
echo " AS DiffYr,"  >> SQLTemp.sql
echo " cast(substr(\"lastsaledate\",1,2) AS INTEGER)"  >> SQLTemp.sql
echo " AS DiffMo,"  >> SQLTemp.sql
echo " cast(substr(\"lastsaledate\",4,2) AS INTEGER)"  >> SQLTemp.sql
echo " AS DiffDa, 1 AS DelFlag"  >> SQLTemp.sql
echo " FROM db15.Data0205"  >> SQLTemp.sql
echo " WHERE PropID IN (SELECT Account FROM a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * change DelFlag to 0 in order to"  >> SQLTemp.sql
echo "-- * undelete changed homesteads;"  >> SQLTemp.sql
echo " WITH a AS (SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " \"homestead exemption\" AS OldHStead,"  >> SQLTemp.sql
echo " cast(substr( \"last sale date\",7,4) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldYr,"  >> SQLTemp.sql
echo " cast(substr(\"last sale date\",1,2) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldMo,"  >> SQLTemp.sql
echo " cast(substr(\"last sale date\",1,2) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldDa"  >> SQLTemp.sql
echo "  FROM NVenAll"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "  UPDATE DiffAccts"  >> SQLTemp.sql
echo "  SET DelFlag = 0"  >> SQLTemp.sql
echo "  WHERE DiffHStead IS NOT (SELECT OldHstead FROM A"  >> SQLTemp.sql
echo "   WHERE Acct IS DiffAcct);"  >> SQLTemp.sql
echo "  "  >> SQLTemp.sql
echo "-- * change DelFlag to 0 in order to"  >> SQLTemp.sql
echo "-- * undelete changed sale dates;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " \"homestead exemption\" AS OldHStead,"  >> SQLTemp.sql
echo " cast(substr( \"last sale date\",7,4) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldYr,"  >> SQLTemp.sql
echo " cast(substr(\"last sale date\",1,2) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldMo,"  >> SQLTemp.sql
echo " cast(substr(\"last sale date\",1,2) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldDa"  >> SQLTemp.sql
echo "  FROM NVenAll"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "  UPDATE DiffAccts"  >> SQLTemp.sql
echo "  SET DelFlag = 0"  >> SQLTemp.sql
echo "  WHERE DiffYr = 2021"  >> SQLTemp.sql
echo "  AND (DiffYr IS NOT (SELECT OldYr FROM A"  >> SQLTemp.sql
echo "   WHERE Acct IS DiffAcct)"  >> SQLTemp.sql
echo "   OR DiffMo IS NOT (SELECT OldMo FROM a"  >> SQLTemp.sql
echo "   WHERE Acct IS DiffAcct)"  >> SQLTemp.sql
echo "   OR DiffDa IS NOT (SELECT OldDa FROM a"  >> SQLTemp.sql
echo "   WHERE Acct IS NOT DiffAcct) )"  >> SQLTemp.sql
echo "   ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * A05 difference records into Diff1102;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DiffAcct FROM DiffAccts"  >> SQLTemp.sql
echo "  WHERE DelFlag = 0)"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO Diff0205"  >> SQLTemp.sql
echo "select * from db15.Data0205"  >> SQLTemp.sql
echo "where \"Account#\" in"  >> SQLTemp.sql
echo " (select DiffAcct FROM a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END SCNewVsNVenall.psq/sql **********;"  >> SQLTemp.sql
echo "--***********************************************;"  >> SQLTemp.sql
echo "-- code moved to DiffsToNVenAll.psq..;"  >> SQLTemp.sql
echo "-- move to DiffsToNVenAll.psq..."  >> SQLTemp.sql
echo "-- * Update NVenAll with Diff1102 differences;"  >> SQLTemp.sql
echo ".open 'SCPADiff_02-05.db'"  >> SQLTemp.sql
echo "--attach '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo "--|| '/SCPA_02-05.db'"  >> SQLTemp.sql
echo "--as db15;"  >> SQLTemp.sql
echo "WITH a AS (Select DiffAcct FROM DiffActs"  >> SQLTemp.sql
echo "WHERE DelFlag = 0)"  >> SQLTemp.sql
echo "INSERT OR REPLACE INTO NVenAll"  >> SQLTemp.sql
echo "SELECT * FROM Data0205"  >> SQLTemp.sql
echo "WHERE \"Account#\" IN (SELECT DiffAcct from a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * select same fields from NVenAll;"  >> SQLTemp.sql
echo "SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " \"homestead exemption\" AS OldHStead,"  >> SQLTemp.sql
echo " cast(substr( \"last sale date\",7,4) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldYr,"  >> SQLTemp.sql
echo " cast(substr(\"last sale date\",1,2) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldMo,"  >> SQLTemp.sql
echo " cast(substr(\"last sale date\",1,2) AS INTEGER)"  >> SQLTemp.sql
echo "  as OldDa"  >> SQLTemp.sql
echo "  FROM NVenAll"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#notify-send "SCNewVsNVenall.sh" "SCNewVsNVenall processing complete. $P1"
echo "  SCNewVsNVenall complete."
~/sysprocs/LOGMSG "  SCNewVsNVenall complete."
#end proc
