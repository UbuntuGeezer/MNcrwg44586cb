#!/bin/bash
# SortQTerrByAddr.sh -  (Dev) SortQTerr records by address.
# 5/2/22.	wmk. (rewrite)
#	Usage. bash SortQTerr.sh terrid
#		terrid  - territory id
#
#	Results.
#		QTerr<terrid>.db table QTerr<terrid> sorted by street, number
#			and apartment/unit number
#
# Dependencies.
# 	folder ../TerrData/<terrid> folder exists
#	database QTerr<terrid>.db contains unsorted territory records
#		extracted from PolyTerri and MultiMail for territory <terrid>
#	assumes user running from Terminal from ../Procs or ../Procs-Dev
#	generates SQL into file SQLTemp.sql
#	sqlite3 command line available
#
# Modification History.
# ---------------------
# 4/24/22.	wmk.	*pathbase* env var incorporated.
# 5/2/22.	wmk.	minor corrections.
# Legacy mods.
# 11/17/20.	wmk.	original shell
# 3/7/21.	wmk.	mod to work with make; sorting improvements; rewrite
#					QTerrxxx.csv on completion.
# 3/10/21.	wmk.	code rearranged to keep SQL in contiguous block for
#					partitioning editing.
# 5/30/21.	wmk.	modified for multihost system support.
# 7/3/21.	wmk.	multihost code generalized; error messages improved
#					documentation added.
# 7/3/21.	wmk.	major revision of SQL section.
#
# Notes. The resultant SQLTemp.sql performs the following operations:
# (current)
#	change to folder TerrData/Terrxxx/Working-Files
#	open db QTerrxxx.db
#	drop tables QTerrxxxU and QSplit
#	create new QSplit table, splitting UnitAddress into Street, Number
#	  and Unit fields and populating from QTerrxxx table
#	create new QSort table, same fields as QTerrxxx table
#	populate QSort table with select all records from QSplit table,
#	  reassembling UnitAddress field from Number, Street and Unit
#	drop table QTerrxxxU
#	rename table Qterrxxx to QTerrxxxU
#	rename table QSort to QTerrxxx
#
# (desired) 
#	after create new QSplitTable with additiona UpperStreet field
#	create new TEMP QSort table, same fields as QSplit table
#	populate QSortTable with all records from QSplit table
#	  order by UpperStreet, CAST(Number AS INT), Unit
#	create table QSorted, same fields as QTerrxxx
#	populate QSorted with all records from QSort table
#	  reassembling UnitAddress field from Number, Street and Unit
#	rename QTerrxxx table to QTerrxxU
#	rename QSorted table to QTerrxxx
# This sorting $hit is really bizarre; best way to sort is to split
# street, number, and unit and sort on that by adding a new field
# that is the uppercase street (UpperStreet); this
# will keep the friggin upper and lower case addresses that are the 
# same together and the sort can just be by UpperStreet, Number, Unit
# and it comes out in the correct order (so far...).
#jumpto function definition
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
 export pathbase=$folderbase/Territories
fi
#
P1=$1
if [ -z $system_log ]; then
   system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$folderbase/temp
if [ -z "$P1" ]; then
  #echo "  SortQTerrByAddr.. -param not specified - abandoned." >> $system_log #
  ~/sysprocs/LOGMSG "  SortQTerrByAddr.. <terrid> not specified - abandoned."
  echo "  SortQTerrByAddr.. must specify <terrid>."
  exit 1
else
  ~/sysprocs/LOGMSG "  SortQTerrByAddr $P1 - initiated from Terminal"
  echo "  SortQTerrByAddr $P1 - initiated from Terminal"
fi 
#proc body here
TID=$1
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
NAME_PRFX="QTerr$TID"
NAME_SUFFX="U"
DB_END=".db"
TBL_NAME1="QSplit"
TBL_NAME2="QSort"
TBL_NAME3="QSorted"
DB_NAME="$NAME_PRFX$DB_END"
# begin sorting SQL
echo "-- * SortQTerrByAddr query as batch run;" > SQLTemp.sql
echo "-- * entry env vars folderbase=Territories base directory;" >> SQLTemp.sql
echo "-- * TID = territory ID," >> SQLTemp.sql
echo "-- * NAME_PRFX=\"QTerr$TID\"" >> SQLTemp.sql
echo "-- * NAME_SUFFX=\"U\"" >> SQLTemp.sql
echo "-- * DB_END=\".db\"" >> SQLTemp.sql
echo "-- * TBL_NAME1=\"QSplit\"" >> SQLTemp.sql
echo "-- * TBL_NAME2=\"QSort\"" >> SQLTemp.sql
echo "-- * TBL_NAME3=\"QSorted\"" >> SQLTemp.sql
echo "-- * DB_NAME=\"$NAME_PRFX$DB_END\";" >> SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './TerrData/Terr$TID/Working-Files'" >> SQLTemp.sql
echo ".open $NAME_PRFX$DB_END" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $NAME_PRFX$NAME_SUFFX;" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME1;" >> SQLTemp.sql
if [ not = true ];then
 jumpto NoSplit
