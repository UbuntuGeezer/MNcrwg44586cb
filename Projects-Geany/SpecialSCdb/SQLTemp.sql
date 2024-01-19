-- * HarborLights.sql - HarborLightsMHP SC download records to .db.
-- *	5/9/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 3/18/23.	wmk.	original code; adapted from EaglePoint.
-- * 5/9/23.	wmk.	modified to extract records from Terr86777 using parcel
-- *		 ids.
-- * Legacy mods.
-- * 10/7/21.	wmk.	original code; cloned from Method2.sql.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- *
-- * Notes. Method2 uses the downloaded SCPA records from the .csv
-- * that was produced from a SCPA polygon download into file
-- * <specialdb>.csv. Then it builds the <specialdb> table, SpecSCBridge,
-- * PropTerr and TerrList tables from the full download records.
-- *;

-- * subquery list.
-- * --------------
-- * BuildHarborLights - Build SC Download table from Terr86777.
-- * GetCsvRecords - Get records from download HarorLights.csv.
-- *;

.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Special/HarborLightsMHP.db'
-- * BuildHarborLights - build HarborLightsMHP.db from Terr86777;
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
 AS db2;
-- pragma db2.table_info(Terr86777);

DROP TABLE IF EXISTS HarborLightsMHP;
CREATE TABLE HarborLightsMHP (
 "Account #" TEXT NOT NULL, "Owner 1" TEXT, "Owner 2" TEXT, "Owner 3" TEXT, 
 "Mailing Address 1" TEXT, "Mailing Address 2" TEXT, "Mailing City" TEXT, 
 "Mailing State" TEXT, "Mailing Zip Code" TEXT, "Mailing Country" TEXT, 
 "Situs Address (Property Address)" TEXT, "Situs City" TEXT, 
 "Situs State" TEXT, "Situs Zip Code" TEXT, "Property Use Code" TEXT, 
 "Neighborhood" TEXT, "Subdivision" TEXT, "Taxing District" TEXT, 
 "Municipality" TEXT, "Waterfront Code" TEXT, "Homestead Exemption" TEXT, 
 "Homestead Exemption Grant Year" TEXT, "Zoning" TEXT, 
 "Parcel Desc 1" TEXT, "Parcel Desc 2" TEXT, "Parcel Desc 3" TEXT, 
 "Parcel Desc 4" TEXT, "Pool (YES or NO)" TEXT, 
 "Total Living Units" TEXT, "Land Area S. F." TEXT, 
 "Gross Bldg Area" TEXT, "Living Area" TEXT, "Bedrooms" TEXT, "Baths" TEXT, 
 "Half Baths" TEXT, "Year Built" TEXT, "Last Sale Amount" TEXT, 
 "Last Sale Date" TEXT, "Last Sale Qual Code" TEXT, 
 "Prior Sale Amount" TEXT, "Prior Sale Date" TEXT, 
 "Prior Sale Qual Code" TEXT, "Just Value" TEXT, "Assessed Value" TEXT, 
 "Taxable Value" TEXT, "Link to Property Detail Page" TEXT, 
 "Value Data Source" TEXT, "Parcel Characteristics Data" TEXT, 
 "Status" TEXT, "DownloadDate" TEXT, PRIMARY KEY("Account #") );
INSERT INTO HarborLightsMHP
select *  from db2.Terr86777
where cast("Account #" as integer) >= 407031001
  and cast("Account #" as integer) <= 407031154
order by "Account #"
  ;

