#!/bin/bash
echo " ** PopulateAllAccts.sh out-of-date **";exit 1
echo " ** PopulateAllAccts.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash PopulateAllAccts.sh
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
  ~/sysprocs/LOGMSG "  PopulateAllAccts - initiated from Make"
  echo "  PopulateAllAccts - initiated from Make"
else
  ~/sysprocs/LOGMSG "  PopulateAllAccts - initiated from Terminal"
  echo "  PopulateAllAccts - initiated from Terminal"
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

echo "-- PopulateAllAccts - Populate AllAccts table in Terr86777.db."  > SQLTemp.sql
echo "-- *	4/29/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 4/29/22.	wmk.	original code."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS AllAccts;"  >> SQLTemp.sql
echo "CREATE TABLE AllAccts"  >> SQLTemp.sql
echo "( Account TEXT, PRIMARY KEY(Account));"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO AllAccts"  >> SQLTemp.sql
echo "SELECT \"Account #\" FROM Terr86777"  >> SQLTemp.sql
echo "ORDER BY \"Account #\";"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END PopulateAllAccts."  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "PopulateAllAccts.sh" "PopulateAllAccts processing complete. $P1"
fi
echo "  PopulateAllAccts complete."
~/sysprocs/LOGMSG "  PopulateAllAccts complete."
#end proc
