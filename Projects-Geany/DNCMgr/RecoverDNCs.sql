-- * RecoverDNCs.sql - module description.
-- * 5/31/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.ArchivedDNCs = table or archived DoNotCalls
-- *
-- * Dependencies. < terrid > and < initials > fields replaced by DoSedRecover.sh
-- *
-- * Exit.	/DB-Dev/TerrIDData.DoNotCalls = updated with recovered DoNotCall
-- *	records from ArchivedDNCs table
-- *	ArchivedDNCs table recovered records marked for deletion
-- *
-- * Modification History.
-- * ---------------------
-- * 5/31/23.	wmk.	original code.
-- *
-- * Notes.
-- *;

.open '$pathbase/DB-Dev/XTerrIDData.db'
ATTACH '$pathbase/$scpath/Terr101/Terr101_SC.db'
 AS db11;
--pragma db11.table_info(Terr101_SCBridge);

--CREATE TABLE ArchivedDNCs (
-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, 
-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, 
-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, 
-- ArchDate TEXT, Initials TEXT );

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
 
-- * insert ArchivedDNC records;
WITH a AS (SELECT OwningParcel Acct, Unit s_Unit
 FROM db11.Terr101_SCBridge),
b AS (SELECT
 TerrID, Name , UnitAddress, Unit,  Phone, Notes, RecDate, RSO, 
 "Foreign", PropID, ZipCode, 0, Initials
 FROM ArchivedDNCs
 WHERE PropID IN (SELECT Acct FROM a
  WHERE s_Unit IS Unit) )
INSERT INTO DoNotCalls( TerrID, Name , UnitAddress, Unit,  Phone, Notes, RecDate, RSO, 
 "Foreign", PropID, ZipCode, DelPending, 
 Initials)
SELECT
 TerrID, Name , UnitAddress, Unit,  Phone, Notes, RecDate, RSO, 
 "Foreign", PropID, ZipCode, 0,
 'wmk'
FROM b;

-- * set DelPending on ArchivedDNCs records = 1;
UPDATE ArchivedDNCs
SET DelPending = 1
WHERE TerrID IS '101';

-- * END RecoverDNCs.sql;
