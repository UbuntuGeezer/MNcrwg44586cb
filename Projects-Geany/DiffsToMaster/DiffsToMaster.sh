#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash DiffsToMaster.sh
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
  ~/sysprocs/LOGMSG "  DiffsToMaster - initiated from Make"
  echo "  DiffsToMaster - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DiffsToMaster - initiated from Terminal"
  echo "  DiffsToMaster - initiated from Terminal"
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

echo "-- * DiffsToMaster.psq/sql - Update master territory database with new differences."  > SQLTemp.sql
echo "-- *	1/23/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 1/23/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. DiffsToMaster uses the INSERT/REPLACE INTO sql command to bring the"  >> SQLTemp.sql
echo "-- * Terr86777.db/Terr86777 table up-to-date. The parcel ID (Account #) field is"  >> SQLTemp.sql
echo "-- * the primary key for the Terr86777 table, so a new parcel ID will add a"  >> SQLTemp.sql
echo "-- * record, while an existing parcel ID will replace a record."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * open databases;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo " || '/SCPADiff_01-13.db'"  >> SQLTemp.sql
echo " AS db15;"  >> SQLTemp.sql
echo "-- PRAGMA db15.table_info(Diff0113);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * update Terr86777 from Diff0113 table;"  >> SQLTemp.sql
echo "INSERT OR REPLACE INTO Terr86777"  >> SQLTemp.sql
echo "SELECT * FROM db15.Diff0113;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END DiffsToMaster.sql"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  DiffsToMaster complete."
~/sysprocs/LOGMSG "  DiffsToMaster complete."
#end proc
