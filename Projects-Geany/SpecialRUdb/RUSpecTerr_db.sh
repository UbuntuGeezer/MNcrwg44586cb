#!/bin/bash
echo " ** RUSpecTerr_db.sh out-of-date **";exit 1
echo " ** RUSpecTerr_db.sh out-of-date **";exit 1
# RUSpecTerr_db.sh - Process RefUSA new territory download into db.
#	3/1/23.	wmk. (Dev) 20:56
#
# RUSpecTerr_db - run sqlite processing raw download data into db
#	download from .csv (Phase 1) into SQL table TerrProps
#
#	Usage. bash RUSpecTerr_db.sh <spec-name>
#		<spec-name> = special name for territory (e.g. GondolaParkDr)
#		<spec-name>.csv assumed to exist in ~/RefUSA-Downloads/Special folder
#		user assumed to be in RawData/RefUSA/RefUSA-Downloads folder
#
# Exit. <spec-name>.db created in folder /RefUSA-Downloads/Special, if
#		  does not exist; updated with new tables if already exists
#			Spec_RURaw - raw download data from Special/<spec-name>.csv
#			Spec_RUPoly - sorted download data from RURaw
#			Spec_RUBridge - Bridge template records from Spec_RUPoly
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 3/1/23.	wmk.	modified to preserve date on <special>.csv by editing to
#			 target <spceial>.csv.imp; (RUSpecTerr_db.sql will now import the
#			 .imp file.
# Legacy mods.
# 4/25/22.	wmk.	modified for <state> <county> <congno> support;
#			 *pathbase* support.
# 5/31/22.	wmk.	TEMP_PATH defined; RUSpecTerr_db.log on temp path.
# Legacy mods.
# 4/24/21.	wmk.	original shell (compatible with make); adapted from
#					RUNewTerr_db.sql; mod history below kept while debugging.
# 6/7/21.	wmk.	multihost support added.
# 7/18/21.	wmk.	database base name changed from Terr to Spec.
# 8/17/21.	wmk.	<terrid> parameter eliminated.
#
# Notes. RUSpecTerr_db generates an .sql batch directives
# file, then runs sqlite to import the raw .csv data into table
# Special_Raw. Then a sorting query is run to create a second table
# Special_Poly containing the download records sorted by street
# and number for easy extraction in correct order for territories.
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
TEMP_PATH=$HOME/temp
P1=$1
P2=$2
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/"SystemLog.txt"
 NO_PROMPT=1
  bash ~/sysprocs/LOGMSG "   RUSpecTerr_db initiated from Make."
  echo "   RUSpecTerr_db initiated."
else
 NO_PROMPT=0
  bash ~/sysprocs/LOGMSG "   RUSpecTerr_db initiated from Terminal."
  echo "   RUSpecTerr_db initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  special db name not specified... RUSpecTerr_db abandoned."
  echo -e "special db name must be specified...\nRUSpecTerr_db abandoned."
  exit 1
fi
if [ true ]; then
TST_STR=(test)
else
TST_STR=""
fi
#TID=$1
CSV_BASE=$P1
CSV_SUFFX=.csv
CSV_NAME=$CSV_BASE$CSV_SUFFX
echo "special db source = \"Special/$CSV_NAME\""
DB_END=".db"
DB_RUEND="_RU.db"
TBL_END1="_RURaw"
TBL_END2="_RUPoly"
TBL_END3="_RUBridge"
NAME_PRFX="$CSV_BASE"
MAP_SUFFX="_RU"
CSV_NAME1="$NAME_PRFX.csv"
DB_NAME=$P1$DB_END
TBL_NAME1=Spec$TBL_END1
TBL_NAME2=Spec$TBL_END2
TBL_NAME3=Spec$TBL_END3
echo "DB_NAME = \"$DB_NAME\""  > $TEMP_PATH/RUSpecTerr_db.log
echo "TBL_NAME1 = \"$TBL_NAME1\"" >> $TEMP_PATH/RUSpecTerr_db.log
echo "TBL_NAME2 = \"$TBL_NAME2\"" >> $TEMP_PATH/RUSpecTerr_db.log
echo "TBL_NAME3 = \"$TBL_NAME3\"" >> $TEMP_PATH/RUSpecTerr_db.log
#remove column headings if present.
export csvdate=dummy
. $codebase/Projects-Geany/SyncAllData/SetCSVDate.sh $P1
echo $csvdate
# Note! This resets the .csv filedate to *now...; the original .csv date should
# have been captured in *csvdate BEFORE this...
sed '/Last Name/ d' $pathbase/RawData/RefUSA/RefUSA-Downloads/Special/$CSV_NAME \
 > $pathbase/RawData/RefUSA/RefUSA-Downloads/Special/$CSV_NAME1.imp
