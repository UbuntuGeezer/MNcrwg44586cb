-- ExtractOldDiffs.sq - Extract older RU records not in newer download.
--	4/25/22.	wmk.
-- * Modification History.
-- * ---------------------
-- * 7/6/21.	wmk.	original code.
-- * 4/25/22.	wmk.	modified for general use FL/SARA/86777;
-- *			 *pathbase* support.
-- *;

-- * subquery list.
-- * --------------
-- * ExtractOldDiffs - Extract older RU records not in newer download.
-- *;

-- ** ExtractOldDiffs **********
-- *	7/6/21.	wmk.
-- *----------------------------
-- *
-- * ExtractOldDiffs - Extract older RU records not in newer download.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db
-- *	Terr314_RU.db - as db12,
-- *	./Previous/Terr314_RU.db - as db32,
-- *
-- * Exit DB and table results.
-- *	Terr314OldDiffs.csv - extracted _RUBridge records from ./Previous
-- *	  .db where UnitAddress not in current .db
-- *
-- * Notes.
-- *;

.open '$pathbase/DB-Dev/junk.db'
.cd '$pathbase/RawData/RefUSA/RefUSA-Downloads'
ATTACH './Terr314/Terr314_RU.db'
 AS db12;
-- pragma db12.table_info(Terr314_RUBridge);

ATTACH './Terr314/Previous/Terr314_RU.db'
 AS db32;
-- pragma db32.table_info(Terr314_RUBridge);

.headers ON
.separator ,
.mode csv
.output './Terr314/Terr314OldDiffs.csv'
UPDATE db12.Terr314_RUBridge
SET UnitAddress = trim(UnitAddress);
UPDATE db32.Terr314_RUBridge
SET UnitAddress = trim(UnitAddress);
WITH a AS (SELECT UnitAddress FROM db12.Terr314_RUBridge)
SELECT * FROM db32.Terr314_RUBridge
 WHERE UnitAddress NOT IN (SELECT UnitAddress FROM a);
--DETACH db12;
--DETACH db32;
.quit

-- ** END ExtractOldDiffs **********;
