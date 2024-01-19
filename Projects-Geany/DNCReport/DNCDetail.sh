#!/bin/bash
echo " ** DNCDetail.sh out-of-date **";exit 1
echo " ** DNCDetail.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash DNCDetail.sh
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
  ~/sysprocs/LOGMSG "  DNCDetail - initiated from Make"
  echo "  DNCDetail - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DNCDetail - initiated from Terminal"
  echo "  DNCDetail - initiated from Terminal"
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

echo "-- * DNCDetail.sql - Generate DNCDetail.csv in Tracking folder."  > SQLTemp.sql
echo "-- *	5/17/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	*pathbase/DB-Dev/TerrIDData.db.DoNotCalls table has all"  >> SQLTemp.sql
echo "-- *	DO NOT CALL entries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.  *pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/DNCDetail.csv"  >> SQLTemp.sql
echo "-- * 	has count of RSOs by territory. This can easily be imported into a"  >> SQLTemp.sql
echo "-- *	spreadsheet for a general format report."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 7/10/22.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 5/17/23.	wmk.	target path corrected to use *codebase."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * This query should be run through the AnySQLtoSH project to produce the"  >> SQLTemp.sql
echo "-- * DNCDetail.sh shell. That shell will produce the output described in the"  >> SQLTemp.sql
echo "-- * Exit conditions above."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "--pragma db2.table_info(Terr86777);"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTs DNCDetail;"  >> SQLTemp.sql
echo "create temp table DNCDetail"  >> SQLTemp.sql
echo "(TID  TEXT, Address TEXT, Unit TEXT, Name TEXT, Phone TEXT,"  >> SQLTemp.sql
echo " RecDate TEXT, CntyDate TEXT,"  >> SQLTemp.sql
echo " RSO TEXT, FL TEXT, ZIP TEXT, Notes TEXT);"  >> SQLTemp.sql
echo "WITH b AS (SELECT \"Account #\" Acct, DownloadDate CountyDate"  >> SQLTemp.sql
echo " FROM db2.Terr86777 WHERE Acct IN (SELECT PropID FROM DoNotCalls))"  >> SQLTemp.sql
echo "insert into DNCDetail"  >> SQLTemp.sql
echo "SELECT TERRID, UnitAddress, Unit, Name, Phone, RecDate, b.CountyDate, RSO,"  >> SQLTemp.sql
echo " \"Foreign\", ZipCode, Notes"  >> SQLTemp.sql
echo "FROM donotcalls"  >> SQLTemp.sql
echo "INNER JOIN b"  >> SQLTemp.sql
echo "ON b.Acct IS PropID"  >> SQLTemp.sql
echo "order by TERRID;"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers on"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".output '$codebase/Projects-Geany/DoTerrsWithCalc/Tracking/DNCDetail.csv'"  >> SQLTemp.sql
echo "select * from DNCDetail;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END DNCDetail **********;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  DNCDetail complete."
~/sysprocs/LOGMSG "  DNCDetail complete."
#end proc