#echo -e "! If you did not delete the 'headings' from the .csv file..."
touch $TEMP_PATH/scratchfile
# end RUSpecTerr_1.sh

echo "-- * RUSpecTerr_db.sql - RUSpecTerr raw .csv to .db template."  > SQLTemp.sql
echo "-- *	3/1/23.	wmk."  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 3/1/23.	wmk.	INSERT simplified using only populated fields; *csvdate"  >> SQLTemp.sql
echo "-- *			 environment var dependency; change to import from"  >> SQLTemp.sql
echo "-- *			 <special>.csv.imp to preseve date on .csv download file."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, "  >> SQLTemp.sql
echo "-- *			 *congterr*, *conglib* env vars introduced."  >> SQLTemp.sql
echo "-- * 4/25/22.	wmk.	bug fix in .import missing *pathbase*."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 11/28/21.	wmk.	bug fix where pre-directional not incorporated into"  >> SQLTemp.sql
echo "-- *					Bridge UnitAddress fields."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- If table <special-db> exists, leave it alone."  >> SQLTemp.sql
echo "-- Create anew tables Spec_RURaw, Spec_RUPoly, Spec_RUBridge;"  >> SQLTemp.sql
echo "-- Create anew table TerrList, add count field;"  >> SQLTemp.sql
echo "-- Set CongTerrids from PolyTerri and MultiMail, updating TerrList."  >> SQLTemp.sql
echo "-- * open files  ************************;"  >> SQLTemp.sql
echo ".cd '$pathbase'"  >> SQLTemp.sql
echo ".cd './RawData/RefUSA/RefUSA-Downloads'"  >> SQLTemp.sql
echo "--.trace 'Procs-Dev/SQLTrace.txt'"  >> SQLTemp.sql
echo ".cd './Special'"  >> SQLTemp.sql
echo "-- .open './DB/PolyTerri.db';"  >> SQLTemp.sql
echo "--#echo $DB_NAME;"  >> SQLTemp.sql
echo ".open $DB_NAME "  >> SQLTemp.sql
echo "-- * create initial RURaw table.***************;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME1;"  >> SQLTemp.sql
echo "-- insert CREATE TABLE for Terrxxx_RURaw here;"  >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME1"  >> SQLTemp.sql
echo "(\"Last Name\" TEXT,\"First Name\" TEXT,"  >> SQLTemp.sql
echo "\"House Number\" TEXT,"  >> SQLTemp.sql
echo "\"Pre-directional\" TEXT,\"Street\" TEXT,"  >> SQLTemp.sql
echo "\"Street Suffix\" TEXT,"  >> SQLTemp.sql
echo "\"Post-directional\" TEXT,\"Apartment Number\" TEXT,"  >> SQLTemp.sql
echo "\"City\" TEXT,\"State\" TEXT,\"ZIP Code\" TEXT,"  >> SQLTemp.sql
echo "\"County Name\" TEXT,"  >> SQLTemp.sql
echo "\"Phone Number\" TEXT);"  >> SQLTemp.sql
echo "-- setup and import new records to $TBL_NAME1;"  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo "--# note. .csv file must not contain headers for batch .import"  >> SQLTemp.sql
echo "--#.import 'Map$TID.csv' $TBL_NAME;"  >> SQLTemp.sql
echo ".import '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/$CSV_NAME1.imp' $TBL_NAME1"  >> SQLTemp.sql
echo "UPDATE $TBL_NAME1"  >> SQLTemp.sql
echo "SET \"House Number\" = TRIM(\"House Number\");"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- * create Terrxxx_RUPoly, then populate with sorted RURaw records *******************;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME2;"  >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME2"  >> SQLTemp.sql
echo "(\"Last Name\" TEXT,\"First Name\" TEXT,"  >> SQLTemp.sql
echo "\"House Number\" TEXT,"  >> SQLTemp.sql
echo "\"Pre-directional\" TEXT,\"Street\" TEXT,"  >> SQLTemp.sql
echo "\"Street Suffix\" TEXT,"  >> SQLTemp.sql
echo "\"Post-directional\" TEXT,\"Apartment Number\" TEXT,"  >> SQLTemp.sql
echo "\"City\" TEXT,\"State\" TEXT,\"ZIP Code\" TEXT,"  >> SQLTemp.sql
echo "\"County Name\" TEXT,"  >> SQLTemp.sql
echo "\"Phone Number\" TEXT);"  >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME2 "  >> SQLTemp.sql
echo "(\"Last Name\",\"First Name\","  >> SQLTemp.sql
echo "\"House Number\","  >> SQLTemp.sql
echo "\"Pre-directional\",\"Street\","  >> SQLTemp.sql
echo "\"Street Suffix\","  >> SQLTemp.sql
echo "\"Post-directional\",\"Apartment Number\","  >> SQLTemp.sql
echo "\"City\",\"State\",\"ZIP Code\","  >> SQLTemp.sql
echo "\"County Name\","  >> SQLTemp.sql
echo "\"Phone Number\" ) "  >> SQLTemp.sql
echo "SELECT * FROM $TBL_NAME1  "  >> SQLTemp.sql
echo "ORDER BY \"Street\", \"Post-directional\","  >> SQLTemp.sql
echo "   CAST(\"House Number\" AS INT), \"Apartment Number\" ;"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- now create Bridge table. ******************************;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME3;"  >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME3"  >> SQLTemp.sql
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
echo "-- now populate the RUBridge table;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Last Name\","  >> SQLTemp.sql
echo " \"First Name\", TRIM(\"House Number\") AS House,"  >> SQLTemp.sql
echo "\"Pre-directional\","  >> SQLTemp.sql
echo "\"Street\", \"Street Suffix\", \"Post-Directional\","  >> SQLTemp.sql
echo " \"Apartment Number\","  >> SQLTemp.sql
echo "\"Phone Number\" FROM $TBL_NAME2) "  >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME3"  >> SQLTemp.sql
echo "( \"OwningParcel\", \"UnitAddress\","  >> SQLTemp.sql
echo " \"Unit\", \"Resident1\","  >> SQLTemp.sql
echo " \"RefUSA-Phone\", \"RecordDate\")"  >> SQLTemp.sql
echo "SELECT \"-\","  >> SQLTemp.sql
echo "CASE"  >> SQLTemp.sql
echo "   WHEN LENGTH(\"Pre-directional\") > 0   -- have predirectional"  >> SQLTemp.sql
echo "   THEN"  >> SQLTemp.sql
echo "     CASE"  >> SQLTemp.sql
echo "	 WHEN LENGTH(\"Street Suffix\") > 0"  >> SQLTemp.sql
echo "	 THEN"  >> SQLTemp.sql
echo "	  CASE"  >> SQLTemp.sql
echo "	  WHEN LENGTH(\"Post-directional\") > 0"  >> SQLTemp.sql
echo "	  THEN"  >> SQLTemp.sql
echo "		House || '   ' || \"Pre-Directional\" || ' ' || \"Street\" || ' '"  >> SQLTemp.sql
echo "		|| TRIM(\"Street Suffix\") || ' ' || \"Post-Directional\""  >> SQLTemp.sql
echo "	  ELSE  -- no postdirectional"  >> SQLTemp.sql
echo "		House || '   ' || \"Pre-Directional\" || ' ' || \"Street\" || ' '"  >> SQLTemp.sql
echo "		|| TRIM(\"Street Suffix\")"  >> SQLTemp.sql
echo "	  END  -- postdirectional"  >> SQLTemp.sql
echo "	 ELSE	-- no street suffix"  >> SQLTemp.sql
echo "	  CASE"  >> SQLTemp.sql
echo "	  WHEN LENGTH(\"Post-directional\") > 0"  >> SQLTemp.sql
echo "	  THEN"  >> SQLTemp.sql
echo "		House || '   ' || \"Pre-Directional\" || ' ' || \"Street\" || ' '"  >> SQLTemp.sql
echo "		|| \"Post-Directional\""  >> SQLTemp.sql
echo "	  ELSE -- no postidirectional"  >> SQLTemp.sql
echo "		House || '   ' || \"Pre-Directional\" || ' ' || \"Street\""  >> SQLTemp.sql
echo "	  END -- postdirectional"  >> SQLTemp.sql
echo "	 END  -- street suffix"  >> SQLTemp.sql
echo "ELSE -- no predirectional"  >> SQLTemp.sql
echo "     CASE"  >> SQLTemp.sql
echo "     WHEN LENGTH(\"Street Suffix\") > 0"  >> SQLTemp.sql
echo "     THEN"  >> SQLTemp.sql
echo "      CASE"  >> SQLTemp.sql
echo "      WHEN LENGTH(\"Post-directional\") > 0"  >> SQLTemp.sql
echo "      THEN"  >> SQLTemp.sql
echo "		House || '   ' || \"Street\" || ' ' || TRIM(\"Street Suffix\") || ' '"  >> SQLTemp.sql
echo "		|| \"Post-Directional\""  >> SQLTemp.sql
echo "	  ELSE -- no postdirectional"  >> SQLTemp.sql
echo "		House || '   ' || \"Street\" || ' ' || TRIM(\"Street Suffix\")"  >> SQLTemp.sql
echo "	  END -- postdirectional"  >> SQLTemp.sql
echo "    ELSE -- no street suffix"  >> SQLTemp.sql
echo "     CASE"  >> SQLTemp.sql
echo "     WHEN LENGTH(\"Post-directional\") > 0"  >> SQLTemp.sql
echo "     THEN"  >> SQLTemp.sql
echo "	  House || \"   \" || \"Street\" || \" \""  >> SQLTemp.sql
echo "		|| \"Post-Directional\""  >> SQLTemp.sql
echo "	 ELSE -- no postdirectional"  >> SQLTemp.sql
echo "	  House || \"   \" || \"Street\""  >> SQLTemp.sql
echo "	 END	-- postdirectional"  >> SQLTemp.sql
echo "   END	-- predirectional"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "  \"Apartment Number\","  >> SQLTemp.sql
echo "  TRIM(\"First Name\") || \" \" || TRIM(\"Last Name\"),"  >> SQLTemp.sql
echo "  \"Phone Number\", \"$csvdate\" "  >> SQLTemp.sql
echo "FROM a;"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- now create TerrList table. ***********************************;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS TerrList;"  >> SQLTemp.sql
echo "CREATE TABLE TerrList"  >> SQLTemp.sql
echo "(TerrID TEXT, Counts INTEGER DEFAULT 0);"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- * set territory ids from PolyTerri and MultiMail records *****;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/PolyTerri.db'"  >> SQLTemp.sql
echo " AS db5;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/MultiMail.db'"  >> SQLTemp.sql
echo " AS db3;"  >> SQLTemp.sql
echo "-- find matches in TerrProps;"  >> SQLTemp.sql
echo "with a AS (select DISTINCT upper(TRIM(UnitAddress)) AS StreetAddr,"  >> SQLTemp.sql
echo " CongTerrID AS TerrNo FROM TerrProps) "  >> SQLTemp.sql
echo "UPDATE Spec_RUBridge"  >> SQLTemp.sql
echo "SET CongTerrID = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UNITADDRESS)) IN (SELECT StreetAddr FROM a)"  >> SQLTemp.sql
echo "THEN (SELECT TerrNo FROM a "  >> SQLTemp.sql
echo " WHERE StreetAddr IS UPPER(trim(UnitAddress)))"  >> SQLTemp.sql
echo "ELSE CongTerrID"  >> SQLTemp.sql
echo "END "  >> SQLTemp.sql
echo "WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);"  >> SQLTemp.sql
echo "-- now find matches in SplitProps;"  >> SQLTemp.sql
echo "with a AS (select DISTINCT UPPER(TRIM(UnitAddress)) AS StreetAddr,"  >> SQLTemp.sql
echo " CongTerrID AS TerrNo FROM SplitProps )"  >> SQLTemp.sql
echo "UPDATE Spec_RUBridge"  >> SQLTemp.sql
echo "SET CongTerrID ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UNITADDRESS)) IN (SELECT StreetAddr FROM a)"  >> SQLTemp.sql
echo "THEN (SELECT TerrNo FROM a "  >> SQLTemp.sql
echo " WHERE StreetAddr IS UPPER(trim(UnitAddress)))"  >> SQLTemp.sql
echo "ELSE CongTerrID"  >> SQLTemp.sql
echo "END "  >> SQLTemp.sql
echo "WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);"  >> SQLTemp.sql
echo "-- end SetNewBridgeTerrs.sq;"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- * set TerrList and Counts in Territories **********************;"  >> SQLTemp.sql
echo "INSERT INTO TerrList"  >> SQLTemp.sql
echo "SELECT DISTINCT CongTerrID,0"  >> SQLTemp.sql
echo "FROM Spec_RUBridge;"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "WITH a AS (SELECT TerrID FROM Spec_RUBridge)"  >> SQLTemp.sql
echo "UPDATE TerrList"  >> SQLTemp.sql
echo "SET Counts ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN TerrID IN (SELECT TerrID FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT COUNT() FROM Spec_RUBridge"  >> SQLTemp.sql
echo "    WHERE TerrID IS TerrList.TerrID)"  >> SQLTemp.sql
echo "ELSE Counts"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- end RUSpecTerr_db.sq;"  >> SQLTemp.sql
# begin RUSpecTerr_2.sh
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 3/1/23.	wmk.	notify-send removed; [true] jumpto,s removed.
jumpto TrySQL
TrySQL:
echo "starting sqlite3..."
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
#  RUSpecTerr_db $1 (Dev) $TST_STR complete." >> $system_log #
~/sysprocs/LOGMSG "  RUSpecTerr_db $1 (Dev) $TST_STR complete."
echo "RUSpecTerr_db (Dev) $TST_STR complete."
# end RUSpecTerr_db.sh
# end RUSpecTerr_2.sh
