#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash SCSpecTerr_db.sh
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
  ~/sysprocs/LOGMSG "  SCSpecTerr_db - initiated from Make"
  echo "  SCSpecTerr_db - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SCSpecTerr_db - initiated from Terminal"
  echo "  SCSpecTerr_db - initiated from Terminal"
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

# #!/bin/bash
# SCSpecTerr_db.hd1 - Preamble for SCSpecTErr_db.sh.
#	6/5/22.	wmk. (Dev)
#
#	Usage. bash SCSpecTerr_db.sh  <spec-name> <mm> <dd> [<terrid>]
#		<spec-name> = special name for territory (e.g. GondolaParkDr)
#		<spec-name>.csv assumed to exist in ~/SCPA-Downloads/Special folder
#		<mm> = month of download csv data extracted from (year 2021)
#		<dd> = day of download csv data extracted from 
#		user assumed to be in RawData/SCPA/SCPA-Downloads folder
#
#		[<terrid>] = (optional) territory ID to preset in all
#			<spec-name> table records
#
# Exit. <spec-name>.db created in folder /SCPA-Downloads/Special
#		  <spec-name> table is raw data from map polygon download
#		  PropTerr table is account#, situsaddress, terrid
#		  TerrList table is territory IDs and counts
#
# Modification History.
# ---------------------
# 6/5/22.	wmk.	name change from SCSpecTerr_1.sh to SCSpecTerr_db.hd1;
#			 for use with HdrsSQLtoSH project *make*.
# Legacy mods.
# 5/30/22.	wmk.	(automated) *pathbase* block added.
# Legacy  mods.
# 7/2/21.	wmk.	original shell (compatible with make); adapted from
#					RUSpecTerr.sh.
# 7/24/21.	wmk.	superfluous "s removed; passed parameters added to
#					log messages for tracking.
# 7/25/21.	wmk.	added <terrid> preset option.
#
# Notes. SCSpecTerr_db generates an .sql batch directives
# file, then runs sqlite to import the raw .csv data into table
# Special_Raw. Then a sorting query is run to create a second table
# Special_Poly containing the download records sorted by street
# and number for easy extraction in correct order for territories.
# jumpto function definition
#function jumpto
#{
#    label=$1
#    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
#    eval "$cmd"
#    exit
#}
# check for 262system as special case.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
P1=$1		# <special-name> e.g. GondolaParkDr
P2=$2		# mm
P3=$3		# dd
P4=$4		# territory ID for all records in P1.db
TID=$P4
MM=$P2
DD=$P3
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
 NO_PROMPT=1
  bash ~/sysprocs/LOGMSG "   SCSpecTerr_db  $P1  initiated from Make."
  echo "   SCSpecTerr_db  $P1  initiated."
else
 NO_PROMPT=0
  bash ~/sysprocs/LOGMSG "   SCSpecTerr_db initiated from Terminal."
  echo "   SCSpecTerr_db  $P1  initiated."
fi
# pathbase block.
# 5/30/22.
if [ -z "$pathbase" ];then
 if [ ! -z "$congpath" ];then
  export pathbase=$folderbase/Territories/$congpath
 else
  export pathbase=$folderbase/Territories/FL/SARA/86777
 fi
fi
# end pathbase block.
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
  ~/sysprocs/LOGMSG "  missing parameter(s)... SCSpecTerr_db abandoned."
  echo -e "<special-db> mm dd must be specified...\nSCSpecTerr_db abandoned."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
