-- * DeleteDNC.sql - module description.
-- * 6/1/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.DeletedDNCs = table or archived DoNotCalls
-- *				TerrIDData.DoNotCalls = table of DoNotCalls
-- *
-- * Dependencies. < propid >, < unit >, < initials > fields replaced by 
-- *	DoSedDelete.sh
-- *
-- * Exit.	/DB-Dev/TerrIDData.DeletedDNCs = updated with DoNotCall
-- *	removed from DoNotCalls table < propid > < unit >
-- *	DoNotCalls table records < propid > < unit > marked for deletion
-- *
-- * Modification History.
-- * ---------------------
-- * 6/1/23.	wmk.	adapted from ArchiveDNCs.psq.
-- * 6/8/23.	wmk.	bug fix - was deleting where DelPending <> 1; changed
-- *			 to only set DelPending on record.
-- * Legacy mods
-- * 5/31/23.	wmk.	original code.
-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1.
-- *
-- * Notes. The archiving process takes all of the DoNotCalls for a given territory
-- * ID and places them in the DeletedDNCs table.
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

--CREATE TABLE DeletedDNCs (
-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, 
-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, 
-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, 
-- ArchDate TEXT, Initials TEXT );

-- * add records into Deleted DNCs;
INSERT INTO DeletedDNCs
SELECT TerrID, Name, UnitAddress, Unit, Phone, Notes, RecDate, RSO,
"Foreign", PropID, ZipCode, '0', '$TODAY', 'wmk'
FROM DoNotCalls
WHERE PropID IS '0429021395' AND (Unit ISNULL
 OR Unit IS '')
 AND DelPending <> 1; 

-- * Set DelPending on DeleteDoNotCalls records;
UPDATE DoNotCalls
SET DelPending = 1,
DelDate = '$TODAY'
WHERE PropID is '0429021395' AND (Unit ISNULL
 OR Unit IS '');

--INSERT INTO DNCLog(Timestamp,LogMsg)
--VALUES(CURRENT_TIMESTAMP,'0429021395 <unit> DNC deleted.');
INSERT INTO DNCLog(Timestamp,LogMsg)
SELECT CURRENT_TIMESTAMP,'0429021395 <nounit> deleted.' || initials FROM Admin;
.quit

-- * END DeleteDNC.sql;
