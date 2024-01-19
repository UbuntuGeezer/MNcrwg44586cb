-- Useful queries...
-- extracted from QSCPADiff.sh... 12/2/21;
with a AS (select "account #" as Acct, 
 cast(substr("last sale date",7,4) AS INTEGER)
  AS SaleYear,
 cast(substr("las)t sale date",1,2) AS INTEGER)
  as SaleMonth,
 cast(substr("last sale date",4,2) AS INTEGER)
  as SaleDay
 FROM NVenall limit 10);

 with a AS (select "account #" as Acct, 
 cast(substr("last sale date",7,4) AS INTEGER)
  AS SaleYear,
 cast(substr("las)t sale date",1,2) AS INTEGER)
  as SaleMonth,
 cast(substr("last sale date",4,2) AS INTEGER)
  as SaleDay
 FROM NVenall limit 10)
 select 
 case
 when cast(substr("lastsaledate",7,4) as integer) > 
  (SELECT SaleYear from a WHERE Acct 
   IS "aCCOUNT#")
  THEN (SELECT "ACCOUNT#" aS DiffAcct from Data1102)
ELSE ''
END AS SelAcct
;

  pragma Database_list;

-- * open databases;
pragma database_list;
./open 'SCPADiff_11-02.db'
attach '/media/ubuntu/Windows/Users/Bill/Territories/RawData/SCPA/SCPA-Downloads'
|| '/SCPA_11-02.db'
as db15;
attach '/media/ubuntu/Windows/Users/Bill/Territories'
|| '/DB-Dev/VeniceNTerritory.db'
as db2;
-- * create DiffAccts;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts
(DiffAcct TEXT,
 DiffHstead TEXT,
 DiffYr TEXT,
 DiffMo TEXT,
 DiffDa TEXT,
 DelFlag INTEGER DEFAULT 1,
 PRIMARY KEY(DiffAcct) );
-- * populate DiffAccts;
INSERT INTO DiffAccts
WITH a AS (SELECT Account FROM NVenAccts)
SELECT "ACCOUNT#" AS PropID,
 "homesteadexemption(yesorno)" AS DiffAcct,
 cast(substr("lastsaledate",7,4) AS INTEGER)
 AS DiffYr,
 cast(substr("lastsaledate",1,2) AS INTEGER)
 AS DiffMo,
 cast(substr("lastsaledate",4,2) AS INTEGER)
 AS DiffDa, 1 AS DelFlag
 FROM db15.Data1102
 WHERE PropID IN (SELECT Account FROM A)
 limit 10;
-- * select same fields from NVenAll;
SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM NVenAll
  limit 10;
 -- * undelete changed homesteads;
 WITH a AS (SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM NVenAll
 )
  UPDATE DiffAccts
  SET DelFlag = 0
  WHERE DiffYr = 2021
  AND DiffHStead IS NOT (SELECT OldHstead FROM A
   WHERE Acct IS DiffAcct);
   
-- * undelete changed sale dates;
WITH a AS (SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM NVenAll
 )
  UPDATE DiffAccts
  SET DelFlag = 0
  WHERE DiffYr = 2021
  AND (DiffYr IS NOT (SELECT OldYr FROM A
   WHERE Acct IS DiffAcct)
   OR DiffMo IS NOT (SELECT OldMo FROM a
   WHERE Acct IS DiffAcct)
   OR DiffDa IS NOT (SELECT OldDa FROM a
   WHERE Acct IS NOT DiffAcct)
   ;

-- * this is an informational query;
-- * run query to compare columns side-by-side;
WITH a AS (SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM NVenAll
)
select * from DiffAccts
inner join a
on Acct = DiffAcct
where delflag =0;

 -- * undelete changed homesteads;
 WITH a AS (SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM NVenAll
 )
  UPDATE DiffAccts
  SET DelFlag = 0
  WHERE DiffHStead IS NOT (SELECT OldHstead FROM A
   WHERE Acct IS DiffAcct);

-- * Add difference records into Diff1102;
attach '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/RawData/SCPA/SCPA-Downloads'
 || '/SCPA_11-02.db'
 AS db15;
ALTER TABLE Diff1102 ADD Column DownloadDate TEXT;
 WITH a AS (SELECT DiffAcct FROM DiffAccts
  WHERE DelFlag = 0)
INSERT INTO Diff1102
select * from db15.Data1102
where "Account#" in
 (select DiffAcct FROM a); -- * update NVenAll;
WITH a AS Select DiffAcct FROM DiffActs
WHERE DelFlag = 0)
INSERT OR REPLACE INTO NVenAll
SELECT * FROM Data1102
WHERE "Account#" IN (SELECT DiffAcct from a);

-- * Update NVenAll from Diff1102;
.open '/media/ubuntu/Windows/Users/Bill/Territories/RawData/SCPA/SCPA-Downloads/SCPADiff_11_02.db'
attach '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/DB-Dev/VeniceNTerritory.db'
 AS db2;
WITH a AS (SELECT * FROM Diff1102)
INSERT OR REPLACE INTO db2.NVenAll
SELECT * FROM a;

-- * add DownloadDate column to Data1102;
ALTER TABLE db15.Data1102 ADD COLUMN DownloadDate;
UPDATE db15.Data1102
SET DownloadDate = "2021-11-02";

