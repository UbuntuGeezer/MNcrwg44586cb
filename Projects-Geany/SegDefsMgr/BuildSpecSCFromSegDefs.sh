#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash BuildSpecSCFromSegDefs.sh
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
  ~/sysprocs/LOGMSG "  BuildSpecSCFromSegDefs - initiated from Make"
  echo "  BuildSpecSCFromSegDefs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  BuildSpecSCFromSegDefs - initiated from Terminal"
  echo "  BuildSpecSCFromSegDefs - initiated from Terminal"
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

echo "-- * BuildSpecSCFromSegDefs.psq/sql - Build SCPA../Special/<special-db>.db from SegDefs."  > SQLTemp.sql
echo "-- *	5/21/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry. /DB-Dev.Terr86777.db = up-to-date territory master county database"  >> SQLTemp.sql
echo "-- *		/SCPA-Downloads/Special folder exists"  >> SQLTemp.sql
echo "-- *		/Special/SummerGreen.segdefs.csv definition lines inserted into query below"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	/SCPA-Downloads/Special/SummerGreen.db created/updated"  >> SQLTemp.sql
echo "-- *			.Raw86777 = records extracted from Terr86777"  >> SQLTemp.sql
echo "-- *			.Spec_SCBridge = bridge records extracted from Raw86777"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/25/23.	wmk.	original code; adapted from NewLetter.sql."  >> SQLTemp.sql
echo "-- * 3/5/23.	wmk.	minor bug fixes."  >> SQLTemp.sql
echo "-- * 5/21/23.	wmk.	bug fix \"HomesteadExemption(YESorNO)\" fixed in populate"  >> SQLTemp.sql
echo "-- *			 remaing fields section; documentation updated."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 2/20/23.	wmk.	VeniceNTerritory/NVenAll > Terr86777; change to use"  >> SQLTemp.sql
echo "-- *			 *pathbase, *scpath."  >> SQLTemp.sql
echo "-- * 2/21/23.	wmk.	correct HouseNumber placement in Terrxxx_SCPoly"  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 9/20/21.	original  code (for RUBuildSCFromSegDefs)."  >> SQLTemp.sql
echo "-- * 9/21/21.	modified for use with SCBuildSCFromSegDefs."  >> SQLTemp.sql
echo "-- * 10/4/21.	bug fix in output path for Mapxxx_SC.csv; 632 hardwired"  >> SQLTemp.sql
echo "-- *			in some code replaced with y yy."  >> SQLTemp.sql
echo "-- * 10/11/21.	documentation added; Unit field added by name into"  >> SQLTemp.sql
echo "-- *			table Lett106_TS replacing unnamed field before City."  >> SQLTemp.sql
echo "-- * 10/22/21.	bug fix DROP TABLE Lett106_TS was incorrect."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. BuildSpecSCFromSegDefs.psq is transformed into BuildSpecSCFromSegDefs.sql by DoSedBuildSpecSC.sh"  >> SQLTemp.sql
echo "-- * BuildSCFromSegDefs.sql performs the following operations:"  >> SQLTemp.sql
echo "-- *	open a new database SCPA-Downloads/Terryyy/Terryyy_SC.db"  >> SQLTemp.sql
echo "-- *	create table Terryyy_SCPoly with fields matching SCPA polygon download"  >> SQLTemp.sql
echo "-- *	import raw download into table Terryyy_TSRaw"  >> SQLTemp.sql
echo "-- *	copy TSRaw records into SCPoly table"  >> SQLTemp.sql
echo "-- *	create table Terrxxx_SCBridge and populate from SCPoly records"  >> SQLTemp.sql
echo "-- *	set OwningParcel, Resident1, SitusAddress, PropUse, and RecordType"  >> SQLTemp.sql
echo "-- *	 from Terr86777 SCPA records"  >> SQLTemp.sql
echo "-- *	set RecordType fields to correct record type for PropUse"  >> SQLTemp.sql
echo "-- * The Terrxxx_SC.db now has the basic SC download data."  >> SQLTemp.sql
echo "-- * AddZips needs to run to add in the zip codes to the UnitAddress,s"  >> SQLTemp.sql
echo "-- * the \"TIDY\" utility needs to run to tidy up the records just added."  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Special/SummerGreen.db'"  >> SQLTemp.sql
echo "ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Raw86777;"  >> SQLTemp.sql
echo "CREATE TABLE Raw86777("  >> SQLTemp.sql
echo " \"Account#\" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT,"  >> SQLTemp.sql
echo "MailingAddress1 TEXT, MailingAddress2 TEXT, MailingCity TEXT, "  >> SQLTemp.sql
echo "MailingState TEXT, MailingZipCode TEXT, MailingCountry TEXT, "  >> SQLTemp.sql
echo "\"SitusAddress(PropertyAddress)\" TEXT, SitusCity TEXT, SitusState TEXT, "  >> SQLTemp.sql
echo "SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT, "  >> SQLTemp.sql
echo "Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, "  >> SQLTemp.sql
echo "WaterfrontCode TEXT, \"HomesteadExemption(YESorNO)\" TEXT, "  >> SQLTemp.sql
echo "HomesteadExemptionGrantYear TEXT, Zoning TEXT, ParcelDesc1 TEXT, "  >> SQLTemp.sql
echo "ParcelDesc2 TEXT, ParcelDesc3 TEXT, ParcelDesc4 TEXT, "  >> SQLTemp.sql
echo "\"Pool(YESorNO)\" TEXT, TotalLivingUnits TEXT, \"LandAreaS.F.\" TEXT, "  >> SQLTemp.sql
echo "GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, Baths TEXT, "  >> SQLTemp.sql
echo "HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, LastSaleDate TEXT, "  >> SQLTemp.sql
echo "LastSaleQualCode TEXT, PriorSaleAmount TEXT, PriorSaleDate TEXT, "  >> SQLTemp.sql
echo "PriorSaleQualCode TEXT, JustValue TEXT, AssessedValue TEXT, "  >> SQLTemp.sql
echo "TaxableValue TEXT, LinktoPropertyDetailPage TEXT, ValueDataSource TEXT, "  >> SQLTemp.sql
echo "ParcelCharacteristicsData TEXT, Status TEXT, DownloadDate TEXT, "  >> SQLTemp.sql
echo "PRIMARY KEY (\"Account#\") );"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM db2.Terr86777"  >> SQLTemp.sql
echo "-- segdefs clauses below... from /Special/SummerGreen.segdefs.csv"  >> SQLTemp.sql
echo "--inserthere"  >> SQLTemp.sql
echo "WHERE (\"situs address (property address)\" like '%capri isles blvd%'"  >> SQLTemp.sql
echo "AND CAST(SUBSTR(\"situs address (property address)\",1,"  >> SQLTemp.sql
echo " INSTR(\"situs address (property address)\",' ')) AS INTEGER) >= 792"  >> SQLTemp.sql
echo "AND CAST(SUBSTR(\"situs address (property address)\",1,"  >> SQLTemp.sql
echo " INSTR(\"situs address (property address)\",' ')) AS INTEGER) <= 824"  >> SQLTemp.sql
echo "AND CAST(SUBSTR(\"situs address (property address)\",1,"  >> SQLTemp.sql
echo " INSTR(\"situs address (property address)\",' ')) AS INTEGER)%2 =0)"  >> SQLTemp.sql
echo "--endwhere"  >> SQLTemp.sql
echo ")"  >> SQLTemp.sql
echo "INSERT INTO Raw86777"  >> SQLTemp.sql
echo "SELECT * FROM a;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--======== now populate SCBridge from all Raw86777 records;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Spec_SCBridge;"  >> SQLTemp.sql
echo "CREATE TABLE Spec_SCBridge"  >> SQLTemp.sql
echo "( \"OwningParcel\" TEXT NOT NULL,"  >> SQLTemp.sql
echo " \"UnitAddress\" TEXT NOT NULL,"  >> SQLTemp.sql
echo " \"Unit\" TEXT, \"Resident1\" TEXT, "  >> SQLTemp.sql
echo " \"Phone1\" TEXT,  \"Phone2\" TEXT,"  >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, \"SubTerritory\" TEXT,"  >> SQLTemp.sql
echo " \"CongTerrID\" TEXT, \"DoNotCall\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RSO\" INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RecordDate\" REAL DEFAULT 0,"  >> SQLTemp.sql
echo " \"SitusAddress\" TEXT, \"PropUse\" TEXT,"  >> SQLTemp.sql
echo "  \"DelPending\" INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " \"RecordType\" TEXT);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- now populate the SCBridge table from Raw86777;"  >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM Raw86777)"  >> SQLTemp.sql
echo "INSERT INTO Spec_SCBridge"  >> SQLTemp.sql
echo "( OwningParcel, UnitAddress,"  >> SQLTemp.sql
echo " Unit, CongTerrID, RecordDate)"  >> SQLTemp.sql
echo "SELECT \"Account#\","  >> SQLTemp.sql
echo " TRIM(SUBSTR(\"situsaddress(propertyaddress)\",1,35)),"  >> SQLTemp.sql
echo " TRIM(SUBSTR(\"situsaddress(propertyaddress)\",36)) PUnit,"  >> SQLTemp.sql
echo " '',DownloadDate"  >> SQLTemp.sql
echo "FROM a;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--===============================; continue after above tested..;"  >> SQLTemp.sql
echo "-- set remaining fields;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account#\" AS Acct,"  >> SQLTemp.sql
echo " CASE "  >> SQLTemp.sql
echo " WHEN LENGTH(\"Owner3\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner1\" || ', ' || \"Owner2\" || ', ' || \"Owner3\""  >> SQLTemp.sql
echo " WHEN LENGTH(\"Owner2\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner1\" || ', ' || \"Owner2\""  >> SQLTemp.sql
echo " ELSE \"Owner1\""  >> SQLTemp.sql
echo " END As WhoIsThere,"  >> SQLTemp.sql
echo " \"situsaddress(propertyaddress)\" AS Situs,"  >> SQLTemp.sql
echo " TRIM(SUBSTR(\"situsaddress(propertyaddress)\",1,35)) AS StreetAddr,"  >> SQLTemp.sql
echo "  TRIM(SUBSTR(\"situsaddress(propertyaddress)\",36)) AS SCUnit,"  >> SQLTemp.sql
echo " \"propertyusecode\" AS SCPropUse,"  >> SQLTemp.sql
echo " CASE "  >> SQLTemp.sql
echo " WHEN \"HomesteadExemption(YESorNO)\" IS 'YES'"  >> SQLTemp.sql
echo "  THEN '*'"  >> SQLTemp.sql
echo " ELSE ''"  >> SQLTemp.sql
echo " END AS Hstead,"  >> SQLTemp.sql
echo " DownloadDate LoadDate"  >> SQLTemp.sql
echo " FROM Raw86777"  >> SQLTemp.sql
echo " WHERE Acct IN (SELECT OwningParcel"  >> SQLTemp.sql
echo "  FROM Spec_SCBridge) )"  >> SQLTemp.sql
echo "UPDATE Spec_SCBridge"  >> SQLTemp.sql
echo "SET Resident1 ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT WhoIsThere FROM a"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel )"  >> SQLTemp.sql
echo "ELSE Resident1"  >> SQLTemp.sql
echo "END, "  >> SQLTemp.sql
echo " SitusAddress = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Situs FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) "  >> SQLTemp.sql
echo "    AND SCUnit IS Unit  )"  >> SQLTemp.sql
echo "ELSE SitusAddress"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " Phone2 = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Hstead FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) "  >> SQLTemp.sql
echo "    AND SCUnit IS Unit  )"  >> SQLTemp.sql
echo "ELSE Phone2"  >> SQLTemp.sql
echo "END, "  >> SQLTemp.sql
echo " PropUse ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT SCPropUse FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) "  >> SQLTemp.sql
echo "    AND SCUnit IS Unit  )"  >> SQLTemp.sql
echo "ELSE PropUse"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " RecordDate ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT LoadDate FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) "  >> SQLTemp.sql
echo "    AND SCUnit IS Unit  )"  >> SQLTemp.sql
echo "ELSE RecordDate"  >> SQLTemp.sql
echo "END; "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- now set RecordType fields;"  >> SQLTemp.sql
echo "WITH a AS (SELECT Code,RType FROM db2.SCPropUse)"  >> SQLTemp.sql
echo "UPDATE Spec_SCBridge"  >> SQLTemp.sql
echo "SET RecordType ="  >> SQLTemp.sql
echo "CASE WHEN PropUse IN (SELECT Code FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT RType FROM a"  >> SQLTemp.sql
echo "  WHERE Code IS PropUse)"  >> SQLTemp.sql
echo "ELSE RecordType"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "--======================================================================"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Spec_TSRaw;"  >> SQLTemp.sql
echo "CREATE TABLE Spec_TSRaw"  >> SQLTemp.sql
echo "(AreaName TEXT, HouseNumber TEXT, Street1 TEXT, Street2 TEXT,"  >> SQLTemp.sql
echo " Street3 TEXT, Unit TEXT, City TEXT, Empty TEXT, State TEXT, Zip TEXT );"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- this block inserted data by using territory servant...;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--.headers ON"  >> SQLTemp.sql
echo "--.mode csv"  >> SQLTemp.sql
echo "--.separator ,"  >> SQLTemp.sql
echo "--.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr<terrid>/Lett<terrid>_TS.csv' Terr<terrid>_TSRaw"  >> SQLTemp.sql
echo " -- above block inserted data by using territory servant...;"  >> SQLTemp.sql
echo "WITH a AS (SELECT * FROM Raw86777)"  >> SQLTemp.sql
echo "INSERT INTO Terr<terrid>_TSRaw(AreaName,HouseNumber,Street1,"  >> SQLTemp.sql
echo "   Unit,City,State,Zip)"  >> SQLTemp.sql
echo "SELECT '', "  >> SQLTemp.sql
echo "TRIM(SUBSTR(\"situsaddress(propertyaddress)\","  >> SQLTemp.sql
echo "     1,"  >> SQLTemp.sql
echo "     INSTR(\"situsaddress(propertyaddress)\",' ')"  >> SQLTemp.sql
echo "     )),"  >> SQLTemp.sql
echo "TRIM(SUBSTR(\"situsaddress(propertyaddress)\","  >> SQLTemp.sql
echo "	  INSTR(\"situsaddress(propertyaddress)\",' '),"  >> SQLTemp.sql
echo "     36-INSTR(\"situsaddress(propertyaddress)\",' ')"  >> SQLTemp.sql
echo "     )),"  >> SQLTemp.sql
echo "TRIM(SUBSTR(\"situsaddress(propertyaddress)\","  >> SQLTemp.sql
echo "    36)"  >> SQLTemp.sql
echo "    ),"  >> SQLTemp.sql
echo "     \"situscity\", 'FL', \"situszipcode\""  >> SQLTemp.sql
echo "FROM a"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- now select all the records just created and make a pseudo Map106_SC.csv;"  >> SQLTemp.sql
echo "-- this .csv will be used in the unlikely event that SCNewTerritory gets run"  >> SQLTemp.sql
echo "-- so there is a .csv file to pick up..;"  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".output '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr106/Map106_SC.csv'"  >> SQLTemp.sql
echo "select * from Terr106_SCPoly;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- now set OwningParcel, Resident1, SitusAddress, PropUse, and RecordType from"  >> SQLTemp.sql
echo "-- TerritoryNVenice. Terr86777 and SCPropUse tables;"  >> SQLTemp.sql
echo "ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct,"  >> SQLTemp.sql
echo " CASE "  >> SQLTemp.sql
echo " WHEN LENGTH(\"Owner 3\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner 1\" || ', ' || \"Owner 2\" || ', ' || \"Owner 3\""  >> SQLTemp.sql
echo " WHEN LENGTH(\"Owner 2\") > 0"  >> SQLTemp.sql
echo "  THEN \"Owner 1\" || ', ' || \"Owner 2\""  >> SQLTemp.sql
echo " ELSE \"Owner 1\""  >> SQLTemp.sql
echo " END As WhoIsThere,"  >> SQLTemp.sql
echo " \"situs address (property address)\" AS Situs,"  >> SQLTemp.sql
echo " TRIM(SUBSTR(\"situs address (property address)\",1,35)) AS StreetAddr,"  >> SQLTemp.sql
echo " \"property use code\" AS SCPropUse,"  >> SQLTemp.sql
echo " CASE "  >> SQLTemp.sql
echo " WHEN \"Homestead Exemption\" IS 'YES'"  >> SQLTemp.sql
echo "  THEN '*'"  >> SQLTemp.sql
echo " ELSE ''"  >> SQLTemp.sql
echo " END AS Hstead"  >> SQLTemp.sql
echo " FROM Terr86777"  >> SQLTemp.sql
echo " WHERE StreetAddr IN (SELECT UPPER(TRIM(UnitAddress))"  >> SQLTemp.sql
echo "  FROM Terr106_SCBridge) )"  >> SQLTemp.sql
echo "UPDATE Terr106_SCBridge"  >> SQLTemp.sql
echo "SET OwningParcel ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Acct FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )"  >> SQLTemp.sql
echo "ELSE OwningParcel"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " Resident1 ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT WhoIsThere FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )"  >> SQLTemp.sql
echo "ELSE Resident1"  >> SQLTemp.sql
echo "END, "  >> SQLTemp.sql
echo " SitusAddress = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Situs FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )"  >> SQLTemp.sql
echo "ELSE SitusAddress"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " Phone2 = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Hstead FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )"  >> SQLTemp.sql
echo "ELSE Phone2"  >> SQLTemp.sql
echo "END, "  >> SQLTemp.sql
echo " PropUse ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT SCPropUse FROM a"  >> SQLTemp.sql
echo "  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )"  >> SQLTemp.sql
echo "ELSE PropUse"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE OwningParcel IS '-';"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- set record types;"  >> SQLTemp.sql
echo "UPDATE Terr106_SCBridge"  >> SQLTemp.sql
echo "SET RecordType = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN PropUse IN (SELECT Code FROM db2.SCPropUse)"  >> SQLTemp.sql
echo " THEN (SELECT RType FROM db2.SCPropUse"  >> SQLTemp.sql
echo "  WHERE Code IS PropUse)"  >> SQLTemp.sql
echo "ELSE RecordType"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- Attach TerrIDData.db and extract Terr106Hdr.csv, saving into folder"  >> SQLTemp.sql
echo "--  TerrData/Terr106/Working-Files;"  >> SQLTemp.sql
echo "ATTACH '/home/vncwmk3/Territories/FL/SARA/86777'"  >> SQLTemp.sql
echo "	||		'/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo "	AS db4;"  >> SQLTemp.sql
echo "-- pragma db4.table_info(Territories);"  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".output '/home/vncwmk3/Territories/FL/SARA/86777/TerrData/Terr<terrid>/Working-Files/Terr<terrid>Hdr.csv'"  >> SQLTemp.sql
echo "SELECT * FROM db4.Territory"  >> SQLTemp.sql
echo "WHERE TerrID is '<terrid>';	"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END BuildSCFromSegDefs.psq/sql;"  >> SQLTemp.sql
echo " -- import Lett<terrid>_TS.csv into Terr106_SC.db.Terr<terrid>_TSRaw;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Terr<terrid>_TSRaw;"  >> SQLTemp.sql
echo "CREATE TABLE Terryyy_TSRaw"  >> SQLTemp.sql
echo "(AreaName TEXT, HouseNumber TEXT, Street1 TEXT, Street2 TEXT,"  >> SQLTemp.sql
echo " Street3 TEXT, Unit TEXT, City TEXT, Empty TEXT, State TEXT, Zip TEXT );"  >> SQLTemp.sql
echo " -- this block inserted data by using territory servant...;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr106/Lett<terrid>_TS.csv' Terr<terrid>_TSRaw"  >> SQLTemp.sql
echo " -- above block inserted data by using territory servant...;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  BuildSpecSCFromSegDefs complete."
~/sysprocs/LOGMSG "  BuildSpecSCFromSegDefs complete."
#end proc
