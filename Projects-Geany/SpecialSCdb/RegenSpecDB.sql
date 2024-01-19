-- RegenSpecDB.sq - Regenerate Specxxx_SC.db in SC territory folder (template).
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--	8/30/21.	wmk.
-- copy and edit this SQL template to territory SC download folder.
.cd '$pathbase'
.cd './RawData/SCPA/SCPA-Downloads/Terrxxx'
--.trace 'Procs-Dev/SQLTrace.txt';
-- .open 'Specxxx_SC.db';
--#echo $DB_NAME;
.open 'Specxxx_SC.db'
-- drop old version of Special Bridge and recreate;
DROP TABLE IF EXISTS Spec_SCBridge;
CREATE TABLE Spec_SCBridge
( "OwningParcel" TEXT NOT NULL,
 "UnitAddress" TEXT NOT NULL,
 "Unit" TEXT, "Resident1" TEXT, 
 "Phone1" TEXT,  "Phone2" TEXT,
 "RefUSA-Phone" TEXT, "SubTerritory" TEXT,
 "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0,
 "RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
 "RecordDate" REAL DEFAULT 0,
 "SitusAddress" TEXT, "PropUse" TEXT,
  "DelPending" INTEGER DEFAULT 0,
 "RecordType" TEXT);
 -- Now attach Special databases and select/insert their records;
--.cd './Special';
.cd '../Special'
ATTACH '<special-db>.db' AS db29;
INSERT INTO Spec_SCBridge
SELECT * FROM db29.Spec_SCBridge 
 WHERE CongTerrID IS 'xxx';
DETACH db29;
.quit
-- end RegenSpecDB_db.sq;
