-- * FlagSCUpdqate.psq/sql - Flag SC territory for update.
-- * 7/1/22.	wmk.
-- *
-- * Entry.	[m m d d edited by DoSed with P2, P3 command line parameters.]
-- *
-- * Exit.	Terr998_SC.db new table Diff0113 containing records from
-- *		SCPADiff_01-13.db.Diff0113 whose property IDs are in
-- *		Terr998_SC.Terr998_SCBridge.
-- *		if record count > 0, UpdtyyyM.csv has 1 record written to
-- *		 flag UpdateRUDwnld makefile.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/1/22.	wmk.	*pathbase* support.
-- * 7/1/22.	wmk.	path fixes.
-- * Legacy mods.
-- * 11/3/21.	wmk.	complete rewrite.
-- * Legacy mods.
-- * 3/1/21.	wmk.	original code.
-- * 3/18/21.	wmk.	AttachDBs added for setup; db references qualified.
-- * 4/19/21.	wmk.	bug fix where table names for SELECT not picking
-- *					up 0113 from Diff download spec.
-- * 5/27/21.	wmk.	modified to work with Kay's system.
-- * 6/19/21.	wmk.	external dependencies documented.
-- * 6/20/21.	wmk.	restore full field names.
-- *
-- * Dependencies.
-- * -------------
-- * The placeholder *pathbase* is used in file paths within this query.
-- *
-- * The placeholder "998" is used in place of a territory id within this
-- * query. All occurrrences should be replaced by the territory id for
-- * which to flag SC updates.
--- *
-- * The placeholders "@ @-z z" and "@ @z z" are used in date-dependent fields
-- * within this query. All occurrences should be replaced with the 2-digit
-- * month (@ @) and day (z z) prior to execution (e.g. 04 26).
-- *
-- * These dependencies imply that this SQL query will be edited to a
-- * separate file (e.g. SQLTemp.sql) before being read by the SQL command
-- * line processor (sqlite3).
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FlagSCUpdate - Flag SC territory for update.
-- *;

-- ** AttachDBs **********
-- *	5/1/22.	wmk.
-- *----------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	SCPADiff_m2-d2.db as db16,  Difference collection of new/updated
-- *	  property records between current and past SCPA downloads
-- *		Diffm2d2 - table of differences new/updated SCPA records
-- *		  where either last sale date or homestead exemption field(s)
-- *		  have changed
-- *		DiffAccts (future) table of property ids and territory ids of
-- *		  parcels in Diffm2d2 table
-- *	caller must use sed to change: m2-d2 and m2d2 to correct date,
-- *	  and 998 to territory ID.
-- *	MultiMail.db - as db3, territory parcels with multiple residents
-- *		SplitProps - territory parcels with multiple dwellings
-- *		SplitOwners - parcel owner information
-- *	TerrIDData.db - as db4, territory and subterritories (all) defs
-- *		Territory - territory id definitions
-- *		SubTerrs - subterritory definitions
-- *		DoNotCalls - DoNotCall addresses by territory
-- *	PolyTerri.db - as db5, territory parcels from map polygons
-- *		TerrProps - territory parcels
-- *		PropOwners - parcel owner information
-- *
-- * Exit DB and table results.
-- *	UpdtP998.csv - file containing Diff records from SC download of @ @-z z
-- *	  that matched in PolyTerri/TerrProps that can be used to update
-- *      the Terr998_SCBridge table.
-- *	UpdtM998.csv - file containing Diff records from SC download of @ @-z z
-- *	  that matched in MultiMail/SplitProps that can be used to update
-- *      the Terr998_SCBridge table.
-- *
-- * Modification History.
-- * ---------------------
-- * 3/18/21.	wmk.	AttachDBs added for setup; db references qualified.
-- * 5/27/21.	wmk.	modified to work with various host systems.
-- *;

.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase'
||		'/DB-Dev/MultiMail.db'
 AS db3;
--SELECT tbl_name FROM db3.sqlite_master;
--pragma db3.table_info(SplitProps); 

ATTACH '$pathbase'
 ||		'/DB-Dev/TerrIDData.db'
 AS db4;
--SELECT tbl_name FROM db4.sqlite_master 
-- WHERE type is "table";
--pragma db4.table_info(DoNotCalls);

ATTACH '$pathbase'
 ||		'/DB-Dev/PolyTerri.db'
  AS db5;
--SELECT tbl_name FROM db5.sqlite_master;
--pragma db5.table_info(TerrProps); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPADiff_01-13.db'
 AS db16;
  SELECT tbl_name FROM db16.sqlite_master;
--  PRAGMA db16.table_info(Diff0113);
--  PRAGMA db16.table_info(DiffAccts);
--  PRAGMA db16.table_info(MissingParcels);
--  PRAGMA db16.table_info(DNCNewOwners);

-- ** END AttachDBs **********;


