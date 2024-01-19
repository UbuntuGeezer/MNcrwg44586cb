#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash SCTidyTerr_db.sh
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
  ~/sysprocs/LOGMSG "  SCTidyTerr_db - initiated from Make"
  echo "  SCTidyTerr_db - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SCTidyTerr_db - initiated from Terminal"
  echo "  SCTidyTerr_db - initiated from Terminal"
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

# preSCTidy.sh
DB_END="_SC.db"
TBL_END1="_SCBridge"
TBL_END2=""
TBL_END3=""
DB_NAME="Terr$TID$DB_END"
TBL_NAME1="Terr$TID$TBL_END1"
TBL_NAME2="Terr$TID$TBL_END2"
TBL_NAME3="Terr$TID$TBL_END3"
# end preSCTidy.sh

echo "-- *procbodyhere;"  > SQLTemp.sql
echo "-- * SCTidyTerr -Tidy up _SCBridge records in new SCPA territory db."  >> SQLTemp.sql
echo "-- * 6/28/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/28/22.	wmk.	(automated) *pathbase* integration."  >> SQLTemp.sql
echo "-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777."  >> SQLTemp.sql
echo "-- * 6/28/22.	wmk.	*procbody support."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 11/11/20.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 9/23/21.	wmk.	modify RecordType code to use SCPropUse table from"  >> SQLTemp.sql
echo "-- *			 Terr86777.db."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".cd '$pathbase'"  >> SQLTemp.sql
echo ".cd './RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo ".shell touch SQLTrace.txt"  >> SQLTemp.sql
echo ".trace 'SQLTrace.txt'"  >> SQLTemp.sql
echo ".cd './Terr$TID'"  >> SQLTemp.sql
echo ".open $DB_NAME "  >> SQLTemp.sql
echo "-- * SetSitusPropUse - Set Situs and PropUse fields in $TBL_NAME1.;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "||		'/DB-Dev/Terr86777.db' "  >> SQLTemp.sql
echo "AS db2;"  >> SQLTemp.sql
echo "-- * set Situs and Property Use;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"ACCOUNT #\", "  >> SQLTemp.sql
echo "		\"SITUS ADDRESS (PROPERTY ADDRESS)\", \"PROPERTY USE CODE\""  >> SQLTemp.sql
echo "	FROM Terr86777)"  >> SQLTemp.sql
echo "UPDATE $TBL_NAME1"  >> SQLTemp.sql
echo "SET SitusAddress = "  >> SQLTemp.sql
echo "    (SELECT \"SITUS ADDRESS (PROPERTY ADDRESS)\""  >> SQLTemp.sql
echo "    FROM a "  >> SQLTemp.sql
echo "    WHERE \"ACCOUNT #\" IS OwningParcel),"  >> SQLTemp.sql
echo " PropUse = "  >> SQLTemp.sql
echo "    (SELECT \"PROPERTY USE CODE\""  >> SQLTemp.sql
echo "    FROM a "  >> SQLTemp.sql
echo "    WHERE \"ACCOUNT #\" IS OwningParcel)"  >> SQLTemp.sql
echo "WHERE OwningParcel IN "  >> SQLTemp.sql
echo " (SELECT \"ACCOUNT #\" FROM a)"  >> SQLTemp.sql
echo " AND (PropUse ISNULL OR PropUse IS \"\");"  >> SQLTemp.sql
echo "-- * SetDoNotCalls - Set DoNotCall, RSO and Foreign fields in Bridge;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo " AS db4;"  >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM db4.DoNotCalls"  >> SQLTemp.sql
echo "  WHERE TerrID IS \"$TID\")"  >> SQLTemp.sql
echo "UPDATE $TBL_NAME1"  >> SQLTemp.sql
echo "SET DoNotCall ="  >> SQLTemp.sql
echo "	CASE "  >> SQLTemp.sql
echo "	WHEN OwningParcel"  >> SQLTemp.sql
echo "	 IN (SELECT PropID FROM a)"  >> SQLTemp.sql
echo "   AND Unit IN (SELECT Unit FROM a "  >> SQLTemp.sql
echo "       WHERE PropID IS OwningParcel)"  >> SQLTemp.sql
echo "	THEN 1"  >> SQLTemp.sql
echo "	ELSE \"\""  >> SQLTemp.sql
echo "	END,"  >> SQLTemp.sql
echo "RSO ="  >> SQLTemp.sql
echo "	CASE "  >> SQLTemp.sql
echo "	WHEN OwningParcel"  >> SQLTemp.sql
echo "	 IN (SELECT PropID FROM a)"  >> SQLTemp.sql
echo "   AND Unit IN (SELECT Unit FROM a "  >> SQLTemp.sql
echo "       WHERE PropID IS OwningParcel)"  >> SQLTemp.sql
echo "	THEN "  >> SQLTemp.sql
echo "	  (SELECT RSO FROM a "  >> SQLTemp.sql
echo "		WHERE PROPID IS OwningParcel)"  >> SQLTemp.sql
echo "	ELSE RSO"  >> SQLTemp.sql
echo "	END,"  >> SQLTemp.sql
echo "\"Foreign\" = "  >> SQLTemp.sql
echo "	CASE "  >> SQLTemp.sql
echo "	WHEN OwningParcel"  >> SQLTemp.sql
echo "	 IN (SELECT PropID FROM a)"  >> SQLTemp.sql
echo "   AND Unit IN (SELECT Unit FROM a "  >> SQLTemp.sql
echo "       WHERE PropID IS OwningParcel)"  >> SQLTemp.sql
echo "	THEN "  >> SQLTemp.sql
echo "	  (SELECT \"FOREIGN\" FROM a "  >> SQLTemp.sql
echo "		WHERE PROPID IS OwningParcel)"  >> SQLTemp.sql
echo "	ELSE \"Foreign\""  >> SQLTemp.sql
echo "	END"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo "-- * SetRecordTypes - Set DoNotCallReccordType fields in Bridge.;"  >> SQLTemp.sql
echo "WITH a AS (SELECT Code, RType FROM db2.SCPropUse)"  >> SQLTemp.sql
echo "UPDATE $TBL_NAME1"  >> SQLTemp.sql
echo "SET RecordType ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN PropUse IN (SELECT Code FROM a) "  >> SQLTemp.sql
echo " THEN (SELECT RType FROM a"  >> SQLTemp.sql
echo "   WHERE Code IS PropUse)"  >> SQLTemp.sql
echo "ELSE RecordType"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo "-- * change Phone2 field to homestead * where matched;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " \"Homestead Exemption\" AS QHomestead"  >> SQLTemp.sql
echo " FROM Terr86777"  >> SQLTemp.sql
echo " WHERE Acct IN (SELECT OWNINGPARCEL"  >> SQLTemp.sql
echo "  FROM $TBL_NAME1))"  >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 "  >> SQLTemp.sql
echo "SET Phone2 = "  >> SQLTemp.sql
echo "CASE"  >> SQLTemp.sql
echo "WHEN (SELECT QHomestead FROM a "  >> SQLTemp.sql
echo "   WHERE Acct IS OWNINGPARCEL) IS \"YES\""  >> SQLTemp.sql
echo "   THEN \"*\""  >> SQLTemp.sql
echo "WHEN (SELECT QHomestead FROM a "  >> SQLTemp.sql
echo "   WHERE Acct IS OWNINGPARCEL) IS \"NO\""  >> SQLTemp.sql
echo "   THEN \"\""  >> SQLTemp.sql
echo "ELSE Phone2"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- *endprocbody;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  SCTidyTerr_db complete."
~/sysprocs/LOGMSG "  SCTidyTerr_db complete."
#end proc
