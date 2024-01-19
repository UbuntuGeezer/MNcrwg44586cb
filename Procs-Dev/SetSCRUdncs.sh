#!/bin/bash
echo " ** SetSCRUdncs.sh out-of-date **";exit 1
#SetSCRUdncs.sh - Set DONOTCALLs in SC and RU Bridge tables.
#	10/6/22.	wmk.
#	Usage. bash SetSCRUdncs.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/6/22.	wmk.	comments tidied; jumpto references removed.
# Legacy mods.
# 4/24/22.	wmk.	*pathbase* env var incorporated.
# 5/2/22.	wmk.	missing parameter detection.
# Legacy mods.
# 4/6/21.	wmk.	original shell (template)
# 5/27/21.	wmk		modified for use with either home or Kay's system;
#				    folderbase vars added.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/7/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH 
#					ensured set; log messages fixed.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  ~/sysprocs/LOGMSG "  SetSCRUdncs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SetSCRUdncs - initiated from Terminal"
  echo "  SetSCRUdncs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#
P1=$1
TID=$P1
if [ -z "$P1" ];then
 echo "SetSCRUdncs <terrid> missing paramter - abandoned."
 exit 1
fi
TN="Terr"
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere
pushd ./ > $TEMP_PATH/bitbucket.txt
~/sysprocs/LOGMSG "   SetSCRUdncs.sh initiated from make."
echo "   SetSCRUdncs.sh initiated from make."
echo "--SetSCRUdncs.sql - Extracted sql from SetSCRUdncs.sh." > SQLTemp.sql
echo "--	4/6/21.	wmk." >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "-- * Dependencies." >> SQLTemp.sql
echo "-- *	Environment vars:" >> SQLTemp.sql
echo "-- *	NAME_BASE = \"Terr\"" >> SQLTemp.sql
echo "-- *	TID = territory ID" >> SQLTemp.sql
echo "-- *	SC_DB = \"_SC.db\"" >> SQLTemp.sql
echo "-- *	RU_DB = \"_RU.db\"" >> SQLTemp.sql
echo "-- *	SC_SUFFX = \"_SCBridge\"" >> SQLTemp.sql
echo "-- *	RU_SUFFX = \"_RUBridge\"" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Modification History." >> SQLTemp.sql
echo "-- * ---------------------" >> SQLTemp.sql
echo "-- * 3/9/21.	wmk.	original shell" >> SQLTemp.sql
echo "-- * 4/2/21.	wmk.	bug fix where unit not being checked on multi-unit" >> SQLTemp.sql
echo "-- *					properties and all units set DNC." >> SQLTemp.sql
echo "-- * Attach databases." >> SQLTemp.sql
echo ".cd '$pathbase/DB-Dev'" >> SQLTemp.sql
echo ".open junk.db" >> SQLTemp.sql
echo "ATTACH 'TerrIDData.db' AS db4;" >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData'" >> SQLTemp.sql
echo " ||		'/SCPA/SCPA-Downloads/$NAME_BASE$TID/$NAME_BASE$TID$SC_DB'" >> SQLTemp.sql
echo " AS db11;" >> SQLTemp.sql
echo "-- " >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData'" >> SQLTemp.sql
echo " ||		'/RefUSA/RefUSA-Downloads/$NAME_BASE$TID/$NAME_BASE$TID$RU_DB' " >> SQLTemp.sql
echo " AS db12;" >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "-- * Set DNCs in newly loaded Bridge tables." >> SQLTemp.sql
echo "-- *   in _SCBridge first;" >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM DONOTCALLS " >> SQLTemp.sql
echo "WHERE TERRID IS \"$TID\")" >> SQLTemp.sql
echo "UPDATE $NAME_BASE$TID$SC_SUFFX" >> SQLTemp.sql
echo "SET DONOTCALL = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN LENGTH(Unit) > 0 " >> SQLTemp.sql
echo " AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$SC_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$SC_SUFFX.Unit)" >> SQLTemp.sql
echo " THEN 1" >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT UnitAddress FROM a " >> SQLTemp.sql
echo " WHERE PropID IS OwningParcel)" >> SQLTemp.sql
echo " THEN 1" >> SQLTemp.sql
echo "ELSE \"\"" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo " \"FOREIGN\" = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN LENGTH(Unit) > 0 " >> SQLTemp.sql
echo " AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$SC_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$SC_SUFFX.Unit)" >> SQLTemp.sql
echo " THEN  (SELECT \"foreign\" from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$SC_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$SC_SUFFX.Unit)" >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT UnitAddress FROM a " >> SQLTemp.sql
echo " WHERE PropID IS OwningParcel)" >> SQLTemp.sql
echo " THEN  (SELECT \"foreign\" from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$SC_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "  )" >> SQLTemp.sql
echo "ELSE \"\"" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo "RSO = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN LENGTH(Unit) > 0 " >> SQLTemp.sql
echo " AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$SC_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$SC_SUFFX.Unit)" >> SQLTemp.sql
echo " THEN  (SELECT RSO from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$SC_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$SC_SUFFX.Unit)" >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT UnitAddress FROM a " >> SQLTemp.sql
echo " WHERE PropID IS OwningParcel)" >> SQLTemp.sql
echo " THEN  (SELECT RSO from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$SC_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "  )" >> SQLTemp.sql
echo "ELSE \"\"" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE OWNINGPARCEL IN (SELECT PROPID FROM a) " >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "--* now update RUBridge;" >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM DONOTCALLS " >> SQLTemp.sql
echo "WHERE TERRID IS \"$TID\")" >> SQLTemp.sql
echo "UPDATE $NAME_BASE$TID$RU_SUFFX" >> SQLTemp.sql
echo "SET DONOTCALL = " >> SQLTemp.sql
echo "CASE" >> SQLTemp.sql
echo "WHEN LENGTH(Unit) > 0 " >> SQLTemp.sql
echo " AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$RU_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$RU_SUFFX.Unit)" >> SQLTemp.sql
echo " THEN 1" >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT UnitAddress FROM a" >> SQLTemp.sql
echo "  WHERE PropID is OwningParcel) " >> SQLTemp.sql
echo " THEN 1" >> SQLTemp.sql
echo "ELSE \"\"" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo " \"FOREIGN\" = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN LENGTH(Unit) > 0 " >> SQLTemp.sql
echo " AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$RU_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$RU_SUFFX.Unit)" >> SQLTemp.sql
echo " THEN  (SELECT \"foreign\" from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$RU_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$RU_SUFFX.Unit)" >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT UnitAddress FROM a" >> SQLTemp.sql
echo "  WHERE PropID is OwningParcel) " >> SQLTemp.sql
echo " THEN  (SELECT \"foreign\" from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$RU_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "  )" >> SQLTemp.sql
echo "ELSE \"\"" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo "RSO = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN LENGTH(Unit) > 0 " >> SQLTemp.sql
echo " AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$RU_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$RU_SUFFX.Unit)" >> SQLTemp.sql
echo " THEN  (SELECT RSO from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$RU_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "	AND Unit IS $NAME_BASE$TID$RU_SUFFX.Unit)" >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT UnitAddress FROM a" >> SQLTemp.sql
echo "  WHERE PropID is OwningParcel) " >> SQLTemp.sql
echo " THEN  (SELECT RSO from a " >> SQLTemp.sql
echo "  where propid is OWNINGPARCEL" >> SQLTemp.sql
echo "	AND UnitAddress IS UPPER(TRIM($NAME_BASE$TID$RU_SUFFX.UnitAddress))" >> SQLTemp.sql
echo "  )" >> SQLTemp.sql
echo "ELSE \"\"" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE OWNINGPARCEL IN (SELECT PROPID FROM a)" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql

#endprocbody
#
sqlite3 < SQLTemp.sql
#
popd >> $TEMP_PATH/bitbucket.txt
echo "  SetSCRUdncs PostProcessing complete."
#end proc
~/sysprocs/LOGMSG "   SetSCRUdncs  $TID complete."
echo "   SetSCRUdncs $TID complete."
