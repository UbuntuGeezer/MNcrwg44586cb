#!/bin/bash
# SCNewTerr_db.sh - Process SCPA new territory download into db.
#	8/6/22.	wmk. (Dev)
# SCNewTerr_db - run sqlite processing raw download data into db
#	download from .csv (Phase 1) into SQL table TerrProps
#	Usage. bash SCNewTerr_db.sh <terrid>
#		<terrid> = territory ID (e.g. 101)
#		user assumed to be in RawData/RefUSA/RefUSA-Downloads folder
#
# Modification History.
# ---------------------
# 8/6/22.	wmk.	*pathbase support; paths updated.
# Legacy mods.
# 11/14/20.	wmk.	original shell; adapted from RUNewTerr_db.sh
# 12/1/29.	wmk.	documentation updated
# 3/6/21.	wmk.	added terrid to system log messages; adapted to run
#					from make bash call.
# 5/30/21.	wmk.	modified for multihost support.
# 6/17/21.	wmk.	multihost code generalized; unary operator bug fixes.
# 9/10/21.	wmk.	ensure Terr_SCBridge build, even if no records;
#					superfluous #s removed;
# SCNewTerr_db generates an .sql batch directives
# file, then runs sqlite to import the raw .csv data into table
# Terrxxx_SCPoly. Then a sorting query is run to create a second table
# Terrxxx_SCBridge containing the download records sorted by street
# and number for easy extraction in correct order for territories.
#Notes on jumpto- in order for "labels" to not generate "unrecognized"
# errors, to protect against this for labels that have not been processed
# through a prior jumpto reference, each label is preceded by a jumpto
# referencing it.
# jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
#
P1=$1
NO_PROMPT=0
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
 TEMP_PATH=$HOME/temp
 NO_PROMPT=1
fi
#date +%T >> $system_log #
#echo "  SCNewTerr_db $P1 (Dev) started." >> $system_log #
~/sysprocs/LOGMSG "  SCNewTerr_db (Dev) started."
if [ -z "$P1" ]; then
  echo "  Territory id not specified... SCNewTerr_db abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nSCNewTerr_db abandoned."
  exit 1
fi
TID=$1
CSV_BASE="Map$TID"
CSV_SUFFX="_SC.csv"
CSV_NAME=$CSV_BASE$CSV_SUFFX
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
sed -i '/Account,Name,/ d' $pathbase/RawData/SCPA/SCPA-Downloads/Terr$TID/$CSV_NAME
#echo -e "! If you did not delete the 'headings' from the .csv file..."
if [ $NO_PROMPT = 0 ]; then 
 read -p "Do you wish to proceed? (y/n)"
 if [ $REPLY == 'y' ] || [ $REPLY == 'Y' ]; then
  echo "  Proceeding with SCNewTerr_db..."
 else
  echo "  SCNewTerr_db - user wants to delete headings in .csv" >> $system_log #
  echo "  SCNewTerr_db abandoned - delete headings in .csv"
  exit 0 
 fi   # end NO_PROMPT conditional
