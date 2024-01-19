-- * TerrIDDataRestruct.sql - Restructure TerrIDData.db with FOREIGN keys.
-- *
-- * these queries are to be run on TerrIDData.db;
-- * These queries add FOREIGN KEY specifiers to all tables having a
-- * territory ID field. When The Territory.TerrID field is deleted or
-- * updated, the new TerrID value is cascaded into the tables having
-- * a territory ID field.
-- *
-- * Notes. When converting an previous table that doesn't have the FOREIGN
-- * key, rename the current table, create the new table (with old name) and
-- * include the FOREIGN key specifications, then copy the old table records
-- * into the new table.
-- *;

-- * modify DoNotCalls with FOREIGN KEY to Territory;
ALTER TABLE DoNotCalls RENAME TO XDoNotCalls;

DROP TABLE IF EXISTS DoNotCalls;
CREATE TABLE "DoNotCalls" ( 
 TerrID` TEXT NOT NULL DEFAULT '000',
 Name TEXT, `UnitAddress` TEXT NOT NULL DEFAULT ' ',
 Unit TEXT, `Phone` TEXT, `Notes` TEXT, `RecDate` TEXT, `RSO` INTEGER, 
 "Foreign" INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, 
 DelDate TEXT, Initials TEXT, LangID INTEGER,
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
 
-- * Propagation table for tracking if territory change propagated to
-- * other databases;
-- * The Propagation table is initialized with OldTerr=NewTerr = the
-- * orginal territory ID. When the TerrID for a territory is changed/updated,
-- * the NewTerr field is updated to reflect the change.
-- *
-- * if the NewTerr is not equal to the OldTerr, then the change must be
-- * propagated into the PolyTerri and MultiMail publisher territory master
-- * dbs, as well as the RefUSA Special and Terrxxx folders and the
-- * SCPA Special and Terrxxx folders.
-- *
-- * PolyTerri and MultiMail will have all the OldTerr id matching records
-- * be set to DelPending (but not deleted). This will prevent the records
-- * from being picked up on a subsequent BridgesToTerr operation.
--*
-- * The RefUSA-Downloads/Terrxxx and SCPA-Downloads/Terrxxx folders will
-- * be "zipped", preserving the files, but effectively taking the old
-- * territory data out of play. An additional file "OBSOLETE" will be
-- * added into the Terrxxx folder flagging the territory as OBSOLETE
-- * to all Territory processes.
-- *
-- * As each of the above steps are taken, the appropriate flag will be
-- * set to 1 (e.g. PolyTerri records set with DelPending, PolyTerri = 1).
-- * This allows tracking to ensure that the territory id change has been
-- * propagated throughout the data segment.

DROP TABLE IF EXISTS Propagation;
CREATE TABLE Propagation(
 OldTerr TEXT NOT NULL DEFAULT '000',
 NewTerr TEXT NOT NULL DEFAULT '000',
 PolyTerri INTEGER DEFAULT 0,
 MultiMail INTEGER DEFAULT 0,
 RUSpecial INTEGER DEFAULT 0,
 RUTerrs INTEGER DEFAULT 0,
 SCSpecial INTEGER DEFAULT 0,
 SCTerrs INTEGER DEFAULT 0,
 FOREIGN KEY (NewTerr)
 REFERENCES Territory(TerrID)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT)
 ;

-- * initialize propagation table;
WITH a AS (SELECT TerrID from Territory)
INSERT INTO Propagation(OldTerr, NewTerr)
SELECT TerrID, TerrID FROM a;
