#!/bin/bash
echo " ** RSOSummary.sh out-of-date **";exit 1
echo " ** RSOSummary.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash RSOSummary.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  RSOSummary - initiated from Make"
  echo "  RSOSummary - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RSOSummary - initiated from Terminal"
  echo "  RSOSummary - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

echo "-- * RSOSummary.sql - Generate RSOSummary.csv in Tracking folder."  > SQLTemp.sql
echo "-- *	7/10/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	*pathbase/DB-Dev/TerrIDData.db.DoNotCalls table has all"  >> SQLTemp.sql
echo "-- *	DO NOT CALL entries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.  *codebase/Projects-Geany/DoTerrsWithCalc/Tracking/RSOSummary.csv"  >> SQLTemp.sql
echo "-- * 	has count of RSOs by territory. This can easily be imported into a"  >> SQLTemp.sql
echo "-- *	spreadsheet for a general format report."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * This query should be run through the AnySQLtoSH project to produce the"  >> SQLTemp.sql
echo "-- * RSOSummary.sh shell. That shell will produce the output described in the"  >> SQLTemp.sql
echo "-- * Exit conditions above."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTs RSOCount;"  >> SQLTemp.sql
echo "create temp table RSOCount"  >> SQLTemp.sql
echo "(TID  TEXT, NRSOs  integer, OldestRSO TEXT, NewestRSO TEXT);"  >> SQLTemp.sql
echo "insert into RSOCount"  >> SQLTemp.sql
echo "SELECT DISTINCT TERRID, '0', '', '' fROM donotcalls"  >> SQLTemp.sql
echo "order by TERRID;"  >> SQLTemp.sql
echo "with a as (SELECT TerrID,DelPending, "  >> SQLTemp.sql
echo "  RecDate NumDate, RSO from donotcalls)"  >> SQLTemp.sql
echo "update RSOCount"  >> SQLTemp.sql
echo "set nRSOs ="  >> SQLTemp.sql
echo "case"  >> SQLTemp.sql
echo "when TID IN (SELECT TerrID from a)"  >> SQLTemp.sql
echo " THEN (SELECT COUNT() TERRID from a"  >> SQLTemp.sql
echo "  where TERRID IS TID"  >> SQLTemp.sql
echo "  and DelPending IS NOT 1"  >> SQLTemp.sql
echo "  AND RSO > 0"  >> SQLTemp.sql
echo "  AND LENGTH(RSO) > 0)"  >> SQLTemp.sql
echo "else nRSOs"  >> SQLTemp.sql
echo "end,"  >> SQLTemp.sql
echo "OldestRSO = (SELECT NumDate FROM a "  >> SQLTemp.sql
echo " WHERE NumDate IN (SELECT MIN(NumDate) FROM a"  >> SQLTemp.sql
echo "   WHERE TerrID IS TID"  >> SQLTemp.sql
echo "     AND RSO > 0"  >> SQLTemp.sql
echo "     AND LENGTH(RSO) > 0)),"  >> SQLTemp.sql
echo "NewestRSO =  (SELECT NumDate FROM a "  >> SQLTemp.sql
echo " WHERE NumDate IN (SELECT MAX(NumDate) FROM a"  >> SQLTemp.sql
echo "   WHERE TerrID IS TID"  >> SQLTemp.sql
echo "     AND RSO > 0"  >> SQLTemp.sql
echo "     AND LENGTH(RSO) > 0));"  >> SQLTemp.sql
echo "DELETE FROM RSOCount"  >> SQLTemp.sql
echo "WHERE nRSOS = 0;"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers on"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".output '$codebase/Projects-Geany/DoTerrsWithCalc/Tracking/RSOSummary.csv'"  >> SQLTemp.sql
echo "select * from RSOcount;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END RSOSummary **********;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  RSOSummary complete."
~/sysprocs/LOGMSG "  RSOSummary complete."
#end proc
