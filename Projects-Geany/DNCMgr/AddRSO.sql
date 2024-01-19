-- * AddRSO.sql - Add new RSO entry.
-- * 6/1/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.RSOAddress= table of RSO Addresses. (parent)
-- *				TerrIDData.RSOInfo = table of RSO information. (child)
-- *
-- * Dependencies. RSOAddress.RSOid autoincremented integer RSO id field.
-- *
-- * Exit.	/DB-Dev/TerrIDData.RSOAddress = new RSO added
-- *						  .RSOInfo = new RSO information added.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/12/23.	wmk.	original code; adapted from AddDNC.sql.
-- * Legacy mods
-- * 5/31/23.	wmk.	original code.
-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1.
-- *
-- * Notes. The archiving process takes all of the DoNotCalls for a given territory
-- * ID and places them in the AdddDNCs table.
-- *;

.open '$pathbase/DB-Dev/TerrIDData.db'

--CREATE TABLE RSOAddress (
-- RSOid INTEGER PRIMARY KEY AUTOINCREMENT, PropID TEXT, Unit TEXT, Initials TEXT,
-- RecDate TEXT, UnitAddress TEXT)
--;

--CREATE TABLE RSOInfo (
-- Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT, 
-- RSOid INTEGER NOT NULL,
--  PRIMARY KEY(RSOid), 
--  FOREIGN KEY(RSOid) 
--  REFERENCES RSOAddress(RSOid) )
;

--* record current max rowid;
drop table if exists MaxRSOid;
create TEMPORARY table MaxRSOid(lastrow INTEGER);

--* preserve current last row for downstream insertions;
INSERT INTO MaxRSOid(lastrow)
SELECT rowid FROM RSOAddress
WHERE rowid IN (SELECT MAX(rowid) FROM RSOAddress);


-- template for NewRSOs.csv; 
--TerrID|Name|UnitAddress|Unit|Phone|Notes|RecDate|PropID|ZipCode|initials
;
DROP TABLE IF EXISTS NewRSOs;
CREATE TEMPORARY TABLE NewRSOs (
TerrID TEXT NOT NULL DEFAULT '000', "Name" TEXT, 
UnitAddress TEXT NOT NULL DEFAULT ' ', Unit TEXT, Phone TEXT, 
Notes TEXT, RecDate TEXT, PropID TEXT, 
ZipCode TEXT, Initials TEXT )
;

-- * add records into RSOAddress, RSOInfo;
-- * import records to NewRecs;
.headers ON
.mode csv
.separator "|"
.import '$codebase/Projects-Geany/DNCMgr/NewRSO.csv' NewRSOs

-- add new record(s) into DoNotCalls;
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
-- * create new DNC entry corresponding to new RSO entry(ies);
-- NewRSOs;
--TerrID|Name|UnitAddress|Unit|Phone|Notes|RecDate|PropID|ZipCode|initials;
-- * RSOid (automatic),PropID, Unit, initials, RecDate, UnitAddress;
INSERT INTO DoNotCalls(TerrID, "Name", UnitAddress, Unit, Phone, Notes,
 RecDate, PropID, ZipCode, Initials)
SELECT TerrID, "Name", UnitAddress, Unit, Phone, Notes, RecDate, PropID,
 ZipCode, Initials
FROM NewRSOs;

-- * add new record(s) into RSOAddress;
--CREATE TABLE RSOAddress (
-- RSOid INTEGER PRIMARY KEY AUTOINCREMENT, PropID TEXT, Unit TEXT, Initials TEXT,
-- RecDate TEXT, UnitAddress TEXT)
--;
-- NewRSOs;
--TerrID|Name|UnitAddress|Unit|Phone|Notes|RecDate|PropID|ZipCode|initials;
-- * RSOid (automatic),PropID, Unit, initials, RecDate, UnitAddress;
INSERT INTO RSOAddress(PropID, Unit, initials, RecDate, UnitAddress)
SELECT PropID, Unit, Initials, RecDate, UnitAddress FROM NewRSOs;


--CREATE TABLE RSOInfo (
-- Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT, 
-- RSOid INTEGER NOT NULL,
--  PRIMARY KEY(RSOid), 
--  FOREIGN KEY(RSOid) 
--  REFERENCES RSOAddress(RSOid) )
;
-- * add new record(s) into RSOInfo using RSOAddress;
WITH a AS (SELECT RSOid aRSOid, UnitAddress aUnitAddress, Unit aUnit
 FROM RSOAddress WHERE rowid > (SELECT lastrow FROM MaxRSOid))
INSERT INTO RSOInfo(Address, Unit, RSOid)
SELECT aUnitAddress, aUnit, aRSOid 
 FROM a;

-- * update RSOInfo with additional fields from NewRSOs;
-- * Name, Phone, Notes RecDate;
WITH a AS (SELECT "Name" aName, Phone aPhone, Notes aNotes, RecDate aRecDate,
 UnitAddress aUnitAddress,  Unit aUnit
 FROM NewRSOs)
UPDATE RSOInfo
SET "Name" =
CASE WHEN Address IN (SELECT aUnitAddress FROM a
 WHERE aUnit IS Unit)
 THEN (SELECT aName FROM a
  WHERE aUnitAddress IS Address
    AND aUnit IS Unit)
ELSE "Name"
END,
 Phone =
CASE WHEN Address IN (SELECT aUnitAddress FROM a
 WHERE aUnit IS Unit)
 THEN (SELECT aPhone FROM a
  WHERE aUnitAddress IS Address
    AND aUnit IS Unit)
ELSE Phone
END,
 Notes =
CASE WHEN Address IN (SELECT aUnitAddress FROM a
 WHERE aUnit IS Unit)
 THEN (SELECT aNotes FROM a
  WHERE aUnitAddress IS Address
    AND aUnit IS Unit)
ELSE Notes
END
WHERE rowid > (SELECT lastrow FROM MaxRSOid);
-- * Name, UnitAddress, Unit Phone, Notes, RSOid (from RSOAddress records)
-- *   ,PropID, Unit, initials, RecDate, UnitAddress;

-- * update DoNotCalls with RSOid(s) from RSOAddress table;
WITH a AS (SELECT RSOid, PropID aPropID, Unit aUnit
FROM RSOAddress WHERE rowid > (SELECT lastrow FROM MaxRSOid))
UPDATE DoNotCalls
SET RSO = (SELECT RSOid FROM a
 WHERE aPropID IS PropID
   AND aUnit IS Unit)
WHERE PropID IN (SELECT aPropID FROM a
 WHERE aUnit IS Unit);

-- * create log entries for each new property ID/Unit added;
WITH a AS (SELECT PropID, Unit FROM NewRSOs)
INSERT INTO RSOLog(Timestamp,LogMsg)
SELECT CURRENT_TIMESTAMP,'imported ' || PropID || '/' || Unit 
 || ' from NewRSO.csv' FROM a;

-- * create RSOLog summary log entry;
INSERT INTO RSOLog(Timestamp,LogMsg)
VALUES(CURRENT_TIMESTAMP,'imported new records from NewRSO.csv.');

-- * create log entries for each new DNC added;
WITH a AS (SELECT PropID, Unit FROM NewRSOs)
INSERT INTO DNCLog(Timestamp,LogMsg)
SELECT CURRENT_TIMESTAMP,'created DNC ' || PropID || '/' || Unit 
 || ' from NewRSO.csv' FROM a;

-- * create DNCLog summary log entry;
INSERT INTO DNCLog(Timestamp,LogMsg)
VALUES(CURRENT_TIMESTAMP,'created new DNC records from NewRSO.csv.');


.quit

-- * END AddRSO.sql;
