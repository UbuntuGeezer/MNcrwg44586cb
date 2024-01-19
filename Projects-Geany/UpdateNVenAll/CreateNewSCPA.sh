#!/bin/bash
echo " ** CreateNewSCPA.sh out-of-date **";exit 1
echo " ** CreateNewSCPA.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/30/21.	wmk.
#	Usage. bash CreateNewSCPA.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 12/30/21.	wmk.	$ HOME changed to USER; TODAY env var export removed.
P1=$1
TID=$P1
TN="Terr"
if [ "$USER" == "ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  ~/sysprocs/LOGMSG "  CreateNewSCPA - initiated from Make"
  echo "  CreateNewSCPA - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CreateNewSCPA - initiated from Terminal"
  echo "  CreateNewSCPA - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

echo "--CreateNewSCPA.psq/sql - Create new SCPA full database" > SQLTemp.sql
echo "--		1/2/22.	wmk." >> SQLTemp.sql
echo "-- Modification History." >> SQLTemp.sql
echo "-- ---------------------" >> SQLTemp.sql
echo "-- 9/30/20.	wmk.	original code." >> SQLTemp.sql
echo "-- 8/25/21.	wmk.	documented and improved." >> SQLTemp.sql
echo "-- 9/29/21.	wmk.	changed from mm dd to m 2 d 2 to avoid problems" >> SQLTemp.sql
echo "--					with sed editing dd into fields containing 'address'." >> SQLTemp.sql
echo "-- 11/3/21.	wmk.	revert to using $ folderbase, replacing 'folderbase';" >> SQLTemp.sql
echo "--			 superfluous \"s removed; PRIMARY KEY added to table" >> SQLTemp.sql
echo "--			 definition; column DownloadDate added." >> SQLTemp.sql
echo "-- 1/2/22.	wmk.	change welded date to $ TODAY." >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "-- Notes. Raw download data on file Dataxxyy.csv where xxyy is mmdd;" >> SQLTemp.sql
echo "-- sed modifies this SQL, changing mm and dd to the correct values" >> SQLTemp.sql
echo "--;" >> SQLTemp.sql
echo ".cd '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'" >> SQLTemp.sql
echo ".open 'SCPA_02-05.db'" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Data0205;" >> SQLTemp.sql
echo "CREATE TABLE Data0205 " >> SQLTemp.sql
echo "( \"Account#\" , Owner1 , Owner2 , Owner3 , MailingAddress1 , " >> SQLTemp.sql
echo "MailingAddress2 , MailingCity , MailingState , MailingZipCode , " >> SQLTemp.sql
echo "MailingCountry , \"SitusAddress(PropertyAddress)\" , SitusCity , " >> SQLTemp.sql
echo "SitusState , SitusZipCode , PropertyUseCode , Neighborhood , " >> SQLTemp.sql
echo "Subdivision , TaxingDistrict , Municipality , WaterfrontCode , " >> SQLTemp.sql
echo "\"HomesteadExemption(YESorNO)\" , HomesteadExemptionGrantYear , " >> SQLTemp.sql
echo "Zoning , ParcelDesc1 , ParcelDesc2 , ParcelDesc3 , " >> SQLTemp.sql
echo "ParcelDesc4 , \"Pool(YESorNO)\" , TotalLivingUnits , \"LandAreaS.F.\" , " >> SQLTemp.sql
echo "GrossBldgArea , LivingArea , Bedrooms , Baths , HalfBaths , " >> SQLTemp.sql
echo "YearBuilt , LastSaleAmount , LastSaleDate , LastSaleQualCode , " >> SQLTemp.sql
echo "PriorSaleAmount , PriorSaleDate , PriorSaleQualCode , JustValue , " >> SQLTemp.sql
echo "AssessedValue , TaxableValue , LinktoPropertyDetailPage , " >> SQLTemp.sql
echo "ValueDataSource , ParcelCharacteristicsData , \"Status\"," >> SQLTemp.sql
echo "PRIMARY KEY(\"Account#\") );" >> SQLTemp.sql
echo "-- .show     show current settings" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo "-- make sure are running on path /Territories/SCPA-Downloads;" >> SQLTemp.sql
echo ".separator ," >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".import 'Data0205.csv' Data0205" >> SQLTemp.sql
echo "-- add DownloadDate column for convenient updating NVenAll;" >> SQLTemp.sql
echo "ALTER TABLE Data0205 ADD COLUMN DownloadDate;" >> SQLTemp.sql
echo "UPDATE Data0205" >> SQLTemp.sql
echo "SET DownloadDate = \"$TODAY\";" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "-- ** END CreateNewSCPA.sql **********;" >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#notify-send "CreateNewSCPA.sh" "CreateNewSCPA processing complete. $P1"
echo "  CreateNewSCPA complete."
~/sysprocs/LOGMSG "  CreateNewSCPA complete."
#end proc
