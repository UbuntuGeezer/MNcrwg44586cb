#!/bin/bash
echo " ** RUNewTerr_db.sh out-of-date **";exit 1
# RUNewTerr_db.sh - Process RefUSA new territory download into db.
#	8/15/23.	wmk.
#
#	Usage. bash RUNewTerr_db.sh <terrid>
#		<terrid> = territory ID (e.g. 101)
#		user assumed to be in RawData/RefUSA/RefUSA-Downloads folder
#
# Exit. Map<terrid>_RU.csv imported into Terr<terrid>_RU.db
#
# Modification History.
# ---------------------
# 3/4/22.	wmk.	*sed removing header moved to UpdateRUDwnld project Mov*.sh
#			 files; NOPROMPT section removed; exit documentation clarified.
# 7/2/23.	wmk.	NOMAP semaphore support.
# 8/15/23.	wmk.	adapted for MN/CRWG/44586 territory.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.	wmk.	peform 9/23 automated mod.
# Legacy mods.
# 5/5/22.	wmk.	*pathbase* support.
# 7/9/22.	wmk.	'1 -eq 1' replaced with '1 -eq 1';TEMP_PATH corrected;
#			 trade 'touch' for 'if test -f';
# 7/18/22.	wmk.	code rearranged; environment var definitions consolidated.
# Legacy mods.
# 11/10/20.	wmk.	original shell
# 11/13/20. wmk.	IF EXISTS condition added to DROP TABLE sqls
# 11/14/20.	wmk.	bug fix "101" finished replacing with TID
# 12/1/20.	wmk.	Map filename vars changed to Map.TerrID._RU
# 3/6/21.	wmk.	added terrid to system log messages; adapted to run
#					from make bash call; NO_PROMPT env var added; sed
#					added to check 1st line of .csv
# 4/13/21.	wmk.	single line log messages.
# 4/15/21.	wmk.	mod to include ImportExtras.csv records if present.
# 5/10/21.	wmk.	bug fix; streets with Pre-directional not having
#					direction added when placed in Bridge table.
# 5/18/21.	wmk.	NOPROMPT always set 1 since sed takes care of 1st line.
# 5/27/21.	wmk.	modified for use with Kay's system; environment checked
#					and used for correct Territory folder paths.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/6/21.	wmk.	bug fixes; equality check for ($)HOME, TEMP_PATH
#					ensured set.
# Notes. 7/2/23. If the territory has the semaphore file NOMAP, only an empty
# Terr _RUBridge table is created in the database. Also the file Mapxxx_RU.csv
# is cleared to be an empty file.
# 
# 3/4/23. RUNewTerr_db was corrupting the Mapxxx_.csv file date by running
# *sed to eliminate the header. The mod with this date moves the *sed run to the
# Mov..sh shells in UpdateRUDwnld so that when the file is moved from the
# ./Downloads folder to the territory the header is stripped at that time. This
# leaves the Mapxxx_RU.csv file date accurately reflecting the download date.
# (This is part of the SyncAllData enhancement.)
#
# RUNewTerr_db generates an .sql batch directives
# file, then runs sqlite to import the Mapyyy_RU.csv data into table
# Terrxxx_RUPoly.  If file 'ImportExtra.csv' exists in the territory folder,
# its content is combined with Mapyyy_RU.csv.
# Then a sorting query is run to create a second table
# Terrxxx_RUBridge containing the download records sorted by street
# and number for easy extraction in correct order for territories.
# Notes on jumpto- in order for "labels" to not generate "unrecognized"
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
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
TEMP_PATH=$HOME/temp
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
P1=$1
# if this is a NOMAP territory, all its data comes from /Special downloads.
nomap=0
if test -f $pathbase/$rupath/Terr$P1/NOMAP;then
 $codebase/Procs-Dev/MakeEmptyRUMap.sh $P1
 nomap=1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
 NO_PROMPT=1
  bash ~/sysprocs/LOGMSG "   RUNewTerr_db initiated from Make."
  echo "   RUNewTerr_db initiated."