DROP TABLE IF EXISTS Spec_SCBridge;
CREATE TABLE Spec_SCBridge 
( "OwningParcel" TEXT NOT NULL, "UnitAddress" TEXT NOT NULL, "Unit" TEXT, 
"Resident1" TEXT, "Phone1" TEXT, "Phone2" TEXT, "RefUSA-Phone" TEXT, 
"SubTerritory" TEXT, "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0, 
"RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0, 
"RecordDate" REAL DEFAULT 0, "SitusAddress" TEXT, "PropUse" TEXT, 
"DelPending" INTEGER DEFAULT 0, "RecordType" TEXT);
INSERT INTO Spec_SCBridge(OwningParcel,UnitAddress,Unit,Resident1,
 Phone2,RecordDate,SitusAddress,PropUse)
 SELECT "Account #",
  trim(SUBSTR("situs address (property address)",1,35)),
  SUBSTR("situs address (property address)",36),
  CASE
  WHEN LENGTH("Owner 3") > 0
   THEN "Owner 1" || ", " || "Owner 2" || ", " || "Owner 3"
  WHEN LENGTH("Owner 2") > 0
   THEN "Owner 1" || ", " || "Owner 2"
  ELSE "Owner 1"
  END,
  CASE 
  WHEN "Homestead Exemption" IS "YES" 
   THEN "*"
  ELSE ""
  END, DownloadDate,
  "situs address (property address)",
  "Property Use Code" FROM HarborLightsMHP;
  
DROP TABLE IF EXISTS PropTerr;
CREATE TABLE PropTerr (PropID TEXT, StreetAddr TEXT, TerrID TEXT);
WITH a AS (SELECT "Account #" AS Acct,
 TRIM(SUBSTR("situs address (property address)",1,35)) AS StreetAddr, ''
 FROM HarborLightsMHP)
INSERT INTO PropTerr
 SELECT * FROM a;
DROP TABLE IF EXISTS TerrList;
CREATE TABLE TerrList (TerrID TEXT, Counts INTEGER DEFAULT 0);
.quit
-- ** END HarborLightsMHP.sql;
--==============================================================;
-- old code;
.mode csv
.separator "|"
.headers on
DROP TABLE IF EXISTS HarborLightsMHP;
CREATE TABLE HarborLightsMHP (
 "Account #" TEXT NOT NULL, "Owner 1" TEXT, "Owner 2" TEXT, "Owner 3" TEXT, 
 "Mailing Address 1" TEXT, "Mailing Address 2" TEXT, "Mailing City" TEXT, 
 "Mailing State" TEXT, "Mailing Zip Code" TEXT, "Mailing Country" TEXT, 
 "Situs Address (Property Address)" TEXT, "Situs City" TEXT, 
 "Situs State" TEXT, "Situs Zip Code" TEXT, "Property Use Code" TEXT, 
 "Neighborhood" TEXT, "Subdivision" TEXT, "Taxing District" TEXT, 
 "Municipality" TEXT, "Waterfront Code" TEXT, "Homestead Exemption" TEXT, 
 "Homestead Exemption Grant Year" TEXT, "Zoning" TEXT, 
 "Parcel Desc 1" TEXT, "Parcel Desc 2" TEXT, "Parcel Desc 3" TEXT, 
 "Parcel Desc 4" TEXT, "Pool (YES or NO)" TEXT, 
 "Total Living Units" TEXT, "Land Area S. F." TEXT, 
 "Gross Bldg Area" TEXT, "Living Area" TEXT, "Bedrooms" TEXT, "Baths" TEXT, 
 "Half Baths" TEXT, "Year Built" TEXT, "Last Sale Amount" TEXT, 
 "Last Sale Date" TEXT, "Last Sale Qual Code" TEXT, 
 "Prior Sale Amount" TEXT, "Prior Sale Date" TEXT, 
 "Prior Sale Qual Code" TEXT, "Just Value" TEXT, "Assessed Value" TEXT, 
 "Taxable Value" TEXT, "Link to Property Detail Page" TEXT, 
 "Value Data Source" TEXT, "Parcel Characteristics Data" TEXT, 
 "Status" TEXT, "DownloadDate" TEXT, PRIMARY KEY("Account #") );
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Special/HarborLightsMHP.csv' HarborLightsMHP

