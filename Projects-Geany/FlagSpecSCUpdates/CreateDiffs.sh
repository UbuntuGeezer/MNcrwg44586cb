#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash CreateDiffs.sh
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
  ~/sysprocs/LOGMSG "  CreateDiffs - initiated from Make"
  echo "  CreateDiffs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CreateDiffs - initiated from Terminal"
  echo "  CreateDiffs - initiated from Terminal"
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

echo "-- * CreateDiffs.psq - create Special differences table for updating WhitePineTreeRd.db.db"  > SQLTemp.sql
echo "-- * 1/31/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 1/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. CreateDiffs.psq is edited by *sed to set the spec-db database name"  >> SQLTemp.sql
echo "-- * in the query code. spec-db.db has the DiffSpec table added which contains"  >> SQLTemp.sql
echo "-- * the newest Terr86777 records for the special database."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/$scpath/Special/WhitePineTreeRd.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/$scpath/Special/SpecialDBs.db'"  >> SQLTemp.sql
echo " AS db19;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS DiffSpec;"  >> SQLTemp.sql
echo "CREATE TABLE DiffSpec ( "  >> SQLTemp.sql
echo " \"Account#\" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT, MailingAddress1 TEXT,"  >> SQLTemp.sql
echo "  MailingAddress2 TEXT, MailingCity TEXT, MailingState TEXT, MailingZipCode TEXT,"  >> SQLTemp.sql
echo "  MailingCountry TEXT, \"SitusAddress(PropertyAddress)\" TEXT, SitusCity TEXT,"  >> SQLTemp.sql
echo "  SitusState TEXT, SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT,"  >> SQLTemp.sql
echo "  Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, WaterfrontCode TEXT,"  >> SQLTemp.sql
echo "  \"HomesteadExemption(YESorNO)\" TEXT, HomesteadExemptionGrantYear TEXT, "  >> SQLTemp.sql
echo "  Zoning TEXT, ParcelDesc1 TEXT, ParcelDesc2 TEXT, ParcelDesc3 TEXT, "  >> SQLTemp.sql
echo "  ParcelDesc4 TEXT, \"Pool(YESorNO)\" TEXT, TotalLivingUnits TEXT, "  >> SQLTemp.sql
echo "  \"LandAreaS.F.\" TEXT, GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, "  >> SQLTemp.sql
echo "  Baths TEXT, HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, "  >> SQLTemp.sql
echo "  LastSaleDate TEXT, LastSaleQualCode TEXT, PriorSaleAmount TEXT, "  >> SQLTemp.sql
echo "  PriorSaleDate TEXT, PriorSaleQualCode TEXT, JustValue TEXT, "  >> SQLTemp.sql
echo "  AssessedValue TEXT, TaxableValue TEXT, LinktoPropertyDetailPage TEXT, "  >> SQLTemp.sql
echo "  ValueDataSource TEXT, ParcelCharacteristicsData TEXT, Status TEXT, "  >> SQLTemp.sql
echo "  DownloadDate TEXT,"  >> SQLTemp.sql
echo "   PRIMARY KEY (\"Account#\") );"  >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM db19.OutOfDates)"  >> SQLTemp.sql
echo "INSERT INTO DiffSpec"  >> SQLTemp.sql
echo "SELECT * FROM db2.Terr86777"  >> SQLTemp.sql
echo "WHERE \"Account #\" IN (SELECT PropID FROM a"  >> SQLTemp.sql
echo "  WHERE DBNAME IS \"WhitePineTreeRd.db\");"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  CreateDiffs complete."
~/sysprocs/LOGMSG "  CreateDiffs complete."
#end proc