else
 NO_PROMPT=0
  bash ~/sysprocs/LOGMSG "   RUNewTerr_db initiated from Terminal."
  echo "   RUNewTerr_db initiated."
fi
#
NO_PROMPT=1		# always set NOPROMPT since sed takes care of
if [ -z $P1 ]; then
  echo "  Territory id not specified... RUNewTerr_db abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nRUNewTerr_db abandoned."
  exit 1
fi
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
TID=$1
TN="Terr"
CSV_BASE="Map$TID"
CSV_SUFFX="_RU.csv"
CSV_NAME=$CSV_BASE$CSV_SUFFX
echo $CSV_NAME
BASE_FOLDER="$pathbase/RawData/RefUSA/RefUSA-Downloads/$TN$TID"
DB_END="_RU.db"
TBL_END1="_RURaw"
TBL_END2="_RUPoly"
TBL_END3="_RUBridge"
NAME_PRFX="Map$TID"
MAP_SUFFX="_RU"
CSV_NAME1=$NAME_PRFX$MAP_SUFFX.csv		# Mapyyy_RU.csv
CSV_TEMP=$NAME_PRFX$MAP_SUFFX.tmp		# Mapyyy_RU.tmp
DB_NAME=Terr$TID$DB_END			# Terryyy_RU.db
TBL_NAME1=Terr$TID$TBL_END1		# Terryyy_RURaw
TBL_NAME2=Terr$TID$TBL_END2		# Terryyy_RUPoly
TBL_NAME3=Terr$TID$TBL_END3		# Terryyy_RUBridge
#sed -i '/Last Name/ d' $pathbase/RawData/RefUSA/RefUSA-Downloads/$TN$TID/$CSV_NAME
touch $TEMP_PATH/scratchfile
error_counter=0
#echo $DB_NAME
if [ 1 -eq 0 ]; then
  jumpto NewestShell
fi
if [ $nomap -eq 0 ];then
 if test -f $BASE_FOLDER/ImportExtra.csv;then
  #sed -i '{:a;/Last Name/ d;t a}' $BASE_FOLDER/ImportExtra.csv
  #cat here to join .csv files...
  mv $BASE_FOLDER/$CSV_NAME1 $BASE_FOLDER/CSV_TEMP
  cat $BASE_FOLDER/CSV_TEMP $BASE_FOLDER/ImportExtra.csv > $BASE_FOLDER/$CSV_NAME1
 fi
fi	# end not NOMAP
echo "-- SQLTemp.sql - RUNewTerr raw .csv to .db." > SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/RefUSA/RefUSA-Downloads'" >> SQLTemp.sql
#echo ".trace 'Procs-Dev/SQLTrace.txt'" >> SQLTemp.sql
echo ".cd './Terr$TID'"  >> SQLTemp.sql
echo ".open $DB_NAME " >> SQLTemp.sql
# if NOMAP, generate empty RUBridge table and quit.
if [ $nomap -ne 0 ];then
 jumpto NewestShell
