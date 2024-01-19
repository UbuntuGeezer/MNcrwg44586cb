-- QSCPADiff.psq/sql - Get differences between SCPA_04-04 and SCPA_05-28
-- * Modification History.
-- * ---------------------
-- * 11/27/22.	wmk.	CB update; comments tidied.
-- * Legacy mods.
-- * ??/??/??.	wmk.	original code.
-- * 5/26/22.	wmk.	bug fixes; *pathbase* implemented; VeniceNTerritory.db
-- *			 > Terr86777.db
-- * Notes. DoSed edits m 1  d 1, m 2 d 2 to old and new download month/day.
-- * open old download as db14;
-- *	SCPA_04-04.db - as db14, SCPA (new) full download from date 04/04
-- *		Data0528 - SCPA download records from date 04/04 in any year
-- *;
.open $pathbase/DB-Dev/junk.db 
.cd '$pathbase'
.cd './RawData/SCPA/SCPA-Downloads' 

ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
AS db2;

ATTACH '$pathbase' 
 ||		'/RawData/SCPA/SCPA-Downloads' 
 ||		'/SCPA_04-04.db'
 AS db14; 

ATTACH '$pathbase' 
 ||		'/RawData/SCPA/SCPA-Downloads' 
 ||		'/SCPA_05-28.db' 
 AS db15; 
--
--junk.db, main
--db2.AcctsAll
--db14 SCPA0404
--db15 SCPA0528
drop table if exists DiffAccts0528;
create table DiffAccts0528
(Acct TEXT, PRIMARY KEY(Acct));
with a AS (SELECT "Account#" AS OAcct,
"LastSaleDate" AS OLastSale, 
"HomesteadExemption(YESorNO)" AS oHstead
FROM db14.Data0404)
INSERT OR IGNORE INTO DiffAccts0528 
SELECT "Account#" AS nAcct
from db15.Data0528
WHERE nAcct IN (SELECT oAcct FROM a
  WHERE (oAcct is nAcct
  AND oLastSale IS NOT "LASTSALEDATE")
  OR (oAcct IS nAcct
  AND oHstead IS NOT "HOMESTEADEXEMPTION(YESORNO)")
  );

--select count(acct) from DiffAccts0528;

WITH a AS (SELECT Account FROM db2.AcctsAll)
DELETE FROM DiffAccts0528
WHERE Acct NOT IN (SELECT account from a);

-- pragma database_list;

.headers ON
.output 'Diff0528.csv' 
.mode csv
.separator ,
--# these are the new/changed records...;
WITH a AS (SELECT Acct FROM DiffAccts0528)
SELECT * FROM db15.Data0528
WHERE "Account#" IN (SELECT Acct FROM a);

.open 'SCPADiff_05-28.db' 
DROP TABLE IF EXISTS Diff0528 ;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE Diff0528 ( "Account#" TEXT NOT NULL,
 "Owner1" TEXT, "Owner2" TEXT, "Owner3" TEXT,
 "MailingAddress1" TEXT, "MailingAddress2" TEXT,
 "MailingCity" TEXT, "MailingState" TEXT,
 "MailingZipCode" TEXT, "MailingCountry" TEXT,
 "SitusAddress(PropertyAddress)" TEXT,
 "SitusCity" TEXT, "SitusState" TEXT,
 "SitusZipCode" TEXT, "PropertyUseCode" TEXT,
 "Neighborhood" TEXT, "Subdivision" TEXT,
 "TaxingDistrict" TEXT, "Municipality" TEXT,
 "WaterfrontCode" TEXT, "HomesteadExemption(YESorNO)" TEXT,
 "HomesteadExemptionGrantYear" TEXT, "Zoning" TEXT,
 "ParcelDesc1" TEXT, "ParcelDesc2" TEXT,
 "ParcelDesc3" TEXT, "ParcelDesc4" TEXT,
 "Pool(YESorNO)" TEXT, "TotalLivingUnits" TEXT,
 "LandAreaS.F." TEXT, "GrossBldgArea" TEXT,
 "LivingArea" TEXT, "Bedrooms" TEXT, "Baths" TEXT,
 "HalfBaths" TEXT, "YearBuilt" TEXT,
 "LastSaleAmount" TEXT, "LastSaleDate" TEXT,
 "LastSaleQualCode" TEXT, "PriorSaleAmount" TEXT,
 "PriorSaleDate" TEXT, "PriorSaleQualCode" TEXT,
 "JustValue" TEXT, "AssessedValue" TEXT,
 "TaxableValue" TEXT,
 "LinktoPropertyDetailPage" TEXT,
 "ValueDataSource" TEXT,
 "ParcelCharacteristicsData" TEXT,
 "Status" TEXT, "DownloadDate" TEXT,
 PRIMARY KEY("Account#") )
