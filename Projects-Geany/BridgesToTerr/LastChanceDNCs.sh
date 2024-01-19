#!/bin/bash
echo " ** LastChanceDNCs.sh out-of-date **";exit 1
echo " ** LastChanceDNCs.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 10/5/22.	wmk.
#	Usage. bash LastChanceDNCs.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	comments tidied.
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  LastChanceDNCs - initiated from Make"
  echo "  LastChanceDNCs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  LastChanceDNCs - initiated from Terminal"
  echo "  LastChanceDNCs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 TODAY=2022-04-22
fi
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
echo "--LastChanceDNCs.sql - Last chance correction of DNCs in QTerr$P1.SCBridge table;"  > SQLTemp.sql
echo "-- * 5/7/22.	wmk.	(automated) *pathbase* integration."  >> SQLTemp.sql
echo "-- this file will be converted to shell commands to write SQLTemp.sql;"  >> SQLTemp.sql
echo "-- 4/24/22.	wmk."  >> SQLTemp.sql
echo "-- Modification History."  >> SQLTemp.sql
echo "-- ---------------------"  >> SQLTemp.sql
echo "-- 4/24/22.	wmk.	*pathbase* env var included."  >> SQLTemp.sql
echo "-- Legacy mods."  >> SQLTemp.sql
echo "-- 7/8/21.	wmk.	original query script"  >> SQLTemp.sql
echo "-- 9/15/21.	wmk.	modified to only use DNC records with DelPending <> 1;"  >> SQLTemp.sql
echo "--					env var set statements commented out;"  >> SQLTemp.sql
echo "-- 10/5/21.	wmk.	ensure that Unit with blank(s) only treated as no unit;"  >> SQLTemp.sql
echo "--TID=$P1"  >> SQLTemp.sql
echo "--NAME_BASE=Terr"  >> SQLTemp.sql
echo "--Q_NAME=Q$NAME_BASE"  >> SQLTemp.sql
echo "--DB_SUFFX=.db"  >> SQLTemp.sql
echo "--RU_SUFFX=_RUBridge"  >> SQLTemp.sql
echo "--SC_SUFFX_SCBridge"  >> SQLTemp.sql
echo "--RU_DB=_RU.db"  >> SQLTemp.sql
echo "--SC_DB=_SC.db"  >> SQLTemp.sql
echo "--#proc body here"  >> SQLTemp.sql
echo "--pushd ./ >> $TEMP_PATH/bitbucket.txt"  >> SQLTemp.sql
echo "--cd $codebase/Procs-Dev"  >> SQLTemp.sql
echo "-- * Begin LastChanceDNCs - Attach databases;"  >> SQLTemp.sql
echo ".cd '$pathbase/TerrData'"  >> SQLTemp.sql
echo ".cd './$NAME_BASE$TID/Working-Files'"  >> SQLTemp.sql
echo ".open $Q_NAME$TID$DB_SUFFX"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev'"  >> SQLTemp.sql
echo " ||		'/TerrIDData.db'"  >> SQLTemp.sql
echo " AS db4;"  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * Start fresh, clearing all DNC fields;"  >> SQLTemp.sql
echo "UPDATE $Q_NAME$TID"  >> SQLTemp.sql
echo "SET DONOTCALL = \"\", "  >> SQLTemp.sql
echo " RSO = \"\", "  >> SQLTemp.sql
echo " \"FOREIGN\" = \"\" "  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo "-- * Set DNCs in newly created QTerrxxx records."  >> SQLTemp.sql
echo "-- *   in _SCBridge first;"  >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM DONOTCALLS "  >> SQLTemp.sql
echo "WHERE TERRID IS \"$TID\""  >> SQLTemp.sql
echo " AND DelPending IS NOT 1)"  >> SQLTemp.sql
echo "UPDATE $Q_NAME$TID"  >> SQLTemp.sql
echo "SET DONOTCALL = "  >> SQLTemp.sql
echo "case"  >> SQLTemp.sql
echo "when LENGTH(trim(Unit)) > 0"  >> SQLTemp.sql
echo " then"  >> SQLTemp.sql
echo "  CASE "  >> SQLTemp.sql
echo "  WHEN Unit IN (SELECT Unit FROM a "  >> SQLTemp.sql
echo "    where propid is OWNINGPARCEL"  >> SQLTemp.sql
echo "    AND UPPER(TRIM(UnitAddress))"  >> SQLTemp.sql
echo "     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))"  >> SQLTemp.sql
echo "  	AND Unit IS $Q_NAME$TID.Unit)"  >> SQLTemp.sql
echo "   THEN 1"  >> SQLTemp.sql
echo "  ELSE DONOTCALL"  >> SQLTemp.sql
echo "  END"  >> SQLTemp.sql
echo "else"  >> SQLTemp.sql
echo "    case"  >> SQLTemp.sql
echo "    when OwningParcel IN (SELECT PropID FROM a "  >> SQLTemp.sql
echo "       where Unit isnull or Length(Unit) = 0"  >> SQLTemp.sql
echo "       and upper(trim(UnitAddress))"  >> SQLTemp.sql
echo "        IN (select upper(trim(UnitAddress)) FROM a))"  >> SQLTemp.sql
echo "     then 1"  >> SQLTemp.sql
echo "    else DONOTCALL"  >> SQLTemp.sql
echo "    end"  >> SQLTemp.sql
echo "end,"  >> SQLTemp.sql
echo " \"FOREIGN\" = "  >> SQLTemp.sql
echo "case"  >> SQLTemp.sql
echo "when LENGTH(Unit) > 0"  >> SQLTemp.sql
echo " then"  >> SQLTemp.sql
echo "  CASE "  >> SQLTemp.sql
echo "  WHEN Unit IN (SELECT Unit FROM a "  >> SQLTemp.sql
echo "    where propid is OWNINGPARCEL"  >> SQLTemp.sql
echo "    AND UPPER(TRIM(UnitAddress))"  >> SQLTemp.sql
echo "     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))"  >> SQLTemp.sql
echo "  	AND Unit IS $Q_NAME$TID.Unit)"  >> SQLTemp.sql
echo "   THEN  (SELECT \"foreign\" from a "  >> SQLTemp.sql
echo "  			WHERE Unit IS $Q_NAME$TID.Unit"  >> SQLTemp.sql
echo "    AND UPPER(TRIM(UnitAddress))"  >> SQLTemp.sql
echo "     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))"  >> SQLTemp.sql
echo "    )"  >> SQLTemp.sql
echo "  ELSE \"Foreign\""  >> SQLTemp.sql
echo "  END"  >> SQLTemp.sql
echo "else"  >> SQLTemp.sql
echo "  case"  >> SQLTemp.sql
echo "  when OwningParcel IN (SELECT PropID FROM a "  >> SQLTemp.sql
echo "       where Unit isnull or Length(Unit) = 0)"  >> SQLTemp.sql
echo "   then (select \"Foreign\" from a "  >> SQLTemp.sql
echo "      where propid is OwningParcel"  >> SQLTemp.sql
echo "       and upper(trim(UnitAddress))"  >> SQLTemp.sql
echo "        IN (select upper(trim(UnitAddress)) FROM a))"  >> SQLTemp.sql
echo "  else \"Foreign\""  >> SQLTemp.sql
echo "  end"  >> SQLTemp.sql
echo "end,"  >> SQLTemp.sql
echo "RSO = "  >> SQLTemp.sql
echo "case"  >> SQLTemp.sql
echo "when LENGTH(Unit) > 0"  >> SQLTemp.sql
echo " then"  >> SQLTemp.sql
echo "  CASE "  >> SQLTemp.sql
echo "  WHEN Unit IN (SELECT Unit FROM a "  >> SQLTemp.sql
echo "    where propid is OWNINGPARCEL"  >> SQLTemp.sql
echo "    AND UPPER(TRIM(UnitAddress))"  >> SQLTemp.sql
echo "     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))"  >> SQLTemp.sql
echo "  	AND Unit IS $Q_NAME$TID.Unit)"  >> SQLTemp.sql
echo "   THEN  (SELECT RSO from a "  >> SQLTemp.sql
echo "  			WHERE Unit IS $Q_NAME$TID.Unit"  >> SQLTemp.sql
echo "    AND UPPER(TRIM(UnitAddress))"  >> SQLTemp.sql
echo "     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))"  >> SQLTemp.sql
echo "    )"  >> SQLTemp.sql
echo "  ELSE RSO"  >> SQLTemp.sql
echo "  END"  >> SQLTemp.sql
echo "else"  >> SQLTemp.sql
echo "  case"  >> SQLTemp.sql
echo "  when OwningParcel IN (SELECT PropID FROM a "  >> SQLTemp.sql
echo "       where Unit isnull or Length(Unit) = 0)"  >> SQLTemp.sql
echo "   then (select RSO from a "  >> SQLTemp.sql
echo "      where propid is OwningParcel"  >> SQLTemp.sql
echo "      and upper(trim(UnitAddress))"  >> SQLTemp.sql
echo "        IN (select upper(trim(UnitAddress)) FROM a))"  >> SQLTemp.sql
echo "   else RSO"  >> SQLTemp.sql
echo "  end"  >> SQLTemp.sql
echo "end"  >> SQLTemp.sql
echo "WHERE OWNINGPARCEL IN (SELECT PROPID FROM a); "  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- end LastChanceDNCs ***;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  LastChanceDNCs complete."
~/sysprocs/LOGMSG "  LastChanceDNCs complete."
#end proc
