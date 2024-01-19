-- PopulateCongTerr.psq/sql - Populate new Terr86777.Terr86777 table.
-- * 5/1/22.	wmk.
-- *
-- * Modification History.
-- * 4/27/22.	wmk.	original code.
-- * 5/1/22.	wmk.	modified to use db8.AuxSCPAData.AcctsAll table instead
-- *			 of VeniceNTerritory.db.NVenAccts for consitency with ExtractDiff.
-- *
-- * PopulateCongTerr.sql regenerates table Terr86777 by adding all records
-- *  from SCPA_05-28.db.Data0528
-- * into Terr86777.Terr86777 where "Account#" in Data0528 in
-- * AuxSCPAData.db.AcctsAll table.
-- *;
.open '$pathbase/DB-Dev/Terr86777.db'
ATTACH '$pathbase'
    || '/DB-Dev/VeniceNTerritory.db'
    AS db2;
ATTACH '$pathbase'
    || '/DB-Dev/AuxSCPAData.db'
    AS db8;
ATTACH '$pathbase'
	|| '/RawData/SCPA/SCPA-Downloads/SCPA_05-28.db'
	AS db29;
DROP TABLE IF EXISTS Terr86777;
CREATE TABLE Terr86777
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
 "Total Living Units" TEXT, "Land Area S. F." TEXT,
 "Gross Bldg Area" TEXT, "Living Area" TEXT, "Bedrooms" TEXT,
 "Baths" TEXT, "Half Baths" TEXT, "Year Built" TEXT,
 "Last Sale Amount" TEXT, "Last Sale Date" TEXT,
 "Last Sale Qual Code" TEXT, "Prior Sale Amount" TEXT,
 "Prior Sale Date" TEXT, "Prior Sale Qual Code" TEXT, "Just Value" TEXT,
 "Assessed Value" TEXT, "Taxable Value" TEXT, 
 "Link to Property Detail Page" TEXT, "Value Data Source" TEXT, 
 "Parcel Characteristics Data" TEXT, "Status" TEXT, "DownloadDate" TEXT, 
 PRIMARY KEY("Account #") );
WITH a AS (SELECT Account FROM db8.AcctsAll)
INSERT INTO Terr86777
 SELECT * FROM db29.Data0528
  WHERE "Account#" IN (SELECT Account FROM a);
UPDATE Terr86777
SET DownloadDate = "$TODAY";
.quit
-- END PopulateCongTerr.psq/sql;
