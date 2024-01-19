#!/bin/bash
echo " ** AddLetterZips.sh out-of-date **";exit 1
echo " ** AddLetterZips.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash AddLetterZips.sh
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
  ~/sysprocs/LOGMSG "  AddLetterZips - initiated from Make"
  echo "  AddLetterZips - initiated from Make"
else
  ~/sysprocs/LOGMSG "  AddLetterZips - initiated from Terminal"
  echo "  AddLetterZips - initiated from Terminal"
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

#begin preamble.LastChance.txt
#	9/15/21.	wmk.
#
# Modification History.
# ----------------------
# 7/8/21.	wmk.	original code.
# 9/15/21.	wmk.	SC_SUFFX assignment corrected.
TID=$P1
NAME_BASE=Terr
Q_NAME=Q$NAME_BASE
DB_SUFFX=.db
RU_SUFFX=_RUBridge
SC_SUFFX=_SCBridge
RU_DB=_RU.db
SC_DB=_SC.db
#end preamble.LastChance.txt
str=${TID:0:1}
if [ "$str" != "6" ];then exit 0;fi
echo "-- AddLetterZips - add zipcodes to letter territory SC UnitAddress fields;"  > SQLTemp.sql
echo "--		10/22/21.	wmk."  >> SQLTemp.sql
echo "-- Modification History."  >> SQLTemp.sql
echo "-- ---------------------"  >> SQLTemp.sql
echo "-- 4/24/22.		wmk.	*pathbase* env var added."  >> SQLTemp.sql
echo "-- Legacy mods."  >> SQLTemp.sql
echo "-- 10/11/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- 10/22/21.	wmk.	bug fix where 34275- getting doubled."  >> SQLTemp.sql
echo "--TID=$P1"  >> SQLTemp.sql
echo "--NAME_BASE=Terr"  >> SQLTemp.sql
echo "--Q_NAME=Q$NAME_BASE"  >> SQLTemp.sql
echo "--DB_SUFFX=.db"  >> SQLTemp.sql
echo "--RU_SUFFX=_RUBridge"  >> SQLTemp.sql
echo "--SC_SUFFX_SCBridge"  >> SQLTemp.sql
echo "--RU_DB=_RU.db"  >> SQLTemp.sql
echo "--SC_DB=_SC.db"  >> SQLTemp.sql
echo "-- * Begin AddLetterZips - Attach databases;"  >> SQLTemp.sql
echo ".cd '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo ".cd './$NAME_BASE$TID'"  >> SQLTemp.sql
echo ".open $NAME_BASE$TID$SC_DB"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev'"  >> SQLTemp.sql
echo " ||		'/VeniceNTerritory.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " \"situs zip code\" AS Zip"  >> SQLTemp.sql
echo "  FROM NVenAll)"  >> SQLTemp.sql
echo "UPDATE $NAME_BASE$TID$SC_SUFFX"  >> SQLTemp.sql
echo "SET UnitAddress ="  >> SQLTemp.sql
echo "case"  >> SQLTemp.sql
echo "when OWNINGPARCEL IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " then trim(UnitAddress) || '   '"  >> SQLTemp.sql
echo "  || (SELECT Zip FROM a"  >> SQLTemp.sql
echo "      WHERE Acct IS OwningParcel)"  >> SQLTemp.sql
echo "ELSE UnitAddress"  >> SQLTemp.sql
echo "end"  >> SQLTemp.sql
echo "WHERE CONGTERRID LIKE '6%'"  >> SQLTemp.sql
echo "  AND SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  AddLetterZips complete."
~/sysprocs/LOGMSG "  AddLetterZips complete."
#end proc
