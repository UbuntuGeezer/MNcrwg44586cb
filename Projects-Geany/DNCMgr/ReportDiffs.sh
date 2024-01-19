#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash ReportDiffs.sh
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
  ~/sysprocs/LOGMSG "  ReportDiffs - initiated from Make"
  echo "  ReportDiffs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ReportDiffs - initiated from Terminal"
  echo "  ReportDiffs - initiated from Terminal"
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
echo "-- * ReportDiffs.sql - Report from DNCDiffs table to DNCDiffs.csv for spreadsheet."  > SQLTemp.sql
echo "-- *	6/11/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	/DB-Dev/TerrIDData.DNCDiffs = differences table of Territories data"  >> SQLTemp.sql
echo "-- *	vs. all_dncs_report.pdf entries"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	/DNCMgr/DNCDiffs.csv = .csv export of DNCDiffs table entries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/11/23.	wmk.	original code; adapted from ReportOrphans."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 4/26/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 5/3/23.	wmk.	name change to ReportOrphans; results on OrphansIDs.csv."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. modified by DoSed with m 2, d 2 changed to month/day of current download."  >> SQLTemp.sql
echo "-- * Cannot use mm, dd since it would alter SitusAddressPropertyAddress."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ".headers on"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator \"|\""  >> SQLTemp.sql
echo ".output '$codebase/Projects-Geany/DNCMgr/DNCDiffs.csv'"  >> SQLTemp.sql
echo "select * FROM DNCDiffs; "  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  ReportDiffs complete."
~/sysprocs/LOGMSG "  ReportDiffs complete."
#end proc
