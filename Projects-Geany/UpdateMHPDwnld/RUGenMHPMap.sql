--RUGenMHPMap.sq - Generate pseudo MHP Map download.csv (template).
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--	7/6/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 7/5/21.	wmk.	original code.
-- * 7/6/21.	wmk.	bug fixes where " " preceded "." co07ands.
-- *;

-- * subquery list.
-- * --------------
-- * RUGenMHPMap - Generate pseudo MHP Map download.csv.
-- *;

-- ** RUGenMHPMap **********
-- *	7/6/21.	wmk.
-- *--------------------------
-- *
-- * RUGenMHPMap - Generate pseudo MHP Map download.csv.
-- *
-- * Entry DB and table dependencies.
-- *	Terr269_RU.db - as db12; from ./Previous folder
-- *	  Terr269_MHP table - table of known a04resses from last download
-- *		of terr269 from RU data 
-- *	RU<MHP-name>_07-04.db - as db19, full download of MHP as of 07-04
-- *	  <MHP-name> table - full download table
-- *
-- * Exit DB and table results.
-- *	Map269_RU.csv - .csv of download data that corresponds to the
-- *	  latest full RU download of the MHP.
-- *
-- * Modification History.
-- * ---------------------
-- * 7/5/21.	wmk.	original code.
-- * 7/6/21.	wmk.	bug fixes where " " preceded "." co07ands; bug
-- *					fix changing Terr269_MHP from ./Previous.
-- *
-- * Notes. The Terr269_MHP table records are in RU polygon map download
-- * order so the fields House Number, Pre-Directional, Street, Street Suffix,
-- * and Post-Directional can be compared directly with the full download
-- * to obtain the records for all the known a04resses in territory 269.
-- * A second pass over the full download using only Pre-Directional, Street, 
-- * Street Suffix, and Post-Directional can be done to find House Number
-- * fields that are new since the last download, and these records can
-- * be a04ed.
-- *;

-- * open junk as main;
.open '$pathbase/DB-Dev/junk.db'
 
-- * attach ./Previous/Terr_RU.db as db12;
ATTACH '$pathbase'
	|| 		'/RawData/RefUSA/RefUSA-Downloads/Terr269/'
	|| '/Terr269_RU.db'
	AS db12;
-- pragma db12.table_info(Terr269_MHP);

-- * attach full download of MHP;
ATTACH '$pathbase'
	|| 		'/RawData/RefUSA/RefUSA-Downloads/Special/'
	|| '/RUBayIndies_07-04.db'
	AS db19;
--	pragma db19.table_info(BayIndies);

CREATE TEMP TABLE MHP_Recs
( "Last Name" TEXT, "First Name" TEXT, "House Number" TEXT,
 "Pre-directional" TEXT, Street TEXT, "Street Suffix" TEXT,
  "Post-directional" TEXT, "Apartment Number" TEXT, City TEXT,
 State TEXT, "ZIP Code" TEXT, "County Name" TEXT,
 "Phone Number" TEXT );
with a AS (SELECT "Pre-Directional" AS PreDir, "House Number" AS HouseNo,
  Street AS StreetName, "Street Suffix" AS StreetType, 
  "Post-Directional" AS PostDir
  FROM db12.Terr269_MHP)
 INSERT INTO MHP_Recs
 SELECT * FROM db19.BayIndies 
  WHERE "Pre-directional"||"House Number"||Street||"Street Suffix"
	|| "Post-Directional"
   IN (SELECT PreDir || HouseNo || StreetName || StreetType || PostDir
    from a);
.headers ON
.separator ,
.mode csv
.output '$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr269/Map269_RU.csv'
 SELECT * FROM MHP_Recs;
 DROP TABLE MHP_Recs;
.quit

-- ** END RUGenMHPMap **********;
