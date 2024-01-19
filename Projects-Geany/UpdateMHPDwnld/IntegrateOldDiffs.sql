-- IntegrateOldDiffs.sq - Integrate older RU records into newer download.
-- *	6/7/22.	wmk.
-- *
-- * Modification History.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 6/7/22.	wmk.	code check migrating to FL/SARA/86777
-- * Legacy  mods.
-- * 7/6/21.	wmk.	original SQL.
-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same
-- *					UnitAddress after merge.
-- * 9/9/21.	wmk.	cloned into UpdateMHPDwnld from UpdateRUDwnld project.
-- * 11/14/21.	wmk.	bug fix where newly inserted ? records with older 
-- *					dates supplanting newer records with valid names;
-- *					add code to delete duplicate rows after getting
-- *					newest records.
-- *;

-- * subquery list.
-- * --------------
-- * IntegrateOldDiffs - Integrate older RU records into newer download.
-- *;

-- ** IntegrateOldDiffs **********
-- *	6/7/22.	wmk.
-- *----------------------------
-- *
-- * IntegrateOldDiffs - Integrate older RU records into newer download.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db
-- *	Terr262_RU.db - as db12,
-- *	Terr262OldDiffs.csv - .csv records of older Bridge entries to
-- *	  integrate into Terr262_RU.db.Terr262_RUBridge
-- *
-- * Exit DB and table results.
-- *	Terr262_RU.db - as db12,
-- *	  updated with records from Terr262OldDiffs.csv
-- *
-- * Modification History.
-- * ---------------------
-- * 6/7/22.	wmk.	code check migrating to FL/SARA/86777
-- * Legacy mods.
-- * 7/6/21.	wmk.	original SQL.
-- * 9/8/21.	wmk.	add code to eliminate duplicate ? records on same
-- *					UnitAddress after merge.
-- *
-- * Notes. IntegrateOldDiffs integrates the Terr262OldDiffs.csv Bridge
-- * records back into the current Terr262_RUBridge table, leaving the
-- * RecordDate intact from the old record, but changing the Resident1
-- * field to "?" indicating that the address is valid, but there was no
-- * RefUSA record for it with the latest download. (Note: if the DoNotCall
-- * status changed, it will not be picked up here.)
-- *;

.open '$pathbase/DB-Dev/junk.db'
.cd '$pathbase/RawData/RefUSA/RefUSA-Downloads'
ATTACH './Terr262/Terr262_RU.db'
 AS db12;
-- pragma db12.table_info(Terr262_RUBridge);

.headers ON
.separator ,
.mode csv
CREATE TEMP TABLE OldRecs
( "OwningParcel" TEXT NOT NULL, "UnitAddress" TEXT NOT NULL, "Unit" TEXT,
 "Resident1" TEXT, "Phone1" TEXT, "Phone2" TEXT, "RefUSA-Phone" TEXT,
 "SubTerritory" TEXT, "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0,
 "RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
 "RecordDate" REAL DEFAULT 0, "SitusAddress" TEXT, "PropUse" TEXT,
  "DelPending" INTEGER DEFAULT 0, "RecordType" TEXT);
.import './Terr262/Terr262OldDiffs.csv' OldRecs
INSERT INTO Terr262_RUBridge
SELECT
 "OwningParcel" , "UnitAddress" , "Unit" ,
 "?" , "Phone1" , "Phone2" , "" ,
 "SubTerritory" , "CongTerrID" , "DoNotCall" ,
 "RSO" , "Foreign" ,
 "RecordDate" , "SitusAddress" , "PropUse" ,
  "DelPending" , "RecordType"
 FROM OldRecs;
UPDATE db12.Terr262_RUBridge
SET UnitAddress = trim(UnitAddress);
DELETE FROM db12.Terr262_RUBridge
WHERE RecordDate NOT IN (SELECT MAX(RecordDate) from Terr262_RUBridge
	GROUP BY UnitAddress, Unit, Resident1);
DELETE FROM db12.Terr262_RUBridge
WHERE rowid NOT IN (SELECT MAX(rowid) from Terr262_RUBridge
	GROUP BY UnitAddress, Unit, Resident1);
-- * set ? in older records not in current download;
with a as (SELECT MAX(recorddate) AS MaxDate
 FROM Terr262_RUBridge)
Update Terr262_RUBridge
SET Resident1 = '?'
where recorddate not in (select MaxDate from a);
DETACH db12;
--DETACH db12;

.quit

-- ** END IntegrateOldDiffs **********;
