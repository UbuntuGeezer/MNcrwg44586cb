#!/bin/bash
# SCSpecTerrN_db.sh - Process SCPA special territory query into db.
#	6/5/23.	wmk.
#
#	Usage. bash SCSpecTerrN_db.sh  <spec-name>
#		<spec-name> = special name for territory (e.g. GondolaParkDr)
#		<spec-name>.csv assumed to exist in ~/SCPA-Downloads/Special folder
#		user assumed to be in RawData/SCPA/SCPA-Downloads folder
#
# Exit. <spec-name>.db created in folder /SCPA-Downloads/Special
#		  <spec-name> table is raw data from map polygon download
#		  PropTerr table is table of account#, situsaddress, terrid
#
# Modification History.
# ---------------------
# 5/30/22.	wmk.	(automated) pathbase block inserted; folderbase improvments.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 6/5/23.	wmk.	*pathbase corrected to FL/SARA/86777; comments tidied.
# Legacy mods.
# 7/2/21.	wmk.	original shell (compatible with make); adapted from
#			 SCSpecTerr.sh.
#
# Notes. The .csv file for this query has full records extracted from
# NVenAll. The resultant table <spec-name> is identical to the
# NVenAll table structure. SCSpecTerrN_db generates an .sql batch
# directives file, then runs sqlite to import the raw .csv data into table
# <spec-name>. Then a second query is run to create a second table
# PropTerr containing the property ID, street address and territory id.
# It is left as an exercise for the user to manually go through this
# table and assign territory ID field values, as the records may span
# several territories, and may be without rhyme or reason (e.g. "random"
# address assignments to territories courtesy of Territory Servant).
# jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
# check for 262system as special case.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
P1=$1
P2=$2
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/"SystemLog.txt"
  TEMP_PATH=$HOME/temp
 NO_PROMPT=1
  bash ~/sysprocs/LOGMSG "   SCSpecTerrN_db initiated from Make."
  echo "   SCSpecTerrN_db initiated."
else
 NO_PROMPT=0
  bash ~/sysprocs/LOGMSG "   SCSpecTerrN_db initiated from Terminal."
  echo "   SCSpecTerrN_db initiated."
fi
# pathbase block.
# 5/30/22.
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
  export pathbase=$folderbase/Territories/FL/SARA/86777
fi
# end pathbase block.
TEMP_PATH=$HOME/temp
#
if [ -z $P1 ]; then
  ~/sysprocs/LOGMSG "  special db name not specified... SCSpecTerrN_db abandoned."
  echo -e "special db name must be specified...\nSCSpecTerrN_db abandoned."
  exit 1
