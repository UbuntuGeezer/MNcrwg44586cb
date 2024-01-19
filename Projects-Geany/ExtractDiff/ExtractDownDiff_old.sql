-- ** Extract_DownDiff **********
-- *	4/27/22.	wmk.
-- *-----------------------------
-- *
-- * Extract_DownDiff - Extract sale-date homestead changed  records .
-- *
-- * entry DB and table dependencies.
-- *	SCPADiffm2d2.db - as main, new differences database to populate
-- *	SCPA_m1d1.db - as db14, SCPA (old) full download from date m1/d1/2020
-- *		Datam1d1 - SCPA download records from date m1/d1/2020
-- *	SCPA_m2d2.db - as db15, SCPA (new) full download from date m1/d1/2020
-- *		Datam2d2 - SCPA download records from date m2/d2/2020
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		AcctsNVen - table of property IDs in N Venice territory
-- *
-- * 	ENVIRONMENT var dependencies.
-- *    the following are set in the preamble.sh
-- *	folderbase = base path of host system for Territories
-- *	SCPA_DB1 = SCPA_m1-d1.db with m1 d1 substituted 
-- * 	SCPA_TBL1 = Datam1d1 with m1d1 substituted
-- *	SCPA_DB2 = SCPA_m2-d2.db with m2 d2 substituted
-- *	DIFF_DB = SCPADiff_m2-d2.db with m2 d2 substituted
-- *	DIFF_TBL = Diffm2d2 with m2 d2 substituted
-- *	M2D2 = "m2-d2" with m2 d2 substituted
-- *
-- * exit DB and table results.
-- *	SCPADiff_m2d2.db - as main populated with tables and records
-- *		Diffmmdd - table of new records that differ from previous
-- *		  download; date stamped with yyyy-m2-d2 in records
-- *		DiffAccts - (see BuildDiffAccts) reserved for recording
-- *		  account#s and territory IDs of affected territories
-- *		MissingParcels - (see BuildMissingParcels) reserved for
-- *		  recording full records of differences downloaded where
-- *		  parcel not in either PolyTerri/TerrProps or MultiMail/SplitProps
-- *		DNCNewOwners - (see BuildDNCNewOwners) reserved for
-- *		  recording full records of differences downloaded where
-- *		  where new download changes property info for parcels that
-- *		  are listed as DoNotCall in TerrIDData.db.
-- *		
-- *	junk.db as main, scratch database to catch changes
-- *		DownDiff (TEMP) - extracted sale-date-changed SCPA records
-- *
-- * Modification History.
-- * ---------------------
-- * 4/27/22.	wmk.	modified for general use; FL/SARA/86777; *pathbase*
-- *			 support.
-- * Legacy mods.
-- * 9/30/20.	wmk.	original query
-- * 12/3/20.	wmk.	modified to use generic SCPA_m1-d1.db as db14 for
-- *			 old SCPA full download, SCPA_m2-d2.db as db15 for
-- *			 new SCPA full download to facilitate conversion
-- *			 to QSCPADiff.sh shell script
-- * 2/3/21.	wmk.	comments updated; mod to use SCPA_m1d1.db as db14
-- *			 SCPA_m2d2.db as db15 as new name support; all
-- *			 dbs assumed in SCPA-Downloads folder
-- * 4/17/21.	wmk.	extracted from QSCPADiff.sql to ExtractDownDiff.sql
-- *			 and modified for use as shell query; references
-- *			 to SC download databases reformatted to match
-- *			 pattern SCPA_mm-dd.db; pragma references commented
-- *			 out; DownloadDate field eliminated from CREATE for
-- *			 new Diffm2d2 table, and added via ALTER TABLE 
-- *			 after loading difference records.
-- * 6/19/21.	wmk.	multihost support modifications.
-- * 7/22/21.	wmk.	temporary modification since m2d2 field names
-- *				 re trimmed (automatic import), but m1d1 field
-- *			 names are not...!!!
-- * 9/30/21.	wmk.	'Last Sale Date' corrected to 'LastSaleDate';
-- *			 'Homestead Exemption' corrected to
-- *			 'HomesteadExemption(YESorNO)'; compress all field
-- *			 names for consistency.
-- * 1/2/22.	wmk.	DownloadDate field included in CREATE.
-- * 2/7/22.	wmk.	db8, db14, db15 qualifiers added to INSERT query.
-- * 3/19/22.	wmk.	bug fixes throughout.
-- *
-- * Notes. This query differences 2 SCPA downloads into a new database
-- * SCPADiff_m2-d2.db with table Diffmmdd. The records in Diffmmdd are
-- * all those records in SCPA_m2-d2.db that differ from records in 
-- * SCPA_m1-d1.db.;

