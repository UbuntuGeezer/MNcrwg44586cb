#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash LoadSegDefs.sh
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
  ~/sysprocs/LOGMSG "  LoadSegDefs - initiated from Make"
  echo "  LoadSegDefs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  LoadSegDefs - initiated from Terminal"
  echo "  LoadSegDefs - initiated from Terminal"
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

echo "-- * LoadSegDefs.psq/sql - Load Terr808/segdefs.csv file content into TerriDData.SegDefs table."  > SQLTemp.sql
echo "-- * 2/25/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit. table TerriDData.Defs808 created by loading /Terr808/segdefs.csv"  >> SQLTemp.sql
echo "-- *	   table TerrIDData.808Counts created by querying SegDefs table for terr 808."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/11/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 2/12/23.	wmk.	.open statement added to Jumpto.sql; exit conditions documented."  >> SQLTemp.sql
echo "-- * 2/25/23.	wmk.	modified for use in SegDefsMgr."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. segdefs contains a set of WHERE clauses with the following pattern:"  >> SQLTemp.sql
echo "-- *	WHERE UnitAddress LIKE '%street1%'"  >> SQLTemp.sql
echo "-- *       OR UnitAddress LIKE '%street2%'"  >> SQLTemp.sql
echo "-- *	   OR (UnitAddress LIKE '%street3%'"  >> SQLTemp.sql
echo "-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n1"  >> SQLTemp.sql
echo "-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n2"  >> SQLTemp.sql
echo "-- *         AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT)%2 = 1)"  >> SQLTemp.sql
echo "-- * The sqldef clauses are defined as part of a triplet:"  >> SQLTemp.sql
echo "-- *  TerrID,dbName,sqldef"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * if TerrIDData.SegDefs already has entries for Territoryxxx, this query will do nothing."  >> SQLTemp.sql
echo "-- * test code... this query stops just short, creating Jumpto.sql in /Special."  >> SQLTemp.sql
echo "-- * DoSedSegDefs transforms the strings @ @ and z z to the month and day passed"  >> SQLTemp.sql
echo "-- * to it as parameters 3 and 4. The database name will be modified on-the-fly"  >> SQLTemp.sql
echo "-- * by the Jumpto.sql code."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS EndMessage;"  >> SQLTemp.sql
echo "CREATE TABLE EndMessage("  >> SQLTemp.sql
echo " msg TEXT)"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "INSERT INTO EndMessage"  >> SQLTemp.sql
echo "VALUES( \" LoadSegDefs initiated..\");"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS \"808Counts\";"  >> SQLTemp.sql
echo "CREATE TABLE \"808Counts\"("  >> SQLTemp.sql
echo " DefLines INTEGER )"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo "INSERT INTO \"808Counts\""  >> SQLTemp.sql
echo "SELECT count() TerriD FROM SegDefs"  >> SQLTemp.sql
echo "WHERE TerrID IS '808';"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers OFF"  >> SQLTemp.sql
echo ".separator \" \""  >> SQLTemp.sql
echo ".output '$pathbase/$rupath/Special/Jumpto.sql'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS JumptoSQL;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE JumptoSQL("  >> SQLTemp.sql
echo " sqlsrc TEXT);"  >> SQLTemp.sql
echo "-- * write SQL source code to table then export;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- .open database line;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl > 0"  >> SQLTemp.sql
echo "THEN \".open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/TerrIDData.db'\""  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ------------------------------------------------------------"  >> SQLTemp.sql
echo "-- do this if counts > 0; write to Jumpto.sql;"  >> SQLTemp.sql
echo "-- * SegDefs for territory 808 already exist; do not overwrite;"  >> SQLTemp.sql
echo "-- line 1 - INSERT INTO EndMessage;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl> 0"  >> SQLTemp.sql
echo "THEN "  >> SQLTemp.sql
echo "\"INSERT INTO EndMessage(msg) VALUES(' **  SegDefs for territory 808 already exist - LoadSegDefs abandoned. **');\""  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 2 SELECT msg FROM EndMessage;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl> 0"  >> SQLTemp.sql
echo "THEN "  >> SQLTemp.sql
echo "'SELECT msg FROM EndMessage;'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 3 .exit 3;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl> 0"  >> SQLTemp.sql
echo "THEN "  >> SQLTemp.sql
echo "'.exit 3'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "---------------------------------------------------------------"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- do this if counts = 0; write to Jumpto.sql;"  >> SQLTemp.sql
echo "-- write new defs into SegDefs table;"  >> SQLTemp.sql
echo "-- .open database line;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN \".open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/TerrIDData.db'\""  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 1;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN 'DROP TABLE IF EXISTS Defs808;'"  >> SQLTemp.sql
echo " ELSE '.quit'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 2;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN 'CREATE TABLE \"Defs808\"(newtid TEXT, newdb TEXT, newsql TEXT);'"  >> SQLTemp.sql
echo " ELSE '.quit'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 3;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN '.mode csv'"  >> SQLTemp.sql
echo " ELSE '.quit'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 4;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN  '.headers OFF'"  >> SQLTemp.sql
echo " ELSE '.quit'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 5;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN  '.separator |'"  >> SQLTemp.sql
echo " ELSE '.quit'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 6; .import... segdefs.csv into Defsyy;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN   \".import '$pathbase/$rupath/Terr808/segdefs.csv' Defs808\""  >> SQLTemp.sql
echo " ELSE '.quit'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 7-9; if any dbName field is SCPA, change to SCPA_@ @-z z;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN   \"UPDATE Defs808\""  >> SQLTemp.sql
echo "ELSE   \"UPDATE Defs808\""  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN   \"SET dbName = dbname || '_@@-zz'\""  >> SQLTemp.sql
echo "ELSE   \"SET dbName = dbname || '_@@-zz'\""  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN   \"WHERE dbName IS 'SCPA';\""  >> SQLTemp.sql
echo "ELSE   \"WHERE dbName IS 'SCPA';\""  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo "-- end lines 7-9 block;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 10;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN   '.quit'"  >> SQLTemp.sql
echo " ELSE '.quit'"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "SELECT * FROM JumptoSQL;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "INSERT INTO EndMessage"  >> SQLTemp.sql
echo "VALUES(\"  LoadSegDefs complete.\");"  >> SQLTemp.sql
echo "INSERT INTO EndMessage"  >> SQLTemp.sql
echo "VALUES(\"   TerrIDData.Defs808 has loaded segment definitions.\");"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--========== end block which writes to Jumpto.sql =============;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "--==================================================================="  >> SQLTemp.sql
echo "--CREATE TEMP TABLE \"106Defs\"(;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE \"106Defs\"("  >> SQLTemp.sql
echo " newsql TEXT)"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers OFF"  >> SQLTemp.sql
echo ".import '$pathbase/$rupath/Terr106/sqldefs.csv' \"106Defs\""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS NewDefs;"  >> SQLTemp.sql
echo "CREATE TABLE NewDefs("  >> SQLTemp.sql
echo " newsql TEXT)"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".import '$pathbase/$rupath/Terr106/segdefs.csv' NewDefs"  >> SQLTemp.sql
echo "INSERT INTO "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers OFF"  >> SQLTemp.sql
echo ".separator |"  >> SQLTemp.sql
echo ".output '$pathbase/$rupath/Special/Jumpto.sql'"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"106Counts\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl > 0"  >> SQLTemp.sql
echo "THEN 'select '** '"  >> SQLTemp.sql
echo "END FROM \"106Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".read '$pathbase/$rupath/Special/Jumpto.sql'"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--################################################"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"106Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"106Defs\")"  >> SQLTemp.sql
echo "INSERT INTO SegDefs(TerrID,dbName,sqldef)"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl > 0"  >> SQLTemp.sql
echo "THEN '.quit'"  >> SQLTemp.sql
echo "END FROM 106Counts;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"106Counts\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl > 0"  >> SQLTemp.sql
echo "THEN sqldef"  >> SQLTemp.sql
echo "END sqldef FROM SegDefs"  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo "-- * END LoadSegDefs.sql;"  >> SQLTemp.sql
echo "--========================================================"  >> SQLTemp.sql
echo "all the code from EXECUTE SQL.."  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"106Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"106Defs\")"  >> SQLTemp.sql
echo "INSERT INTO SegDefs(TerrID,dbName,sqldef)"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "'371','BayLakeMHP',b.newdef"  >> SQLTemp.sql
echo "FROM \"106Defs\""  >> SQLTemp.sql
echo "UNION a,b;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"106Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT sqldef newdef FROM \"106Defs\")"  >> SQLTemp.sql
echo "INSERT INTO SegDefs(TerrID,dbName,sqldef)"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "'371','BayLakeMHP',b.newdef"  >> SQLTemp.sql
echo "FROM \"106Defs\""  >> SQLTemp.sql
echo "UNION a,b;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "clear;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--this code only selects records if 106Counts.dl=0;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"106Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"106Defs\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN '371' END terrid,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN 'BayLakeMHP' END dname,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN b.newdef END segsql"  >> SQLTemp.sql
echo "FROM \"106Defs\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0"  >> SQLTemp.sql
echo "INNER JOIN b"  >> SQLTemp.sql
echo "ON b.newdef NOT NULL;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"106Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"106Defs\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN '371' END,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN 'BayLakeMHP' END,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN b.newdef END"  >> SQLTemp.sql
echo "FROM \"106Defs\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0"  >> SQLTemp.sql
echo "INNER JOIN b"  >> SQLTemp.sql
echo "ON b.newdef NOT NULL;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  LoadSegDefs complete."
~/sysprocs/LOGMSG "  LoadSegDefs complete."
#end proc
