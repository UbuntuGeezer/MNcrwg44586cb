-- SetSpecTerrs.MHP.sql - Set SpecTerrxxx_RU.db MHP territory IDs and info.
--	11/12/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 8/15/21.	wmk.	original code;
-- * 8/16/21.	wmk.	code enhancements.
-- * 8/17/21.	wmk.	terr 201 replaced with xxx; db30 documentation
-- *					updated.
-- * 8/18/21.	wmk.	terr274 code appended to end for use as model
-- *					code for other territories; code correction
-- *					in TerrList references.
-- * 8/20/21.	wmk.	bug fix extraneous ',' in CASE statement; bad
-- *					reference to AvenidaEstancias for Spec_RUBridge;
-- *					bug fix when setting CongTerrID where units cleared.
-- * 8/31/21.	wmk.	edited for territory xxx.
-- * 11/12/21.	wmk.	dbname change to <special -db>.db.
-- *
-- * Notes. Only Eleuthera, Freeport, Guadalupe, and Haite E are in territory xxx.
-- * Queries setting fields use trim(UnitAddress) rather than property ID, since this
-- * is a MHP where all property IDs are the same.
-- *;

--
-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FiXxxxRU - Fix RU records territory xxx.
-- *;


-- ** AttachDBs **********
-- *	8/16/21.	wmk.
-- *---------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- * 19	Specxxx_RU.db - as db19, special download records for terr xxx
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  Specxxx_RU database
-- * 30	BayIndies.db - as db30, special download records
-- *		Spec_RURaw - unsorted raw download data from street
-- *		Spec_RUPoly - sorted download data from street
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  NVenAll table
-- *		TerrList - list of territories and record counts 
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 8/15/21.	wmk.	original code.
-- * 8/16/21.	wmk.	added query code to set PropUse and OwningParcels.
-- * Notes.
-- *;

-- * junk as main;
.open '$folderbase/Territories/DB-Dev/junk.db'

ATTACH '$folderbase/Territories/DB-Dev/VeniceNTerritory.db'
 AS db2;
--  PRAGMA db2.table_info(NVenAll)

ATTACH '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'
  || '/Terrxxx/Terrxxx_SC.db'
  AS db11;
--	PRAGMA db11.table_info(Terrxxx_SCBridge);

ATTACH '$folderbase/Territories'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Specxxx_RU.db'
  AS db19;
--  PRAGMA db19.table_info(Spec_RUBridge);

-- ** END AttachDBs **********;

-- ** FixSpecRU **********
-- *	8/15/21.	wmk.
-- *---------------------
-- *
-- * FixSpecRU - Fix Specxxx_RU records territory 289.
-- *
-- * Entry DB and table dependencies.
-- * 19	Specxxx_RU.db - as db19, special download records for terr xxx
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  Specxxx_RU database
-- * 30	BayIndies.db - as db30, special download records
-- *		BayIndies - table of special download record
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  NVenAll table
-- *		TerrList - list of territories and record counts 
-- *
-- * Exit DB and table results.
-- * 19	Specxxx_RU.db - as db19, special download records for terr xxx
-- *		Spec_RUBridge - Bridge records updated with terr xxx
-- * 30	BayIndies.db - as db30, special download records
-- *		BayIndies - table of special download records; CongTerrID updated
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *			NOT UPDATED with terrxxx
-- *		Spec_RUBridge - Bridge records updated with terr xxx
-- *		  NVenAll table
-- *		TerrList - record counts updated for terr xxx
-- *
-- * Modification History.
-- * ---------------------
-- * 8/15/21.	wmk.	original code;
-- *
-- * Notes. Since OwningParcel is same for all MHP entries, SELECT DISTINCT
-- * is used for setting fields.
-- *;

-- * DBs attached above;

-- ** perform territory-dependent fixes on new records **;

-- * Terrxxx_RU.db/Terrxxx_RUBridge;
ATTACH '$folderbase/Territories'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Terrxxx_RU.db'
  AS db12;
-- * set all owningparcels to MHP parcel ID;
UPDATE Terrxxx_RUBridge 
SET OwningParcel = '<mhp-parcelid>'
WHERE OwningParcel IS "-";

-- * set SitusAddress and ProUse fields;
WITH a AS (SELECT DISTINCT "Account #", "situs address (property address)",
	"Property Use Code" FROM NVenAll
	WHERE "Account #" IN (SELECT DISTINCT OwningParcel FROM Terrxxx_RUBridge
				WHERE OwningParcel IS NOT '-') )
UPDATE Terrxxx_RUBridge 
SET SitusAddress =
 (SELECT "situs address (property address)" FROM a
   WHERE "Account #" IS OwningParcel),
PropUse = 
 (SELECT "Property Use Code" FROM a
   WHERE "Account #" IS OwningParcel)
WHERE OwningParcel IS NOT "-";

-- ** END SetSitusPropUse **********;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT DISTINCT OWNINGPARCEL AS Acct, trim(UNITADDRESS) AS StreetAddr,
 PROPUSE AS UseType
 FROM Terrxxx_RUBridge
 WHERE OwningParcel IS NOT "-")
UPDATE db19.Spec_RUBridge
SET OWNINGPARCEL = '<mhp-parcelid>',
PROPUSE = 
CASE
WHEN trim(UNITADDRESS) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS trim(UNITADDRESS))
ELSE PROPUSE
END
WHERE OwningParcel IS '-';
;

-- * set territory xxx in all these records;
UPDATE db19.Spec_RUBridge
SET 
CongTerrID = 'xxx'
;

-- set record type;
WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE db19.Spec_RUBridge
SET RecordType =
CASE
WHEN PropUse IN (SELECT Code FROM a)
 THEN (SELECT RType FROM a 
		WHERE Code IS PropUse)
ELSE NULL
END;
-- end SetRecordType;
-- ****** end Terrxxx block *****;

-- repeat below block for each special db;
--*************** BayIndies;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/<special-db>.db'
 AS db30;

-- * set OwningParcels and PropUses for streets in terr xxx;
WITH a AS (SELECT trim(UnitAddress) AS StreetAddr
 FROM db11.Terrxxx_SCBridge)
UPDATE db30.Spec_RUBridge
SET OWNINGPARCEL = '<mhp-parcelid>',
PROPUSE = '2860'
WHERE upper(trim(UnitAddress))
   IN (SELECT StreetAddr FROM a);

-- * set territory xxx in all Special/<special-db> records for xxx;
with a AS (SELECT trim(UnitAddress) AS StreetAddr FROM db19.Spec_RUBridge)
UPDATE db30.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a)
 THEN 'xxx'
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE db30.Spec_RUBridge
SET RecordType =
CASE
WHEN PropUse IN (SELECT Code FROM a)
 THEN (SELECT RType FROM a 
		WHERE Code IS PropUse)
ELSE NULL
END;
-- end SetRecordType;

-- * update Terr xxx counts field in BayIndies.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db30.Spec_RUBridge)
INSERT INTO db30.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db30.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db30.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db30.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db30;

--***** end BayIndies block *****;

-- ** END FiXxxxRU **********;

.quit
-- ** END SetSpecTerrs **********;

