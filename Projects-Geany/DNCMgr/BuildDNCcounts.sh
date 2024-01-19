#!/bin/bash
# BuildDNCCounts.sh - Build DNCCounts table in TerrIDData.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash BuildDNCcounts.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 6/14/23.	wmk.	header updated.
# Legacy mods.
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
  ~/sysprocs/LOGMSG "  BuildDNCcounts - initiated from Make"
  echo "  BuildDNCcounts - initiated from Make"
else
  ~/sysprocs/LOGMSG "  BuildDNCcounts - initiated from Terminal"
  echo "  BuildDNCcounts - initiated from Terminal"
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

echo "-- * BuildDNCCounts.sql - Build DNCCounts table in TerrIDData."  > SQLTemp.sql
echo "-- *	6/8/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/8/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo "--pragma table_info(DoNotCalls);"  >> SQLTemp.sql
echo "--pragma table_info(DNCCounts);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS DNCCounts;"  >> SQLTemp.sql
echo "CREATE TABLE DNCCounts("  >> SQLTemp.sql
echo " TerrID TEXT,"  >> SQLTemp.sql
echo " NumDNCs INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " PRIMARY KEY(TerrID),"  >> SQLTemp.sql
echo " FOREIGN KEY(TerrID)"  >> SQLTemp.sql
echo " REFERENCES Territory(TerrID)"  >> SQLTemp.sql
echo " ON UPDATE CASCADE)"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "INSERT INTO DNCCounts(TerrID)"  >> SQLTemp.sql
echo "SELECT DISTINCT TerrID FROM DoNotCalls;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "UPDATE DNCCounts"  >> SQLTemp.sql
echo "SET NumDNCs ="  >> SQLTemp.sql
echo " (SELECT COUNT() TerrID FROM DoNotCalls"  >> SQLTemp.sql
echo "  WHERE TerrID IS DNCCounts.TerrID"  >> SQLTemp.sql
echo "  AND DelPending <> 1);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END BuildDNCCounts.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  BuildDNCcounts complete."
~/sysprocs/LOGMSG "  BuildDNCcounts complete."
#end proc
