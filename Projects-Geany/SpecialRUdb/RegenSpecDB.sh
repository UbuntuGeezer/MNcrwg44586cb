#!/bin/bash
echo " ** RegenSpecDB.sh out-of-date **";exit 1
echo " ** RegenSpecDB.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash RegenSpecDB.sh
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
  ~/sysprocs/LOGMSG "  RegenSpecDB - initiated from Make"
  echo "  RegenSpecDB - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RegenSpecDB - initiated from Terminal"
  echo "  RegenSpecDB - initiated from Terminal"
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

echo "-- * RegenSpecDB.sql - Regenerate Spec129_SC.db in SC territory folder."  > SQLTemp.sql
echo "-- * 5/8/23.	wmk."  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 12/15/21.	wmk.	edited for territory 129."  >> SQLTemp.sql
echo "-- * 5/7/22.	wmk.	(automated) *pathbase* integration."  >> SQLTemp.sql
echo "-- * 5/8/23.	wmk.	Gibbs Rd added to dbs processed; read RegenSpec109 eliminated;"  >> SQLTemp.sql
echo ".cd '$pathbase'"  >> SQLTemp.sql
echo ".cd './RawData/SCPA/SCPA-Downloads/Terr129'"  >> SQLTemp.sql
echo "--.trace 'Procs-Dev/SQLTrace.txt';"  >> SQLTemp.sql
echo "-- .open 'Spec129_SC.db';"  >> SQLTemp.sql
echo "--#echo $DB_NAME;"  >> SQLTemp.sql
echo ".open 'Spec129_SC.db'"  >> SQLTemp.sql
echo "-- drop old version of Special Bridge and recreate;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Spec_SCBridge;"  >> SQLTemp.sql
echo "CREATE TABLE Spec_SCBridge"  >> SQLTemp.sql
echo "( \"OwningParcel\" TEXT NOT NULL,"  >> SQLTemp.sql
echo " \"UnitAddress\" TEXT NOT NULL,"  >> SQLTemp.sql
echo " \"Unit\" TEXT, \"Resident1\" TEXT, "  >> SQLTemp.sql
echo " \"Phone1\" TEXT,  \"Phone2\" TEXT,"  >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, \"SubTerritory\" TEXT,"  >> SQLTemp.sql
echo " \"CongTerrID\" TEXT, \"DoNotCall\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RSO\" INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RecordDate\" REAL DEFAULT 0,"  >> SQLTemp.sql
echo " \"SitusAddress\" TEXT, \"PropUse\" TEXT,"  >> SQLTemp.sql
echo "  \"DelPending\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RecordType\" TEXT);"  >> SQLTemp.sql
echo " -- Now attach Special databases and select/insert their records;"  >> SQLTemp.sql
echo "--.cd './Special';"  >> SQLTemp.sql
echo "--.read 'RegenSpec109.sql'"  >> SQLTemp.sql
echo "-- store the below block in Terr129Regen.sql"  >> SQLTemp.sql
echo ".cd '../Special'"  >> SQLTemp.sql
echo "ATTACH 'TarponCenterDr.db' AS db29;"  >> SQLTemp.sql
echo "INSERT INTO Spec_SCBridge"  >> SQLTemp.sql
echo "SELECT * FROM db29.Spec_SCBridge "  >> SQLTemp.sql
echo " WHERE UnitAddress LIKE '1555   tarpon center%';"  >> SQLTemp.sql
echo "DETACH db29;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH 'GibbsRd.db' AS db29;"  >> SQLTemp.sql
echo "INSERT INTO Spec_SCBridge"  >> SQLTemp.sql
echo "SELECT * FROM db29.Spec_SCBridge; "  >> SQLTemp.sql
echo "DETACH db29;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- end RegenSpecDB_db.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  RegenSpecDB complete."
~/sysprocs/LOGMSG "  RegenSpecDB complete."
#end proc