fi
#TID=$1
CSV_BASE=$P1
CSV_SUFFX=".csv"
CSV_NAME=$CSV_BASE$CSV_SUFFX
echo "special db source = \"Special/$CSV_NAME\""
if [ true ]; then
TST_STR="(test)"
else
TST_STR=""
fi
#remove column headings if present.
#sed -i '/Last Name/ d' $pathbase/RawData/SCPA/SCPA-Downloads/Special/$CSV_NAME
#echo -e "! If you did not delete the 'headings' from the .csv file..."
touch $TEMP_PATH/scratchfile
echo "-- copy Special .csv records to new tables...;" > SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/SCPA/SCPA-Downloads'" >> SQLTemp.sql
#.trace 'Procs-Dev/SQLTrace.txt'
echo ".cd \"./Special\""  >> SQLTemp.sql
# .open './DB/PolyTerri.db'
DB_END=".db"
#DB_SCEND="_SC.db"
TBL_END1=""
#TBL_END2="_SCPoly"
#TBL_END3="_SCBridge"
NAME_PRFX="$CSV_BASE"
MAP_SUFFX="_SC"
CSV_NAME1="$NAME_PRFX.csv"
DB_NAME="$P1$DB_END"
TBL_NAME1=$CSV_BASE
TBL_NAME2=PropTerr
#TBL_NAME3="Terr$TID$TBL_END3"
echo "DB_NAME = \"$DB_NAME\""
echo "TBL_NAME1 = \"$TBL_NAME1\""
echo "TBL_NAME2 = \"$TBL_NAME2\""
#echo "TBL_NAME3 = \"$TBL_NAME3\""
#echo $DB_NAME" >> SQLTemp.sql
echo ".open $DB_NAME " >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo ".separator ," >> SQLTemp.sql
echo "-- note. .csv file must contain headers for unspec'd .import;" >> SQLTemp.sql
echo "--.import '$CSV_BASE.csv' $TBL_NAME;" >> SQLTemp.sql
echo ".import '$pathbase/RawData/SCPA/SCPA-Downloads/Special/$CSV_NAME1' $TBL_NAME1" >> SQLTemp.sql
#echo ".import '$pathbase/RawData/SCPA/SCPA-Downloads/Special/$CSV_NAME1' " >> SQLTemp.sql
#  echo ".quit" >> SQLTemp.sql
echo "--create PropTerr table with account#, location name + location  street, terrid." >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME2;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME2" >> SQLTemp.sql
echo "(PropID TEXT, StreetAddr TEXT, TerrID TEXT);" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME2" >> SQLTemp.sql
echo "SELECT \"Account #\"," >> SQLTemp.sql
echo " trim(SUBSTR(\"situs address (property address)\",1,35)) AS StreetAddr," >> SQLTemp.sql
echo " \"\"" >> SQLTemp.sql
echo " FROM $TBL_NAME1" >> SQLTemp.sql
echo " ORDER BY StreetAddr;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
#
echo "-- create Terrxxx_SCPoly, then populate with sorted SCRaw records;" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME2;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME2" >> SQLTemp.sql
echo "(\"Last Name\" TEXT,\"First Name\" TEXT," >> SQLTemp.sql
echo "\"House Number\" TEXT," >> SQLTemp.sql
echo "\"Pre-directional\" TEXT,Street TEXT," >> SQLTemp.sql
echo "\"Street Suffix\" TEXT," >> SQLTemp.sql
echo "\"Post-directional\" TEXT,\"Apartment Number\" TEXT," >> SQLTemp.sql
echo "\"City\" TEXT,State TEXT,\"ZIP Code\" TEXT," >> SQLTemp.sql
echo "\"County Name\" TEXT," >> SQLTemp.sql
echo "\"Phone Number\" TEXT);" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME2 " >> SQLTemp.sql
echo "(\"Last Name\",\"First Name\"," >> SQLTemp.sql
echo "\"House Number\"," >> SQLTemp.sql
echo "\"Pre-directional\","Street"," >> SQLTemp.sql
echo "\"Street Suffix\"," >> SQLTemp.sql
echo "\"Post-directional\",\"Apartment Number\"," >> SQLTemp.sql
echo "City,State,\"ZIP Code\"," >> SQLTemp.sql
echo "\"County Name\"," >> SQLTemp.sql
echo "\"Phone Number\" ) " >> SQLTemp.sql
echo "SELECT * FROM $TBL_NAME1  " >> SQLTemp.sql
echo " ORDER BY Street, \"Post-directional\"," >> SQLTemp.sql
echo "    \"House Number\", \"Apartment Number\" ;" >> SQLTemp.sql
echo "-- now create SCBridge table;" >> SQLTemp.sql
jumpto NewestShell
NewestShell:
echo "DROP TABLE IF EXISTS $TBL_NAME3;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME3" >> SQLTemp.sql
echo "( OwningParcel TEXT NOT NULL," >> SQLTemp.sql
echo " UnitAddress TEXT NOT NULL," >> SQLTemp.sql
echo " Unit TEXT, Resident1 TEXT, " >> SQLTemp.sql
echo " Phone1 TEXT,  Phone2 TEXT," >> SQLTemp.sql
echo " \"SCPA-Phone\" TEXT, SubTerritory TEXT," >> SQLTemp.sql
echo " CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RSO INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RecordDate REAL DEFAULT 0," >> SQLTemp.sql
echo " SitusAddress TEXT, PropUse TEXT," >> SQLTemp.sql
echo "  DelPending INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RecordType TEXT);" >> SQLTemp.sql
echo "-- now populate the SCBridge table;" >> SQLTemp.sql
echo "WITH a AS (SELECT \"Last Name\"," >> SQLTemp.sql
echo " \"First Name\", TRIM(\"House Number\") AS House," >> SQLTemp.sql
echo "Street, \"Street Suffix\", \"Post-Directional\"," >> SQLTemp.sql
echo " \"Apartment Number\"," >> SQLTemp.sql
echo "\"Phone Number\" FROM $TBL_NAME2) " >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME3" >> SQLTemp.sql
echo "( OwningParcel, UnitAddress," >> SQLTemp.sql
echo " Unit, Resident1, Phone1, Phone2," >> SQLTemp.sql
echo " \"SCPA-Phone\", SubTerritory, CongTerrID, DoNotCall," >> SQLTemp.sql
echo "  RSO, \"Foreign\", RecordDate, SitusAddress," >> SQLTemp.sql
echo "  PropUse, DelPending, RecordType)" >> SQLTemp.sql
echo "SELECT \"-\"," >> SQLTemp.sql
echo "   CASE" >> SQLTemp.sql
echo "   WHEN LENGTH(\"Street Suffix\") > 0 THEN" >> SQLTemp.sql
echo "		House || \"   \" || Street || \" \"" >> SQLTemp.sql
echo "		|| TRIM(\"Street Suffix\") || \" \" || \"Post-Directional\"" >> SQLTemp.sql
echo "   ELSE" >> SQLTemp.sql
echo "		House || \"   \" || Street || \" \"" >> SQLTemp.sql
echo "		|| \"Post-Directional\"" >> SQLTemp.sql
echo "   END," >> SQLTemp.sql
echo "  \"Apartment Number\"," >> SQLTemp.sql
echo "  TRIM(\"First Name\") || \" \" || TRIM(\"Last Name\")," >> SQLTemp.sql
echo " \"\", \"\", \"Phone Number\", \"\", \"$TID\", NULL, NULL, NULL," >> SQLTemp.sql
echo "  DATE('now'), \"\", \"\", NULL,NULL " >> SQLTemp.sql
echo "FROM a;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "---SQL ends here.;" >> SQLTemp.sql
notify-send "SCSpecTerrN_db" "SQLTemp created."
if [ true ]; then
  jumpto TrySQL
fi
if [ true ]; then
  jumpto TestEnd
fi
jumpto TrySQL
TrySQL:
echo "starting sqlite3..."
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
#date +%T >> $system_log #
#  SCSpecTerrN_db $1 (Dev) $TST_STR complete." >> $system_log #
bash ~/sysprocs/LOGMSG "  SCSpecTerrN_db $1 (Dev) $TST_STR complete."
echo "SCSpecTerrN_db (Dev) $TST_STR complete."
# end SCSpecTerrN_db.sh
