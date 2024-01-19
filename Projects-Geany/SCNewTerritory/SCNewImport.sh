#!/bin/bash
echo " ** SCNewImport.sh out-of-date **";exit 1
echo " ** SCNewImport.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash SCNewImport.sh
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
  ~/sysprocs/LOGMSG "  SCNewImport - initiated from Make"
  echo "  SCNewImport - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SCNewImport - initiated from Terminal"
  echo "  SCNewImport - initiated from Terminal"
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

echo "-- * SCNewImport.psq - SCNewImport.sql template."  > SQLTemp.sql
echo "-- *	1/14/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 1/14/23.	wmk.	original code; adapted from AddTerr86777Record.sql."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 6/5/22.	wmk.	original code; adapted from AddNVenAllRec;"  >> SQLTemp.sql
echo "-- *			 *pathbase* support; AnySQLtoSH now required; year change"  >> SQLTemp.sql
echo "-- *			 to 2022 in query."  >> SQLTemp.sql
echo "-- * 6/6/22.	wmk.	mod to use IGNORE instead of REPLACE to leave current"  >> SQLTemp.sql
echo "-- *			 records intact; header corrected from AddNVenAll to Add86777."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. sed substitutes mm for @ @ and dd for z z"  >> SQLTemp.sql
echo "-- * for m 1 and d 1 within this query, writing the resultant to .sql."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo " || '/SCPA_01-13.db'"  >> SQLTemp.sql
echo " AS db15;"  >> SQLTemp.sql
echo "-- pragma db15.table_info(Data0113);"  >> SQLTemp.sql
echo "-- Note - fieldnames in Datam1d1 are blank-compressed;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS NewImport;"  >> SQLTemp.sql
echo "CREATE TEMP TABLE NewImport("  >> SQLTemp.sql
echo " \"Account#\" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT, MailingAddress1 TEXT,"  >> SQLTemp.sql
echo " MailingAddress2 TEXT, MailingCity TEXT, MailingState TEXT, MailingZipCode TEXT,"  >> SQLTemp.sql
echo "  MailingCountry TEXT, \"SitusAddress(PropertyAddress)\" TEXT, SitusCity TEXT, "  >> SQLTemp.sql
echo "  SitusState TEXT, SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT, "  >> SQLTemp.sql
echo "  Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, WaterfrontCode TEXT, "  >> SQLTemp.sql
echo "  \"HomesteadExemption(YESorNO)\" TEXT, HomesteadExemptionGrantYear TEXT, "  >> SQLTemp.sql
echo "  Zoning TEXT, ParcelDesc1 TEXT, ParcelDesc2 TEXT, ParcelDesc3 TEXT, "  >> SQLTemp.sql
echo "  ParcelDesc4 TEXT, \"Pool(YESorNO)\" TEXT, TotalLivingUnits TEXT, "  >> SQLTemp.sql
echo "  \"LandAreaS.F.\" TEXT, GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, "  >> SQLTemp.sql
echo "  Baths TEXT, HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, "  >> SQLTemp.sql
echo "  LastSaleDate TEXT, LastSaleQualCode TEXT, PriorSaleAmount TEXT, "  >> SQLTemp.sql
echo "  PriorSaleDate TEXT, PriorSaleQualCode TEXT, JustValue TEXT, "  >> SQLTemp.sql
echo "  AssessedValue TEXT, TaxableValue TEXT, LinktoPropertyDetailPage TEXT, "  >> SQLTemp.sql
echo "  ValueDataSource TEXT, ParcelCharacteristicsData TEXT, Status TEXT);"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".import '$pathbase/RawData/SCPA/SCPA-Downloads/Terr900/Full900_SC.csv' NewImport"  >> SQLTemp.sql
echo "INSERT OR REPLACE INTO Terr86777"  >> SQLTemp.sql
echo "SELECT \"Account#\" , Owner1 , Owner2 , Owner3 , MailingAddress1 ,"  >> SQLTemp.sql
echo " MailingAddress2 , MailingCity , MailingState , MailingZipCode ,"  >> SQLTemp.sql
echo "  MailingCountry , \"SitusAddress(PropertyAddress)\" , SitusCity , "  >> SQLTemp.sql
echo "  SitusState , SitusZipCode , PropertyUseCode , Neighborhood , "  >> SQLTemp.sql
echo "  Subdivision , TaxingDistrict , Municipality , WaterfrontCode , "  >> SQLTemp.sql
echo "  \"HomesteadExemption(YESorNO)\" , HomesteadExemptionGrantYear , "  >> SQLTemp.sql
echo "  Zoning , ParcelDesc1 , ParcelDesc2 , ParcelDesc3 , "  >> SQLTemp.sql
echo "  ParcelDesc4 , \"Pool(YESorNO)\" , TotalLivingUnits , "  >> SQLTemp.sql
echo "  \"LandAreaS.F.\" , GrossBldgArea , LivingArea , Bedrooms , "  >> SQLTemp.sql
echo "  Baths , HalfBaths , YearBuilt , LastSaleAmount , "  >> SQLTemp.sql
echo "  LastSaleDate , LastSaleQualCode , PriorSaleAmount , "  >> SQLTemp.sql
echo "  PriorSaleDate , PriorSaleQualCode , JustValue , "  >> SQLTemp.sql
echo "  AssessedValue , TaxableValue , LinktoPropertyDetailPage , "  >> SQLTemp.sql
echo "  ValueDataSource , ParcelCharacteristicsData , Status, '2023-01-13'"  >> SQLTemp.sql
echo "FROM NewImport;"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO AllAccts"  >> SQLTemp.sql
echo " SELECT \"Account#\" FROM NewImport;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- End SCNewImport;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  SCNewImport complete."
~/sysprocs/LOGMSG "  SCNewImport complete."
#end proc