.cd '$pathbase/RawData/SCPA/SCPA-Downloads'
.open '$DIFF_DB'

ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AcctsNVen); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/$SCPA_DB1'
 AS db14;
--  SELECT tbl_name FROM db14.sqlite_master;
--  PRAGMA db14.table_info($SCPA_TBL1);
 
-- *	SCPA_m2d2.db - as db15, SCPA (new) full download from date m1/d1
-- *		Datam2d2 - SCPA download records from date m2/d2 any uear
ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/$SCPA_DB2'
 AS db15;
--  SELECT tbl_name FROM db15.sqlite_master;
--  PRAGMA db15.table_info($SCPA_TBL2);

-- create empty Diffm2d2 table in New database ...;
DROP TABLE IF EXISTS $DIFF_TBL;
CREATE TABLE "$DIFF_TBL"
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

-- with db8, db14, db15 attached, the following will insert the newer rows 
-- where Last Sale Date or Homestead Exemption changed;
INSERT OR IGNORE INTO $DIFF_TBL
 SELECT $SCPA_TBL2.* FROM db15.$SCPA_TBL2
   INNER JOIN db14.$SCPA_TBL1
    ON db15.$SCPA_TBL2."Account#" = db14.$SCPA_TBL1."Account#"
   INNER JOIN db8.AllAccts
    ON db15.$SCPA_TBL2."Account#" = db8.AllAccts."Account"
	WHERE db15.$SCPA_TBL2."LastSaleDate" <> db14.$SCPA_TBL1."LastSaleDate"
	    OR db15.$SCPA_TBL2."HomesteadExemption(YESORNO)"
	       <> db14.$SCPA_TBL1."HomesteadExemption(YESorNO)"
	ORDER BY db14.$SCPA_TBL1."Account#";

--ALTER TABLE $DIFF_TBL ADD COLUMN DownloadDate TEXT;
--UPDATE $DIFF_TBL
--SET DownloadDate = "2022-" || "$M2D2";
.quit
--*****************************************
with a AS (select "Account #" as PropID, 
 "last sale date" as LastSold, "Homestead Exemption" as HStead
 from nvenall)	
-- ** END Extract_DownDiff **********
WITH a AS (SELECT Account FROM AcctsNVen),
b AS (SELECT "Account#" AS Acct, LastSaleDate AS LastSold,
 "HomesteadExemption(YESORNO)" as Hstead FROM $SCPA_TBL1)
SELECT * FROM $SCPA_TBL2
 WHERE "Account#" IN (SELECT Account FROM a)
  AND "Account#" IN (SELECT Acct FROM b
   WHERE Hstead IS NOT "HomseteadExemption(YESORNO)"
    OR LastSold IS NOT "LastSaleDate");
WITH a AS (SELECT Account FROM d2b.NVenAccts),
b AS (SELECT "Account#" AS Acct, 
  LastSaleDate as LastSold, "HomesteadExemption(YESORNO)"
   AS Hstead from Data0825 
   WHERE Acct IN (SELECT Account FROM a))
Select * from Data0929 
 WHERE "ACCOUNT#" IN (SELECT Acct from b
  WHERE LastSold is not "LASTSALEDATE" 
   OR Hstead IS NOT "HOMESTEADEXEMPTION(YESORNO)");
