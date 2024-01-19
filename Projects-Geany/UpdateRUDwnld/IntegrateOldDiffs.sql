-- IntegrateOldDiffs.sq - Integrate older RU records into newer download.
--	9/8/21.	wmk.
-- *
-- * Modification History.
-- * 7/6/21.	wmk.	original SQL.
-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same
-- *					UnitAddress after merge.

-- * subquery list.
-- * --------------
-- * IntegrateOldDiffs - Integrate older RU records into newer download.
-- *;

-- ** IntegrateOldDiffs **********
-- *	9/8/21.	wmk.
-- *----------------------------
-- *
-- * IntegrateOldDiffs - Integrate older RU records into newer download.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db
-- *	Terr245_RU.db - as db12,
-- *	Terr245OldDiffs.csv - .csv records of older Bridge entries to
-- *	  integrate into Terr245_RU.db.Terr245_RUBridge
-- *
-- * Exit DB and table results.
-- *	Terr245_RU.db - as db12,
-- *	  updated with records from Terr245OldDiffs.csv
-- *
-- * Modification History.
-- * 7/6/21.	wmk.	original SQL.
-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same
-- *					UnitAddress after merge.
-- *
-- * Notes. IntegrateOldDiffs integrates the Terr245OldDiffs.csv Bridge
-- * records back into the current Terr245_RUBridge table, leaving the
-- * RecordDate intact from the old record, but changing the Resident1
-- * field to "?" indicating that the address is valid, but there was no
-- * RefUSA record for it with the latest download. (Note: if the DoNotCall
-- * status changed, it will not be picked up here.)
-- *;

.open '$folderbase/Territories/DB-Dev/junk.db'
.cd '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads'
ATTACH './Terr245/Terr245_RU.db'
 AS db12;
-- pragma db12.table_info(Terr245_RUBridge);

.headers ON
.separator ,
.mode csv
.import './Terr245/Terr245OldDiffs.csv' Terr245_RUBridge
UPDATE db12.Terr245_RUBridge
SET UnitAddress = trim(UnitAddress);
DELETE FROM db12.Terr245_RUBridge
WHERE rowid NOT IN (SELECT MAX(rowid) from Terr245_RUBridge
		GROUP BY UnitAddress, Unit, Resident1);
DETACH db12;
--DETACH db12;

.quit

-- ** END IntegrateOldDiffs **********;
