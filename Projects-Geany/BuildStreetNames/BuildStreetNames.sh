#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash BuildStreetNames.sh
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
  ~/sysprocs/LOGMSG "  BuildStreetNames - initiated from Make"
  echo "  BuildStreetNames - initiated from Make"
else
  ~/sysprocs/LOGMSG "  BuildStreetNames - initiated from Terminal"
  echo "  BuildStreetNames - initiated from Terminal"
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

echo "-- * GetStreets.psq/sql - Get street names from Terr638_RU.db;"  > SQLTemp.sql
echo "-- *	12/19/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 12/19/22.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/StreetNames.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads'"  >> SQLTemp.sql
echo " || '/Terr638/Terr638_RU.db'"  >> SQLTemp.sql
echo " AS db12;"  >> SQLTemp.sql
echo "--PRAGMA db12.table_info(\"Streets\");"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "	INSERT INTO Streets"  >> SQLTemp.sql
echo "	SELECT DISTINCT TRIM(SUBSTR(UnitAddress, INSTR(UnitAddress,' ')))"  >> SQLTemp.sql
echo "	  StreetName, '638', '', ''"  >> SQLTemp.sql
echo "	FROM db12.Terr638_RUBridge"  >> SQLTemp.sql
echo "	ORDER BY StreetName;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END GetStreets.psq/sql."  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  BuildStreetNames complete."
~/sysprocs/LOGMSG "  BuildStreetNames complete."
#end proc
