-- * MoveRSO.psq/sql - Move RSO within TerrIDData.
-- * 6/14/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.DeletedRSOs = table or archived DoNotCalls
-- *				TerrIDData.DoNotCalls = table of DoNotCalls
-- *
-- * Dependencies. -1, 424   ARMADA RD S, 2, 34285 000 wmk fields replaced by 
-- *	DoSedMove.sh
-- *
-- * Exit.	/DB-Dev/TerrIDData.RSOAddress, .RSOInfo = updated with move info.
-- *	DoNotCalls table records -1 marked for deletion
-- *	RSOLog entry made
-- *
-- * Modification History.
-- * ---------------------
-- * 6/13/23.	wmk.	original code; adapted from DeleteRSO.
-- * 6/14/23.	wmk.	selections corrected to use *rsoid.
-- * Legacy mods.
-- * 6/1/23.	wmk.	adapted from ArchiveRSOs.psq.
-- * 6/8/23.	wmk.	bug fix - was deleting where DelPending <> 1; changed
-- *			 to only set DelPending on record.
-- * Legacy mods
-- * 5/31/23.	wmk.	original code.
-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1.
-- *
-- * Notes. The archiving process takes all of the DoNotCalls for a given territory
-- * ID and places them in the DeletedRSOs table.
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

--CREATE TABLE DeletedRSOs (
-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, 
-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, 
-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, 
-- ArchDate TEXT, Initials TEXT );

-- * add record into Deleted RSOs;
INSERT INTO DeletedRSOs
SELECT TerrID, Name, UnitAddress, Unit, Phone, Notes, RecDate, RSO,
"Foreign", PropID, ZipCode, '0', '$TODAY', 'wmk'
FROM DoNotCalls
WHERE RSO = -1
 AND DelPending <> 1; 

-- * create temp tabbe with new address, new unit, propid placeholder;
DROP TABLE IF EXISTS NewPropID;
CREATE TEMP TABLE NewPropID(NewID TEXT, UnitAddress TEXT, Unit TEXT);
INSERT INTO NewPropID(NewID,UnitAddress,Unit)
VALUES('9999999999','424   ARMADA RD S','2');

-- * attempt to match up Property ID from address;
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;;
WITH a AS (SELECT "Account #" Acct, 
 TRIM(SUBSTR("situs address (property address)",1,35)) StreetAddr,
 TRIM(SUBSTR("situs address (property address)",36)) SCUnit
  FROM Terr86777)
UPDATE NewPropID
SET NewID =
CASE WHEN UPPER(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE SCUnit IS Unit)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS UPPER(UnitAddress)
   AND SCUnit IS UNIT)
ELSE NewID
END;
 
-- * Set Update address, unit, zipcode, RecDate in DoNotCalls record for RSOid;
-- * set PropID = '9999999999' since unknown at this point;
WITH a AS (SELECT NewID FROM NewPropID)
UPDATE DoNotCalls
SET TerrID = '000', 
 UnitAddress = '424   ARMADA RD S',
 Unit = '2',
 ZipCode = '34285',
 RecDate = '$TODAY',
 PropID = (SELECT NewID FROM a)
WHERE RSO = -1;

-- * issue RSOLog message;
--INSERT INTO RSOLog(Timestamp,LogMsg)
--VALUES(CURRENT_TIMESTAMP,'RSO < rsoid > address moved.');
INSERT INTO RSOLog(Timestamp,LogMsg)
SELECT CURRENT_TIMESTAMP,'RSO -1 address moved.' || initials FROM Admin;

--CREATE TABLE RSOInfo (
-- Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT, 
-- RSOid INTEGER NOT NULL,
--  PRIMARY KEY(RSOid), 
--  FOREIGN KEY(RSOid) 
--  REFERENCES RSOAddress(RSOid) )
;
-- * update RSOInfo first, since RSOAddress is parent;
UPDATE RSOInfo
SET Address = '424   ARMADA RD S',
 Unit = '2'
WHERE RSOid = -1;

--CREATE TABLE RSOAddress (
-- RSOid INTEGER PRIMARY KEY AUTOINCREMENT, PropID TEXT, Unit TEXT, Initials TEXT,
-- RecDate TEXT, UnitAddress TEXT)
--;
-- * update RSOAddress parent record;
WITH a AS (SELECT NewID FROM NewPropID)
UPDATE RSOAddress
SET Initials = 'wmk',
 RecDate = '$TODAY$',
 Unit = '2',
 UnitAddress = '424   ARMADA RD S',
 PROPID = (SELECT NewID FROM a)
WHERE RSOid = -1;

.quit
-- * END MoveRSO.sql;
