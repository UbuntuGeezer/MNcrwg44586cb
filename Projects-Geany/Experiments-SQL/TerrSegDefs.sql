-- * TerrSegDefs.sql - module description.
-- * 1/30/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/30/23.	wmk.	original code.
-- *
-- * Notes. New table for defining publisher territory segment definitions wihtin
-- * the SegDefs table in /DB-Dev/TerrIDData.
-- * 
-- * SegDefsTable
-- *	TerrID = territory ID primary key
-- *	Status = modified status, if even, has not been modified
-- *;
DROP TABLE IF EXISTS SegDefs;
CREATE TABLE SegDefs (
 RecNo INTEGER PRIMARY KEY AUTOINCREMENT,
 TerrID TEXT,
 dbName TEXT, 
 sqldef TEXT
);

INSERT INTO SegDefs(TerrID,dbName,sqldef)
VALUES("251","BayIndiesMHP", 
"WHERE (UnitAddress LIKE '%bimini%' 
   AND CAST(SUBSTR(UnitAddress,1,instr(Unitaddress,' ') as int)%2 = 0)");
INSERT INTO SegDefs(TerrID,dbName,sqldef)
VALUES("251","BayIndiesMHP",
"OR (UnitAddress LIKE '%zacapa%'
   AND CAST(SUBSTR(UnitAddress,1,instr(Unitaddress,' ') as int) >= 871
   AND CAST(SUBSTR(UnitAddress,1,instr(Unitaddress,' ') as int) <= 895
   AND CAST(SUBSTR(UnitAddress,1,instr(Unitaddress,' ') as int)%2 = 1)");
INSERT INTO SegDefs(TerrID,dbName,sqldef)
VALUES("251","BayIndiesMHP",
"OR (UnitAddress LIKE '%dominica%'
   AND CAST(SUBSTR(UnitAddress,1,instr(Unitaddress,' ') as int) >= 874
   AND CAST(SUBSTR(UnitAddress,1,instr(Unitaddress,' ') as int) <= 878)");

select distinct dbName,sqldef from SegDefs(TerrID,sqldef)
where TerrID is '251'
ORDER BY RecNo;

-- * END TerrSegDefs.sq;
--==============================================================
-- TerIDData.db is main;
-- get list of Special databases for this a territory;
CREATE TEMP TABLE IF NOT EXISTS ScratchDBs(DBName TEXT);
WITH a AS (SELECT TerrID TID, Segmented FROM Territory
  WHERE TerrID IS '251')
INSERT INTO ScratchDBs
SELECT CASE WHEN a.Segmented = 1
 THEN (SELECT DISTINCT dbName FROM SegDefs
        WHERE TerrID IS '251')
END DatabaseName
FROM SegDefs
INNER JOIN a ON
 a.TID IS TerrID
WHERE TerrID IS '251';
DELETE FROM ScratchDBs
 WHERE rowid NOT IN (SELECT MAX(rowid) FROM ScratchDBs
  Group BY DBName);
SELECT * FROM ScratchDBs;
