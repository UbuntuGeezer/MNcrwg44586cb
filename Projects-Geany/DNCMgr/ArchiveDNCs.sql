-- * ArhiveDNCs.sql - module description.
-- * 6/1/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.ArchivedDNCs = table or archived DoNotCalls
-- *				TerrIDData.DoNotCalls = table of DoNotCalls
-- *
-- * Dependencies. < terrid > and < initials > fields replaced by DoSedRecover.sh
-- *
-- * Exit.	/DB-Dev/TerrIDData.ArchivedDNCs = updated with DoNotCalls
-- *	added from DoNotCalls table < terrid >
-- *	DoNotCalls table records < terrid > marked for deletion
-- *
-- * Modification History.
-- * ---------------------
-- * 5/31/23.	wmk.	original code.
-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1.
-- *
-- * Notes. The archiving process takes all of the DoNotCalls for a given territory
-- * ID and places them in the ArchivedDNCs table.
-- *;

.open '$pathbase/DB-Dev/XTerrIDData.db'

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

--CREATE TABLE ArchivedDNCs (
-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, 
-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, 
-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, 
-- ArchDate TEXT, Initials TEXT );

-- * add records into Archived DNCs;
INSERT INTO ArchivedDNCs
SELECT TerrID, Name, UnitAddress, Unit, Phone, Notes, RecDate, RSO,
"Foreign", PropID, ZipCode, '0', '$TODAY', 'wmk'
FROM DoNotCalls
WHERE TerrID IS '101'
 AND DelPending <> 1; 

-- * set DelPending on DoNotCalls records;
UPDATE DoNotCalls
SET DelPending = 1
WHERE TerrID is '101';

.quit

-- * END ArhiveDNCs.sql;
