#!/bin/bash
echo " ** PopulateCongTerr.sh out-of-date **";exit 1
echo " ** PopulateCongTerr.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash PopulateCongTerr.sh
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  PopulateCongTerr - initiated from Make"
  echo "  PopulateCongTerr - initiated from Make"
else
  ~/sysprocs/LOGMSG "  PopulateCongTerr - initiated from Terminal"
  echo "  PopulateCongTerr - initiated from Terminal"
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

echo "-- PopulateCongTerr.psq/sql - Populate new Terr86777.Terr86777 table."  > SQLTemp.sql
echo "-- * 5/1/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * 4/27/22.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 5/1/22.	wmk.	modified to use db8.AuxSCPAData.AcctsAll table instead"  >> SQLTemp.sql
echo "-- *			 of VeniceNTerritory.db.NVenAccts for consitency with ExtractDiff."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * PopulateCongTerr.sql regenerates table Terr86777 by adding all records"  >> SQLTemp.sql
echo "-- *  from SCPA_05-26.db.Data0526"  >> SQLTemp.sql
echo "-- * into Terr86777.Terr86777 where \"Account#\" in Data0526 in"  >> SQLTemp.sql
echo "-- * AuxSCPAData.db.AcctsAll table."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "    || '/DB-Dev/VeniceNTerritory.db'"  >> SQLTemp.sql
echo "    AS db2;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "    || '/DB-Dev/AuxSCPAData.db'"  >> SQLTemp.sql
echo "    AS db8;"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "	|| '/RawData/SCPA/SCPA-Downloads/SCPA_05-26.db'"  >> SQLTemp.sql
echo "	AS db29;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Terr86777;"  >> SQLTemp.sql
echo "CREATE TABLE Terr86777"  >> SQLTemp.sql
echo "( \"Account #\" TEXT NOT NULL, \"Owner 1\" TEXT, \"Owner 2\" TEXT,"  >> SQLTemp.sql
echo " \"Owner 3\" TEXT, \"Mailing Address 1\" TEXT, \"Mailing Address 2\" TEXT,"  >> SQLTemp.sql
echo " \"Mailing City\" TEXT, \"Mailing State\" TEXT, \"Mailing Zip Code\" TEXT,"  >> SQLTemp.sql
echo " \"Mailing Country\" TEXT, \"Situs Address (Property Address)\" TEXT,"  >> SQLTemp.sql
echo " \"Situs City\" TEXT, \"Situs State\" TEXT, \"Situs Zip Code\" TEXT,"  >> SQLTemp.sql
echo " \"Property Use Code\" TEXT, \"Neighborhood\" TEXT, \"Subdivision\" TEXT,"  >> SQLTemp.sql
echo " \"Taxing District\" TEXT, \"Municipality\" TEXT, \"Waterfront Code\" TEXT,"  >> SQLTemp.sql
echo " \"Homestead Exemption\" TEXT, \"Homestead Exemption Grant Year\" TEXT,"  >> SQLTemp.sql
echo " \"Zoning\" TEXT, \"Parcel Desc 1\" TEXT, \"Parcel Desc 2\" TEXT,"  >> SQLTemp.sql
echo " \"Parcel Desc 3\" TEXT, \"Parcel Desc 4\" TEXT, \"Pool (YES or NO)\" TEXT,"  >> SQLTemp.sql
echo " \"Total Living Units\" TEXT, \"Land Area S. F.\" TEXT,"  >> SQLTemp.sql
echo " \"Gross Bldg Area\" TEXT, \"Living Area\" TEXT, \"Bedrooms\" TEXT,"  >> SQLTemp.sql
echo " \"Baths\" TEXT, \"Half Baths\" TEXT, \"Year Built\" TEXT,"  >> SQLTemp.sql
echo " \"Last Sale Amount\" TEXT, \"Last Sale Date\" TEXT,"  >> SQLTemp.sql
echo " \"Last Sale Qual Code\" TEXT, \"Prior Sale Amount\" TEXT,"  >> SQLTemp.sql
echo " \"Prior Sale Date\" TEXT, \"Prior Sale Qual Code\" TEXT, \"Just Value\" TEXT,"  >> SQLTemp.sql
echo " \"Assessed Value\" TEXT, \"Taxable Value\" TEXT, "  >> SQLTemp.sql
echo " \"Link to Property Detail Page\" TEXT, \"Value Data Source\" TEXT, "  >> SQLTemp.sql
echo " \"Parcel Characteristics Data\" TEXT, \"Status\" TEXT, \"DownloadDate\" TEXT, "  >> SQLTemp.sql
echo " PRIMARY KEY(\"Account #\") );"  >> SQLTemp.sql
echo "WITH a AS (SELECT Account FROM db8.AcctsAll)"  >> SQLTemp.sql
echo "INSERT INTO Terr86777"  >> SQLTemp.sql
echo " SELECT * FROM db29.Data0526"  >> SQLTemp.sql
echo "  WHERE \"Account#\" IN (SELECT Account FROM a);"  >> SQLTemp.sql
echo "UPDATE Terr86777"  >> SQLTemp.sql
echo "SET DownloadDate = \"$TODAY\";"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- END PopulateCongTerr.psq/sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "PopulateCongTerr.sh" "PopulateCongTerr processing complete. $P1"
fi
echo "  PopulateCongTerr complete."
~/sysprocs/LOGMSG "  PopulateCongTerr complete."
#end proc
