#!/bin/bash
# RUNewBTerr_db.sh - Process RefUSA new business territory download into db.
#	8/4/22.	wmk. 
# RUNewBTerr_db - run sqlite processing raw download data into db
#	download from .csv (Phase 1) into SQL table TerrProps
#	Usage. bash RUNewBTerr_db.sh <terrid>
#		<terrid> = territory ID (e.g. 101)
#		user assumed to be in RawData/RefUSA/RefUSA-Downloads folder
#
# Modification History.
# ---------------------
# 5/11/22.	wmk.	*pathbase* support; add code to ensure 3 spaces
#			 between number and street in UnitAddress for consistency.
# 8/4/22.	wmk.	change base path to RawData from RawData.
# Legacy mods.
# 9/24/21.	wmk.	original shell; adapted from RUNewTerr_db.
# 9/25/21.	wmk.	RUPoly section activated.
# RUNewBTerr_db generates an .sql batch directives
# file, then runs sqlite to import the raw .csv data into table
# Terrxxx_RUPoly. Then a sorting query is run to create a second table
# Terrxxx_RUBridge containing the download records sorted by street
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
TEMP_PATH=$HOME
#
P1=$1

# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
 NO_PROMPT=1
  bash ~/sysprocs/LOGMSG "   RUNewBTerr_db initiated from Make."
  echo "   RUNewBTerr_db initiated."
else
 NO_PROMPT=0
  bash ~/sysprocs/LOGMSG "   RUNewBTerr_db initiated from Terminal."
  echo "   RUNewBTerr_db initiated."
fi
#
NO_PROMPT=1		# always set NOPROMPT since sed takes care of
if [ -z $P1 ]; then
  echo "  Territory id not specified... RUNewBTerr_db abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nRUNewBTerr_db abandoned."
  exit 1
fi
TID=$1
TN="Terr"
CSV_BASE="Map$TID"
CSV_SUFFX="_RU.csv"
CSV_NAME=$CSV_BASE$CSV_SUFFX
echo $CSV_NAME
if [ true ]; then
TST_STR="(test)"
else
TST_STR=""
fi
BASE_FOLDER=$pathbase/RawData/RefUSA/RefUSA-Downloads/$TN$TID
sed -i '/Last Name/ d' $pathbase/RawData/RefUSA/RefUSA-Downloads/$TN$TID/$CSV_NAME
if [ $NO_PROMPT = 0 ]; then
  echo -e "! If you did not delete the 'headings' from the .csv file..."
  read -p "Do you wish to proceed? (y/n)"
  if [ $REPLY == 'y' ] || [ $REPLY == 'Y' ]; then
   echo "  Proceeding with RUNewBTerr_db..."
  else
   echo "  RUNewBTerr_db - user wants to delete headings in .csv" >> $system_log
   echo "  RUNewBTerr_db abandoned - delete headings in .csv"
   exit 0 
  fi
fi
touch $TEMP_PATH/scratchfile
error_counter=0
echo "-- SQLTemp.sql - RUNewTerr raw .csv to .db." > SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/RefUSA/RefUSA-Downloads'" >> SQLTemp.sql
#echo ".trace 'Procs-Dev/SQLTrace.txt'" >> SQLTemp.sql
echo ".cd './Terr$TID'"  >> SQLTemp.sql
# echo ".open './DB/PolyTerri.db'" >> SQLTemp.sql
DB_END="_RU.db"
TBL_END1="_RURaw"
TBL_END2="_RUPoly"
TBL_END3="_RUBridge"
NAME_PRFX="Map$TID"
MAP_SUFFX="_RU"
CSV_NAME1="$NAME_PRFX$MAP_SUFFX.csv"
CSV_TEMP="$NAME_PRFX$MAP_SUFFX.tmp"
DB_NAME="Terr$TID$DB_END"
TBL_NAME1="Terr$TID$TBL_END1"
TBL_NAME2="Terr$TID$TBL_END2"
TBL_NAME3="Terr$TID$TBL_END3"
#echo $DB_NAME
echo ".open $DB_NAME " >> SQLTemp.sql
if [ not = true ]; then
  jumpto NewestShell
fi
if test -f $BASE_FOLDER/ImportExtra.csv;then
 sed -i '{:a;/Company Name/ d;t a}' $BASE_FOLDER/ImportExtra.csv
 #cat here to join .csv files...
 mv $BASE_FOLDER/$CSV_NAME1 $TEMP_PATH/CSV_TEMP
 cat $TEMP_PATH/CSV_TEMP $BASE_FOLDER/ImportExtra.csv > $BASE_FOLDER/$CSV_NAME1