-- ** FlagSCUpdate **********
-- *	5/1/22.	wmk.
-- *-------------------------
-- *
-- * FlagSCUpdate - Flag SC territory for update.
-- *
-- * Entry DB and table dependencies.
-- *	SCPADiff_m2d2.db as db16,  Difference collection of new/updated
-- *	  property records between current and past SCPA downloads
-- *		Diffm2d2 - table of differences new/updated SCPA records
-- *		  where either last sale date or homestead exemption field(s)
-- *		  have changed
-- *		DiffAccts (future) table of property ids and territory ids of
-- *		  parcels in Diffm2d2 table
-- *	caller must use sed to change: m2-d2 and m2d2 to correct date,
-- *	  and 998 to territory ID.
-- *	MultiMail.db - as db3, territory parcels with multiple residents
-- *		SplitProps - territory parcels with multiple dwellings
-- *		SplitOwners - parcel owner information
-- *	PolyTerri.db - as db5, territory parcels from map polygons
-- *		TerrProps - territory parcels
-- *		PropOwners - parcel owner information
-- *
-- * Exit DB and table results.
-- *	UpdtP998.csv - file containing Diff records from SC download of @ @-z z
-- *	  that matched in PolyTerri/TerrProps that can be used to update
-- *      the Terr998_SCBridge table.
-- *	UpdtM998.csv - file containing Diff records from SC download of @ @-z z
-- *	  that matched in MultiMail/SplitProps that can be used to update
-- *      the Terr998_SCBridge table.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/1/22.	*pathbase* support.
-- * Legacy mods.
-- * 11/3/21.	complete rewrite.
-- * Legacy mods.
-- * 3/1/21.	original code.
-- * 3/18/21.	db ATTACHes moved up to start; db references qualified.
-- * 5/27/21.	wmk.	modified to work with Kay's system.
-- * 6/20/21.	wmk.	restore full field names.
-- *
-- * Notes. Creating the Updt998P.csv or Updt998M.csv file sets a dependency
-- * for the UpdateSCBridge make. If the Updt998.csv file is newer than the
-- * Terr998_SC.db, UpdateSCBridge make will update the Terr998_SC.db
-- * Terr998_SCBridge table with the new records on the Updt998.csv file.
-- * The sed method in the "make" will need to change "@ @-z z" to the
-- * month and day of the Diff file, and "@ @z z" to the same as well.
-- * In addition, sid will need to change "998" to the territory ID.
-- *;
-- * select difference records into 2 separate .csv files.;
-- * UpdtP998.csv is records that will update into PolyTerri and will be
-- *  RecordType P in Terr998_SCBridge.
-- * UpdtM998.csv is records that will update into MultiMail and will be
-- *  RecordType M in Terr998_SCBridge.
-- *;

--.shell "rm '$pathbase/RawData/SCPA/SCPA-Downloads/Terr998/Updt998.csv' "


.open '$pathbase/DB-Dev/junk.db'
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'
	|| '/SCPADiff_01-13.db'
	AS db19;
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'
	|| '/Terr998/Terr998_SC.db'
	AS db11;

DROP TABLE IF EXISTS db11.Diffs0113;
CREATE TABLE db11.Diffs0113 
( "Account#" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT, 
MailingAddress1 TEXT, MailingAddress2 TEXT, MailingCity TEXT, 
MailingState TEXT, MailingZipCode TEXT, MailingCountry TEXT, 
"SitusAddress(PropertyAddress)" TEXT, SitusCity TEXT, SitusState TEXT, 
SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT, 
Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, 
WaterfrontCode TEXT, "HomesteadExemption(YESorNO)" TEXT, 
HomesteadExemptionGrantYear TEXT, Zoning TEXT, ParcelDesc1 TEXT, 
ParcelDesc2 TEXT, ParcelDesc3 TEXT, ParcelDesc4 TEXT, 
"Pool(YESorNO)" TEXT, TotalLivingUnits TEXT, "LandAreaS.F." TEXT, 
GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, Baths TEXT, 
HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, LastSaleDate TEXT, 
LastSaleQualCode TEXT, PriorSaleAmount TEXT, PriorSaleDate TEXT, 
PriorSaleQualCode TEXT, JustValue TEXT, AssessedValue TEXT, 
TaxableValue TEXT, LinktoPropertyDetailPage TEXT, ValueDataSource TEXT, 
ParcelCharacteristicsData TEXT, Status TEXT, DownloadDate TEXT,
PRIMARY KEY ("Account#") );
WITH a AS (SELECT OwningParcel AS PropID FROM db11.Terr998_SCBridge
 WHERE PropID IS NOT '-')
INSERT OR IGNORE INTO db11.Diffs0113
SELECT * FROM db19.Diff0113 
WHERE "Account#" IN (SELECT PropID FROM a);

-- * write 1 record to Updt998M.csv if count > 0;
.output '$pathbase/RawData/SCPA/SCPA-Downloads/Terr998/Updt998M.csv'
.mode csv
.separator ,
SELECT * FROM Diffs0113
limit 1;

.quit
--***** END FlagSCUpdate *****;