fi
# create initial RURaw table
# concatenate ImportExtra.csv to CSV_NAME1
echo "DROP TABLE IF EXISTS $TBL_NAME1;" >> SQLTemp.sql
#insert CREATE TABLE for Terrxxx_RURaw here
echo "CREATE TABLE $TBL_NAME1" >> SQLTemp.sql
echo "(\"Last Name\" TEXT,\"First Name\" TEXT," >> SQLTemp.sql
echo "\"House Number\" TEXT," >> SQLTemp.sql
echo "\"Pre-directional\" TEXT,\"Street\" TEXT," >> SQLTemp.sql
echo "\"Street Suffix\" TEXT," >> SQLTemp.sql
echo "\"Post-directional\" TEXT,\"Apartment Number\" TEXT," >> SQLTemp.sql
echo "\"City\" TEXT,\"State\" TEXT,\"ZIP Code\" TEXT," >> SQLTemp.sql
echo "\"County Name\" TEXT," >> SQLTemp.sql
echo "\"Phone Number\" TEXT);" >> SQLTemp.sql
echo "-- setup and import new records to $TBL_NAME1" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo ".separator ," >> SQLTemp.sql
# note. .csv file must not contain headers for batch .import
#echo ".import 'Map$TID.csv' $TBL_NAME" >> SQLTemp.sql
echo ".import '$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$TID/$CSV_NAME1' $TBL_NAME1" >> SQLTemp.sql
# create Terrxxx_RUPoly, then populate with sorted RURaw records
echo "DROP TABLE IF EXISTS $TBL_NAME2;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME2" >> SQLTemp.sql
echo "(\"Last Name\" TEXT,\"First Name\" TEXT," >> SQLTemp.sql
echo "\"House Number\" TEXT," >> SQLTemp.sql
echo "\"Pre-directional\" TEXT,\"Street\" TEXT," >> SQLTemp.sql
echo "\"Street Suffix\" TEXT," >> SQLTemp.sql
echo "\"Post-directional\" TEXT,\"Apartment Number\" TEXT," >> SQLTemp.sql
echo "\"City\" TEXT,\"State\" TEXT,\"ZIP Code\" TEXT," >> SQLTemp.sql
echo "\"County Name\" TEXT," >> SQLTemp.sql
echo "\"Phone Number\" TEXT);" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME2 " >> SQLTemp.sql
echo "(\"Last Name\",\"First Name\"," >> SQLTemp.sql
echo "\"House Number\"," >> SQLTemp.sql
echo "\"Pre-directional\",\"Street\"," >> SQLTemp.sql
echo "\"Street Suffix\"," >> SQLTemp.sql
echo "\"Post-directional\",\"Apartment Number\"," >> SQLTemp.sql
echo "\"City\",\"State\",\"ZIP Code\"," >> SQLTemp.sql
echo "\"County Name\"," >> SQLTemp.sql
echo "\"Phone Number\" ) " >> SQLTemp.sql
echo "SELECT * FROM $TBL_NAME1  " >> SQLTemp.sql
echo " ORDER BY \"Street\", \"Post-directional\"," >> SQLTemp.sql
echo "    \"House Number\", \"Apartment Number\" ;" >> SQLTemp.sql
# now create RUBridge table
jumpto NewestShell
NewestShell:
echo "DROP TABLE IF EXISTS $TBL_NAME3;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME3" >> SQLTemp.sql
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
# stop here if NOMAP with empty RUBridge table.
if [ $nomap -ne 0 ];then
 echo ".quit" >> SQLTemp.sql
 jumpto TrySQL
