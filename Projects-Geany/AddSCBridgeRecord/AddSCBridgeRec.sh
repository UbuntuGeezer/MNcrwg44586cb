#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash AddSCBridgeRec.sh
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
  ~/sysprocs/LOGMSG "  AddSCBridgeRec - initiated from Make"
  echo "  AddSCBridgeRec - initiated from Make"
else
  ~/sysprocs/LOGMSG "  AddSCBridgeRec - initiated from Terminal"
  echo "  AddSCBridgeRec - initiated from Terminal"
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

echo "-- * AddSCBridgeRec.psq - AddSCBridgeRec.sql template."  > SQLTemp.sql
echo "-- *	3/12/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 9/22/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/18/22.	wmk.	*pathbase support; code changes for Terr86777.db."  >> SQLTemp.sql
echo "-- * 3/12/23.	wmk.	db2 qualifier added to Terr86777 references."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. sed substitutes property id for w www and territory ID "  >> SQLTemp.sql
echo "-- * for y yy within this query, writing the resultant to .sql."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/RawData/SCPA/SCPA-Downloads/Terr115/Terr115_SC.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "-- pragma db2.table_info(Terr86777);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- code cloned from {SpecialSCdb}/SCSpecTerr_db.sql;"  >> SQLTemp.sql
echo "INSERT OR REPLACE INTO Terr115_SCBridge"  >> SQLTemp.sql
echo " SELECT \"Account #\","  >> SQLTemp.sql
echo "  trim(SUBSTR(\"situs address (property address)\",1,35)),"  >> SQLTemp.sql
echo "  SUBSTR(\"situs address (property address)\",36),"  >> SQLTemp.sql
echo "  CASE"  >> SQLTemp.sql
echo "  WHEN LENGTH(\"Owner 3\") > 0"  >> SQLTemp.sql
echo "   THEN \"Owner 1\" || \", \" || \"Owner 2\" || \", \" || \"Owner 3\""  >> SQLTemp.sql
echo "  WHEN LENGTH(\"Owner 2\") > 0"  >> SQLTemp.sql
echo "   THEN \"Owner 1\" || \", \" || \"Owner 2\""  >> SQLTemp.sql
echo "  ELSE \"Owner 1\""  >> SQLTemp.sql
echo "  END, \"\","  >> SQLTemp.sql
echo "  CASE "  >> SQLTemp.sql
echo "  WHEN \"Homestead Exemption\" IS \"YES\" "  >> SQLTemp.sql
echo "   THEN \"*\""  >> SQLTemp.sql
echo "  ELSE \"\""  >> SQLTemp.sql
echo "  END, \"\", \"\", \"115\", \"\", \"\", \"\", DownloadDate,"  >> SQLTemp.sql
echo "  \"situs address (property address)\","  >> SQLTemp.sql
echo "  \"Property Use Code\", \"\", \"\" FROM db2.Terr86777"  >> SQLTemp.sql
echo "WHERE \"Account #\" IS '0429050008';"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT Code, RType FROM db2.SCPropUse)"  >> SQLTemp.sql
echo "UPDATE Terr115_SCBridge"  >> SQLTemp.sql
echo "SET RecordType ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN PropUse IN (SELECT Code FROM a) "  >> SQLTemp.sql
echo " THEN (SELECT RType FROM a"  >> SQLTemp.sql
echo "  WHERE Code IS PropUse)"  >> SQLTemp.sql
echo "ELSE RecordType"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE OwningParcel IS '0429050008';"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- End AddSCBridgeRec;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  AddSCBridgeRec complete."
~/sysprocs/LOGMSG "  AddSCBridgeRec complete."
#end proc