fi
echo "CREATE TEMP TABLE $TBL_NAME1" >> SQLTemp.sql
echo " ( OwningParcel TEXT," >> SQLTemp.sql
echo " AddrStreet TEXT," >> SQLTemp.sql
echo "  AddrNo TEXT NOT NULL," >> SQLTemp.sql
echo " UpperStreet TEXT," >> SQLTemp.sql
echo " Unit TEXT," >> SQLTemp.sql
echo " Resident1 TEXT, Phone1 TEXT, Phone2 TEXT," >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, SubTerritory TEXT," >> SQLTemp.sql
echo " CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RSO INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"Foreign\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RecordDate REAL DEFAULT 0," >> SQLTemp.sql
echo " SitusAddress TEXT DEFAULT \"\", PropUse INTEGER," >> SQLTemp.sql
echo " DelPending INTEGER DEFAULT 0 )" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME1" >> SQLTemp.sql
echo "( OwningParcel," >> SQLTemp.sql
echo "AddrStreet," >> SQLTemp.sql
echo " AddrNo," >> SQLTemp.sql
echo " UpperStreet," >> SQLTemp.sql
echo " Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2," >> SQLTemp.sql
echo " \"RefUSA-Phone\", SubTerritory," >> SQLTemp.sql
echo " CongTerrID, DoNotCall," >> SQLTemp.sql
echo " RSO," >> SQLTemp.sql
echo " \"Foreign\"," >> SQLTemp.sql
echo " RecordDate," >> SQLTemp.sql
echo " SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending )" >> SQLTemp.sql
echo "select" >> SQLTemp.sql
echo "OwningParcel,	" >> SQLTemp.sql
echo "TRIM(SUBSTR(UnitAddress,INSTR(UnitAddress,\" \")," >> SQLTemp.sql
echo "      LENGTH(UnitAddress)+1-INSTR(UnitAddress,\" \"))) AS Street, " >> SQLTemp.sql
echo "SUBSTR(UnitAddress,1,INSTR(UnitAddress, \" \")-1) AS AddrNo, " >> SQLTemp.sql
echo "UPPER(TRIM(SUBSTR(UnitAddress,6,29)))," >> SQLTemp.sql
echo "Unit, " >> SQLTemp.sql
echo " Resident1," >> SQLTemp.sql
echo " Phone1, Phone2," >> SQLTemp.sql
echo " \"RefUSA-Phone\", SubTerritory," >> SQLTemp.sql
echo " CongTerrID," >> SQLTemp.sql
echo " DoNotCall," >> SQLTemp.sql
echo " RSO," >> SQLTemp.sql
echo " \"Foreign\"," >> SQLTemp.sql
echo " RecordDate," >> SQLTemp.sql
echo " SitusAddress," >> SQLTemp.sql
echo " PropUse, DelPending" >> SQLTemp.sql
echo " FROM $NAME_PRFX" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo "-- * QSort same structure as QSplit;" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME2;" >> SQLTemp.sql
echo "CREATE TEMP TABLE $TBL_NAME2" >> SQLTemp.sql
echo " ( OwningParcel TEXT NOT NULL," >> SQLTemp.sql
echo "AddrStreet TEXT," >> SQLTemp.sql
echo " AddrNo TEXT," >> SQLTemp.sql
echo " UpperStreet TEXT," >> SQLTemp.sql
echo " Unit TEXT," >> SQLTemp.sql
echo " Resident1 TEXT, Phone1 TEXT, Phone2 TEXT," >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, SubTerritory TEXT," >> SQLTemp.sql
echo " CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RSO INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RecordDate REAL DEFAULT 0," >> SQLTemp.sql
echo " SitusAddress TEXT DEFAULT \"\", PropUse INTEGER," >> SQLTemp.sql
echo " DelPending INTEGER DEFAULT 0 );" >> SQLTemp.sql
echo "-- * populate from QSplit, sorting by address fields;" >> SQLTemp.sql
echo " INSERT INTO $TBL_NAME2" >> SQLTemp.sql
echo "  ( OwningParcel," >> SQLTemp.sql
echo " AddrStreet," >> SQLTemp.sql
echo " AddrNo, UpperStreet," >> SQLTemp.sql
echo " Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2," >> SQLTemp.sql
echo " \"RefUSA-Phone\", SubTerritory," >> SQLTemp.sql
echo " CongTerrID, DoNotCall," >> SQLTemp.sql
echo " RSO, \"Foreign\"," >> SQLTemp.sql
echo " RecordDate," >> SQLTemp.sql
echo " SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending)" >> SQLTemp.sql
echo " SELECT " >> SQLTemp.sql
echo " OwningParcel," >> SQLTemp.sql
echo " AddrStreet, AddrNo, UpperStreet, Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2," >> SQLTemp.sql
echo " \"RefUSA-Phone\", SubTerritory," >> SQLTemp.sql
echo " CongTerrID, DoNotCall," >> SQLTemp.sql
echo " RSO," >> SQLTemp.sql
echo " \"Foreign\"," >> SQLTemp.sql
echo " RecordDate," >> SQLTemp.sql
echo " SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending" >> SQLTemp.sql
echo " FROM $TBL_NAME1" >> SQLTemp.sql
echo "  ORDER BY UpperStreet, CAST(AddrNo AS INT), Unit" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
if [ 1 -eq 0 ];then
jumpto SortIt
fi
#
jumpto NoSplit
NoSplit:
jumpto SortIt
SortIt:
echo "-- * QSorted table same structure as QTerrxxx;" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME3;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME3" >> SQLTemp.sql
echo " ( OwningParcel TEXT," >> SQLTemp.sql
echo " UnitAddress TEXT," >> SQLTemp.sql
echo " Unit TEXT," >> SQLTemp.sql
echo " Resident1 TEXT, Phone1 TEXT, Phone2 TEXT," >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, SubTerritory TEXT," >> SQLTemp.sql
echo " CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RSO INTEGER DEFAULT 0," >> SQLTemp.sql
echo " \"Foreign\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RecordDate REAL DEFAULT 0," >> SQLTemp.sql
echo " SitusAddress TEXT DEFAULT \"\", PropUse INTEGER," >> SQLTemp.sql
echo " DelPending INTEGER DEFAULT 0 )" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME3 " >> SQLTemp.sql
echo "SELECT OwningParcel," >> SQLTemp.sql
echo " AddrNo || \"   \" || TRIM(AddrStreet) AS UnitAddress, " >> SQLTemp.sql
#echo " UnitAddress, " >> SQLTemp.sql
echo " Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2," >> SQLTemp.sql
echo " \"RefUSA-Phone\", SubTerritory," >> SQLTemp.sql
echo " CongTerrID, DoNotCall," >> SQLTemp.sql
echo " RSO, \"Foreign\"," >> SQLTemp.sql
echo " RecordDate," >> SQLTemp.sql
echo " SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending" >> SQLTemp.sql
echo "FROM $TBL_NAME2;" >> SQLTemp.sql
#echo " FROM $NAME_PRFX" >> SQLTemp.sql
#echo "  ORDER BY UnitAddress, OwningParcel;" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $NAME_PRFX$NAME_SUFFX;" >> SQLTemp.sql
echo "alter table $NAME_PRFX rename to $NAME_PRFX$NAME_SUFFX;" >> SQLTemp.sql
echo "alter table $TBL_NAME3 rename to $NAME_PRFX;" >> SQLTemp.sql
echo "-- end SortQTerrByAddr" >> SQLTemp.sql
# end sorting SQL.
#echo ".quit" >> SQLTemp.sql
jumpto GenTable
GenTable:
# Generate $TBL_NAME1.csv
echo ".shell echo \"Generating $TBL_NAME1.csv\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo ".shell rm $NAME_PRFX.csv" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".output '$NAME_PRFX.csv'" >> SQLTemp.sql
echo "SELECT * FROM $NAME_PRFX" >> SQLTemp.sql
echo "ORDER BY UnitAddress,OwningParcel;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
#end SQL
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
jumpto EndProc
EndProc:
#end proc body
if [ "$USER" != "vncwmk3" ];then
 notify-send "SortQTerrByAddr" "$P1 territory records sorted."
fi
echo "  $P1 territory records sorted."
~/sysprocs/LOGMSG "  SortQTerrBy Addr  $P1 territory records sorted."
#end SortQTerrByAddr.sh 
