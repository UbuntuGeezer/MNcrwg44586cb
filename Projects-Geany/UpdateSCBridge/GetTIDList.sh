#!/bin/bash
echo " ** GetTIDList.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash GetTIDList.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 12/11/22.	wmk.	run SetToday.sh to export TODAY env var.
# 12/12/22.	wmk.	SetTidy.sh path corrected.
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
  ~/sysprocs/LOGMSG "  GetTIDList - initiated from Make"
  echo "  GetTIDList - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetTIDList - initiated from Terminal"
  echo "  GetTIDList - initiated from Terminal"
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

echo "-- GetTIDList.psq/sql - Get list of territories affected by SC download."  > SQLTemp.sql
echo "--	11/22/22.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ----------------------"  >> SQLTemp.sql
echo "-- * 11/22/22.	wmk.	*codebase support."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 4/25/22.	wmk.	edited for FL/SARA/86777;*pathbase* support."  >> SQLTemp.sql
echo "-- * 5/1/22.	wmk.	modified to output list to TIDList0404.csv"  >> SQLTemp.sql
echo "-- * 7/1/22.	wmk.	documentation/comments updated."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 6/26/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. This .psq is modified by DoSed1, changing @ @   z z to the month"  >> SQLTemp.sql
echo "-- * and day of the new download. Since this is not linked to any specific"  >> SQLTemp.sql
echo "-- * territory, DoSed1 is used to make the changes. The *make* file"  >> SQLTemp.sql
echo "-- * MakeGetTIDList needs no modification, since the SQL code does all the work."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * GetSCUpdateList - Get list of territories affected by SC download."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** GetSCUpdateList ********"  >> SQLTemp.sql
echo "-- *	11/22/22.	wmk."  >> SQLTemp.sql
echo "-- *--------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * GetSCUpdateList - Get list of territories affected by SC download."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *   <list main DB and ATTACHed DBs and tables>"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. DoSed substitutes the month and day of the SCPADiff_mm-dd.db"  >> SQLTemp.sql
echo "-- * into @ @ and z z fields."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " || '/RawData/SCPA/SCPA-Downloads/SCPADiff_04-04.db'"  >> SQLTemp.sql
echo "  AS db16;"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers on"  >> SQLTemp.sql
echo ".output '$codebase/Projects-Geany/UpdateSCBridge/TIDList0404.csv'"  >> SQLTemp.sql
echo "SELECT distinct TerrID FROM db16.DiffAccts"  >> SQLTemp.sql
echo "where length(TerrID) > 0"  >> SQLTemp.sql
echo " ORDER BY TerrID;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END GetSCUpdateList **********"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  GetTIDList complete."
~/sysprocs/LOGMSG "  GetTIDList complete."
#end proc
