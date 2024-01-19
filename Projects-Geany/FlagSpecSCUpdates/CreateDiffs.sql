-- * CreateDiffs.psq - create Special differences table for updating WhitePineTreeRd.db.db
-- * 1/31/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/31/23.	wmk.	original code.
-- *
-- * Notes. CreateDiffs.psq is edited by *sed to set the spec-db database name
-- * in the query code. spec-db.db has the DiffSpec table added which contains
-- * the newest Terr86777 records for the special database.
-- *;
.open '$pathbase/$scpath/Special/WhitePineTreeRd.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
ATTACH '$pathbase/$scpath/Special/SpecialDBs.db'
 AS db19;
DROP TABLE IF EXISTS DiffSpec;
CREATE TABLE DiffSpec ( 
 "Account#" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT, MailingAddress1 TEXT,
  MailingAddress2 TEXT, MailingCity TEXT, MailingState TEXT, MailingZipCode TEXT,
  MailingCountry TEXT, "SitusAddress(PropertyAddress)" TEXT, SitusCity TEXT,
  SitusState TEXT, SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT,
  Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, WaterfrontCode TEXT,
  "HomesteadExemption(YESorNO)" TEXT, HomesteadExemptionGrantYear TEXT, 
  Zoning TEXT, ParcelDesc1 TEXT, ParcelDesc2 TEXT, ParcelDesc3 TEXT, 
  ParcelDesc4 TEXT, "Pool(YESorNO)" TEXT, TotalLivingUnits TEXT, 
  "LandAreaS.F." TEXT, GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, 
  Baths TEXT, HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, 
  LastSaleDate TEXT, LastSaleQualCode TEXT, PriorSaleAmount TEXT, 
  PriorSaleDate TEXT, PriorSaleQualCode TEXT, JustValue TEXT, 
  AssessedValue TEXT, TaxableValue TEXT, LinktoPropertyDetailPage TEXT, 
  ValueDataSource TEXT, ParcelCharacteristicsData TEXT, Status TEXT, 
  DownloadDate TEXT,
   PRIMARY KEY ("Account#") );
WITH a AS (SELECT * FROM db19.OutOfDates)
INSERT INTO DiffSpec
SELECT * FROM db2.Terr86777
WHERE "Account #" IN (SELECT PropID FROM a
  WHERE DBNAME IS "WhitePineTreeRd.db");
