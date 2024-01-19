-- * DeactivateTerr2.psq/sql - Deactivate records in Terrxxx_RUBridge, Terrxxx_SCBridge for terr.
-- *	6/4/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/29/23.	wmk.	original code.
-- * 6/4/23.	wmk.	split out into DeactivateTerr2.
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

ATTACH '$pathbase/$rupath/Terr965/Terr<terrid>_RU.db'
 AS db12;
-- pragma db12.table_info(Terr965_RUBridge);

-- * set DelPending in RUBridge records;
UPDATE db12.Terr965_RUBridge
SET DelPending = 1;
DETACH db12;

.quit
-- * END DeactivateTerr2.sql;
