-- * DeactivateTerr.psq/sql - Deactivate records in Terrxxx_RUBridge, Terrxxx_SCBridge for terr.
-- *	5/29/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/30/23.	wmk.	original code.
-- *
-- * Notes. DeactivateTerr sets the 'DelPending' field = 1 for all
-- * records in Terrxxx_RU.db.Spec_RUBridge,
-- * Terrxxx_SC.db.Spec_SCBridge database(s) for territory xxx. 
-- *
-- * This prevents any BridgesToTerr *make from picking up any obsoleted publisher
-- * records, while preserving the records for archiving. A second layer of
-- * protection is at the folder level; the file OBSOLETE, if present, indicates
-- * that a territory is out of circulation.
-- *;

-- * open/attach db,s;

.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase/DB-Dev/TerrIDData.db'
 AS db6;
--pragma db6.table_info(Territory);

ATTACH '$pathbase/$scpath/Terr964/Terr964_SC.db'
 AS db11;
-- pragma db11.table_info(Terr964_SCBridge);

ATTACH '$pathbase/$rupath/Terr964/Terr<terrid>_RU.db'
 AS db12;
-- pragma db12.table_info(Terr964_RUBridge);

-- * set DelPending in SCBridge records;
UPDATE db11.Terr964_SCBridge
SET DelPending = 1;
DETACH db11;

-- * set DelPending in RUBridge records;
UPDATE db12.Terr964_RUBridge
SET DelPending = 1;
DETACH db12;

-- * deactivate territory in TerrIDData;
UPDATE db6.Territory
SET StatusCode = TerrID,
TerrID = TerrID || 'D'
WHERE TerrID IS '964';

.quit
-- * END DeactivateTerr.sql;
