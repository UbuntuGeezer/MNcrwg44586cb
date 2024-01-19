-- * open old download as db14;-- *	SCPA_06-30.db - as db14, SCPA (new) full download from date 06/30-- *		Data0731 - SCPA download records from date 06/30 in any year
-- Get differences between SCPA_06-30 and SCPA_07-31
-- * Modification History.
-- * ---------------------
-- * ??/??/??.	wmk.	original code.
-- * 5/26/22.	wmk.	bug fixes; *pathbase* implemented; VeniceNTerritory.db
-- *			 > Terr86777.db
.open $pathbase/DB-Dev/junk.db 
.cd '$pathbase'
.cd './RawData/SCPA/SCPA-Downloads' 

ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
AS db2;

ATTACH '$pathbase' 
 ||		'/RawData/SCPA/SCPA-Downloads' 
 ||		'/SCPA_06-30.db'
 AS db14; 

ATTACH '$pathbase' 
 ||		'/RawData/SCPA/SCPA-Downloads' 
 ||		'/SCPA_07-31.db' 
 AS db15; 
--
--junk.db, main
--db2.AcctsAll
--db14 SCPA0630
--db15 SCPA0731
drop table if exists DiffAccts0731;
create table DiffAccts0731
(Acct TEXT, PRIMARY KEY(Acct));
with a AS (SELECT "Account#" AS OAcct,
"LastSaleDate" AS OLastSale, 
"HomesteadExemption(YESorNO)" AS oHstead
FROM db14.Data0630)
INSERT OR IGNORE INTO DiffAccts0731 
SELECT "Account#" AS nAcct
from db15.Data0731
WHERE nAcct IN (SELECT oAcct FROM a
  WHERE (oAcct is nAcct
  AND oLastSale IS NOT "LASTSALEDATE")
  OR (oAcct IS nAcct
  AND oHstead IS NOT "HOMESTEADEXEMPTION(YESORNO)")
  );

--select count(acct) from DiffAccts0731;

WITH a AS (SELECT Account FROM db2.AcctsAll)
DELETE FROM DiffAccts0731
WHERE Acct NOT IN (SELECT account from a);

-- pragma database_list;

.headers ON
.output 'Diff0731.csv' 
.mode csv
.separator ,
--# these are the new/changed records...;
WITH a AS (SELECT Acct FROM DiffAccts0731)
SELECT * FROM db15.Data0731
WHERE "Account#" IN (SELECT Acct FROM a);

.open 'SCPADiff_07-31.db' 
DROP TABLE IF EXISTS Diff0731 ;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE Diff0731 ( "Account#" TEXT NOT NULL,
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
.import 'Diff0731.csv' Diff0731
-- follow up with UPDATE query to set DownloadDate field...;
.open 'SCPADiff_07-31.db'
DROP TABLE IF EXISTS Diff0731 ;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE Diff0731 ( "Account#" TEXT NOT NULL,
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
.import 'Diff0731.csv' Diff0731
.quit
*********** old code block *****************
--#
--#*********** old code block **********************************   
--#SELECT * FROM db15.Data0731 
--#   INNER JOIN db14.Data0630 
--#    ON db14.Data0630."Account#" = db15.Data0731."Account#" 
--#   INNER JOIN db2.AcctsAll 
--#    ON db15.Data0731."Account#" = db2.AcctsAll."Account" 
--#	WHERE db15.Data0731."LastSaleDate" 
--#    	<> db14.Data0630."LastSaleDate" 
--#	  OR db15.Data0731."HomesteadExemption(YESorNO)" 
--#	   <> db14.Data0630."HomesteadExemption(YESorNO)" 
--#	ORDER BY "Account#"; 
--#*********** end old code block **********************************   
--#
--# create new differences database with cleared table(s).
--#-- *	SCPADiff_07-31.db - as db16; Difference collection of new/updated
--#-- *	  property records between current and past SCPA downloads
--#-- *		Diff0731 - table of difference new/updated SCPA records
--#-- *		DiffAccts - table of property IDs and territory IDs affected