fi
touch $TEMP_PATH/scratchfile
error_counter=0
#beginprochere
echo "-- SQLTemp.sql - SCNewTerr raw .csv to .db." > SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/SCPA/SCPA-Downloads'" >> SQLTemp.sql
###echo ".trace 'Procs-Dev/SQLTrace.txt'" >> SQLTemp.sql;
echo ".cd './Terr$TID'"  >> SQLTemp.sql
#
DB_END="_SC.db"
TBL_END1="_SCPoly"
TBL_END2="_SCBridge"
NAME_PRFX="Map$TID"
MAP_SUFFX="_SC"
CSV_NAME1="$NAME_PRFX$MAP_SUFFX.csv"
DB_NAME="Terr$TID$DB_END"
TBL_NAME1="Terr$TID$TBL_END1"
TBL_NAME2="Terr$TID$TBL_END2"
#echo $DB_NAME
echo ".open $DB_NAME " >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto NewestShell
fi
# create initial SCPoly table
echo "DROP TABLE IF EXISTS $TBL_NAME1;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME1 " >> SQLTemp.sql
echo "( Account TEXT, Name TEXT, Name2 TEXT," >> SQLTemp.sql
echo " ADDRESS TEXT, CITY TEXT, STATE TEXT," >> SQLTemp.sql
echo " ZIP TEXT, COUNTRY TEXT," >> SQLTemp.sql
echo "   LOCATIONNAME TEXT, LOCATIONSTREET TEXT," >> SQLTemp.sql
echo "    LOCATIONDIRECTION TEXT, UNIT TEXT," >> SQLTemp.sql
echo "    LOCATIONCITY TEXT, LOCATIONZIP TEXT);" >> SQLTemp.sql
# note. .csv file must not contain headers for batch import
echo ".mode csv" >> SQLTemp.sql
echo ".import '$CSV_NAME1' '$TBL_NAME1'" >> SQLTemp.sql
# create Terrxxx_SCBridge, then populate with sorted SCPoly records
echo "DROP TABLE IF EXISTS $TBL_NAME2;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME2" >> SQLTemp.sql
echo "( \"OwningParcel\" TEXT NOT NULL," >> SQLTemp.sql
echo " \"UnitAddress\" TEXT NOT NULL," >> SQLTemp.sql
echo " \"Unit\" TEXT, \"Resident1\" TEXT," >> SQLTemp.sql 
echo " \"Phone1\" TEXT,  \"Phone2\" TEXT," >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, \"SubTerritory\" TEXT," >> SQLTemp.sql
echo " \"CongTerrID\" TEXT, \"DoNotCall\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"RSO\" INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"RecordDate\" REAL DEFAULT 0," >> SQLTemp.sql
echo " \"SitusAddress\" TEXT, \"PropUse\" TEXT," >> SQLTemp.sql
echo "  \"DelPending\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"RecordType\" TEXT);" >> SQLTemp.sql
# now populate the RUBridge table
echo "WITH a AS (SELECT"  >> SQLTemp.sql
echo "  Account, Name, LocationName, LocationStreet,"  >> SQLTemp.sql
echo "  LocationDirection, Unit"  >> SQLTemp.sql
echo "FROM $TBL_NAME1 " >> SQLTemp.sql
echo " ORDER BY LOCATIONSTREET, LOCATIONNAME) " >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME2" >> SQLTemp.sql
echo "( \"OwningParcel\", \"UnitAddress\"," >> SQLTemp.sql
echo " \"Unit\", \"Resident1\", \"Phone1\", \"Phone2\"," >> SQLTemp.sql
echo " \"RefUSA-Phone\", \"SubTerritory\", \"CongTerrID\", \"DoNotCall\"," >> SQLTemp.sql
echo "  \"RSO\", \"Foreign\", \"RecordDate\", \"SitusAddress\"," >> SQLTemp.sql
echo "  \"PropUse\", \"DelPending\", \"RecordType\")" >> SQLTemp.sql
echo "SELECT \"Account\"," >> SQLTemp.sql
echo "   CASE" >> SQLTemp.sql
echo "   WHEN LENGTH(TRIM(\"LocationDirection\")) > 0 THEN" >> SQLTemp.sql
echo " \"LocationName\" || \"   \" || \"LocationStreet\"" >> SQLTemp.sql
echo " || \" \" || TRIM(\"LocationDirection\")" >> SQLTemp.sql
echo "   ELSE" >> SQLTemp.sql
echo " \"LocationName\" || \"   \" || \"LocationStreet\"" >> SQLTemp.sql
echo " 	 END," >> SQLTemp.sql
echo " \"Unit\", \"Name\", \"\", \"\", \"\", \"\", \"$TID\"," >> SQLTemp.sql
echo " NULL, NULL, NULL, Date(\"now\"), \"\", \"\", NULL, \"\"" >> SQLTemp.sql
echo " FROM a;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
#procendhere
if [ 1 -eq 1 ]; then
  jumpto TrySQL
fi
if [ true ]; then
  jumpto TrySQL
fi
if [ true ]; then
  jumpto TestEnd
fi
jumpto TrySQL
TrySQL:
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
#date +%T >> $system_log #
#echo "  SCNewTerr_db $P1 (Dev) $TST_STR complete." >> $system_log #
~/sysprocs/LOGMSG "  SCNewTerr_db $P1 (Dev) $TST_STR complete."
echo "  SCNewTerr_db (Dev) $TST_STR complete."