fi
# now populate the RUBridge table
echo "WITH a AS (SELECT \"Last Name\"," >> SQLTemp.sql
echo " \"First Name\", TRIM(\"House Number\") AS House," >> SQLTemp.sql
echo " \"Pre-directional\"," >> SQLTemp.sql
echo "\"Street\", \"Street Suffix\", \"Post-Directional\"," >> SQLTemp.sql
echo " \"Apartment Number\"," >> SQLTemp.sql
echo "\"Phone Number\" FROM $TBL_NAME2) " >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME3" >> SQLTemp.sql
echo "( \"OwningParcel\", \"UnitAddress\"," >> SQLTemp.sql
echo " \"Unit\", \"Resident1\", \"Phone1\", \"Phone2\"," >> SQLTemp.sql
echo " \"RefUSA-Phone\", \"SubTerritory\", \"CongTerrID\", \"DoNotCall\"," >> SQLTemp.sql
echo "  \"RSO\", \"Foreign\", \"RecordDate\", \"SitusAddress\"," >> SQLTemp.sql
echo "  \"PropUse\", \"DelPending\", \"RecordType\")" >> SQLTemp.sql
echo "SELECT \"-\"," >> SQLTemp.sql
echo "   CASE"  >> SQLTemp.sql
echo "   WHEN LENGTH(\"Pre-directional\") > 0"  >> SQLTemp.sql
echo "    THEN"  >> SQLTemp.sql
echo "    CASE"  >> SQLTemp.sql
echo "    WHEN LENGTH(\"Street Suffix\") > 0"  >> SQLTemp.sql
echo "     THEN"  >> SQLTemp.sql
echo "		TRIM(House || \"   \" || TRIM(\"Pre-Directional\") || \" \""  >> SQLTemp.sql
echo "		|| \"Street\" || \" \""  >> SQLTemp.sql
echo "		|| TRIM(\"Street Suffix\") || \" \" || \"Post-Directional\")"  >> SQLTemp.sql
echo "     ELSE"  >> SQLTemp.sql
echo "		TRIM(House || \"   \" ||TRIM(\"Pre-Directional\") || \" \""  >> SQLTemp.sql
echo "		|| \"Street\" || \" \""  >> SQLTemp.sql
echo "		|| \"Post-Directional\")"  >> SQLTemp.sql
echo "     END"  >> SQLTemp.sql
echo "  ELSE" 	>> SQLTemp.sql
echo "    CASE"  >> SQLTemp.sql
echo "    WHEN LENGTH(\"Street Suffix\") > 0"  >> SQLTemp.sql
echo "     THEN"  >> SQLTemp.sql
echo "		TRIM(House || \"   \""  >> SQLTemp.sql
echo "		|| \"Street\" || \" \""  >> SQLTemp.sql
echo "		|| TRIM(\"Street Suffix\") || \" \" || \"Post-Directional\")"  >> SQLTemp.sql
echo "    ELSE"  >> SQLTemp.sql
echo "		TRIM(House || \"   \""  >> SQLTemp.sql
echo "		|| \"Street\" || \" \""  >> SQLTemp.sql
echo "		|| \"Post-Directional\")"  >> SQLTemp.sql
echo "    END"  >> SQLTemp.sql
echo "  END,"  >> SQLTemp.sql
#
#echo "   CASE" >> SQLTemp.sql
#echo "   WHEN LENGTH(\"Street Suffix\") > 0 " >> SQLTemp.sql
#echo "		AND LENGTH(\"Pre-Directional\") = 0 " >> SQLTemp.sql
#echo "   THEN" >> SQLTemp.sql
#echo "		House || \"   \" || \"Street\" || \" \"" >> SQLTemp.sql
#echo "		|| TRIM(\"Street Suffix\") || \" \" || \"Post-Directional\"" >> SQLTemp.sql
#echo "   ELSE" >> SQLTemp.sql
#echo "		House || \"   \" || \"Street\" || \" \"" >> SQLTemp.sql
#echo "		|| \"Post-Directional\"" >> SQLTemp.sql
#echo "   END," >> SQLTemp.sql
#
echo "  \"Apartment Number\"," >> SQLTemp.sql
echo "  TRIM(\"First Name\") || \" \" || TRIM(\"Last Name\")," >> SQLTemp.sql
echo " \"\", \"\", \"Phone Number\", \"\", \"$TID\", NULL, NULL, NULL," >> SQLTemp.sql
echo "  DATE('now'), \"\", \"\", NULL,NULL " >> SQLTemp.sql
echo "FROM a;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
if [ 1 -eq 1 ]; then
  jumpto TrySQL
fi
if [ 1 -eq 1 ]; then
  jumpto TestEnd
fi
jumpto TrySQL
TrySQL:
echo "entering sqlite3 with SQLTemp.sql..."
#cat SQLTemp.sql
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
~/sysprocs/LOGMSG "  RUNewTerr_db $1 (Dev) $TST_STR complete."
echo "  RUNewTerr_db (Dev) $TST_STR complete."
