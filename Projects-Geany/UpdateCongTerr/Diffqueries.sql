create table Base0722 
(Account TEXT, LastSale TEXT, HStead TEXT,
PRIMARY KEY(Account));
--;
create table Base0825
(Account TEXT, LastSale TEXT, HStead TEXT,
PRIMARY KEY(Account));
DELETE FROM Base0722;
INSERT INTO Base0722
SELECT "ACCOUNT#","LASTSALEDATE","HOMESTEADEXEMPTION(YESORNO)"
FROM db14.Data0722
WHERE "ACCOUNT#" IN (SELECT Account FROM db2.NVenAccts);
--;
WITH a AS (SELECT Account FROM Base0825 
 WHERE Account IN (SELECT Account FROM Base0722 
  WHERE Account IS Base0825.Account 
   AND (LastSale IS NOT Base0825.LastSale
        OR HStead IS NOT Base0825.HStead)) )
SELECT * FROM db15.Data0825
 WHERE "ACCOUNT#" IN (SELECT Account FROM a);
-- ;
-- export results to Diff0825.csv;
-- create new database SCPADiff_08-25.db;
.open '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/SCPADiff_08-25.db'
-- import table Diff0825.csv;
.import '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/Diff0825.csv' Diff0825
-- add field at end DownloadDate;
ALTER TABLE Diff0825 ADD COLUMN DownloadDate REAL;
-- set all DownloadDate fields to '2021-08-25';
UPDATE Diff0825 
SET DownloadDate = DATE('2021-08-25');
--;
-- * DiffsToNVenAll - Integrate SC download differences into NVenAll.
-- *
-- * Entry DB and table dependencies.
-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory
-- *		NVenAll - SCPA property records
-- *	SCPADiff_08-25.db as db16,  Difference collection of new/updated
-- *	  property records between current and past SCPA downloads
-- *		Diffmmdd - table of differences new/updated SCPA records
-- *		  where either last sale date or homestead exemption field(s)
-- *		  have changed
-- *		DiffAccts (future) table of property ids and territory ids of
-- *		  parcels in Diff08md table
-- *
-- * Exit DB and table results.
-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory
-- *		NVenAll - records with new from Diff0825 replacing records
-- *		  where parcel ID (Account #) matches.
-- *
-- * Notes.;

-- * open junk as main, then open other dbs;
.open '$folderbase/Territories/DB-Dev/junk.db'

ATTACH '$folderbase/Territories'
||		'/DB-Dev/VeniceNTerritory.db' 
 AS db2;
--#SELECT tbl_name FROM db2.sqlite_master 
--# WHERE type is "table";
--#pragma db2.table_info(NVenAll);
 
ATTACH '$folderbase/Territories'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPADiff_08-25.db'
 AS db16;

WITH a AS (SELECT * FROM db16.Diffmmdd 
 WHERE "Account#" IN (SELECT Account FROM NVenAccts)
)
INSERT OR REPLACE INTO db2.NVenAll
SELECT
 "Account#", "Owner1", "Owner2",
 "Owner3", "MailingAddress 1", "MailingAddress 2",
 "MailingCity", "MailingState", "MailingZipCode",
 "MailingCountry", "SitusAddress(PropertyAddress)",
 "SitusCity", "SitusState", "SitusZipCode",
 "PropertyUseCode", Neighborhood, Subdivision,
 "TaxingDistrict", Municipality, "WaterfrontCode",
 "HomesteadExemption", "HomesteadExemptionGrantYear",
 Zoning, "ParcelDesc1", "ParcelDesc2", "ParcelDesc3",
 ParcelDesc4, "Pool(YESorNO)", TotalLivingUnits,
 "LandAreaS.F.", GrossBldgArea, LivingArea, Bedrooms,
 Baths, HalfBaths, YearBuilt, LastSaleAmount,
 "LastSasleDate", LastSaleQualCode, PriorSaleAmount,
 PriorSaleDate, PriorSaleQualCode, JustValue,
 AssessedValue, TaxableValue, LinktoPropertyDetailPage,
 ValueDataSource, ParcelCharacteristicsData, "Status",
 DownloadDate)
FROM db16.Diff0825;
.quit
-- ** END DiffsToNVenAll **********;

-- SCPADiff_08-25.db.DiffAccts setup;
delete from DiffAccts;
insert into DiffAccts
select "Account#", NULL from Diff0825;
-- sqlite3 < BuildDiffAcctsTbl.sql (projbase);
-- VeniceNTerritory.db.NVenAll;
-- SCPADiff_08-25.db.DiffAccts;
WITH a AS (SELECT PropID FROM DiffAccts
WHERE LENGTH(TERRID) = 0)
SELECT * FROM db2.NVENALL 
WHERE "ACCOUNT #" IN (SELECT PropID from A)
 and ("Property Use Code" IS "0100" 
  or "Property Use Code" IS '0101'
  or "property use code" IS '0403'
  or cast("total living units" AS int) > 0);
-- extract list of changed territories for use with UpdtAllSCBridge.sh;
.open SCPADiff_08-25.db
SELECT DISTINCT TERRID FROM DiffAccts
ORDER BY TERRID;
-- unassigned to territories(on Capture maps..);
-- 1623 Valley Dr; Waterford N of Edmondson, E of Capri Isles;
-- 112 Preserve PL, Nokomis; SW quadrant of Pinebrook & Edmondson;
-- 102 Calle Del Paradiso, 327 Rio Terra; in Amora on island S end of; 
--   intercoastal N of Bill Buck;

