#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 6/17/21.	wmk.
#	Usage. bash RegenSpecDB.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1
TID=$P1
TN="Terr"
if [ "$HOME" == "/home/ubuntu" ]; then
 folderbase=$folderbase
else
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  ~/sysprocs/LOGMSG "  RegenSpecDB - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RegenSpecDB - initiated from Terminal"
  echo "  RegenSpecDB - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere
pushd ./ > $TEMP_PATH/bitbucket.txt
echo "-- RegenSpecDB.sq- Regenerate Spec288_RU.db in RU territory folder (template)." > SQLTemp.sql
echo "--	8/22/21.	wmk." >> SQLTemp.sql
echo "-- copy and edit this SQL template to territory RU download folder." >> SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/RefUSA/RefUSA-Downloads/Terr288'" >> SQLTemp.sql
echo "--.trace 'Procs-Dev/SQLTrace.txt'" >> SQLTemp.sql
echo "--.cd './Special'" >> SQLTemp.sql
echo "-- .open 'Spec288_RU.db';" >> SQLTemp.sql
echo "--#echo $DB_NAME;" >> SQLTemp.sql
echo ".open 'Spec288_RU.db' " >> SQLTemp.sql
echo "-- drop old version of Special Bridge and recreate;" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Spec_RUBridge;" >> SQLTemp.sql
echo "CREATE TABLE Spec_RUBridge" >> SQLTemp.sql
echo "( \"OwningParcel\" TEXT NOT NULL," >> SQLTemp.sql
echo " \"UnitAddress\" TEXT NOT NULL," >> SQLTemp.sql
echo " \"Unit\" TEXT, \"Resident1\" TEXT, " >> SQLTemp.sql
echo " \"Phone1\" TEXT,  \"Phone2\" TEXT," >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, \"SubTerritory\" TEXT," >> SQLTemp.sql
echo " \"CongTerrID\" TEXT, \"DoNotCall\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"RSO\" INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"RecordDate\" REAL DEFAULT 0," >> SQLTemp.sql
echo " \"SitusAddress\" TEXT, \"PropUse\" TEXT," >> SQLTemp.sql
echo "  \"DelPending\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"RecordType\" TEXT);" >> SQLTemp.sql
echo "-- * fix OwningParcels in GondolaParkDr.db;" >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Terr288'" >> SQLTemp.sql
echo "   || '/Terr288_SC.db'" >> SQLTemp.sql
echo "   AS db11;" >> SQLTemp.sql
echo ".cd '../Special'" >> SQLTemp.sql
echo "ATTACH 'GondolaParkDr.db' AS db29;" >> SQLTemp.sql
echo "-- * first, set parcelIDs in all GondolaParkDr.db records belonging to territory 288;" >> SQLTemp.sql
echo "WITH a AS (SELECT OwningParcel AS Acct, UnitAddress AS StreetAddr," >> SQLTemp.sql
echo " Unit AS TUnit FROM db11.Terr288_SCBridge)" >> SQLTemp.sql
echo "UPDATE db29.Spec_RUBridge" >> SQLTemp.sql
echo "SET OwningParcel =" >> SQLTemp.sql
echo "CASE" >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)" >> SQLTemp.sql
echo " THEN (SELECT Acct FROM a" >> SQLTemp.sql
echo "   WHERE StreetAddr IS upper(trim(UnitAddress)) )" >> SQLTemp.sql
echo "ELSE OwningParcel" >> SQLTemp.sql
echo "END;" >> SQLTemp.sql
echo "-- Now attach Special databases and select/insert their records;" >> SQLTemp.sql
echo "-- and populate the RUBridge table;" >> SQLTemp.sql
echo "INSERT INTO Spec_RUBridge" >> SQLTemp.sql
echo "SELECT * FROM db29.Spec_RUBridge " >> SQLTemp.sql
echo " WHERE CAST(OWNINGPARCEL AS INTEGER) >= 411113017" >> SQLTemp.sql
echo "  and  CAST(OWNINGPARCEL AS INTEGER) <= 411113080;" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo "DETACH db29;" >> SQLTemp.sql
echo "-- Repeat above block for each Special database.;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "-- end RegenSpecDB_db.sq;" >> SQLTemp.sql

#endprocbody

# conditional to skip SQL execution.
if [ not = true ]; then
 jumpto EndProc
fi
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
#
jumpto EndProc
EndProc:
popd >> $TEMP_PATH/bitbucket.txt
#notify-send "FixXXXRU.sh" "Terr XXX PostProcessing complete. $P1"
echo "  RegenSpecDB complete."
~/sysprocs/LOGMSG "  RegenSpecDB complete."
#end proc
# pathbase block.
# 5/30/22.
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 if [ ! -z "$congpath" ];then
  export pathbase=$folderbase/Territories
 else
  export pathbase=$folderbase/Territories
 fi
fi
# end pathbase block.
