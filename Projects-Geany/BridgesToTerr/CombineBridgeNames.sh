#!/bin/bash
echo " ** CombineBridgeNames.sh out-of-date **";exit 1
echo " ** CombineBridgeNames.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash CombineBridgeNames.sh
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
  ~/sysprocs/LOGMSG "  CombineBridgeNames - initiated from Make"
  echo "  CombineBridgeNames - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CombineBridgeNames - initiated from Terminal"
  echo "  CombineBridgeNames - initiated from Terminal"
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

# preamble.sh - preamble for BridgesToTerr project .sh builds.
#	12/5/22.	wmk.
# 7/10/23.	wmk.	db environment vars exported.
P1=$1
TID=$P1
TN="Terr"
export NAME_BASE=Terr
export NAME_BASE1=Terr_
export SC_DB=_SC.db
export RU_DB=_RU.db
export SC_SUFFX=_SCBridge
export RU_SUFFX=_RUBridge
# 11/29/22.	wmk.	following env vars added.
export DB1=$NAME_BASE$TID
export DB_SUFX=$SC_DB
echo "in premable.. environment vars follow:"
echo "NAME_BASE = '$NAME_BASE'"
echo "NAME_BASE1 = '$NAME_BASE1'"
echo "SC_DB = '$SC_DB'"
echo "RU_DB = '$RU_DB'"
echo "SC_SUFFX = '$SC_SUFFX'"
echo "RU_SUFFX = '$RU_SUFFX'"
echo "DB1 = '$DB_SUFX'"
echo "DB_SUFX = '$DB_SUFX'"
echo "--#procbodyhere"  > SQLTemp.sql
echo "-- * CombineSCBridgeNames - Combine multiple names in SC Bridge records.;"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 11/19/22.	wmk.	bug fix; VeniceNTerritory.db .NVenAll "  >> SQLTemp.sql
echo "-- *			 > Terr86777.db .Terr86777.ls"  >> SQLTemp.sql
echo "--; *"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "||		'/DB-Dev/Terr86777.db' "  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		\"/RawData/SCPA/SCPA-Downloads/Terr$TID/Terr$TID\" || \"_SC.db\""  >> SQLTemp.sql
echo "  AS db11;"  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " CASE "  >> SQLTemp.sql
echo " WHEN LENGTH(TRIM(\"Owner 3\")) > 0"  >> SQLTemp.sql
echo "  THEN TRIM(\"Owner 1\") || \", \""  >> SQLTemp.sql
echo "    || TRIM(\"Owner 2\") || \", \""  >> SQLTemp.sql
echo "    || TRIM(\"Owner 3\")"  >> SQLTemp.sql
echo " WHEN LENGTH(TRIM(\"Owner 2\")) > 0 "  >> SQLTemp.sql
echo "  THEN TRIM(\"Owner 1\") || \", \""  >> SQLTemp.sql
echo "    || TRIM(\"Owner 2\")"  >> SQLTemp.sql
echo " ELSE  \"Owner 1\""  >> SQLTemp.sql
echo " END AS Names"  >> SQLTemp.sql
echo " FROM Terr86777"  >> SQLTemp.sql
echo " WHERE Acct IN (SELECT OwningParcel"  >> SQLTemp.sql
echo "   FROM Terr$TID$SC_SUFFX)"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "UPDATE db11.Terr$TID$SC_SUFFX"  >> SQLTemp.sql
echo "SET Resident1 = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Names FROM a"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel"  >> SQLTemp.sql
echo " ) "  >> SQLTemp.sql
echo "ELSE Resident1"  >> SQLTemp.sql
echo "END; "  >> SQLTemp.sql
echo "--#endprocbody;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  CombineBridgeNames complete."
~/sysprocs/LOGMSG "  CombineBridgeNames complete."
#end proc
