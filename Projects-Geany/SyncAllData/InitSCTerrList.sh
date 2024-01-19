#!/bin/bash
echo " ** InitSCTerrList.sh out-of-date **";exit 1
echo " ** InitSCTerrList.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash InitSCTerrList.sh
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
  ~/sysprocs/LOGMSG "  InitSCTerrList - initiated from Make"
  echo "  InitSCTerrList - initiated from Make"
else
  ~/sysprocs/LOGMSG "  InitSCTerrList - initiated from Terminal"
  echo "  InitSCTerrList - initiated from Terminal"
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

echo "-- * IntTerrList.sql - Initialize SC SpecialDBs.db TerrList table.."  > SQLTemp.sql
echo "-- * 2/4/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	SCPA-Downloads/Special/SpecialDBs.db = special databases control"  >> SQLTemp.sql
echo "-- *		 table."  >> SQLTemp.sql
echo "-- *		/SyncAllData project TerrSpecList.txt = .csv of TerrList table entries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	SpecialDBs.db.TerrList updated with new records from TerrSpecList.txt."  >> SQLTemp.sql
echo "-- *		"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 1/30/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/$scpath/Special/SpecialDBs.db'"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".import '$codebase/Projects-Geany/SyncAllData/TerrSpecList.txt' TerrList"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * eliminate duplicates;"  >> SQLTemp.sql
echo "DELETE FROM TerrList"  >> SQLTemp.sql
echo "WHERE rowid NOT IN (SELECT MAX(rowid) FROM TerrList"  >> SQLTemp.sql
echo " GROUP BY DBName,Terrxxx,Status);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * ensure names all have '.db' suffix;"  >> SQLTemp.sql
echo "UPDATE TerrList"  >> SQLTemp.sql
echo "SET DBName ="  >> SQLTemp.sql
echo " TRIM(DBName) || '.db'"  >> SQLTemp.sql
echo "WHERE INSTR(DBName, '.db') = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * set TerrList.Status fields;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DBName FName, Status DBid FROM DBNames)"  >> SQLTemp.sql
echo "UPDATE TerrList"  >> SQLTemp.sql
echo "SET Status ="  >> SQLTemp.sql
echo "CASE WHEN DBName IN (SELECT FName from a)"  >> SQLTemp.sql
echo " THEN (SELECT DBid from a"  >> SQLTemp.sql
echo "  WHERE FName IS DBName)"  >> SQLTemp.sql
echo "ELSE Status"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END InitSCTerrList.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  InitSCTerrList complete."
~/sysprocs/LOGMSG "  InitSCTerrList complete."
#end proc
