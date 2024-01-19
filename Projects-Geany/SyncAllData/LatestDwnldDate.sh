#!/bin/bash
echo " ** LatestDwnldDate.sh out-of-date **";exit 1
echo " ** LatestDwnldDate.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash LatestDwnldDate.sh
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
  ~/sysprocs/LOGMSG "  LatestDwnldDate - initiated from Make"
  echo "  LatestDwnldDate - initiated from Make"
else
  ~/sysprocs/LOGMSG "  LatestDwnldDate - initiated from Terminal"
  echo "  LatestDwnldDate - initiated from Terminal"
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

echo "-- * LatestDwnldDate.psq/sql - module description."  > SQLTemp.sql
echo "-- * 2/6/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry. /DB-Dev/Terr86777.db has latest county download data"  >> SQLTemp.sql
echo "-- *		//home/vncwmk3/Territories/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Special/TheEsplanade.Spec_RUBridge has field \"OwningParcel\" present"  >> SQLTemp.sql
echo "-- *		 (i.e. is a Bridge table)"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit. *TEMP_PATH/LatestDwnldDate = MAX(DownloadDate) in Terr86777.Terr86777"  >> SQLTemp.sql
echo "-- *		 set of records that is in TheEsplanade.Spec_RUBridge "  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/6/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. LatestDwnldDate extracts the latest *DownloadDate* field from"  >> SQLTemp.sql
echo "-- * Terr86777.Terr86777 records whose *Account #\" field is in the set"  >> SQLTemp.sql
echo "-- * of Spec_SCBridge.OwningParcel fields of some <spec-db>.db."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * LatestDwnldDate.psq depends upon *sed editing the *db-path*,"  >> SQLTemp.sql
echo "-- * *db-name*, and db-table placeholders to be the path, db name and table"  >> SQLTemp.sql
echo "-- * of the database having the records of interest in Terr86777.db."  >> SQLTemp.sql
echo "-- * (Note. The *sed that performs this edit is in preamble1.sh"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Special'"  >> SQLTemp.sql
echo " || '/TheEsplanade'"  >> SQLTemp.sql
echo " AS db19;"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".output '$TEMP_PATH/LatestDwnldDate.txt'"  >> SQLTemp.sql
echo "WITH a AS (SELECT OwningParcel PropID FROM db19.Spec_RUBridge)"  >> SQLTemp.sql
echo "SELECT MAX(DownloadDate), \" TheEsplanade\" FROM Terr86777"  >> SQLTemp.sql
echo " WHERE \"Account #\" IN (SELECT PropID FROM a);"  >> SQLTemp.sql
echo "-- * END LatestDwnldDate.sql;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  LatestDwnldDate complete."
~/sysprocs/LOGMSG "  LatestDwnldDate complete."
#end proc
