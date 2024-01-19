-- * AuxSCPARestruct.sql - Restructure AuxSCPAData.db with FOREIGN keys.
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

-- * Propagation table for tracking if territory change propagated to
-- * other databases;
-- * The Propagation table is initialized with OldTerr=NewTerr = the
-- * orginal territory ID. When the TerrID for a territory is changed/updated,
-- * the NewTerr field is updated to reflect the change.
-- *
-- * Changes/Deletions to the Propagation
-- * table *NewTerr field are cascaded into AddrXcpt and SitusDups;
DROP TABLE IF EXISTS Propagation;
CREATE TABLE Propagation(
 OldTerr TEXT NOT NULL DEFAULT '000',
 NewTerr TEXT NOT NULL DEFAULT '000',
 PRIMARY KEY (NewTerr) )
 ;

-- * initialize propagation table;
WITH a AS (SELECT DISTINCT CongTerr from AddrXcpt
 WHERE LENGTH(CongTerr) > 0)
INSERT INTO Propagation(OldTerr, NewTerr)
SELECT CongTerr, CongTerr FROM a;

-- * modify AddXcpt with FOREIGN KEY to Propagation;
ALTER TABLE AddrXcpt RENAME TO XAddrXcpt;

DROP TABLE IF EXISTS AddrXcpt;
CREATE TABLE AddrXcpt (
 SCPASitus TEXT, RUFull TEXT, UnitAddress TEXT, Unit TEXT, 
 SCUnit TEXT, PropID TEXT, CongTerr TEXT DEFAULT '000', RecordType TEXT,
 FOREIGN KEY (CongTerr)
 REFERENCES Propagation(NewTerr)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT) 
;

INSERT INTO AddrXcpt
SELECT * FROM XAddrXcpt;

-- * modify SitusDups with FOREIGN KEY to Propagation;
ALTER TABLE SitusDups RENAME TO XSitusDups;

CREATE TABLE SitusDups (
 "Account#" TEXT NOT NULL, Situs TEXT, NSEW TEXT, RUFull TEXT, 
 SitusZipCode TEXT, TerrID TEXT DEFAULT '000', 
 PRIMARY KEY("Account#"),
 FOREIGN KEY (TerriD)
 REFERENCES Propagation(NewTerr)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT) 
;

with a AS (SELECT OldTerr FROM PROPAGATION)
INSERT INTO Propagation(OldTerr, NewTerr)
SELECT DISTINCT TerrID, TerrID from XSitusDups
 WHERE TERRID NOT IN (SELECT OLDTERR from a)
 AND LENGTH(TerrID) > 0;


INSERT INTO SitusDups
SELECT * FROM XSitusDups;

-- * Territory table change logging;
CREATE TABLE IF NOT EXISTS TerrLog(
 Timestamp TEXT,
 LogMsg TEXT);

CREATE TRIGGER AuxUpdt AFTER UPDATE ON "Propagation"
 BEGIN INSERT INTO TerrLog
 VALUES(CURRENT_TIMESTAMP, 'AuxSCPA table update.'); END;
 
