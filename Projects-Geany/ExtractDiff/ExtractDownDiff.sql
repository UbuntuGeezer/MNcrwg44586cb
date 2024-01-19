-- ** ExtractDownDiff **********
-- *	5/1/22.	wmk.
-- *-----------------------------
-- *
-- * Extract_DownDiff - Extract sale-date homestead changed  records .
-- *
-- * entry DB and table dependencies.
-- *	SCPADiff0404.db - as main, new differences database to populate
-- *	SCPA_0113.db - as db14, SCPA (old) full download from date 01/13/2010
-- *		Data0113 - SCPA download records from date 01/13/2010
-- *	SCPA_0404.db - as db15, SCPA (new) full download from date 01/13/2010
-- *		Data0404 - SCPA download records from date 04/04/2010
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		AcctsNVen - table of property IDs in N Venice territory
-- *
-- * 	ENVIRONMENT var dependencies.
-- *    the following are set in the preamble.sh
-- *	folderbase = base path of host system for Territories
-- *	SCPA_DB1 = SCPA_01-13.db with 01 13 substituted 
-- * 	SCPA_TBL1 = Data0113 with 0113 substituted
-- *	SCPA_DB2 = SCPA_04-04.db with 04 04 substituted
-- *	DIFF_DB = SCPADiff_04-04.db with 04 04 substituted
-- *	DIFF_TBL = Diff0404 with 04 04 substituted
-- *	M2D2 = "04-04" with 04 04 substituted
-- *
-- * exit DB and table results.
-- *	SCPADiff_0404.db - as main populated with tables and records
-- *		Diffmmdd - table of new records that differ from previous
-- *		  download; date stamped with yyyy-04-04 in records
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
-- * 5/1/22.	wmk.	modified to use Terr86777.db/AllAccts in place
-- *			 of AuxSCPAData/NVenAccts; INNER JOIN code reinstated.
-- * 4/26/22.	wmk.	completed .sql ExtractDownDiff0404.sql migrated
-- *			 into /86777/..ExtractDiff project.
-- * Legacy mods.
-- * 9/30/20.	wmk.	original query.
-- * 12/3/20.	wmk.	modified to use generic SCPA_01-13.db as db14 for
-- *			 old SCPA full download, SCPA_04-04.db as db15 for
-- *			 new SCPA full download to facilitate conversion
-- *			 to QSCPADiff.sh shell script
-- * 2/3/21.	wmk.	comments updated; mod to use SCPA_0113.db as db14
-- *			 SCPA_0404.db as db15 as new name support; all
-- *			 dbs assumed in SCPA-Downloads folder
-- * 4/17/21.	wmk.	extracted from QSCPADiff.sql to ExtractDownDiff.sql
-- *			 and modified for use as shell query; references
-- *			 to SC download databases reformatted to match
-- *			 pattern SCPA_mm-dd.db; pragma references commented
-- *			 out; DownloadDate field eliminated from CREATE for
-- *			 new Diff0404 table, and added via ALTER TABLE 
-- *			 after loading difference records.
-- * 6/19/21.	wmk.	multihost support modifications.
-- * 7/22/21.	wmk.	temporary modification since 0404 field names
-- *				 re trimmed (automatic import), but 0113 field
-- *			 names are not...!!!
-- * 9/30/21.	wmk.	'Last Sale Date' corrected to 'LastSaleDate';
-- *			 'Homestead Exemption' corrected to
-- *			 'HomesteadExemption(YESorNO)'; compress all field
-- *			 names for consistency.
-- * 1/2/22.	wmk.	DownloadDate field included in CREATE.
-- * 2/7/22.	wmk.	db8, db14, db15 qualifiers added to INSERT query.
-- * 3/19/22.	wmk.	manually edited for SCPA_03-19.db, SCPA_04-04.db
-- *			 Data0319, Data0404.
-- *
-- * Notes. This query differences 2 SCPA downloads into a new database
-- * SCPADiff_04-04.db with table Diffmmdd. The records in Diffmmdd are
-- * all those records in SCPA_04-04.db that differ from records in 
-- * SCPA_01-13.db.;

.cd '$pathbase/RawData/SCPA/SCPA-Downloads'
.open 'SCPADiff_04-04.db'
.shell echo "Differencing SCPA_01-13.db with SCPA_04-04.db..may take a few minutes"
ATTACH '$pathbase'
 ||		'/DB-Dev/Terr86777.db'
  AS db2;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db2.table_info(AllAccts); 

ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AcctsAll); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_01-13.db'
 AS db14;
--  SELECT tbl_name FROM db14.sqlite_master;
--  PRAGMA db14.table_info($SCPA_TBL1);
 
-- *	SCPA_0404.db - as db15, SCPA (new) full download from date 01/13
-- *		Data0404 - SCPA download records from date 04/04 any uear
ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_04-04.db'
 AS db15;
--  SELECT tbl_name FROM db15.sqlite_master;
--  PRAGMA db15.table_info($SCPA_TBL2);

-- create empty Diff0404 table in New database ...;
DROP TABLE IF EXISTS Diff0404;
CREATE TABLE Diff0404
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
INSERT OR IGNORE INTO Diff0404
 SELECT Data0404.* FROM db15.Data0404
   INNER JOIN db14.Data0113
    ON db15.Data0404."Account#" = db14.Data0113."Account#"
   INNER JOIN db8.AcctsAll
    ON db15.Data0404."Account#" = db8.AcctsAll.Account
	WHERE db15.Data0404."LastSaleDate" <> db14.Data0113."LastSaleDate"
	    OR db15.Data0404."HomesteadExemption(YESORNO)"
	       <> db14.Data0113."HomesteadExemption(YESorNO)"
	ORDER BY db14.Data0113."Account#";

--ALTER TABLE $DIFF_TBL ADD COLUMN DownloadDate TEXT;
--UPDATE $DIFF_TBL
--SET DownloadDate = "2022-" || "$04-26";
.quit