fi
# create initial RURaw table
# concatenate ImportExtra.csv to CSV_NAME1
echo "DROP TABLE IF EXISTS $TBL_NAME1;" >> SQLTemp.sql
#insert CREATE TABLE for Terrxxx_RURaw here
echo "CREATE TABLE $TBL_NAME1" >> SQLTemp.sql 
echo "( CompanyName , ExecutiveFirstName , ExecutiveLastName ," >> SQLTemp.sql
echo "  Address , City , State , ZIPCode , CreditScoreAlpha ," >> SQLTemp.sql
echo "  ExecutiveGender , ExecutiveTitle , FaxNumberCombined ," >> SQLTemp.sql
echo "  IUSANumber , LocationEmployeeSizeRange ," >> SQLTemp.sql
echo "  LocationSalesVolumeRange , PhoneNumberCombined ," >> SQLTemp.sql
echo "  PrimarySICCode , PrimarySICDescription , SICCode1 ," >> SQLTemp.sql 
echo " SICCode1Description , RecordType )" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo "-- setup and import new records to $TBL_NAME1" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo ".separator ," >> SQLTemp.sql
# note. .csv file must not contain headers for batch .import
#echo ".import 'Map$TID.csv' $TBL_NAME" >> SQLTemp.sql
echo ".import '$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$TID/$CSV_NAME1' $TBL_NAME1" >> SQLTemp.sql
# create Terrxxx_RUPoly, then populate with sorted RURaw records
echo "DROP TABLE IF EXISTS $TBL_NAME2;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME2 " >> SQLTemp.sql
echo "( CompanyName , ExecutiveFirstName , ExecutiveLastName ," >> SQLTemp.sql
echo "  Address , City , State , ZIPCode , CreditScoreAlpha ," >> SQLTemp.sql
echo "  ExecutiveGender , ExecutiveTitle , FaxNumberCombined ," >> SQLTemp.sql
echo "  IUSANumber , LocationEmployeeSizeRange ," >> SQLTemp.sql
echo "  LocationSalesVolumeRange , PhoneNumberCombined ," >> SQLTemp.sql
echo "  PrimarySICCode , PrimarySICDescription , SICCode1 ," >> SQLTemp.sql 
echo " SICCode1Description , RecordType )" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME2 " >> SQLTemp.sql
echo "SELECT * FROM $TBL_NAME1  " >> SQLTemp.sql
echo " ORDER BY Address ;" >> SQLTemp.sql
# now create RUBridge table
echo "DROP TABLE IF EXISTS $TBL_NAME3;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME3" >> SQLTemp.sql
echo "( CompanyName TEXT, UnitAddress TEXT, Owner1 TEXT," >> SQLTemp.sql
echo " ContactPhone TEXT, BizDesc TEXT, City TEXT, Zip TEXT, " >> SQLTemp.sql
echo " OGender TEXT, OTitle TEXT, CongTerrID TEXT, " >> SQLTemp.sql
echo " DoNotCall INTEGER DEFAULT 0, RecordDate REAL DEFAULT 0, " >> SQLTemp.sql
echo " SunBizDoc TEXT, DelPending INTEGER DEFAULT 0 )" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
# now populate the RUBridge table
echo "WITH a AS (SELECT CompanyName AS BizName," >> SQLTemp.sql 
echo "  ExecutiveFirstName || ' ' || ExecutiveLastName AS Owner," >> SQLTemp.sql
echo "Address, City, ZipCode, ExecutiveGender AS Gender, ExecutiveTitle as Title," >> SQLTemp.sql
echo "  PhoneNumberCombined AS Phone, PrimarySICDescription AS BizDesc" >> SQLTemp.sql
echo "  FROM $TBL_NAME2)" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME3" >> SQLTemp.sql
echo "SELECT BizName," >> SQLTemp.sql
echo " SUBSTR(Address,1,Instr(Address,' ')-1) ||" >> SQLTemp.sql
echo " '  ' || SUBSTR(Address,Instr(Address,' ')), " >> SQLTemp.sql
echo " Owner, Phone, BizDesc, City, ZipCode," >> SQLTemp.sql
echo " Gender, Title, \"$TID\", '', Date('now'), '', ''" >> SQLTemp.sql
echo " FROM a" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
sqlite3 < SQLTemp.sql
bash ~/sysprocs/LOGMSG "  RUNewBTerr_db $1 (Dev) $TST_STR complete."
echo "  RUNewBTerr_db (Dev) $TST_STR complete."
# end RUNewBTerr_db.sh
