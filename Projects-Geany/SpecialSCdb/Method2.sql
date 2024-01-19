-- Method2csv.sql - SQL template for SC polygon download records to .db.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--		10/8/21.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 10/8/21.	wmk.	original code; cloned from Method 2.sql.
-- *
-- * Notes. Method2 uses the downloaded SCPA records from the .csv
-- * that was produced from a SCPA polygon download into file
-- * <specialdb>.csv. Then it builds the <specialdb> table, SpecSCBridge,
-- * PropTerr and TerrList tables from the full download records.
-- *;

-- * subquery list.
-- * --------------
-- * BuildPoly<special-db> - Build SC Download table from polygon <special-db>.csv.
-- * GetCsvRecords - Get records from download <special-db>.csv.
-- *;

-- ** BuildPoly<special-db> **********
-- *	10/8/21.	wmk.
-- *---------------------------------
-- *
-- * BuildPoly<special-db> - Build SC Download table from polygon <special-db>.csv.
-- *
-- * Entry DB and table dependencies.
-- *   Terr204Full.db - as main, full polygon download from SCPA data 
-- *		where one or more territories are a subset of the download.
-- *
-- * Exit DB and table results.
-- *	Terr204Full.db - as main, full polygon download from SCPA data 
-- *	  where one or more territories are a subset of the download.
-- *		<special-db>_SCPoly - empty table with fields mirroring the
-- *			SCPA polygon download fields
-- *
-- * Notes. This query builds a table that mirrors the fields downloaded
-- * when a map polygon extracts data from the SCPA property search. Its
-- * usefulness is for paring down territories where the polygon may
-- * select an entire area like a condo property with multiple buildings
-- * but the territory is divided by buildings. Records from the whole
-- * polygon can be selectively extracted into this table for generating
-- * the individual territory(ies).
-- *;

.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/<special-db>.db'

DROP TABLE IF EXISTS <special-db>_SCPoly;
CREATE TABLE <special-db>_SCPoly
 ( Account TEXT NOT NULL, "Name" TEXT, Name2 TEXT, 
   ADDRESS TEXT, CITY TEXT, "STATE" TEXT,
   ZIP TEXT , COUNTRY TEXT , LOCATIONNAME TEXT ,
   LOCATIONSTREET TEXT , LOCATIONDIRECTION TEXT ,
   UNIT TEXT , LOCATIONCITY TEXT , LOCATIONZIP TEXT,
   PRIMARY KEY (Account) );

DROP TABLE IF EXISTS <special-db>;
CREATE TABLE <special-db>
 ( Account TEXT NOT NULL, "Name" TEXT, Name2 TEXT, 
   ADDRESS TEXT, CITY TEXT, "STATE" TEXT,
   ZIP TEXT , COUNTRY TEXT , LOCATIONNAME TEXT ,
   LOCATIONSTREET TEXT , LOCATIONDIRECTION TEXT ,
   UNIT TEXT , LOCATIONCITY TEXT , LOCATIONZIP TEXT,
   PRIMARY KEY (Account) );

-- ** END BuildPoly<db-name> **********;


-- ** GetCsvRecords **********
-- *	10/8/21.	wmk.
-- *--------------------------
-- *
-- * GetCsvRecords - Get records from download <special-db>.csv.
-- *
-- * Entry DB and table dependencies.
-- *   <special-db>.db - as main, full polygon download from SCPA data 
-- *	 where one or more territories are a subset of the download.
-- *		<special-db>_SCPoly - reserved for import of all records from
-- *		  SC polygon download encompassing <special-db>
-- *
-- * Exit DB and table results.
-- *	Query results have all records <special-db>.csv that actually belong
-- *	in <special-db> table.
-- *
-- * Notes.
-- *;

.headers ON
.mode csv
.separator ,
.import from '$pathbase/RawData/SCPA/SCPA-Downloads/Special/<special-db>.csv' <special-db>
INSERT INTO <special-db>_SCPoly
SELECT * FROM <special-db>;
ALTER TABLE <special-db> ADD COLUMN TID TEXT;

-- * now create Spec_SCBridge table;
DROP TABLE IF EXISTS Spec_SCBridge;
CREATE TABLE Spec_SCBridge 
( "OwningParcel" TEXT NOT NULL, "UnitAddress" TEXT NOT NULL, "Unit" TEXT, 
"Resident1" TEXT, "Phone1" TEXT, "Phone2" TEXT, "RefUSA-Phone" TEXT, 
"SubTerritory" TEXT, "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0, 
"RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0, 
"RecordDate" REAL DEFAULT 0, "SitusAddress" TEXT, "PropUse" TEXT, 
"DelPending" INTEGER DEFAULT 0, "RecordType" TEXT);

-- * populate Spec_SCBridge from polygon data.
INSERT INTO Spec_SCBridge
 SELECT Account,
  trim(LOCATIONNAME) || '   ' || trim(LOCATIONSTREET) 
	|| CASE WHEN LENGTH(TRIM(LOCATIONDIRECTION)) > 0
	    THEN ' ' || LOCATIONDIRECTION ELSE '' END,
  UNIT, "NAME", '', '', '',
  '', '', '', 
  '', '',
  '2021-10-07', '', '',
   '', ''
  FROM <special-db>_SCPoly;

DROP TABLE IF EXISTS PropTerr;
CREATE TABLE PropTerr (PropID TEXT, StreetAddr TEXT, TerrID TEXT);
WITH a AS (SELECT Account AS Acct,
 '', TID
 FROM <special-db>)
INSERT INTO PropTerr
 SELECT * FROM a;
DROP TABLE IF EXISTS TerrList;
CREATE TABLE TerrList (TerrID TEXT, Counts INTEGER DEFAULT 0);

-- ** END GetCsvRecords **********;  

.quit
-- ** END Method2 **********;
