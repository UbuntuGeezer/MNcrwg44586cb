#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash ReportUnassigned.sh
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
  ~/sysprocs/LOGMSG "  ReportUnassigned - initiated from Make"
  echo "  ReportUnassigned - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ReportUnassigned - initiated from Terminal"
  echo "  ReportUnassigned - initiated from Terminal"
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

echo "-- * ReportUnassigned.psq - Report residential properties not assigned to territories."  > SQLTemp.sql
echo "-- *	4/26/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 4/26/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. modified by DoSed with m 2, d 2 changed to month/day of current download."  >> SQLTemp.sql
echo "-- * Cannot use mm, dd since it would alter SitusAddressPropertyAddress."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/$scpath/SCPADiff_04-04.db'"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".mode list"  >> SQLTemp.sql
echo ".output '$pathbase/TerrData/UnassignedIDs.csv'"  >> SQLTemp.sql
echo "with a as (select * from DiffAccts"  >> SQLTemp.sql
echo "where terrid is '998')"  >> SQLTemp.sql
echo "select \"Account#\" Acct, \"SitusAddress(PropertyAddress)\" Situs "  >> SQLTemp.sql
echo "FROM Diff0404"  >> SQLTemp.sql
echo "WHERE Acct IN (SELECT PropID from a);"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  ReportUnassigned complete."
~/sysprocs/LOGMSG "  ReportUnassigned complete."
#end proc
