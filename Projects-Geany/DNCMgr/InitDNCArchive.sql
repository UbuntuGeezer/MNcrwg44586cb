
-- * TerrIDData.db ArchivedDNCs table;
DROP TABLE IF EXISTS ArchivedDNCs;
CREATE TABLE ArchivedDNCs (
 TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, 
 Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, 
 "Foreign" INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, 
 ArchDate TEXT, Initials TEXT );

-- * Initialize ArchLog table;
DROP TABLE IF EXISTS ArchLog;
CREATE TABLE ArchLog(TimeStamp TEXT,
 IDString TEXT, 
 Initials TEXT,
 Msg TEXT )
;

INSERT INTO ArchLog
VALUES(CURRENT_TIMESTAMP,'DNCMgr Create','wmk','ArchLog table initialized.');

-- * define trigger for ArchivedDNCs update;
CREATE TRIGGER ArchUpdt AFTER UPDATE ON "ArchivedDNCs" 
BEGIN INSERT INTO ArchLog 
SELECT CURRENT_TIMESTAMP,
 DelPending || ',' || PropID || ',' || Unit, Initials,
'ArchivedDNCs updated.' FROM ArchivedDNCs
WHERE rowid IN (SELECT MAX(rowid) from ArchivedDNCs)
LIMIT 1; 
END
;

-- * define trigger for DoNotCalls update;
CREATE TRIGGER DNCUpdt AFTER UPDATE ON "XDoNotCalls" 
BEGIN INSERT INTO DNCLog 
SELECT CURRENT_TIMESTAMP, 'DoNotCalls updated.' FROM "XDoNotCalls" 
LIMIT 1; 
END
;

-- * define trigger for DoNotCalls DELETE;
DROP TRIGGER "main"."DNCDelt"	;
CREATE TRIGGER DNCDelt AFTER DELETE ON "XDoNotCalls" 
BEGIN INSERT INTO DNCLog 
VALUES(CURRENT_TIMESTAMP,'DoNotCall deleted.'); 
END
;
