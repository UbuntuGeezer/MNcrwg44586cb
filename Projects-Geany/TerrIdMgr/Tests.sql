-- * these queries are to be run on XTerrIDData.db;

-- * Notes. When converting an previous table that doesn't have the FOREIGN
-- * key, rename the current table, create the new table (with old name) and
-- * include the FOREIGN key specifications, then copy the old table records
-- * into the new table.
-- *;

CREATE TABLE "DoNotCalls" ( `TerrID` TEXT NOT NULL DEFAULT '000',
 `Name` TEXT, `UnitAddress` TEXT NOT NULL DEFAULT ' ', `Unit` TEXT, 
 `Phone` TEXT, `Notes` TEXT, `RecDate` TEXT, `RSO` INTEGER, 
 `Foreign` INTEGER, `PropID` TEXT, `ZipCode` TEXT, `DelPending` INTEGER, 
 `DelDate` TEXT, `Initials` TEXT, `LangID` INTEGER,
 FOREIGN KEY (TerrID)
 REFERENCES Territory2 (TerrID)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT);

-- * modify DoNotCalls with FOREIGN KEY to Territory;
ALTER TABLE DoNotCalls RENAME TO XDoNotCalls;

DROP TABLE IF EXISTS DoNotCalls;
CREATE TABLE "DoNotCalls" ( `TerrID` TEXT NOT NULL DEFAULT '000',
 `Name` TEXT, `UnitAddress` TEXT NOT NULL DEFAULT ' ', `Unit` TEXT, 
 `Phone` TEXT, `Notes` TEXT, `RecDate` TEXT, `RSO` INTEGER, 
 `Foreign` INTEGER, `PropID` TEXT, `ZipCode` TEXT, `DelPending` INTEGER, 
 `DelDate` TEXT, `Initials` TEXT, `LangID` INTEGER,
 FOREIGN KEY (TerrID)
 REFERENCES Territory(TerrID)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT) 
;

INSERT INTO DoNotCalls
SELECT * FROM XDoNotCalls;

-- * modify SegDefs with FOREIGN KEY to Territory;
ALTER TABLE SegDefs RENAME TO XSegDefs;

CREATE TABLE SegDefs (
 RecNo INTEGER PRIMARY KEY AUTOINCREMENT, 
 TerrID TEXT DEFAULT '000', 
 dbName TEXT, 
 sqldef TEXT,
 FOREIGN KEY (TerrID)
 REFERENCES Territory(TerrID)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT) 
;

INSERT INTO SegDefs
SELECT * FROM XSegDefs;


-- * modify SpecialRU with FOREIGN KEY to Territory;
ALTER TABLE SpecialRU RENAME TO XSpecialRU;

CREATE TABLE SpecialRU (
 "TID" TEXT NOT NULL DEFAULT '000', 
 "SpecialDB" TEXT,
 FOREIGN KEY (TID)
 REFERENCES Territory(TerrID)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT) 
;

INSERT INTO SpecialRU
SELECT * FROM XSpecialRU;

-- * modify SpecialSC with FOREIGN KEY to Territory;
ALTER TABLE SpecialSC RENAME TO XSpecialSC;

CREATE TABLE SpecialSC(
 TID TEXT NOT NULL DEFAULT '000', 
 SpecialDB TEXT,
 FOREIGN KEY (TID)
 REFERENCES Territory(TerrID)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT) 
;

INSERT INTO SpecialSC
SELECT * FROM XSpecialSC;

-- * modify SubTerrs with FOREIGN KEY to Territory;
ALTER TABLE SubTerrs RENAME TO XSubTerrs;

CREATE TABLE SubTerrs (
 TerrID TEXT NOT NULL DEFAULT '000',
 SubTerr TEXT NOT NULL DEFAULT '001',
 "Streets-Address(s)" TEXT,
 Homestead TEXT,
 "Parcel-LIKE" TEXT,
 "Unit-LIKE" TEXT,
 DBName TEXT,
 PRIMARY KEY(TerrID, SubTerr),
  FOREIGN KEY (TerrID)
 REFERENCES Territory(TerrID)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT) 
;

INSERT INTO SubTerrs
SELECT * FROM XSubTerrs;

-- * Territory table change logging;
CREATE TABLE TerrLog(
 Timestamp TEXT,
 LogMsg TEXT);

CREATE TRIGGER TerrUpdt AFTER UPDATE ON "Territory"
 BEGIN INSERT INTO TerrLog
 VALUES(CURRENT_TIMESTAMP, 'Territory table update.'); END;
 
