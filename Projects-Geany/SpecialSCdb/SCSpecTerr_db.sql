-- * TarponCenterDr.sql - extract all TarponCenterDr records from Terr86777.
-- *	7/6/23.	wmk.
-- *
-- Modification History.
-- ---------------------
-- * 7/6/23.	wmk.	obtain records from latest SCPA download (5/28).
-- * Legacy mods.
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 6/5/22.	wmk.	1000/PH penthouses (601-604) accounted for; source
-- *			 db changed to 05-26 (2022) data; import table
-- *		 DownloadDate column added to match new imports.
-- * Legacy mods.
-- * 12/15/21.	wmk.	original; adapted from AvensCohosh.
-- Legacy mods.
-- * 9/18/21.		wmk.	modified to use SCPA_08-25.db instead of Terr86777.db
--				 to pick up valid properties missing from Terr86777 table;
.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/TarponCenterDr.db'
ATTACH '$pathbase/RawData/SCPA'
 || '/SCPA-Downloads/SCPA_05-28.db'
  AS db40;
.output "$pathbase/RawData/SCPA/SCPA-Downloads/Special/TarponCenterDr.csv"
.headers OFF
.mode csv
select * from db40.Data0528
 where "situsaddress(propertyaddress)"
  like '%tarpon center dr%'
;
DROP TABLE IF EXISTS TarponCenterDr;
-- One column shorter than Terr86777; no DownloadDate in import data;
CREATE TABLE TarponCenterDr 
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
"Parcel Characteristics Data" TEXT, "Status" TEXT, DownloadDate TEXT, 
PRIMARY KEY("Account #") );
.import '$pathbase/RawData/SCPA/SCPA-Downloads/Special/TarponCenterDr.csv' TarponCenterDr
--ALTER TABLE TarponCenterDr ADD COLUMN DownloadDate TEXT;
ALTER TABLE TarponCenterDr ADD COLUMN TID TEXT;
UPDATE TarponCenterDr
SET DownloadDate = '2023-05-28';
DROP TABLE IF EXISTS Spec_SCBridge;
CREATE TABLE Spec_SCBridge 
( "OwningParcel" TEXT NOT NULL, "UnitAddress" TEXT NOT NULL, "Unit" TEXT, 
"Resident1" TEXT, "Phone1" TEXT, "Phone2" TEXT, "RefUSA-Phone" TEXT, 
"SubTerritory" TEXT, "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0, 
"RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0, 
"RecordDate" REAL DEFAULT 0, "SitusAddress" TEXT, "PropUse" TEXT, 
"DelPending" INTEGER DEFAULT 0, "RecordType" TEXT);
INSERT OR REPLACE INTO Spec_SCBridge
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
  END, "", "", "$TID", "", "", "", DownloadDate,
  "situs address (property address)",
  "Property Use Code", "", "" FROM TarponCenterDr;
DROP TABLE IF EXISTS PropTerr;
CREATE TABLE PropTerr (PropID TEXT, StreetAddr TEXT, TerrID TEXT);
WITH a AS (SELECT "Account #" AS Acct,
 TRIM(SUBSTR("situs address (property address)",1,35)) AS StreetAddr, TID
 FROM TarponCenterDr)
INSERT INTO PropTerr
 SELECT * FROM a;
DROP TABLE IF EXISTS TerrList;
CREATE TABLE TerrList (TerrID TEXT, Counts INTEGER DEFAULT 0);
.quit
-- ** END TarponCenterDr.sql;
