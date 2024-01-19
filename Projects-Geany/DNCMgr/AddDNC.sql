-- * AddDNC.sql - module description.
-- * 6/1/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.AdddDNCs = table or archived DoNotCalls
-- *				TerrIDData.DoNotCalls = table of DoNotCalls
-- *
-- * Dependencies. < propid >, < unit >, < initials > fields replaced by 
-- *	DoSedAdd.sh
-- *
-- * Exit.	/DB-Dev/TerrIDData.AdddDNCs = updated with DoNotCall
-- *	removed from DoNotCalls table < propid > < unit >
-- *	DoNotCalls table records < propid > < unit > marked for deletion
-- *
-- * Modification History.
-- * ---------------------
-- * 6/1/23.	wmk.	adapted from ArchiveDNCs.psq.
-- * Legacy mods
-- * 5/31/23.	wmk.	original code.
-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1.
-- *
-- * Notes. The archiving process takes all of the DoNotCalls for a given territory
-- * ID and places them in the AdddDNCs table.
-- *;

.open '$pathbase/DB-Dev/TerrIDData.db'

--CREATE TABLE DoNotCalls (
-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, 
-- UnitAddress TEXT NOT NULL DEFAULT ' ', Unit TEXT, Phone TEXT, 
-- Notes TEXT, RecDate TEXT, RSO INTEGER, Foreign INTEGER, PropID TEXT, 
-- ZipCode TEXT, DelPending INTEGER, DelDate TEXT, Initials TEXT, 
-- LangID INTEGER, 
-- FOREIGN KEY (TerrID) 
-- REFERENCES Territory(TerrID) 
-- ON UPDATE CASCADE 
-- ON DELETE SET DEFAULT);

--CREATE TABLE AdddDNCs (
-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, 
-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, 
-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, 
-- ArchDate TEXT, Initials TEXT );

DROP TABLE IF EXISTS NewRecs;
CREATE TEMPORARY TABLE NewRecs (
TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, 
UnitAddress TEXT NOT NULL DEFAULT ' ', Unit TEXT, Phone TEXT, 
Notes TEXT, RecDate TEXT, RSO INTEGER, "Foreign" INTEGER, PropID TEXT, 
ZipCode TEXT, DelPending INTEGER, DelDate TEXT, Initials TEXT, 
LangID INTEGER)
; 

-- * add records into DoNotCalls;
.headers ON
.mode csv
.separator "|"
.import '$codebase/Projects-Geany/DNCMgr/NewDNC.csv' NewRecs

INSERT INTO DoNotCalls
SELECT * FROM NewRecs;

-- * create log entries for each new property ID/Unit added;
WITH a AS (SELECT PropID, Unit FROM NewRecs)
INSERT INTO DNCLog(Timestamp,LogMsg)
SELECT CURRENT_TIMESTAMP,'imported ' || PropID || '/' || Unit 
 || ' from NewDNC.csv' FROM a;
 
-- * create log entry;
INSERT INTO DNCLog(Timestamp,LogMsg)
VALUES(CURRENT_TIMESTAMP,'imported new records from NewDNC.csv.');

.quit

-- * END AddDNC.sql;
