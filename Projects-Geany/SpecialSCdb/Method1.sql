-- Method1csv.sql - SQL template for SC download full records to .db.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--		5/30/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/30/22.	wmk.	*pathbase* support.
-- * Legacy mods.
-- * 10/7/21.	wmk.	original code; cloned from TheEsplanade.sql.
-- *
-- * Notes. Method1 extracts records from NVenAll based on address into
-- * <specialdb>.csv. Then it builds the <specialdb> table, SpecSCBridge,
-- * PropTerr and TerrList tables from the full download records.
-- *;

-- *
-- * GetCsvRecords - Get records from download <special-db>.csv;

.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/<special-db>.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
  AS db2;
.output '$pathbase/RawData/SCPA/SCPA-Downloads/Special/<special-db>.csv'
.headers OFF
.mode csv
select * from db2.Terr86777
 where "situs address (property address)"
  like '%<streetname>%';
DROP TABLE IF EXISTS <special-db>;
CREATE TABLE <special-db>
( "Account #" TEXT NOT NULL, "Owner 1" TEXT, "Owner 2" TEXT, 
"Owner 3" TEXT, "Mailing Address 1" TEXT, "Mailing Address 2" TEXT, 
"Mailing City" TEXT, "Mailing State" TEXT, "Mailing Zip Code" TEXT, 
"Mailing Country" TEXT, "Situs Address (Property Address)" TEXT, 
"Situs City" TEXT, "Situs State" TEXT, "Situs Zip Code" TEXT, 
"Property Use Code" TEXT, "Neighborhood" TEXT, "Subdivision" TEXT, 
"Taxing District" TEXT, "Municipality" TEXT, "Waterfront Code" TEXT, 
"Homestead Exemption" TEXT, "Homestead Exemption Grant Year" TEXT, 
"Zoning" TEXT, "Parcel Desc 1" TEXT, "Parcel Desc 2" TEXT, 
"Parcel Desc 3" TEXT, "Parcel Desc 4" TEXT, "Pool (YES or NO)" TEXT, 
"Total Living Units" TEXT, "Land Area S. F." TEXT, "Gross Bldg Area" TEXT, 
"Living Area" TEXT, "Bedrooms" TEXT, "Baths" TEXT, "Half Baths" TEXT, 
"Year Built" TEXT, "Last Sale Amount" TEXT, "Last Sale Date" TEXT, 
"Last Sale Qual Code" TEXT, "Prior Sale Amount" TEXT, 
"Prior Sale Date" TEXT, "Prior Sale Qual Code" TEXT, "Just Value" TEXT, 
"Assessed Value" TEXT, "Taxable Value" TEXT, 
"Link to Property Detail Page" TEXT, "Value Data Source" TEXT, 
"Parcel Characteristics Data" TEXT, "Status" TEXT, "DownloadDate" TEXT, 
PRIMARY KEY("Account #") );
.import '$folderbase/RawData/SCPA/SCPA-Downloads/Special/TheEsplanade.csv' TheEsplanade
ALTER TABLE TheEsplanade ADD COLUMN TID TEXT;
DROP TABLE IF EXISTS Spec_SCBridge;
CREATE TABLE Spec_SCBridge 
( "OwningParcel" TEXT NOT NULL, "UnitAddress" TEXT NOT NULL, "Unit" TEXT, 
"Resident1" TEXT, "Phone1" TEXT, "Phone2" TEXT, "RefUSA-Phone" TEXT, 
"SubTerritory" TEXT, "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0, 
"RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0, 
"RecordDate" REAL DEFAULT 0, "SitusAddress" TEXT, "PropUse" TEXT, 
"DelPending" INTEGER DEFAULT 0, "RecordType" TEXT);
INSERT INTO Spec_SCBridge
 SELECT "Account #",
  trim(SUBSTR("situs address (property address)",1,35)),
  SUBSTR("situs address (property address)",36),
  CASE
  WHEN LENGTH("Owner 3") > 0
   THEN "Owner 1" || ", " || "Owner 2" || ", " || "Owner 3"
  WHEN LENGTH("Owner 2") > 0
   THEN "Owner 1" || ", " || "Owner 2"
  ELSE "Owner 1"
  END, "",
  CASE 
  WHEN "Homestead Exemption" IS "YES" 
   THEN "*"
  ELSE ""
  END, "", "", "", "", "", "", DownloadDate,
  "situs address (property address)",
  "Property Use Code", "", "" FROM TheEsplanade;
DROP TABLE IF EXISTS PropTerr;
CREATE TABLE PropTerr (PropID TEXT, StreetAddr TEXT, TerrID TEXT);
WITH a AS (SELECT "Account #" AS Acct,
 TRIM(SUBSTR("situs address (property address)",1,35)) AS StreetAddr, TID
 FROM TheEsplanade)
INSERT INTO PropTerr
 SELECT * FROM a;
DROP TABLE IF EXISTS TerrList;
CREATE TABLE TerrList (TerrID TEXT, Counts INTEGER DEFAULT 0);
.quit
-- * END Method1.sql;
