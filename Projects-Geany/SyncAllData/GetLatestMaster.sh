#!/bin/bash
echo " ** GetLatestMaster.sh out-of-date **";exit 1
echo " ** GetLatestMaster.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash GetLatestMaster.sh
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
  ~/sysprocs/LOGMSG "  GetLatestMaster - initiated from Make"
  echo "  GetLatestMaster - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetLatestMaster - initiated from Terminal"
  echo "  GetLatestMaster - initiated from Terminal"
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

echo "-- * GetLatestMaster.sql - Get date of latest Terr86777.db record matching db table."  > SQLTemp.sql
echo "-- * 2/17/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	*DoSed has set the following fields:"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * < db-path > = database path (e.g. *pathbase/*rupath/Special)"  >> SQLTemp.sql
echo "-- * < db-name > = database name (e.g. CapriIslesBvd.db)"  >> SQLTemp.sql
echo "-- * < db-table > = database table (e.g. Spec_RUBridge)"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit. .csv record:"  >> SQLTemp.sql
echo "-- *		*TEMP_PATH/LatestMasterDate.txt = \"< db-name >\", yyyy-mm-dd "  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/18/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. Terr261_SCBridge must have DownloadDate field."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- * open Terr261_SC.db having Terr261_SCBridge;"  >> SQLTemp.sql
echo "-- * attach Terr86777 as db2;"  >> SQLTemp.sql
echo ".open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr261/Terr261_SC.db'"  >> SQLTemp.sql
echo "--PRAGMA table_info(Terr261_SCBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "--PRAGMA db2.table_info(Terr86777);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * output to file *TEMP_PATH/LatestMasterDate.txt;"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".output '$TEMP_PATH/LatestMasterDate.txt'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * select latest download date of any common record;"  >> SQLTemp.sql
echo "WITH a AS (SELECT OwningParcel FROM Terr261_SCBridge)"  >> SQLTemp.sql
echo "SELECT 'Terr261_SC.db',MAX(DownloadDate) FROM db2.Terr86777"  >> SQLTemp.sql
echo " WHERE \"Account #\" IN (SELECT OwningParcel FROM a);"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo " -- * END GetLatestMaster.sql;-- * .open <spec-db>.db;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  GetLatestMaster complete."
~/sysprocs/LOGMSG "  GetLatestMaster complete."
#end proc
