#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash BuildDiffAcctsTbl.sh
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
  ~/sysprocs/LOGMSG "  BuildDiffAcctsTbl - initiated from Make"
  echo "  BuildDiffAcctsTbl - initiated from Make"
else
  ~/sysprocs/LOGMSG "  BuildDiffAcctsTbl - initiated from Terminal"
  echo "  BuildDiffAcctsTbl - initiated from Terminal"
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

echo "-- * BuildDiffAcctsTbl.psq/sql - Build DiffAccts table in SCPADiff_04-04.db;"  > SQLTemp.sql
echo "-- *	4/26/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 4/26/23.	wmk.	code a04ed to set territory ID 998 in all DiffAccts"  >> SQLTemp.sql
echo "-- *			 records having a residential use code, but no territory;"  >> SQLTemp.sql
echo "-- *			 co04ents tidied."  >> SQLTemp.sql
echo "-- * 4/30/23.	wmk.	code a04ed to set territory IDs in \"no territory\""  >> SQLTemp.sql
echo "-- *			 DiffAccts by zip code."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 1/1/22.     wmk.   original code."  >> SQLTemp.sql
echo "-- * 4/26/22.    wmk.   *pathbase* support."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The DiffAccts table is build anew. "  >> SQLTemp.sql
echo "-- * Extracts all Property IDs from Diff0404 into DiffAccts"  >> SQLTemp.sql
echo "-- * Scans MultiMail.db setting territory IDs for PropIDs"  >> SQLTemp.sql
echo "-- * Scans PolyTerri.db setting territory IDs for PropIDs"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * This leaves DiffAccts as a list of territory IDs affected"  >> SQLTemp.sql
echo "-- * by this download. Only territory IDs that are in the current"  >> SQLTemp.sql
echo "-- * publisher territories are known."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * This may leave some new records \"stranded\" with no known"  >> SQLTemp.sql
echo "-- * territory ID. These \"stranded\" records will have territory"  >> SQLTemp.sql
echo "-- * ID 998 assigned so that they may be checked if they belong"  >> SQLTemp.sql
echo "-- * in a publisher territory, but were previously missed being"  >> SQLTemp.sql
echo "-- * assigned."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/RawData/SCPA/SCPA-Downloads/SCPADiff_04-04.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "  AS db2;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/MultiMail.db' "  >> SQLTemp.sql
echo "  AS db3;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/PolyTerri.db'"  >> SQLTemp.sql
echo " AS db5;"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS DiffAccts;"  >> SQLTemp.sql
echo "CREATE TABLE DiffAccts("  >> SQLTemp.sql
echo " PropID TEXT,"  >> SQLTemp.sql
echo " TerrID TEXT DEFAULT '',"  >> SQLTemp.sql
echo " DelFlag INTEGER DEFAULT 0);"  >> SQLTemp.sql
echo "insert into DiffAccts(PropID) "  >> SQLTemp.sql
echo "SELECT \"ACCOUNT#\" FROM Diff0404;"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "-- * Check MultiMail for territory IDs;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DISTINCT OwningParcel AS Acct,"  >> SQLTemp.sql
echo "CONGTERRID FROM SplitProps"  >> SQLTemp.sql
echo " WHERE Acct"  >> SQLTemp.sql
echo " IN (SELECT \"Account#\" FROM Diff0404))"  >> SQLTemp.sql
echo "UPDATE DiffAccts"  >> SQLTemp.sql
echo "SET TerrID ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN PropID IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT CongTerrID FROM a "  >> SQLTemp.sql
echo "  WHERE Acct IS PropID)"  >> SQLTemp.sql
echo "ELSE TerrID"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE TerrID ISNULL "  >> SQLTemp.sql
echo " OR LENGTH(TerrID) = 0;"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "-- * now check PolyTerri for territory IDs;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DISTINCT OwningParcel AS Acct,"  >> SQLTemp.sql
echo "CONGTERRID FROM TerrProps"  >> SQLTemp.sql
echo " WHERE Acct"  >> SQLTemp.sql
echo " IN (SELECT \"Account#\" FROM Diff0404))"  >> SQLTemp.sql
echo "UPDATE DiffAccts"  >> SQLTemp.sql
echo "SET terrid ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN PropID IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT CongTerrID FROM a "  >> SQLTemp.sql
echo "  WHERE Acct IS pROPId)"  >> SQLTemp.sql
echo "ELSE TerrID"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE TerrID ISNULL "  >> SQLTemp.sql
echo " OR LENGTH(TerrID) = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * now set territory ID by zip code for all entries"  >> SQLTemp.sql
echo "-- * that are a residential property use, but not"  >> SQLTemp.sql
echo "-- * found in either of the main publisher territory dbs"  >> SQLTemp.sql
echo "-- * 998 - zip code 34285"  >> SQLTemp.sql
echo "-- * 997 - zip code 34275"  >> SQLTemp.sql
echo "-- * 996 - zip code 34292;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS NoTerrs;"  >> SQLTemp.sql
echo "create temp table NoTerrs(PropID text,PropUse text);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT PropID from DiffAccts"  >> SQLTemp.sql
echo "WHERE length(terrid) = 0)"  >> SQLTemp.sql
echo "INSERT INTO NoTerrs"  >> SQLTemp.sql
echo "SELECT \"Account#\" Acct, PropertyUseCode FROM Diff0404"  >> SQLTemp.sql
echo "WHERE Acct IN (SELECT PropID FROM a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT Code, RType FROM db2.SCPropUse"  >> SQLTemp.sql
echo "WHERE RType IS 'P'"  >> SQLTemp.sql
echo "   OR RType IS 'M'),"  >> SQLTemp.sql
echo "b AS (SELECT * FROM NoTerrs)"  >> SQLTemp.sql
echo "UPDATE DiffAccts"  >> SQLTemp.sql
echo "SET TerrID = '998'"  >> SQLTemp.sql
echo "WHERE PropID IN (SELECT PropID FROM b"  >> SQLTemp.sql
echo " INNER JOIN a"  >> SQLTemp.sql
echo " ON a.Code IS b.PropUse);"  >> SQLTemp.sql
echo " ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * now reassign by zip code;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS ResNoTerr;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE ResNoTerr("  >> SQLTemp.sql
echo "Acct TEXT,"  >> SQLTemp.sql
echo "Situs TEXT,"  >> SQLTemp.sql
echo "Zip TEXT,"  >> SQLTemp.sql
echo "SCPropUse TEXT,"  >> SQLTemp.sql
echo "TerrID TEXT,"  >> SQLTemp.sql
echo "PRIMARY KEY (Acct));"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT PropID FROM DiffAccts"  >> SQLTemp.sql
echo " WHERE TerriD IS '998'),"  >> SQLTemp.sql
echo "b AS (SELECT Code, RType FROM db2.SCPropUse"  >> SQLTemp.sql
echo "WHERE RType IS 'P'"  >> SQLTemp.sql
echo "   OR RType IS 'M')"  >> SQLTemp.sql
echo "INSERT INTO ResNoTerr"  >> SQLTemp.sql
echo "SELECT \"Account#\" Acct, \"situsa04ress(propertya04ress)\" Situs,"  >> SQLTemp.sql
echo " \"SitusZipCode\" Zip, \"PropertyUseCode\" SCPropUse, '998'"  >> SQLTemp.sql
echo "FROM Diff0404"  >> SQLTemp.sql
echo "INNER JOIN b"  >> SQLTemp.sql
echo "ON b.Code IS SCPropUse"  >> SQLTemp.sql
echo "WHERE Acct IN (SELECT PropID from a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * correct TerrID fields in ResNoTerr by zip code;"  >> SQLTemp.sql
echo "UPDATE ResNoTerr"  >> SQLTemp.sql
echo "SET TerrID ="  >> SQLTemp.sql
echo "CASE WHEN Zip LIKE '34275%'"  >> SQLTemp.sql
echo " THEN '997'"  >> SQLTemp.sql
echo "WHEN ZIP LIKE '34292%'"  >> SQLTemp.sql
echo " THEN '996'"  >> SQLTemp.sql
echo "ELSE TerrID"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- now reassign DiffAccts terr IDs by zip code;"  >> SQLTemp.sql
echo "WITH a AS (SELECT Acct, Zip, TerrID CorrTerr FROM ResNoTerr)"  >> SQLTemp.sql
echo "UPDATE DiffAccts"  >> SQLTemp.sql
echo "SET TerrID ="  >> SQLTemp.sql
echo "CASE WHEN PropID IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT CorrTerr FROM a"  >> SQLTemp.sql
echo "  WHERE Acct IS PropID)"  >> SQLTemp.sql
echo "ELSE TerrID"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * end BuildDiffAcctsTbl;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  BuildDiffAcctsTbl complete."
~/sysprocs/LOGMSG "  BuildDiffAcctsTbl complete."
#end proc
