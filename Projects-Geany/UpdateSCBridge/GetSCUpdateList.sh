#!/bin/bash
echo " ** GetSCUpdateList.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash GetSCUpdateList.sh
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
  ~/sysprocs/LOGMSG "  GetSCUpdateList - initiated from Make"
  echo "  GetSCUpdateList - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetSCUpdateList - initiated from Terminal"
  echo "  GetSCUpdateList - initiated from Terminal"
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

echo "-- GetSCUpdateList.sql - Get list of territories affected by SC download."  > SQLTemp.sql
echo "--	5/27/22.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * 6/26/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 5/2/22.	wmk.	*pathbase* support; added code to also check"  >> SQLTemp.sql
echo "-- *			 PolyTerri.db."  >> SQLTemp.sql
echo "-- * 5/27/22.	wmk.	*pathbase* actually added."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * GetSCUpdateList - Get list of territories affected by SC download."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** GetSCUpdateList **********"  >> SQLTemp.sql
echo "-- *	5/27/22.	wmk."  >> SQLTemp.sql
echo "-- *--------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * GetSCUpdateList - Get list of territories affected by SC download."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *   <list main DB and ATTACHed DBs and tables>"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " || '/RawData/SCPA/SCPA-Downloads/SCPADiff_05-26.db'"  >> SQLTemp.sql
echo "  AS db16;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " || '/DB-Dev/MultiMail.db'"  >> SQLTemp.sql
echo " AS db3;"  >> SQLTemp.sql
echo "with a AS (SELECT \"Account #\" AS Acct FROM Diff0526 )"  >> SQLTemp.sql
echo "SELECT DISTINCT OwningParcel AS PropID, CongTerrID AS TerrID"  >> SQLTemp.sql
echo "FROM SplitProps"  >> SQLTemp.sql
echo " WHERE PropID IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " AND rowid IN (SELECT rowid FROM SplitProps "  >> SQLTemp.sql
echo "  WHERE rowid IN (SELECT MAX(rowid) FROM SplitProps"  >> SQLTemp.sql
echo "   GROUP BY  OwningParcel,CongTerrID))"  >> SQLTemp.sql
echo "   ORDER BY TerrID;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END GetSCUpdateList **********"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "GetSCUpdateList.sh" "GetSCUpdateList processing complete. $P1"
fi
echo "  GetSCUpdateList complete."
~/sysprocs/LOGMSG "  GetSCUpdateList complete."
#end proc
