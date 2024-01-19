--difftest.sql
-- .open 'SCPA_0205.db'
-- attach 'Terr86777.db ' as db2;

create temp table ChangeKeys
(PropID text, LastSold text, Hstead text,
primary key (PropID));

insert into ChangeKeys
select "account#",
"lastsaledate", "homestead(yesorno)"
from Data0205;

create temp table OldKeys
(PropID text, LastSold text, Hstead text,
primary key (PropID));

-- attach 'Terr86777.db' as db2;
insert into OldKeys
select "account #",
"last sale date", "homestead exemption"
from db2.nvenall;

with a as (select * from OldKeys)
select * from ChangeKeys
 where PropID in (select propid from OldKeys 
  where lastsold is not changekeys.lastsold);

--************************************************;
--the following query is golden for db14.SCPA_01-02.db,
-- db15.SCPA_02-05.db, db8.AuxSCPAData.db with SCPADiff_02-05.db as main;
INSERT OR IGNORE INTO Diff0205
 SELECT Data0205.* FROM db15.Data0205
   INNER JOIN db14.Data0102
    ON db15.Data0205."Account#" = db14.Data0102."Account#"
   INNER JOIN db8.AcctsNVen
    ON db15.Data0205."Account#" = db8.AcctsNVen."Account"
	WHERE db15.Data0205."LastSaleDate" <> db14.Data0102."LastSaleDate"
	    OR db15.Data0205."HomesteadExemption(YESORNO)"
	       <> db14.Data0102."HomesteadExemption(YESorNO)"
	ORDER BY db14.Data0102."Account#";
--**********************************************************;
with a as (select PropID from DiffAccts 
 where length(TErrID) = 0)
select "Account #" As Acct, "property Use code" as UseType
from Terr86777
where Acct in (select PropID from a);
--********************************************************;
-- * difference 04-26 with 02-25 since 03-19 is corrupted
-- with db8, db14, db15 attached, the following will insert the newer rows 
-- where Last Sale Date or Homestead Exemption changed;
--**** open/attach databases...
.open 'SCPADidf_04-26.db'
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AcctsNVen); 
detach db14;
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_02-05.db'
 AS db14;
--  SELECT tbl_name FROM db14.sqlite_master;
--  PRAGMA db14.table_info($SCPA_TBL1);
 
-- *	SCPA_m2d2.db - as db15, SCPA (new) full download from date m1/d1
-- *		Datam2d2 - SCPA download records from date m2/d2 any uear
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_04-26.db'
 AS db15;
--  SELECT tbl_name FROM db15.sqlite_master;
--  PRAGMA db15.table_info($SCPA_TBL2);

-- create empty Diffm2d2 table in New database ...;
DROP TABLE IF EXISTS Diff0426;
CREATE TABLE Diff0426
 ( "Account#" TEXT NOT NULL, 
 "Owner1" TEXT, "Owner2" TEXT, "Owner3" TEXT, 
 "MailingAddress1" TEXT, "MailingAddress2" TEXT, 
 "MailingCity" TEXT, "MailingState" TEXT, 
 "MailingZipCode" TEXT, "MailingCountry" TEXT,
 "SitusAddress(PropertyAddress)" TEXT,
 "SitusCity" TEXT, "SitusState" TEXT, "SitusZipCode" TEXT, 
 "PropertyUseCode" TEXT, "Neighborhood" TEXT, 
 "Subdivision" TEXT, "TaxingDistrict" TEXT, 
 "Municipality" TEXT, "WaterfrontCode" TEXT, 
 "HomesteadExemption" TEXT, 
 "HomesteadExemptionGrantYear" TEXT, 
 "Zoning" TEXT, "ParcelDesc1" TEXT, "ParcelDesc2" TEXT, 
 "ParcelDesc3" TEXT, "ParcelDesc4" TEXT, 
 "Pool(YESorNO)" TEXT, "TotalLivingUnits" TEXT, 
 "LandAreaS.F." TEXT, "GrossBldgArea" TEXT, 
 "LivingArea" TEXT, "Bedrooms" TEXT, "Baths" TEXT, 
 "HalfBaths" TEXT, "YearBuilt" TEXT, 
 "LastSaleAmount" TEXT, 
 "LastSaleDate" TEXT, "LastSaleQualCode" TEXT, 
 "PriorSaleAmount" TEXT, "PriorSaleDate" TEXT, 
 "PriorSaleQualCode" TEXT, "JustValue" TEXT, 
 "AssessedValue" TEXT, "TaxableValue" TEXT, 
 "LinktoPropertyDetailPage" TEXT, 
 "ValueDataSource" TEXT, 
 "ParcelCharacteristicsData" TEXT, "Status" TEXT,
 DownloadDate TEXT,
  PRIMARY KEY("Account#") );

  pragma database_list;
  detach db15;
--******* now extract the differences;
INSERT OR IGNORE INTO Diff0426
 SELECT Data0426.* FROM db15.Data0426
   INNER JOIN db14.Data0205
    ON db15.Data0426."Account#" = db14.Data0205."Account#"
   INNER JOIN db8.AcctsNVen
    ON db15.Data0426."Account#" = db8.AcctsNVen."Account"
	WHERE db15.Data0426."LastSaleDate" <> db14.Data0205."LastSaleDate"
	    OR db15.Data0426."HomesteadExemption(YESORNO)"
	       <> db14.Data0205."HomesteadExemption(YESorNO)"
	ORDER BY db14.Data0205."Account#";

--ALTER TABLE $DIFF_TBL ADD COLUMN DownloadDate TEXT;
--UPDATE $DIFF_TBL
--SET DownloadDate = "2022-" || "$04-26";

-- * extract changed territory list from DiffAccts table;
select distinct TerrId FROM DiffAccts
WHERE LENGTH(TERRID) > 0
ORDER BY TERRID;
