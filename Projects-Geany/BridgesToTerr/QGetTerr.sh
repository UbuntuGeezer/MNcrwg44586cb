#!/bin/bash
echo " ** QGetTerr.sh out-of-date **";exit 1
echo " ** QGetTerr.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash QGetTerr.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  QGetTerr - initiated from Make"
  echo "  QGetTerr - initiated from Make"
else
  ~/sysprocs/LOGMSG "  QGetTerr - initiated from Terminal"
  echo "  QGetTerr - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

#
#preQGet.sh
TID=$1
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
NAME_PRFX="QTerr$TID"
DB_END=".db"
CSV_END=".csv"
DB_NAME="$NAME_PRFX$DB_END"
CSV_NAME="$NAME_PRFX$CSV_END"
TBL_NAME1="$NAME_PRFX"
#echo $DB_NAME
#end preQGet.sh
#
echo "-- * QGetTerr query as batch run."  > SQLTemp.sql
echo "-- *	6/26/22.	wmk."  >> SQLTemp.sql
echo ".cd '$pathbase'"  >> SQLTemp.sql
echo ".cd './TerrData/Terr$TID/Working-Files'"  >> SQLTemp.sql
echo ".shell echo \"Opening ./Terr$TID/Working-Files/$DB_NAME\" | awk '{print \$1}' > SQLTrace.txt"  >> SQLTemp.sql
echo ".open $DB_NAME "  >> SQLTemp.sql
echo "-- insert new code here...;"  >> SQLTemp.sql
echo ".shell echo \"Creating TEMP table QGetTerr\" | awk '{print \$1}' > SQLTrace.txt"  >> SQLTemp.sql
echo "-- ATTACH PolyTerri and MultiMail databases;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "||		'/DB-Dev/MultiMail.db'"  >> SQLTemp.sql
echo " AS db3;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/DB-Dev/PolyTerri.db'"  >> SQLTemp.sql
echo "  AS db5;"  >> SQLTemp.sql
echo "-- create TEMP table with extracted records and extra fields for sorting;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE QGetTerr( OwningParcel TEXT NOT NULL,"  >> SQLTemp.sql
echo " UnitAddress TEXT, QNum TEXT, QSitus TEXT, "  >> SQLTemp.sql
echo " QDir TEXT, Unit TEXT,"  >> SQLTemp.sql
echo " Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,"  >> SQLTemp.sql
echo "   \"RefUSA-Phone\" TEXT,SubTerritory TEXT,"  >> SQLTemp.sql
echo "    CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo "     RSO INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo "      RecordDate REAL DEFAULT 0, SitusAddress TEXT DEFAULT \"\","  >> SQLTemp.sql
echo "       PropUse INTEGER"  >> SQLTemp.sql
echo " );"  >> SQLTemp.sql
echo "-- populate temp table with extra sorting fields from PolyTerri and MultiMail; TerrProps and;"  >> SQLTemp.sql
echo "--  SplitProps records for territory;"  >> SQLTemp.sql
echo ".shell echo \"Populating TEMP table QGetTerr from .Props tables\" | awk '{print \$1}' >> SQLTrace.txt"  >> SQLTemp.sql
echo "-- use homestead information already in records;"  >> SQLTemp.sql
echo " INSERT INTO QGetTerr"  >> SQLTemp.sql
echo "( OwningParcel, UnitAddress,"  >> SQLTemp.sql
echo " QNum, QSitus, QDir, Unit,"  >> SQLTemp.sql
echo "  Resident1, Phone1, Phone2,"  >> SQLTemp.sql
echo "  \"RefUSA-Phone\", SubTerritory,"  >> SQLTemp.sql
echo "    CongTerrID, DoNotCall,"  >> SQLTemp.sql
echo "     RSO, \"Foreign\","  >> SQLTemp.sql
echo "      RecordDate, SitusAddress,"  >> SQLTemp.sql
echo "       PropUse"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "SELECT OWNINGPARCEL, UNITADDRESS,"  >> SQLTemp.sql
echo "CAST(SUBSTR(UNITADDRESS,1,INSTR(UNITADDRESS,\" \")-1) AS INTEGER) AS Num,"  >> SQLTemp.sql
echo "TRIM(SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS, \" \"),36-INSTR(SITUSADDRESS, \" \"))) AS SCSitus, "  >> SQLTemp.sql
echo "CASE"  >> SQLTemp.sql
echo "WHEN INSTR(\"NSEW\","  >> SQLTemp.sql
echo "	SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS,\" \")-1,1)) > 0"  >> SQLTemp.sql
echo " THEN SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS,\" \")-1,1)"  >> SQLTemp.sql
echo "ELSE \"\""  >> SQLTemp.sql
echo "END AS NSEW,"  >> SQLTemp.sql
echo " UNIT,"  >> SQLTemp.sql
echo "Resident1, Phone1,"  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN Phone2 IS \"*\" "  >> SQLTemp.sql
echo "  AND UPPER(UNITADDRESS) IS UNITADDRESS "  >> SQLTemp.sql
echo " THEN Phone2 "  >> SQLTemp.sql
echo "ELSE \"\" "  >> SQLTemp.sql
echo "END AS H, "  >> SQLTemp.sql
echo "  \"RefUSA-Phone\" AS RefUSAPhone,"  >> SQLTemp.sql
echo "SubTerritory, CongTerrID, DoNotCall, RSO,"  >> SQLTemp.sql
echo "\"Foreign\", RecordDate, SitusAddress, PropUse "  >> SQLTemp.sql
echo "FROM db5.TERRPROPS"  >> SQLTemp.sql
echo "WHERE CONGTERRID IS \"$TID\""  >> SQLTemp.sql
echo " AND SITUSADDRESS NOTNULL "  >> SQLTemp.sql
echo " AND SITUSADDRESS IS NOT \"\""  >> SQLTemp.sql
echo " AND cast(DELPENDING as INT) IS NOT 1"  >> SQLTemp.sql
echo "ORDER BY SCSitus,Num,Unit ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo " INSERT INTO QGetTerr"  >> SQLTemp.sql
echo "( OwningParcel, UnitAddress,"  >> SQLTemp.sql
echo " QNum, QSitus, QDir, Unit,"  >> SQLTemp.sql
echo "  Resident1, Phone1, Phone2,"  >> SQLTemp.sql
echo "  \"RefUSA-Phone\", SubTerritory,"  >> SQLTemp.sql
echo "    CongTerrID, DoNotCall,"  >> SQLTemp.sql
echo "     RSO, \"Foreign\","  >> SQLTemp.sql
echo "      RecordDate, SitusAddress,"  >> SQLTemp.sql
echo "       PropUse"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "SELECT OWNINGPARCEL, UNITADDRESS,"  >> SQLTemp.sql
echo "CAST(SUBSTR(UNITADDRESS,1,INSTR(UNITADDRESS,\" \")-1) AS INTEGER) AS Num,"  >> SQLTemp.sql
echo "TRIM(SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS, \" \"),36-INSTR(SITUSADDRESS, \" \"))) AS SCSitus, "  >> SQLTemp.sql
echo "CASE"  >> SQLTemp.sql
echo "WHEN INSTR(\"NSEW\","  >> SQLTemp.sql
echo "	SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS,\" \")-1,1)) > 0"  >> SQLTemp.sql
echo " THEN SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS,\" \")-1,1)"  >> SQLTemp.sql
echo "ELSE \"\""  >> SQLTemp.sql
echo "END AS NSEW,"  >> SQLTemp.sql
echo " UNIT,"  >> SQLTemp.sql
echo "Resident1, Phone1,"  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN Phone2 IS \"*\" "  >> SQLTemp.sql
echo "  AND UPPER(UNITADDRESS) IS UNITADDRESS "  >> SQLTemp.sql
echo " THEN Phone2 "  >> SQLTemp.sql
echo "ELSE \"\" "  >> SQLTemp.sql
echo "END AS H, "  >> SQLTemp.sql
echo "  \"RefUSA-Phone\" AS RefUSAPhone,"  >> SQLTemp.sql
echo "SubTerritory, CongTerrID, DoNotCall, RSO,"  >> SQLTemp.sql
echo "\"Foreign\", RecordDate, SitusAddress, PropUse "  >> SQLTemp.sql
echo "FROM db3.SPLITPROPS"  >> SQLTemp.sql
echo "WHERE CONGTERRID IS \"$TID\""  >> SQLTemp.sql
echo " AND SITUSADDRESS  NOTNULL "  >> SQLTemp.sql
echo " AND SITUSADDRESS IS NOT \"\""  >> SQLTemp.sql
echo " AND cast(DELPENDING as INT) IS NOT 1 "  >> SQLTemp.sql
echo "ORDER BY SCSitus,Num,Unit ;"  >> SQLTemp.sql
echo "-- begin 2/5/21 mod;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE HelluvaSort "  >> SQLTemp.sql
echo "( OwningParcel TEXT NOT NULL,"  >> SQLTemp.sql
echo " UnitAddress TEXT, QNum TEXT, QSitus TEXT, "  >> SQLTemp.sql
echo " QDir TEXT, Unit TEXT,"  >> SQLTemp.sql
echo " Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,"  >> SQLTemp.sql
echo "   \"RefUSA-Phone\" TEXT,SubTerritory TEXT,"  >> SQLTemp.sql
echo "    CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo "     RSO INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo "      RecordDate REAL DEFAULT 0, SitusAddress TEXT DEFAULT \"\","  >> SQLTemp.sql
echo "       PropUse INTEGER"  >> SQLTemp.sql
echo " );"  >> SQLTemp.sql
echo "INSERT INTO HelluvaSort "  >> SQLTemp.sql
echo "SELECT * FROM QGetTerr "  >> SQLTemp.sql
echo " ORDER BY QSitus,QNum,Unit;  "  >> SQLTemp.sql
echo "--end 2/5/21 mod.;"  >> SQLTemp.sql
echo "-- NOW select all records from QGetTerr back into QTerrxxx omitting Num;"  >> SQLTemp.sql
echo "-- SCSitus, NSEW all presorted;"  >> SQLTemp.sql
echo ".shell echo \"Select sorted records back into $TBL_NAME1\" | awk '{print \$1}' >> SQLTrace.txt"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME1;"  >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME1"  >> SQLTemp.sql
echo "( OwningParcel TEXT NOT NULL, UnitAddress TEXT NOT NULL, "  >> SQLTemp.sql
echo " Unit TEXT, Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,"  >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, SubTerritory TEXT, CongTerrID TEXT,"  >> SQLTemp.sql
echo " DoNotCall INTEGER DEFAULT 0, RSO INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"Foreign\" INTEGER DEFAULT 0, RecordDate REAL DEFAULT 0,"  >> SQLTemp.sql
echo " SitusAddress TEXT DEFAULT \"\", PropUse INTEGER,"  >> SQLTemp.sql
echo " DelPending INTEGER DEFAULT 0 );"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO $TBL_NAME1 "  >> SQLTemp.sql
echo " SELECT "  >> SQLTemp.sql
echo " OwningParcel,"  >> SQLTemp.sql
echo " UnitAddress,"  >> SQLTemp.sql
echo " Unit,"  >> SQLTemp.sql
echo " Resident1, Phone1, Phone2 AS H,"  >> SQLTemp.sql
echo "   \"RefUSA-Phone\" AS RefUSAPhone ,SubTerritory ,"  >> SQLTemp.sql
echo "    CongTerrID, DoNotCall,"  >> SQLTemp.sql
echo "     RSO , \"Foreign\","  >> SQLTemp.sql
echo "      RecordDate, SitusAddress,"  >> SQLTemp.sql
echo "       PropUse, NULL "  >> SQLTemp.sql
echo " FROM HelluvaSort  "  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo "-- Delete duplicate DONOTCALL records;"  >> SQLTemp.sql
echo "DELETE FROM $TBL_NAME1"  >> SQLTemp.sql
echo "WHERE DONOTCALL IS 1 "  >> SQLTemp.sql
echo " AND rowid NOT IN (SELECT MIN(rowid) FROM $TBL_NAME1"  >> SQLTemp.sql
echo "   GROUP BY OwningParcel, UnitAddress, Unit);"  >> SQLTemp.sql
echo "-- Delete duplicate records from $TBL_NAME1;"  >> SQLTemp.sql
echo "-- Delete duplicate records from $TBL_NAME1;"  >> SQLTemp.sql
echo ".shell echo \"Deleting duplicate records from $TBL_NAME1\" | awk '{print \$1}' >> SQLTrace.txt"  >> SQLTemp.sql
echo "DELETE FROM $TBL_NAME1"  >> SQLTemp.sql
echo "WHERE rowid"  >> SQLTemp.sql
echo "  NOT IN (SELECT MAX(rowid) "  >> SQLTemp.sql
echo "		from $TBL_NAME1"  >> SQLTemp.sql
echo "		group by  owningparcel,"  >> SQLTemp.sql
echo "			 unitaddress, unit, resident1);"  >> SQLTemp.sql
echo "-- Generate $TBL_NAME1.csv;"  >> SQLTemp.sql
echo ".shell echo \"Generating $TBL_NAME1.csv\" | awk '{print \$1}' >> SQLTrace.txt"  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".output '$TBL_NAME1.csv'"  >> SQLTemp.sql
echo "SELECT * FROM $TBL_NAME1;"  >> SQLTemp.sql
echo "-- END QGetTerr.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  QGetTerr complete."
~/sysprocs/LOGMSG "  QGetTerr complete."
#end proc
