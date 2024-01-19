#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash QSCPADiff.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
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
  ~/sysprocs/LOGMSG "  QSCPADiff - initiated from Make"
  echo "  QSCPADiff - initiated from Make"
else
  ~/sysprocs/LOGMSG "  QSCPADiff - initiated from Terminal"
  echo "  QSCPADiff - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 TODAY=2022-05-26
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

echo "-- * open old download as db14;-- *	SCPA_04-26.db - as db14, SCPA (new) full download from date 04/26-- *		Data0526 - SCPA download records from date 04/26 in any year"  > SQLTemp.sql
echo "-- Get differences between SCPA_04-26 and SCPA_05-26"  >> SQLTemp.sql
echo ".open $folderbase/Territories/DB-Dev/junk.db "  >> SQLTemp.sql
echo ".cd '$folderbase/Territories'"  >> SQLTemp.sql
echo ".cd './RawData/SCPA/SCPA-Downloads' "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$folderbase/Territories'"  >> SQLTemp.sql
echo "||		'/DB-Dev/VeniceNTerritory.db' "  >> SQLTemp.sql
echo "AS db2;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$folderbase/Territories' "  >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads' "  >> SQLTemp.sql
echo " ||		'/SCPA_04-26.db'"  >> SQLTemp.sql
echo " AS db14; "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$folderbase/Territories' "  >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads' "  >> SQLTemp.sql
echo " ||		'/SCPA_05-26.db' "  >> SQLTemp.sql
echo " AS db15; "  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "--junk.db, main"  >> SQLTemp.sql
echo "--db2.NVenAccts"  >> SQLTemp.sql
echo "--db14 SCPA0426"  >> SQLTemp.sql
echo "--db15 SCPA0526"  >> SQLTemp.sql
echo "drop table if exists DiffAccts0526;"  >> SQLTemp.sql
echo "create table DiffAccts0526"  >> SQLTemp.sql
echo "(Acct TEXT, PRIMARY KEY(Acct));"  >> SQLTemp.sql
echo "with a AS (SELECT \"Account#\" AS OAcct,"  >> SQLTemp.sql
echo "\"LastSaleDate\" AS OLastSale, "  >> SQLTemp.sql
echo "\"HomesteadExemption(YESorNO)\" AS oHstead"  >> SQLTemp.sql
echo "FROM db14.Data0426)"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO DiffAccts0526 "  >> SQLTemp.sql
echo "SELECT \"Account#\" AS nAcct"  >> SQLTemp.sql
echo "from db15.Data0526"  >> SQLTemp.sql
echo "WHERE nAcct IN (SELECT oAcct FROM a"  >> SQLTemp.sql
echo "  WHERE (oAcct is nAcct"  >> SQLTemp.sql
echo "  AND oLastSale IS NOT \"LASTSALEDATE\")"  >> SQLTemp.sql
echo "  OR (oAcct IS nAcct"  >> SQLTemp.sql
echo "  AND oHstead IS NOT \"HOMESTEADEXEMPTION(YESORNO)\")"  >> SQLTemp.sql
echo "  );"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--select count(acct) from DiffAccts0526;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT Account FROM NVenAccts)"  >> SQLTemp.sql
echo "DELETE FROM DiffAccts0526"  >> SQLTemp.sql
echo "WHERE Acct NOT IN (SELECT account from a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- pragma database_list;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".output 'Diff0526.csv' "  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo "--# these are the new/changed records...;"  >> SQLTemp.sql
echo "WITH a AS (SELECT Acct FROM DiffAccts0526)"  >> SQLTemp.sql
echo "SELECT * FROM db15.Data0526"  >> SQLTemp.sql
echo "WHERE \"Account#\" IN (SELECT Acct FROM a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open 'SCPADiff_05-26.db' "  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Diff0526 ;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS DiffAccts;"  >> SQLTemp.sql
echo "CREATE TABLE Diff0526 ( \"Account#\" TEXT NOT NULL,"  >> SQLTemp.sql
echo " \"Owner1\" TEXT, \"Owner2\" TEXT, \"Owner3\" TEXT,"  >> SQLTemp.sql
echo " \"MailingAddress1\" TEXT, \"MailingAddress2\" TEXT,"  >> SQLTemp.sql
echo " \"MailingCity\" TEXT, \"MailingState\" TEXT,"  >> SQLTemp.sql
echo " \"MailingZipCode\" TEXT, \"MailingCountry\" TEXT,"  >> SQLTemp.sql
echo " \"SitusAddress(PropertyAddress)\" TEXT,"  >> SQLTemp.sql
echo " \"SitusCity\" TEXT, \"SitusState\" TEXT,"  >> SQLTemp.sql
echo " \"SitusZipCode\" TEXT, \"PropertyUseCode\" TEXT,"  >> SQLTemp.sql
echo " \"Neighborhood\" TEXT, \"Subdivision\" TEXT,"  >> SQLTemp.sql
echo " \"TaxingDistrict\" TEXT, \"Municipality\" TEXT,"  >> SQLTemp.sql
echo " \"WaterfrontCode\" TEXT, \"HomesteadExemption(YESorNO)\" TEXT,"  >> SQLTemp.sql
echo " \"HomesteadExemptionGrantYear\" TEXT, \"Zoning\" TEXT,"  >> SQLTemp.sql
echo " \"ParcelDesc1\" TEXT, \"ParcelDesc2\" TEXT,"  >> SQLTemp.sql
echo " \"ParcelDesc3\" TEXT, \"ParcelDesc4\" TEXT,"  >> SQLTemp.sql
echo " \"Pool(YESorNO)\" TEXT, \"TotalLivingUnits\" TEXT,"  >> SQLTemp.sql
echo " \"LandAreaS.F.\" TEXT, \"GrossBldgArea\" TEXT,"  >> SQLTemp.sql
echo " \"LivingArea\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT,"  >> SQLTemp.sql
echo " \"HalfBaths\" TEXT, \"YearBuilt\" TEXT,"  >> SQLTemp.sql
echo " \"LastSaleAmount\" TEXT, \"LastSaleDate\" TEXT,"  >> SQLTemp.sql
echo " \"LastSaleQualCode\" TEXT, \"PriorSaleAmount\" TEXT,"  >> SQLTemp.sql
echo " \"PriorSaleDate\" TEXT, \"PriorSaleQualCode\" TEXT,"  >> SQLTemp.sql
echo " \"JustValue\" TEXT, \"AssessedValue\" TEXT,"  >> SQLTemp.sql
echo " \"TaxableValue\" TEXT,"  >> SQLTemp.sql
echo " \"LinktoPropertyDetailPage\" TEXT,"  >> SQLTemp.sql
echo " \"ValueDataSource\" TEXT,"  >> SQLTemp.sql
echo " \"ParcelCharacteristicsData\" TEXT,"  >> SQLTemp.sql
echo " \"Status\" TEXT, \"DownloadDate\" TEXT,"  >> SQLTemp.sql
echo " PRIMARY KEY(\"Account#\") )"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ".import 'Diff0526.csv' Diff0526"  >> SQLTemp.sql
echo "-- follow up with UPDATE query to set DownloadDate field...;"  >> SQLTemp.sql
echo ".open 'SCPADiff_05-26.db'"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Diff0526 ;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS DiffAccts;"  >> SQLTemp.sql
echo "CREATE TABLE Diff0526 ( \"Account#\" TEXT NOT NULL,"  >> SQLTemp.sql
echo " \"Owner1\" TEXT, \"Owner2\" TEXT, \"Owner3\" TEXT,"  >> SQLTemp.sql
echo " \"MailingAddress1\" TEXT, \"MailingAddress2\" TEXT,"  >> SQLTemp.sql
echo " \"MailingCity\" TEXT, \"MailingState\" TEXT,"  >> SQLTemp.sql
echo " \"MailingZipCode\" TEXT, \"MailingCountry\" TEXT,"  >> SQLTemp.sql
echo " \"SitusAddress(PropertyAddress)\" TEXT,"  >> SQLTemp.sql
echo " \"SitusCity\" TEXT, \"SitusState\" TEXT,"  >> SQLTemp.sql
echo " \"SitusZipCode\" TEXT, \"PropertyUseCode\" TEXT,"  >> SQLTemp.sql
echo " \"Neighborhood\" TEXT, \"Subdivision\" TEXT,"  >> SQLTemp.sql
echo " \"TaxingDistrict\" TEXT, \"Municipality\" TEXT,"  >> SQLTemp.sql
echo " \"WaterfrontCode\" TEXT, \"HomesteadExemption(YESorNO)\" TEXT,"  >> SQLTemp.sql
echo " \"HomesteadExemptionGrantYear\" TEXT, \"Zoning\" TEXT,"  >> SQLTemp.sql
echo " \"ParcelDesc1\" TEXT, \"ParcelDesc2\" TEXT,"  >> SQLTemp.sql
echo " \"ParcelDesc3\" TEXT, \"ParcelDesc4\" TEXT,"  >> SQLTemp.sql
echo " \"Pool(YESorNO)\" TEXT, \"TotalLivingUnits\" TEXT,"  >> SQLTemp.sql
echo " \"LandAreaS.F.\" TEXT, \"GrossBldgArea\" TEXT,"  >> SQLTemp.sql
echo " \"LivingArea\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT,"  >> SQLTemp.sql
echo " \"HalfBaths\" TEXT, \"YearBuilt\" TEXT,"  >> SQLTemp.sql
echo " \"LastSaleAmount\" TEXT, \"LastSaleDate\" TEXT,"  >> SQLTemp.sql
echo " \"LastSaleQualCode\" TEXT, \"PriorSaleAmount\" TEXT,"  >> SQLTemp.sql
echo " \"PriorSaleDate\" TEXT, \"PriorSaleQualCode\" TEXT,"  >> SQLTemp.sql
echo " \"JustValue\" TEXT, \"AssessedValue\" TEXT,"  >> SQLTemp.sql
echo " \"TaxableValue\" TEXT,"  >> SQLTemp.sql
echo " \"LinktoPropertyDetailPage\" TEXT,"  >> SQLTemp.sql
echo " \"ValueDataSource\" TEXT,"  >> SQLTemp.sql
echo " \"ParcelCharacteristicsData\" TEXT,"  >> SQLTemp.sql
echo " \"Status\" TEXT, \"DownloadDate\" TEXT,"  >> SQLTemp.sql
echo " PRIMARY KEY(\"Account#\") )"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ".import 'Diff0526.csv' Diff0526"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "*********** old code block *****************"  >> SQLTemp.sql
echo "--#"  >> SQLTemp.sql
echo "--#*********** old code block **********************************   "  >> SQLTemp.sql
echo "--#SELECT * FROM db15.Data0526 "  >> SQLTemp.sql
echo "--#   INNER JOIN db14.Data0426 "  >> SQLTemp.sql
echo "--#    ON db14.Data0426.\"Account#\" = db15.Data0526.\"Account#\" "  >> SQLTemp.sql
echo "--#   INNER JOIN db2.NVenAccts "  >> SQLTemp.sql
echo "--#    ON db15.Data0526.\"Account#\" = db2.NVenAccts.\"Account\" "  >> SQLTemp.sql
echo "--#	WHERE db15.Data0526.\"LastSaleDate\" "  >> SQLTemp.sql
echo "--#    	<> db14.Data0426.\"LastSaleDate\" "  >> SQLTemp.sql
echo "--#	  OR db15.Data0526.\"HomesteadExemption(YESorNO)\" "  >> SQLTemp.sql
echo "--#	   <> db14.Data0426.\"HomesteadExemption(YESorNO)\" "  >> SQLTemp.sql
echo "--#	ORDER BY \"Account#\"; "  >> SQLTemp.sql
echo "--#*********** end old code block **********************************   "  >> SQLTemp.sql
echo "--#"  >> SQLTemp.sql
echo "--# create new differences database with cleared table(s)."  >> SQLTemp.sql
echo "--#-- *	SCPADiff_05-26.db - as db16; Difference collection of new/updated"  >> SQLTemp.sql
echo "--#-- *	  property records between current and past SCPA downloads"  >> SQLTemp.sql
echo "--#-- *		Diff0526 - table of difference new/updated SCPA records"  >> SQLTemp.sql
echo "--#-- *		DiffAccts - table of property IDs and territory IDs affected"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "QSCPADiff.sh" "QSCPADiff processing complete. $P1"
fi
echo "  QSCPADiff complete."
~/sysprocs/LOGMSG "  QSCPADiff complete."
#end proc
