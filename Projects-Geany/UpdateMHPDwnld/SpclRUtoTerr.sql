-- SpclRUtoTerr.sql - Extract SPECIAL RU records to territory RU db.
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--	7/4/21.	wmk.
--
-- * Entry.	($)folderbase environment var set to Territories base
-- *
-- * Dependencies. SpclRUTerr depends upon being converted from SQL to
-- * shell commands that generate SQLTemp.sql for processing by sqlite3.
-- * If the queries here are run independently, they will need to be
-- * edited by the user before being processed by SQL.
-- *
-- * Exit. ../RefUSA-Downloads/Terrxxx/Mapxxx_RU.csv contains extracted
-- *		  records from the special database vvvv.db/table vvvv
-- *
-- *		if there is not _MHPBridge table present in the Terrxxx_SC.db
-- *		 SpclRUToTerr cannot extract the records from vvvv.db and
-- *		 will exit with an error.
-- *
-- * Modification History.
-- * 7/4/21.	wmk.	original code.
-- *
-- * Notes. SpclRUtoTerr gets ($)TID and ($)DB_BASE from the environment
-- * passed into xxx fields. The make process for the SpclRUtoTerr project
-- * uses the sed editor to create a SpclRUtoTerr.tmp file with the
-- * appropriate database and territory edited into xxx and vvvv fields
-- * within the SQL.
-- * All references to the database, its tables, or any other information
-- * relevant to processing the territories derives from these two
-- * passed values.
-- * SpclRUToTerr emulates data extraction from the RefUSA site
-- * where polygon record data is downloaded into Mapxxx_RU.csv for the
-- * territory. All that SpclRUtoTerr.sql does is use the Terrxxx_SC.db
-- * table Terrxxx_SCBridge to query the appropriate records from the
-- * special database vvvv.db and drop them into a .csv file with a
-- * header row just like the data came from a RefUSA polygon.
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- *;

-- ** AttachDBs **********
-- *	7/4/21.	wmk.
-- *---------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	TerrIDData.db - as db4, territory and subterritories (all) defs
-- *		Territory - territory id definitions
-- *		SubTerrs - subterritory definitions
-- *		DoNotCalls - DoNotCall addresses by territory
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		SitusDups - table of ambiguous situs addresses with account #s
-- *		SitusConv - situs conversion table unitaddress <-> scpa situs
-- *		AddrXcpt - address exceptions
-- *	Terrxxx_SC.db - as db11, new territory records from SCPA polygon
-- *		Terrxxx_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory xxx
-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terrxxx_RUPoly)
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/27/21.	wmk.	modified for cross-system use; dependency on
-- *					folderbase env var.
-- * Notes.
-- *;

-- * junk as main;
-- * folderbase = /home/bill for Kay's system;
-- * folderbase = /media/ubuntu/Windows/Users/Bill for home system.
.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
 AS db2;
--SELECT tbl_name FROM db2.sqlite_master 
-- WHERE type is "table";
--pragma db2.table_info(Terr86777);
 
ATTACH '$pathbase'
 ||		'/DB-Dev/TerrIDData.db'
 AS db4;
--SELECT tbl_name FROM db4.sqlite_master 
-- WHERE type is "table";
--pragma db4.table_info(DoNotCalls);

ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AddrXcpt); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Terr_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terrxxx_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Terrxxx_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terrxxx_RUBridge);

-- ** END AttachDBs **********;


-- ** SpclRUtoTerr **********
-- *	7/4/21.	wmk.
-- *--------------------------
-- *
-- * SpclRUtoTerr - .
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *		open special database
-- *		open Terrxxx_SC.db (above) for obtaining UnitAddress, Unit
-- *		  fields for all parcels in this territory; (note - this 
-- *		  table doesn't exist for MHPs, since there is not SCPA
-- *		  download data... This table should be considered read-only
-- *		  for anything but the .sql that creates it. IT MUST NOT BE
-- *		  updated by UpdateSCBridge; maybe name the table _MHPBridge
-- *		  to distinguish it from the _SCBridge table.)
-- *;

CREATE TEMP TABLE TableNames
(Name TEXT);
INSERT INTO Tablenames
SELECT tbl_name FROM sqlite_master
where tbl_name IS "Terrxxx_MHBridge");

-- ** END SpclRUtoTerr **********;
-- ** END SpclRUtoTerr **********;