-- * query accounts, last sale date fields Datammdd;
.open 'SCPA_11-02.db'
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/DB-Dev/VeniceNTerritory.db'
 AS db2;
WITH c AS (SELECT Account FROM db2.NVenAccts)
SELECT "Account#" as PropID,
cast(substr(lastsaledate,7.4) AS INTEGER) AS SaleYear,
cast(substr(lastsaledate,1.2) AS INTEGER) AS SaleMonth,
cast(substr(lastsaledate,4.2) AS INTEGER) AS SaleDay
FROM Data1102
WHERE SaleYear > 0
 AND bPropID in (select Account from c)
LIMIT 10;

-- * query accounts, last sale date fields NVenAll;
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/DB-Dev/VeniceNTerritory.db'
 AS db2;
WITH b AS (SELECT "Account #" as bPropID,
cast(substr("last sale date",7.4) AS INTEGER)
 AS PrevYear,
cast(substr("last sale date",1.2) AS INTEGER)
 AS PrevMonth,
cast(substr("last sale date",4.2) AS INTEGER)
 AS PrevDay
FROM NVenAll
WHERE PrevYear > 0)

--LIMIT 10;

--*************************************************************

ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/SCPA/SCPA-Downloads/SCPADiff_11-02.db'
 AS db19;
DROP TABLE IF EXISTS Diff1102;
CREATE TABLE Diff1102 
( "Account#" TEXT, Owner1 TEXT, Owner2 TEXT,
 Owner3 TEXT, MailingAddress1 TEXT, MailingAddress2 TEXT,
 MailingCity TEXT, MailingState TEXT,
 MailingZipCode TEXT, MailingCountry TEXT, 
 "SitusAddress(PropertyAddress)" TEXT, SitusCity TEXT, 
 SitusState TEXT, SitusZipCode TEXT, PropertyUseCode TEXT, 
 Neighborhood TEXT, Subdivision TEXT, TaxingDistrict TEXT, 
 Municipality TEXT, WaterfrontCode TEXT, 
 "HomesteadExemption(YESorNO)" TEXT, 
 HomesteadExemptionGrantYear TEXT, Zoning TEXT, 
 ParcelDesc1 TEXT, ParcelDesc2 TEXT, ParcelDesc3 TEXT, 
 ParcelDesc4 TEXT, "Pool(YESorNO)" TEXT, TotalLivingUnits TEXT, 
 "LandAreaS.F." TEXT, GrossBldgArea TEXT, LivingArea TEXT, 
 Bedrooms TEXT, Baths TEXT, HalfBaths TEXT, 
 YearBuilt TEXT, LastSaleAmount TEXT, LastSaleDate TEXT, 
 LastSaleQualCode TEXT, PriorSaleAmount TEXT, 
 PriorSaleDate TEXT, PriorSaleQualCode TEXT, 
 JustValue TEXT, AssessedValue TEXT, 
 TaxableValue TEXT, LinktoPropertyDetailPage TEXT, 
 ValueDataSource TEXT,  ParcelCharacteristicsData TEXT, 
 Status TEXT);

.open 'VeniceNTerritory'
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/SCPA/SCPA-Downloads/SCPA_11-02.db'
 AS db15;
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/SCPA/SCPA-Downloads/SCPADiff_11-02.db'
 AS db19;
WITH a AS (SELECT "ACCOUNT#" AS PropID,
 cast(substr("lastsaledate",7,4) AS INTEGER) AS SaleYear
 FROM db15.Data1102)
INSERT INTO db19.Diff1102
CASE 
WHEN --PrevYear
CAST(SUBSTR("LAST SALE DATE",7,4) AS INTEGER)
 < (SELECT SaleYear FROM a
 WHERE PropID is "ACCOUNT #")
 THEN (SELECT * FROM db15.Data1102
  WHERE "Account#" is "ACCOUNT #");
 
 -- * QUERY Limited to sale year - 2021, month = 10; 
WITH a AS (SELECT Account FROM NVenAccts)
SELECT "ACCOUNT#" AS PropID,
 cast(substr("lastsaledate",7,4) AS INTEGER)
 AS SaleYear,
 cast(substr("lastsaledate",1,2) AS INTEGER)
 AS SaleMonth,
 cast(substr("lastsaledate",4,2) AS INTEGER)
 AS SaleDay
 FROM db15.Data1102
 WHERE PropID IN (SELECT Account FROM A)
  AND SaleYear = 2021
  AND SaleMonth = 10;

DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts
(DiffAcct TEXT,
 DiffHstead TEXT,
 DiffYr TEXT,
 DiffMo TEXT,
 DiffDa TEXT,
 DelFlag INTEGER DEFAULT 1,
 PRIMARY KEY(DiffAcct) );
  
WITH a AS (SELECT Account FROM NVenAccts)
SELECT "ACCOUNT#" AS PropID,
 "homesteadexepmtion(yesorno)" AS DiffAcct
 cast(substr("lastsaledate",7,4) AS INTEGER)
 AS DiffYr,
 cast(substr("lastsaledate",1,2) AS INTEGER)
 AS DiffMo,
 cast(substr("lastsaledate",4,2) AS INTEGER)
 AS DiffDa
 FROM db15.Data1102
 WHERE PropID IN (SELECT Account FROM A);
  AND SaleYear = 2021
  AND SaleMonth = 10;
