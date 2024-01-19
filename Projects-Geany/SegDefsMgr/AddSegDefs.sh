#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash AddSegDefs.sh
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
  ~/sysprocs/LOGMSG "  AddSegDefs - initiated from Make"
  echo "  AddSegDefs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  AddSegDefs - initiated from Terminal"
  echo "  AddSegDefs - initiated from Terminal"
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

echo "-- * AddSegDefs.psq/sql - Add content of TerrIDData.Defs808 table into TerriDData.SegDefs table."  > SQLTemp.sql
echo "-- * 2/12/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry. table TerriDData.Defs808 created by loading /Terr808/segdefs.csv"  >> SQLTemp.sql
echo "-- *	    table TerrIDData.808Counts created by querying SegDefs table for terr 808."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit. table TerrIDData.SegDefs has new records added from Defs808 table."  >> SQLTemp.sql
echo "-- *       tables Defs808 and 808Counts removed from TerrIDData."  >> SQLTemp.sql
echo "-- *	   \"Segmented\" field set to 1 in Territory table for Terrxxx."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/11/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 2/12/23.	wmk.	.open statement added to Jumpto.sql; PrevCounts references"  >> SQLTemp.sql
echo "-- * 			 removed; bug fix Defxxx corrected to Defsxxx; exit conditions"  >> SQLTemp.sql
echo "-- *			 documented."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. segdefs contains a set of WHERE clauses with the following pattern:"  >> SQLTemp.sql
echo "-- *	WHERE UnitAddress LIKE '%street1%'"  >> SQLTemp.sql
echo "-- *       OR UnitAddress LIKE '%street2%'"  >> SQLTemp.sql
echo "-- *	   OR (UnitAddress LIKE '%street3%'"  >> SQLTemp.sql
echo "-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n1"  >> SQLTemp.sql
echo "-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n2"  >> SQLTemp.sql
echo "-- *         AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT)%2 = 1)"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * if TerrIDData.SegDefs already has entries for Territoryxxx, this query will do nothing."  >> SQLTemp.sql
echo "-- * test code... this query stops just short, creating Jumpto.sql in /Special."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * This query is the last in the sequence; it uses the table EndMessage to write"  >> SQLTemp.sql
echo "-- * a script to Jumpto.sql that issues the \"complete\" or \"abandoned\" message.."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * tables."  >> SQLTemp.sql
echo "-- *	EndMessage - ending message table; messages written by Jumpto.sql"  >> SQLTemp.sql
echo "-- *	808Counts = .status, DefLines, status=0 if Def808"  >> SQLTemp.sql
echo "-- *	DefExists,status = 0 if Defs808 table exists"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--DROP TABLE IF EXISTS EndMessage;"  >> SQLTemp.sql
echo "--CREATE TABLE EndMessage("  >> SQLTemp.sql
echo "-- msg TEXT);"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS \"808Counts\";"  >> SQLTemp.sql
echo "CREATE TEMP TABLE \"808Counts\"("  >> SQLTemp.sql
echo " DefLines INTEGER )"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "INSERT INTO EndMessage(msg)"  >> SQLTemp.sql
echo "VALUES(\"  ** AddSegDefs FAILED - Check TerrIDData database for territory 808 **\");"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "CREATE TEMP TABLE DefExists("  >> SQLTemp.sql
echo " status INTEGER)"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo "INSERT INTO DefExists(status)"  >> SQLTemp.sql
echo "SELECT EXISTS("  >> SQLTemp.sql
echo "SELECT name FROM sqlite_schema"  >> SQLTemp.sql
echo " WHERE type is 'table'"  >> SQLTemp.sql
echo "   AND name is 'Defs808');"  >> SQLTemp.sql
echo "   "  >> SQLTemp.sql
echo "-- -------------- insert records here ---------------------------;"  >> SQLTemp.sql
echo "-- * unconditionally insert new records;"  >> SQLTemp.sql
echo "INSERT INTO SegDefs(TerriD, dbName, sqldef)"  >> SQLTemp.sql
echo "SELECT '808', 'SCPA', newsql"  >> SQLTemp.sql
echo "FROM Defs808;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- set ending message;"  >> SQLTemp.sql
echo "DELETE FROM EndMessage;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "INSERT INTO EndMessage(msg)"  >> SQLTemp.sql
echo "VALUES('  AddSegDefs for 808 complete.');"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Defs808;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * ensure Segmented flag set if there are defs for this territory;"  >> SQLTemp.sql
echo "UPDATE Territory"  >> SQLTemp.sql
echo "SET Segmented ="  >> SQLTemp.sql
echo "CASE WHEN (SELECT COUNT() TerrID FROM SegDefs"  >> SQLTemp.sql
echo " WHERE TerrID IS '808') > 0"  >> SQLTemp.sql
echo " THEN 1"  >> SQLTemp.sql
echo "ELSE 0"  >> SQLTemp.sql
echo "END "  >> SQLTemp.sql
echo "WHERE TerrID IS '808';"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ---------- write completion message --------------;"  >> SQLTemp.sql
echo "-- do this in all cases; write to EndMessage code to Jumpto.sql;"  >> SQLTemp.sql
echo "-- entry. 808Counts.DefLines = line count"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers OFF"  >> SQLTemp.sql
echo ".separator \"|\""  >> SQLTemp.sql
echo ".output '$pathbase/$rupath/Special/Jumpto.sql'"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS JumptoSQL;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE JumptoSQL("  >> SQLTemp.sql
echo " sqlsrc TEXT);"  >> SQLTemp.sql
echo "-- * write SQL source code to table then export;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- .open database line;"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "VALUES(\".open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/TerrIDData.db'\");"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 1;"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "VALUES('SELECT * FROM EndMessage;');"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- line 3;"  >> SQLTemp.sql
echo "INSERT INTO JumptoSQL"  >> SQLTemp.sql
echo "VALUES('.quit');"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "SELECT * FROM JumptoSQL;"  >> SQLTemp.sql
echo "--========== end block which writes to Jumpto.sql =============;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ==============================================================;"  >> SQLTemp.sql
echo "-- more experimental code...;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS \"808Counts\";"  >> SQLTemp.sql
echo "CREATE TEMP TABLE \"808Counts\"("  >> SQLTemp.sql
echo " status INTEGER,"  >> SQLTemp.sql
echo " DefLines INTEGER )"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo "WITH a AS (SELECT status FROM DefExists)"  >> SQLTemp.sql
echo "INSERT INTO \"808Counts\"(status)"  >> SQLTemp.sql
echo "SELECT a.status"  >> SQLTemp.sql
echo "FROM SegDefs"  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.status IS NOT NULL"  >> SQLTemp.sql
echo "LIMIT 1;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "UPDATE \"808Counts\""  >> SQLTemp.sql
echo "SET DefLines ="  >> SQLTemp.sql
echo "CASE WHEN status > 0 THEN"  >> SQLTemp.sql
echo " (SELECT COUNT() sqldef FROM SegDefs "  >> SQLTemp.sql
echo "  WHERE TerrID is '808')"  >> SQLTemp.sql
echo " ELSE 0"  >> SQLTemp.sql
echo " END;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--===================================================================;"  >> SQLTemp.sql
echo "--CREATE TEMP TABLE \"808Defs\"(;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE \"808Defs\"("  >> SQLTemp.sql
echo " newsql TEXT)"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers OFF"  >> SQLTemp.sql
echo ".import '$pathbase/$rupath/Terr808/sqldefs.csv' \"808Defs\""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS NewDefs;"  >> SQLTemp.sql
echo "CREATE TABLE NewDefs("  >> SQLTemp.sql
echo " newsql TEXT)"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".import '$pathbase/$rupath/Terr808/segdefs.csv' NewDefs"  >> SQLTemp.sql
echo "INSERT INTO "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers OFF"  >> SQLTemp.sql
echo ".separator |"  >> SQLTemp.sql
echo ".output '$pathbase/$rupath/Special/Jumpto.sql'"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl > 0"  >> SQLTemp.sql
echo "THEN 'select '** '"  >> SQLTemp.sql
echo "END FROM \"808Counts\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".read '$pathbase/$rupath/Special/Jumpto.sql'"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--################################################"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"808Defs\")"  >> SQLTemp.sql
echo "INSERT INTO SegDefs(TerrID,dbName,sqldef)"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl > 0"  >> SQLTemp.sql
echo "THEN '.quit'"  >> SQLTemp.sql
echo "END FROM 808Counts;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl > 0"  >> SQLTemp.sql
echo "THEN sqldef"  >> SQLTemp.sql
echo "END sqldef FROM SegDefs"  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl > 0;"  >> SQLTemp.sql
echo "-- * END AddSegDefs.sql;"  >> SQLTemp.sql
echo "--========================================================"  >> SQLTemp.sql
echo "all the code from EXECUTE SQL.."  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"808Defs\")"  >> SQLTemp.sql
echo "INSERT INTO SegDefs(TerrID,dbName,sqldef)"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "'371','BayLakeMHP',b.newdef"  >> SQLTemp.sql
echo "FROM \"808Defs\""  >> SQLTemp.sql
echo "UNION a,b;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT sqldef newdef FROM \"808Defs\")"  >> SQLTemp.sql
echo "INSERT INTO SegDefs(TerrID,dbName,sqldef)"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "'371','BayLakeMHP',b.newdef"  >> SQLTemp.sql
echo "FROM \"808Defs\""  >> SQLTemp.sql
echo "UNION a,b;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "clear;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--this code only selects records if 808Counts.dl=0;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"808Defs\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN '371' END terrid,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN 'BayLakeMHP' END dname,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN b.newdef END segsql"  >> SQLTemp.sql
echo "FROM \"808Defs\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0"  >> SQLTemp.sql
echo "INNER JOIN b"  >> SQLTemp.sql
echo "ON b.newdef NOT NULL;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT DefLines dl FROM \"808Counts\"),"  >> SQLTemp.sql
echo " b AS (SELECT newsql newdef FROM \"808Defs\")"  >> SQLTemp.sql
echo "SELECT CASE WHEN a.dl = 0"  >> SQLTemp.sql
echo "THEN '371' END,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN 'BayLakeMHP' END,"  >> SQLTemp.sql
echo "CASE WHEN a.dl = 0 THEN b.newdef END"  >> SQLTemp.sql
echo "FROM \"808Defs\""  >> SQLTemp.sql
echo "INNER JOIN a"  >> SQLTemp.sql
echo "ON a.dl = 0"  >> SQLTemp.sql
echo "INNER JOIN b"  >> SQLTemp.sql
echo "ON b.newdef NOT NULL;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  AddSegDefs complete."
~/sysprocs/LOGMSG "  AddSegDefs complete."
#end proc
