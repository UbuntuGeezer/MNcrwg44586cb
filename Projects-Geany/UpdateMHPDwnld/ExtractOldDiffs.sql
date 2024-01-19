-- ExtractOldDiffs.psq - Extract older RU records not in newer download.
--	6/7/22.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 6/7/22.	wmk.	code checked migrating to FL/SARA/86777.
-- * Legacy mods.
-- * 9/9/21.	wmk.	cloned into UpdateMHPDwnld from UpdateRUDwnld project.
-- * 7/6/21.	wmk.	original code.
-- *;

-- * subquery list.
-- * --------------
-- * ExtractOldDiffs - Extract older RU records not in newer download.
-- *;

-- ** ExtractOldDiffs **********
-- *	6/7/22.	wmk.
-- *----------------------------
-- *
-- * ExtractOldDiffs - Extract older RU records not in newer download.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db
-- *	Terr262_RU.db - as db12,
-- *	./Previous/Terr262_RU.db - as db32,
-- *
-- * Exit DB and table results.
-- *	Terr262OldDiffs.csv - extracted _RUBridge records from ./Previous
-- *	  .db where UnitAddress not in current .db
-- *
-- * Notes.
-- *;

.open '$pathbase/DB-Dev/junk.db'
.cd '$pathbase/RawData/RefUSA/RefUSA-Downloads'
ATTACH './Terr262/Terr262_RU.db'
 AS db12;
-- pragma db12.table_info(Terr262_RUBridge);

ATTACH './Terr262/Previous/Terr262_RU.db'
 AS db32;
-- pragma db32.table_info(Terr262_RUBridge);

.headers OFF
.separator ,
.mode csv
.output './Terr262/Terr262OldDiffs.csv'
UPDATE db12.Terr262_RUBridge
SET UnitAddress = trim(UnitAddress);
UPDATE db32.Terr262_RUBridge
SET UnitAddress = trim(UnitAddress);
WITH a AS (SELECT UnitAddress FROM db12.Terr262_RUBridge)
SELECT * FROM db32.Terr262_RUBridge
 WHERE UnitAddress NOT IN (SELECT UnitAddress FROM a);
--DETACH db12;
--DETACH db32;
.quit

-- ** END ExtractOldDiffs **********;

