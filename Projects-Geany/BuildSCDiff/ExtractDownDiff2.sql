-- ** Extract_DownDiff **********
-- *	4/17/21.	wmk.
-- *-----------------------------
-- *
-- * Extract_DownDiff - Extract sale-date homestead changed  records .
-- *
-- * entry DB and table dependencies.
-- *	SCPADiff0416.db - as main, new differences database to populate
-- *	SCPA_0227.db - as db14, SCPA (old) full download from date 02/27/2020
-- *		Data0227 - SCPA download records from date 02/27/2020
-- *	SCPA_0416.db - as db15, SCPA (new) full download from date 02/27/2020
-- *		Data0416 - SCPA download records from date 04/16/2020
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		AcctsNVen - table of property IDs in N Venice territory
-- *
-- * exit DB and table results.
-- *	SCPADiff_0416.db - as main populated with tables and records
-- *		Diffmmdd - table of new records that differ from previous
-- *		  download; date stamped with yyyy-04-16 in records
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
-- * 9/30/20.	wmk.	original query
-- * 12/3/20.	wmk.	modified to use generic SCPA_02-27.db as db14 for
-- *					old SCPA full download, SCPA_04-16.db as db15 for
-- *					new SCPA full download to facilitate conversion
-- *					to QSCPADiff.sh shell script
-- * 2/3/21.	wmk.	comments updated; mod to use SCPA_0227.db as db14
-- *					SCPA_0416.db as db15 as new name support; all
-- *					dbs assumed in SCPA-Downloads folder
-- * 4/17/21.	wmk.	extracted from QSCPADiff.sql to ExtractDownDiff.sql
-- *					and modified for use as shell query; references
-- *					to SC download databases reformatted to match
-- *					pattern SCPA_mm-dd.db; pragma references commented
-- *					out; DownloadDate field eliminated from CREATE for
-- *					new Diff0416 table, and added via ALTER TABLE 
-- *					after loading difference records.
-- *
-- * Notes. This query differences 2 SCPA downloads into a new database
-- * SCPADiff_04-16.db with table Diffmmdd. The records in Diffmmdd are
-- * all those records in SCPA_04-16.db that differ from records in 
-- * SCPA_02-27.db.

.cd '/media/ubuntu/Windows/Users/Bill/Territories/RawData/SCPA/SCPA-Downloads'
.open 'SCPADiff_04-16.db'

ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AcctsNVen); 

ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_02-27.db'
 AS db14;
--  SELECT tbl_name FROM db14.sqlite_master;
--  PRAGMA db14.table_info(Data0227);
 
-- *	SCPA_0416.db - as db15, SCPA (new) full download from date 02/27
-- *		Data0416 - SCPA download records from date 04/16 any uear
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_04-16.db'
 AS db15;
--  SELECT tbl_name FROM db15.sqlite_master;
--  PRAGMA db15.table_info(Data0416);


-- create empty Diff0416 table in New database ...
DROP TABLE IF EXISTS Diff0416;
CREATE TEMP TABLE "Diff0416"
 ( "Account #" TEXT NOT NULL, "Owner 1" TEXT, "Owner 2" TEXT,
 "Owner 3" TEXT, "Mailing Address 1" TEXT, "Mailing Address 2" TEXT, "Mailing City" TEXT,
 "Mailing State" TEXT, "Mailing Zip Code" TEXT, "Mailing Country" TEXT,
 "Situs Address (Property Address)" TEXT, "Situs City" TEXT, "Situs State" TEXT,
 "Situs Zip Code" TEXT, "Property Use Code" TEXT, "Neighborhood" TEXT, "Subdivision" TEXT,
 "Taxing District" TEXT, "Municipality" TEXT, "Waterfront Code" TEXT,
 "Homestead Exemption" TEXT, "Homestead Exemption Grant Year" TEXT, "Zoning" TEXT,
 "Parcel Desc 1" TEXT, "Parcel Desc 2" TEXT, "Parcel Desc 3" TEXT, "Parcel Desc 4" TEXT,
 "Pool (YES or NO)" TEXT, "Total Living Units" TEXT, "Land Area S. F." TEXT,
 "Gross Bldg Area" TEXT, "Living Area" TEXT, "Bedrooms" TEXT, "Baths" TEXT,
 "Half Baths" TEXT, "Year Built" TEXT, "Last Sale Amount" TEXT, "Last Sale Date" TEXT,
 "Last Sale Qual Code" TEXT, "Prior Sale Amount" TEXT, "Prior Sale Date" TEXT,
 "Prior Sale Qual Code" TEXT, "Just Value" TEXT, "Assessed Value" TEXT,
 "Taxable Value" TEXT, "Link to Property Detail Page" TEXT, "Value Data Source" TEXT,
 "Parcel Characteristics Data" TEXT, "Status" TEXT,
 PRIMARY KEY("Account #") );

-- with db1, db2, db3 attached, the following will insert the newer rows 
-- where Last Sale Date or Homestead Exemption changed;
INSERT OR IGNORE INTO Diff0416
 SELECT Data0416.* FROM Data0416
   INNER JOIN Data0227
    ON Data0416."Account #" = Data0227."Account #"
   INNER JOIN AcctsNVen
    ON Data0416."Account #" = AcctsNVen."Account"
	WHERE Data0416."Last Sale Date" <> Data0227."Last Sale Date"
	    OR Data0416."Homestead Exemption (YES or NO)"
	       <> Data0227."Homestead Exemption (YES or NO)"
	ORDER BY "Account #";

ALTER TABLE Diff0416 ADD COLUMN DownloadDate TEXT;
UPDATE Diff0416 
SET DownloadDate = "2021-04-16";
	
-- ** END Extract_DownDiff **********

