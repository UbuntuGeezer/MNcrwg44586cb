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
-- * 4/27/22.	wmk.	*pathbase* support.
-- * Legacy mods.
-- * 9/30/20.	wmk.	original query
-- * 12/3/20.	wmk.	modified to use generic SCPA_m1-d1.db as db14 for
-- *					old SCPA full download, SCPA_m2-d2.db as db15 for
-- *					new SCPA full download to facilitate conversion
-- *					to QSCPADiff.sh shell script
-- * 2/3/21.	wmk.	comments updated; mod to use SCPA_m1d1.db as db14
-- *					SCPA_m2d2.db as db15 as new name support; all
-- *					dbs assumed in SCPA-Downloads folder
-- * 4/17/21.	wmk.	extracted from QSCPADiff.sql to ExtractDownDiff.sql
-- *					and modified for use as shell query; references
-- *					to SC download databases reformatted to match
-- *					pattern SCPA_mm-dd.db; pragma references commented
-- *					out; DownloadDate field eliminated from CREATE for
-- *					new Diffm2d2 table, and added via ALTER TABLE 
-- *					after loading difference records.
-- *
-- * Notes. This query differences 2 SCPA downloads into a new database
-- * SCPADiff_m2-d2.db with table Diffmmdd. The records in Diffmmdd are
-- * all those records in SCPA_m2-d2.db that differ from records in 
-- * SCPA_m1-d1.db.

.cd '$pathbase/RawData/SCPA/SCPA-Downloads'
.open 'SCPADiff_m2-d2.db'

ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AcctsNVen); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_m1-d1.db'
 AS db14;
--  SELECT tbl_name FROM db14.sqlite_master;
--  PRAGMA db14.table_info(Datam1d1);
 
-- *	SCPA_m2d2.db - as db15, SCPA (new) full download from date m1/d1
-- *		Datam2d2 - SCPA download records from date m2/d2 any uear
ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPA_m2-d2.db'
 AS db15;
--  SELECT tbl_name FROM db15.sqlite_master;
--  PRAGMA db15.table_info(Datam2d2);


-- create empty Diffm2d2 table in New database ...
DROP TABLE IF EXISTS Diffm2d2;
CREATE TEMP TABLE "Diffm2d2"
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
INSERT OR IGNORE INTO Diffm2d2
 SELECT Datam2d2.* FROM Datam2d2
   INNER JOIN Datam1d1
    ON Datam2d2."Account #" = Datam1d1."Account #"
   INNER JOIN AcctsNVen
    ON Datam2d2."Account #" = AcctsNVen."Account"
	WHERE Datam2d2."Last Sale Date" <> Datam1d1."Last Sale Date"
	    OR Datam2d2."Homestead Exemption (YES or NO)"
	       <> Datam1d1."Homestead Exemption (YES or NO)"
	ORDER BY "Account #";

ALTER TABLE Diffm2d2 ADD COLUMN DownloadDate TEXT;
UPDATE Diffm2d2 
SET DownloadDate = "2021-m2-d2";
	
-- ** END Extract_DownDiff **********;
