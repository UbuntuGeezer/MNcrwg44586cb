#!/bin/bash
echo " ** FillGaps86777.sh out-of-date **";exit 1
echo " ** FillGaps86777.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash FillGaps86777.sh
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
  ~/sysprocs/LOGMSG "  FillGaps86777 - initiated from Make"
  echo "  FillGaps86777 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FillGaps86777 - initiated from Terminal"
  echo "  FillGaps86777 - initiated from Terminal"
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

echo "-- * FillGaps86777.psq.sql- module description."  > SQLTemp.sql
echo "-- * 3/5/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 3/5/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. FillGaps86777 adds new records to Terr86777 from a diffs file of"  >> SQLTemp.sql
echo "-- * records extracted from SPCA_mm-dd.db. The diffs are obtained by using"  >> SQLTemp.sql
echo "-- * the parcel IDs from Terr86777 then selecting any records from SCPA_mm-dd.db"  >> SQLTemp.sql
echo "-- * Datammdd with street constraints where the Account#,s are not in the"  >> SQLTemp.sql
echo "-- * parcel IDs from Terr86777. The import .csv should be named something like"  >> SQLTemp.sql
echo "-- * Diffsmmdd.csv."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "CREATE TABLE Diffs0113 ( \"Account #\" TEXT NOT NULL, \"Owner 1\" TEXT,"  >> SQLTemp.sql
echo " \"Owner 2\" TEXT, \"Owner 3\" TEXT, \"Mailing Address 1\" TEXT,"  >> SQLTemp.sql
echo " \"Mailing Address 2\" TEXT, \"Mailing City\" TEXT, \"Mailing State\" TEXT, "  >> SQLTemp.sql
echo " \"Mailing Zip Code\" TEXT, \"Mailing Country\" TEXT, "  >> SQLTemp.sql
echo " \"Situs Address (Property Address)\" TEXT, \"Situs City\" TEXT, "  >> SQLTemp.sql
echo " \"Situs State\" TEXT, \"Situs Zip Code\" TEXT, \"Property Use Code\" TEXT, "  >> SQLTemp.sql
echo " \"Neighborhood\" TEXT, \"Subdivision\" TEXT, \"Taxing District\" TEXT, "  >> SQLTemp.sql
echo " \"Municipality\" TEXT, \"Waterfront Code\" TEXT, \"Homestead Exemption\" TEXT, "  >> SQLTemp.sql
echo " \"Homestead Exemption Grant Year\" TEXT, \"Zoning\" TEXT, \"Parcel Desc 1\" TEXT, "  >> SQLTemp.sql
echo " \"Parcel Desc 2\" TEXT, \"Parcel Desc 3\" TEXT, \"Parcel Desc 4\" TEXT, "  >> SQLTemp.sql
echo " \"Pool (YES or NO)\" TEXT, \"Total Living Units\" TEXT, \"Land Area S. F.\" TEXT, "  >> SQLTemp.sql
echo " \"Gross Bldg Area\" TEXT, \"Living Area\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT, "  >> SQLTemp.sql
echo " \"Half Baths\" TEXT, \"Year Built\" TEXT, \"Last Sale Amount\" TEXT, "  >> SQLTemp.sql
echo " \"Last Sale Date\" TEXT, \"Last Sale Qual Code\" TEXT, \"Prior Sale Amount\" TEXT, "  >> SQLTemp.sql
echo " \"Prior Sale Date\" TEXT, \"Prior Sale Qual Code\" TEXT, \"Just Value\" TEXT, "  >> SQLTemp.sql
echo " \"Assessed Value\" TEXT, \"Taxable Value\" TEXT, "  >> SQLTemp.sql
echo " \"Link to Property Detail Page\" TEXT, \"Value Data Source\" TEXT, "  >> SQLTemp.sql
echo " \"Parcel Characteristics Data\" TEXT, \"Status\" TEXT, \"DownloadDate\" TEXT, "  >> SQLTemp.sql
echo " PRIMARY KEY(\"Account #\") );"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator |"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr211/Diffs0113.csv' Diffs0113 "  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO Terr86777"  >> SQLTemp.sql
echo "SELECT * from Diffs0113;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END FillGaps86777.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  FillGaps86777 complete."
~/sysprocs/LOGMSG "  FillGaps86777 complete."
#end proc