fi
#TID=$1
CSV_BASE=$P1
CSV_SUFFX=".csv"
CSV_NAME=$CSV_BASE$CSV_SUFFX
echo "special db source = \"Special/$CSV_NAME\""
if [ true ]; then
TST_STR="(test)"
else
TST_STR=""
fi
#remove column headings if present.
sed -i '/Account #/d' $pathbase/RawData/SCPA/SCPA-Downloads/Special/$CSV_NAME
touch $TEMP_PATH/scratchfile
#.trace 'Procs-Dev/SQLTrace.txt'
# .open './DB/PolyTerri.db'
DB_END=".db"
TBL_END1=""
NAME_PRFX="$CSV_BASE"
MAP_SUFFX="_SC"
CSV_NAME1="$NAME_PRFX.csv"
DB_NAME="$P1$DB_END"
TBL_NAME1=$CSV_BASE
TBL_NAME2=PropTerr
TBL_NAME3=Spec_SCBridge
echo "DB_NAME = \"$DB_NAME\""
echo "TBL_NAME1 = \"$TBL_NAME1\""
echo "TBL_NAME2 = \"$TBL_NAME2\""
echo "TBL_NAME3 = \"$TBL_NAME3\""
#procbodyhere.
echo "-- * HarborLights.sql - HarborLightsMHP SC download records to .db."  > SQLTemp.sql
echo "-- *	5/9/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 3/18/23.	wmk.	original code; adapted from EaglePoint."  >> SQLTemp.sql
echo "-- * 5/9/23.	wmk.	modified to extract records from Terr86777 using parcel"  >> SQLTemp.sql
echo "-- *		 ids."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 10/7/21.	wmk.	original code; cloned from Method2.sql."  >> SQLTemp.sql
echo "-- * 5/7/22.	wmk.	(automated) *pathbase* integration."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. Method2 uses the downloaded SCPA records from the .csv"  >> SQLTemp.sql
echo "-- * that was produced from a SCPA polygon download into file"  >> SQLTemp.sql
echo "-- * <specialdb>.csv. Then it builds the <specialdb> table, SpecSCBridge,"  >> SQLTemp.sql
echo "-- * PropTerr and TerrList tables from the full download records."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * BuildHarborLights - Build SC Download table from Terr86777."  >> SQLTemp.sql
echo "-- * GetCsvRecords - Get records from download HarorLights.csv."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/HarborLightsMHP.db'"  >> SQLTemp.sql
echo "-- * BuildHarborLights - build HarborLightsMHP.db from Terr86777;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "-- pragma db2.table_info(Terr86777);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS HarborLightsMHP;"  >> SQLTemp.sql
echo "CREATE TABLE HarborLightsMHP ("  >> SQLTemp.sql
echo " \"Account #\" TEXT NOT NULL, \"Owner 1\" TEXT, \"Owner 2\" TEXT, \"Owner 3\" TEXT, "  >> SQLTemp.sql
echo " \"Mailing Address 1\" TEXT, \"Mailing Address 2\" TEXT, \"Mailing City\" TEXT, "  >> SQLTemp.sql
echo " \"Mailing State\" TEXT, \"Mailing Zip Code\" TEXT, \"Mailing Country\" TEXT, "  >> SQLTemp.sql
echo " \"Situs Address (Property Address)\" TEXT, \"Situs City\" TEXT, "  >> SQLTemp.sql
echo " \"Situs State\" TEXT, \"Situs Zip Code\" TEXT, \"Property Use Code\" TEXT, "  >> SQLTemp.sql
echo " \"Neighborhood\" TEXT, \"Subdivision\" TEXT, \"Taxing District\" TEXT, "  >> SQLTemp.sql
echo " \"Municipality\" TEXT, \"Waterfront Code\" TEXT, \"Homestead Exemption\" TEXT, "  >> SQLTemp.sql
echo " \"Homestead Exemption Grant Year\" TEXT, \"Zoning\" TEXT, "  >> SQLTemp.sql
echo " \"Parcel Desc 1\" TEXT, \"Parcel Desc 2\" TEXT, \"Parcel Desc 3\" TEXT, "  >> SQLTemp.sql
echo " \"Parcel Desc 4\" TEXT, \"Pool (YES or NO)\" TEXT, "  >> SQLTemp.sql
echo " \"Total Living Units\" TEXT, \"Land Area S. F.\" TEXT, "  >> SQLTemp.sql
echo " \"Gross Bldg Area\" TEXT, \"Living Area\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT, "  >> SQLTemp.sql
echo " \"Half Baths\" TEXT, \"Year Built\" TEXT, \"Last Sale Amount\" TEXT, "  >> SQLTemp.sql
echo " \"Last Sale Date\" TEXT, \"Last Sale Qual Code\" TEXT, "  >> SQLTemp.sql
echo " \"Prior Sale Amount\" TEXT, \"Prior Sale Date\" TEXT, "  >> SQLTemp.sql
echo " \"Prior Sale Qual Code\" TEXT, \"Just Value\" TEXT, \"Assessed Value\" TEXT, "  >> SQLTemp.sql
echo " \"Taxable Value\" TEXT, \"Link to Property Detail Page\" TEXT, "  >> SQLTemp.sql
echo " \"Value Data Source\" TEXT, \"Parcel Characteristics Data\" TEXT, "  >> SQLTemp.sql
echo " \"Status\" TEXT, \"DownloadDate\" TEXT, PRIMARY KEY(\"Account #\") );"  >> SQLTemp.sql
echo "INSERT INTO HarborLightsMHP"  >> SQLTemp.sql
echo "select *  from db2.Terr86777"  >> SQLTemp.sql
echo "where cast(\"Account #\" as integer) >= 407031001"  >> SQLTemp.sql
echo "  and cast(\"Account #\" as integer) <= 407031154"  >> SQLTemp.sql
echo "order by \"Account #\""  >> SQLTemp.sql
echo "  ;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Spec_SCBridge;"  >> SQLTemp.sql
echo "CREATE TABLE Spec_SCBridge "  >> SQLTemp.sql
echo "( \"OwningParcel\" TEXT NOT NULL, \"UnitAddress\" TEXT NOT NULL, \"Unit\" TEXT, "  >> SQLTemp.sql
echo "\"Resident1\" TEXT, \"Phone1\" TEXT, \"Phone2\" TEXT, \"RefUSA-Phone\" TEXT, "  >> SQLTemp.sql
echo "\"SubTerritory\" TEXT, \"CongTerrID\" TEXT, \"DoNotCall\" INTEGER DEFAULT 0, "  >> SQLTemp.sql
echo "\"RSO\" INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0, "  >> SQLTemp.sql
echo "\"RecordDate\" REAL DEFAULT 0, \"SitusAddress\" TEXT, \"PropUse\" TEXT, "  >> SQLTemp.sql
echo "\"DelPending\" INTEGER DEFAULT 0, \"RecordType\" TEXT);"  >> SQLTemp.sql
echo "INSERT INTO Spec_SCBridge(OwningParcel,UnitAddress,Unit,Resident1,"  >> SQLTemp.sql
echo " Phone2,RecordDate,SitusAddress,PropUse)"  >> SQLTemp.sql
echo " SELECT \"Account #\","  >> SQLTemp.sql
echo "  trim(SUBSTR(\"situs address (property address)\",1,35)),"  >> SQLTemp.sql
echo "  SUBSTR(\"situs address (property address)\",36),"  >> SQLTemp.sql
echo "  CASE"  >> SQLTemp.sql
echo "  WHEN LENGTH(\"Owner 3\") > 0"  >> SQLTemp.sql
echo "   THEN \"Owner 1\" || \", \" || \"Owner 2\" || \", \" || \"Owner 3\""  >> SQLTemp.sql
echo "  WHEN LENGTH(\"Owner 2\") > 0"  >> SQLTemp.sql
echo "   THEN \"Owner 1\" || \", \" || \"Owner 2\""  >> SQLTemp.sql
echo "  ELSE \"Owner 1\""  >> SQLTemp.sql
echo "  END,"  >> SQLTemp.sql
echo "  CASE "  >> SQLTemp.sql
echo "  WHEN \"Homestead Exemption\" IS \"YES\" "  >> SQLTemp.sql
echo "   THEN \"*\""  >> SQLTemp.sql
echo "  ELSE \"\""  >> SQLTemp.sql
echo "  END, DownloadDate,"  >> SQLTemp.sql
echo "  \"situs address (property address)\","  >> SQLTemp.sql
echo "  \"Property Use Code\" FROM HarborLightsMHP;"  >> SQLTemp.sql
echo "  "  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS PropTerr;"  >> SQLTemp.sql
echo "CREATE TABLE PropTerr (PropID TEXT, StreetAddr TEXT, TerrID TEXT);"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " TRIM(SUBSTR(\"situs address (property address)\",1,35)) AS StreetAddr, ''"  >> SQLTemp.sql
echo " FROM HarborLightsMHP)"  >> SQLTemp.sql
echo "INSERT INTO PropTerr"  >> SQLTemp.sql
echo " SELECT * FROM a;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS TerrList;"  >> SQLTemp.sql
echo "CREATE TABLE TerrList (TerrID TEXT, Counts INTEGER DEFAULT 0);"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END HarborLightsMHP.sql;"  >> SQLTemp.sql
echo "--==============================================================;"  >> SQLTemp.sql
echo "-- old code;"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator \"|\""  >> SQLTemp.sql
echo ".headers on"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS HarborLightsMHP;"  >> SQLTemp.sql
echo "CREATE TABLE HarborLightsMHP ("  >> SQLTemp.sql
echo " \"Account #\" TEXT NOT NULL, \"Owner 1\" TEXT, \"Owner 2\" TEXT, \"Owner 3\" TEXT, "  >> SQLTemp.sql
echo " \"Mailing Address 1\" TEXT, \"Mailing Address 2\" TEXT, \"Mailing City\" TEXT, "  >> SQLTemp.sql
echo " \"Mailing State\" TEXT, \"Mailing Zip Code\" TEXT, \"Mailing Country\" TEXT, "  >> SQLTemp.sql
echo " \"Situs Address (Property Address)\" TEXT, \"Situs City\" TEXT, "  >> SQLTemp.sql
echo " \"Situs State\" TEXT, \"Situs Zip Code\" TEXT, \"Property Use Code\" TEXT, "  >> SQLTemp.sql
echo " \"Neighborhood\" TEXT, \"Subdivision\" TEXT, \"Taxing District\" TEXT, "  >> SQLTemp.sql
echo " \"Municipality\" TEXT, \"Waterfront Code\" TEXT, \"Homestead Exemption\" TEXT, "  >> SQLTemp.sql
echo " \"Homestead Exemption Grant Year\" TEXT, \"Zoning\" TEXT, "  >> SQLTemp.sql
echo " \"Parcel Desc 1\" TEXT, \"Parcel Desc 2\" TEXT, \"Parcel Desc 3\" TEXT, "  >> SQLTemp.sql
echo " \"Parcel Desc 4\" TEXT, \"Pool (YES or NO)\" TEXT, "  >> SQLTemp.sql
echo " \"Total Living Units\" TEXT, \"Land Area S. F.\" TEXT, "  >> SQLTemp.sql
echo " \"Gross Bldg Area\" TEXT, \"Living Area\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT, "  >> SQLTemp.sql
echo " \"Half Baths\" TEXT, \"Year Built\" TEXT, \"Last Sale Amount\" TEXT, "  >> SQLTemp.sql
echo " \"Last Sale Date\" TEXT, \"Last Sale Qual Code\" TEXT, "  >> SQLTemp.sql
echo " \"Prior Sale Amount\" TEXT, \"Prior Sale Date\" TEXT, "  >> SQLTemp.sql
echo " \"Prior Sale Qual Code\" TEXT, \"Just Value\" TEXT, \"Assessed Value\" TEXT, "  >> SQLTemp.sql
echo " \"Taxable Value\" TEXT, \"Link to Property Detail Page\" TEXT, "  >> SQLTemp.sql
echo " \"Value Data Source\" TEXT, \"Parcel Characteristics Data\" TEXT, "  >> SQLTemp.sql
echo " \"Status\" TEXT, \"DownloadDate\" TEXT, PRIMARY KEY(\"Account #\") );"  >> SQLTemp.sql
echo ".import '$pathbase/$scpath/Special/HarborLightsMHP.csv' HarborLightsMHP"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#endprocbody.
# begin SCSpecTerr_db.hd2
#jumpto TrySQL
#TrySQL:
echo "starting sqlite3..."
sqlite3 < SQLTemp.sql
#jumpto TestEnd
#TestEnd:
~/sysprocs/LOGMSG "  SCSpecTerr_db $P1 (Dev) $TST_STR complete."
echo "SCSpecTerr_db $P1 (Dev) $TST_STR complete."
# end SCSpecTerr_db.hd2
echo "  SCSpecTerr_db complete."
~/sysprocs/LOGMSG "  SCSpecTerr_db complete."
#end proc
