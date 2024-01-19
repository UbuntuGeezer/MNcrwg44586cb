-- * Add this to SpecialDBs.db;
-- *
-- * Notes. The SpecialDBs.db.OutOfDates table is automatically updated
-- * whenever the Status field of the parent table DBList is updated.
-- * Each DBName entry in the DBList table is assigned a unique status
-- * that is an even number. Thus, the Status field of each TerrID
-- * within the OutOfDates table is also set to the unique Status of
-- * its parent DBList.DBName. The DBName entry contains a static field,
-- * base_status, that is its unique status identifier.
-- *
-- * Whenever a special .db is updated, its Status is changed in the
-- * DBList.DBName table to be the base_status + 1; this cascades into
-- * the OutOfDates table entry for each TerriD whose Status is base_status.
-- * An "even" Status within any given OutOfDates table entry indicates
-- * that the territory is up-to-date with the special DBName that is
-- * a prerequisite. An "odd" Status within any given OutOfDates table
-- * entry indicates that the territory is out-of-date with the special
-- * DBName that is a prerequisite.
-- *
DROP TABLE IF EXISTS DBNames;
CREATE TABLE DBNames(
 DBName TEXT,
 Mod_Date TEXT,
 base_status INTEGER,
 Status INTEGER
 PRIMARY KEY (Status) );
 
DROP TABLE IF EXISTS OutOfDates;
CREATE TABLE OutOfDates(
TerrID TEXT, Status INTEGER,
 FOREIGN KEY (Status)
 REFERENCES DBList (Status)
 ON UPDATE CASCADE);
 
 select TerriD from OutOfDates
  WHERE STATUS%2 IS 1;
  
-- ######################
DROP TABLE IF EXISTS TerrList;
-- * list of territories using each DBName;
CREATE TABLE TerrList(
DBName TEXT, Terrxxx TEXT, Status INTEGER,
 FOREIGN KEY (Status)
 REFERENCES DBList (Status)
 ON UPDATE CASCADE;

SELECT Terrxxx FROM TerrList
 WHERE DBName IS '<spec-db>.db' 
   AND Status%2 IS 1;

-- ########################
WITH a AS (SELECT DBName FName, Status DBid FROM DBNames)
UPDATE TerrList
SET Status =
CASE WHEN DBName IN (SELECT FName from a)
 THEN (SELECT DBid from a
  WHERE FName IS DBName)
ELSE Status
END;