;
.import 'Diff0528.csv' Diff0528
-- follow up with UPDATE query to set DownloadDate field...;
.open 'SCPADiff_05-28.db'
DROP TABLE IF EXISTS Diff0528 ;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE Diff0528 ( "Account#" TEXT NOT NULL,
 "Owner1" TEXT, "Owner2" TEXT, "Owner3" TEXT,
 "MailingAddress1" TEXT, "MailingAddress2" TEXT,
 "MailingCity" TEXT, "MailingState" TEXT,
 "MailingZipCode" TEXT, "MailingCountry" TEXT,
 "SitusAddress(PropertyAddress)" TEXT,
 "SitusCity" TEXT, "SitusState" TEXT,
 "SitusZipCode" TEXT, "PropertyUseCode" TEXT,
 "Neighborhood" TEXT, "Subdivision" TEXT,
 "TaxingDistrict" TEXT, "Municipality" TEXT,
 "WaterfrontCode" TEXT, "HomesteadExemption(YESorNO)" TEXT,
 "HomesteadExemptionGrantYear" TEXT, "Zoning" TEXT,
 "ParcelDesc1" TEXT, "ParcelDesc2" TEXT,
 "ParcelDesc3" TEXT, "ParcelDesc4" TEXT,
 "Pool(YESorNO)" TEXT, "TotalLivingUnits" TEXT,
 "LandAreaS.F." TEXT, "GrossBldgArea" TEXT,
 "LivingArea" TEXT, "Bedrooms" TEXT, "Baths" TEXT,
 "HalfBaths" TEXT, "YearBuilt" TEXT,
 "LastSaleAmount" TEXT, "LastSaleDate" TEXT,
 "LastSaleQualCode" TEXT, "PriorSaleAmount" TEXT,
 "PriorSaleDate" TEXT, "PriorSaleQualCode" TEXT,
 "JustValue" TEXT, "AssessedValue" TEXT,
 "TaxableValue" TEXT,
 "LinktoPropertyDetailPage" TEXT,
 "ValueDataSource" TEXT,
 "ParcelCharacteristicsData" TEXT,
 "Status" TEXT, "DownloadDate" TEXT,
 PRIMARY KEY("Account#") )
;
.import 'Diff0528.csv' Diff0528
.quit
*********** old code block *****************
--#
--#*********** old code block **********************************   
--#SELECT * FROM db15.Data0528 
--#   INNER JOIN db14.Data0404 
--#    ON db14.Data0404."Account#" = db15.Data0528."Account#" 
--#   INNER JOIN db2.AcctsAll 
--#    ON db15.Data0528."Account#" = db2.AcctsAll."Account" 
--#	WHERE db15.Data0528."LastSaleDate" 
--#    	<> db14.Data0404."LastSaleDate" 
--#	  OR db15.Data0528."HomesteadExemption(YESorNO)" 
--#	   <> db14.Data0404."HomesteadExemption(YESorNO)" 
--#	ORDER BY "Account#"; 
--#*********** end old code block **********************************   
--#
--# create new differences database with cleared table(s).
--#-- *	SCPADiff_05-28.db - as db16; Difference collection of new/updated
--#-- *	  property records between current and past SCPA downloads
--#-- *		Diff0528 - table of difference new/updated SCPA records
--#-- *		DiffAccts - table of property IDs and territory IDs affected

