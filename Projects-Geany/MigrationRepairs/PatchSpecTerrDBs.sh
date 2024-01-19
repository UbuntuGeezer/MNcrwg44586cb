#!/bin/bash
echo " ** PatchSpecTerrDBs.sh out-of-date **";exit 1
echo " ** PatchSpecTerrDBs.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash PatchSpecTerrDBs.sh
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
  ~/sysprocs/LOGMSG "  PatchSpecTerrDBs - initiated from Make"
  echo "  PatchSpecTerrDBs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  PatchSpecTerrDBs - initiated from Terminal"
  echo "  PatchSpecTerrDBs - initiated from Terminal"
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

echo "-- * PatchSpecTerrDBs.psq/sql - Patch SC Special territory databases ."  > SQLTemp.sql
echo "-- * 5/10/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/10/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. PatchSpecTerrDBs fills in the Resident1, Phone2 and RecordDate"  >> SQLTemp.sql
echo "-- * fields in Terr139_SC.db and Spec139_SC.db.a"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.txt'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/$scpath/Terr139/Terr139_SC.db'"  >> SQLTemp.sql
echo " AS db11;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/$scpath/Terr139/Spec139_SC.db'"  >> SQLTemp.sql
echo " AS db21;"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "-- * fill in Terr139_SC.db records;"  >> SQLTemp.sql
echo "WITH a AS (SELECT OwningParcel PropID FROM db11.Terr139_SCBridge),"  >> SQLTemp.sql
echo "b AS (SELECT \"Account #\" Acct, DownloadDate DwnldDt,"  >> SQLTemp.sql
echo " CASE WHEN \"Homestead Exemption\" IS 'YES'"  >> SQLTemp.sql
echo "  THEN '*'"  >> SQLTemp.sql
echo " ELSE ''"  >> SQLTemp.sql
echo " END Hstead,"  >> SQLTemp.sql
echo " CASE WHEN LENGTH(\"Owner 3\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner 1\" || \", \" || \"Owner 2\" || \"Owner 3\""  >> SQLTemp.sql
echo " WHEN LENGTH(\"Owner 2\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner 1\" || \", \" || \"Owner 2\""  >> SQLTemp.sql
echo " ELSE \"Owner 1\""  >> SQLTemp.sql
echo " END WhosThere"  >> SQLTemp.sql
echo " FROM db2.Terr86777"  >> SQLTemp.sql
echo " WHERE Acct IN (SELECT PropID FROM a))"  >> SQLTemp.sql
echo "UPDATE Terr139_SCBridge"  >> SQLTemp.sql
echo "SET Resident1 ="  >> SQLTemp.sql
echo "CASE WHEN OwningParcel IN (SELECT Acct FROM b)"  >> SQLTemp.sql
echo " THEN (SELECT WhosThere FROM b"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel)"  >> SQLTemp.sql
echo "ELSE Resident1"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo "Phone2 ="  >> SQLTemp.sql
echo "CASE WHEN OwningParcel IN (SELECT Acct FROM b)"  >> SQLTemp.sql
echo " THEN (SELECT Hstead FROM b"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel)"  >> SQLTemp.sql
echo "ELSE Phone2"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo "RecordDate ="  >> SQLTemp.sql
echo "CASE WHEN OwningParcel IN (SELECT Acct FROM b)"  >> SQLTemp.sql
echo " THEN (SELECT DwnldDt FROM b"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel)"  >> SQLTemp.sql
echo "ELSE RecordDate"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * now fill in Spec139_DB records;"  >> SQLTemp.sql
echo "WITH a AS (SELECT OwningParcel PropID FROM db21.Spec_SCBridge),"  >> SQLTemp.sql
echo "b AS (SELECT \"Account #\" Acct, DownloadDate DwnldDt,"  >> SQLTemp.sql
echo " CASE WHEN \"Homestead Exemption\" IS 'YES'"  >> SQLTemp.sql
echo "  THEN '*'"  >> SQLTemp.sql
echo " ELSE ''"  >> SQLTemp.sql
echo " END Hstead,"  >> SQLTemp.sql
echo " CASE WHEN LENGTH(\"Owner 3\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner 1\" || \", \" || \"Owner 2\" || \"Owner 3\""  >> SQLTemp.sql
echo " WHEN LENGTH(\"Owner 2\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner 1\" || \", \" || \"Owner 2\""  >> SQLTemp.sql
echo " ELSE \"Owner 1\""  >> SQLTemp.sql
echo " END WhosThere"  >> SQLTemp.sql
echo " FROM db2.Terr86777"  >> SQLTemp.sql
echo " WHERE Acct IN (SELECT PropID FROM a))"  >> SQLTemp.sql
echo "UPDATE db21.Spec_SCBridge"  >> SQLTemp.sql
echo "SET Resident1 ="  >> SQLTemp.sql
echo "CASE WHEN OwningParcel IN (SELECT Acct FROM b)"  >> SQLTemp.sql
echo " THEN (SELECT WhosThere FROM b"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel)"  >> SQLTemp.sql
echo "ELSE Resident1"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo "Phone2 ="  >> SQLTemp.sql
echo "CASE WHEN OwningParcel IN (SELECT Acct FROM b)"  >> SQLTemp.sql
echo " THEN (SELECT Hstead FROM b"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel)"  >> SQLTemp.sql
echo "ELSE Phone2"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo "RecordDate ="  >> SQLTemp.sql
echo "CASE WHEN OwningParcel IN (SELECT Acct FROM b)"  >> SQLTemp.sql
echo " THEN (SELECT DwnldDt FROM b"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel)"  >> SQLTemp.sql
echo "ELSE RecordDate"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END PatchSpecTerrDBs.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  PatchSpecTerrDBs complete."
~/sysprocs/LOGMSG "  PatchSpecTerrDBs complete."
#end proc
