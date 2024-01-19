-- * IntTerrList.sql - Initialize SC SpecialDBs.db TerrList table..
-- * 2/4/23.	wmk.
-- *
-- * Entry.	SCPA-Downloads/Special/SpecialDBs.db = special databases control
-- *		 table.
-- *		/SyncAllData project TerrSpecList.txt = .csv of TerrList table entries.
-- *
-- * Exit.	SpecialDBs.db.TerrList updated with new records from TerrSpecList.txt.
-- *		
-- * Modification History.
-- * ---------------------
-- * 1/30/23.	wmk.	original code.
-- *
-- * Notes.
-- *;
.open '$pathbase/$scpath/Special/SpecialDBs.db'
.mode csv
.separator ,
.headers off
.import '$codebase/Projects-Geany/SyncAllData/TerrSpecList.txt' TerrList

-- * eliminate duplicates;
DELETE FROM TerrList
WHERE rowid NOT IN (SELECT MAX(rowid) FROM TerrList
 GROUP BY DBName,Terrxxx,Status);

-- * ensure names all have '.db' suffix;
UPDATE TerrList
SET DBName =
 TRIM(DBName) || '.db'
WHERE INSTR(DBName, '.db') = 0;

-- * set TerrList.Status fields;
WITH a AS (SELECT DBName FName, Status DBid FROM DBNames)
UPDATE TerrList
SET Status =
CASE WHEN DBName IN (SELECT FName from a)
 THEN (SELECT DBid from a
  WHERE FName IS DBName)
ELSE Status
END;
.quit
-- * END IntTerrList.sql;
