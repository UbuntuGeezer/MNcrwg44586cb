#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash ExtractOldDiffs.sh
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
  ~/sysprocs/LOGMSG "  ExtractOldDiffs - initiated from Make"
  echo "  ExtractOldDiffs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ExtractOldDiffs - initiated from Terminal"
  echo "  ExtractOldDiffs - initiated from Terminal"
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

echo "-- ExtractOldDiffs.psq - Extract older RU records not in newer download."  > SQLTemp.sql
echo "--	6/7/22.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/28/22.	wmk.	(automated) *pathbase* integration."  >> SQLTemp.sql
echo "-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777."  >> SQLTemp.sql
echo "-- * 6/7/22.	wmk.	code checked migrating to FL/SARA/86777."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 9/9/21.	wmk.	cloned into UpdateMHPDwnld from UpdateRUDwnld project."  >> SQLTemp.sql
echo "-- * 7/6/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * ExtractOldDiffs - Extract older RU records not in newer download."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** ExtractOldDiffs **********"  >> SQLTemp.sql
echo "-- *	6/7/22.	wmk."  >> SQLTemp.sql
echo "-- *----------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * ExtractOldDiffs - Extract older RU records not in newer download."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	junk.db"  >> SQLTemp.sql
echo "-- *	Terr262_RU.db - as db12,"  >> SQLTemp.sql
echo "-- *	./Previous/Terr262_RU.db - as db32,"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	Terr262OldDiffs.csv - extracted _RUBridge records from ./Previous"  >> SQLTemp.sql
echo "-- *	  .db where UnitAddress not in current .db"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ".cd '$pathbase/RawData/RefUSA/RefUSA-Downloads'"  >> SQLTemp.sql
echo "ATTACH './Terr262/Terr262_RU.db'"  >> SQLTemp.sql
echo " AS db12;"  >> SQLTemp.sql
echo "-- pragma db12.table_info(Terr262_RUBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH './Terr262/Previous/Terr262_RU.db'"  >> SQLTemp.sql
echo " AS db32;"  >> SQLTemp.sql
echo "-- pragma db32.table_info(Terr262_RUBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".headers OFF"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".output './Terr262/Terr262OldDiffs.csv'"  >> SQLTemp.sql
echo "UPDATE db12.Terr262_RUBridge"  >> SQLTemp.sql
echo "SET UnitAddress = trim(UnitAddress);"  >> SQLTemp.sql
echo "UPDATE db32.Terr262_RUBridge"  >> SQLTemp.sql
echo "SET UnitAddress = trim(UnitAddress);"  >> SQLTemp.sql
echo "WITH a AS (SELECT UnitAddress FROM db12.Terr262_RUBridge)"  >> SQLTemp.sql
echo "SELECT * FROM db32.Terr262_RUBridge"  >> SQLTemp.sql
echo " WHERE UnitAddress NOT IN (SELECT UnitAddress FROM a);"  >> SQLTemp.sql
echo "--DETACH db12;"  >> SQLTemp.sql
echo "--DETACH db32;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END ExtractOldDiffs **********;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  ExtractOldDiffs complete."
~/sysprocs/LOGMSG "  ExtractOldDiffs complete."
#end proc
