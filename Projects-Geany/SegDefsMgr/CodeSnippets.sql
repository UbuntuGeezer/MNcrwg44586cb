DROP TABLE IF EXISTS SegSelect;

CREATE TABLE SegSelect(
 Type TEXT,
 tidFilter TEXT,
 dbFilter
 );

 select distinct dbname from SegDefs;
 
insert into SegSelect(Type, dbFilter)
values('dname','CapriIslesBlvd');

-- * query with dbname only;
WITH a AS (SELECT * FROM SegSelect)
SELECT *
FROM SegDefs
INNER JOIN a
ON a.dbFilter IS dbName
WHERE dbName IS a.dbFilter;

-- * territory id query setup and test;
insert into SegSelect(Type, tidFilter)
values('terrid','284');

-- * query with terrid only;
WITH a AS (SELECT * FROM SegSelect)
SELECT TerrID, dbName, sqldef
FROM SegDefs
INNER JOIN a
ON a.tidFilter IS TerrID
WHERE TerrID IS a.tidFilter;

-- **** test 1 *****;
-- * territory id  and dbname query setup and test;
delete from SegSelect;
insert into SegSelect(Type, tidFilter, dbFilter)
values('terrid','284', 'CapriIslesBlvd');

WITH a AS (SELECT * FROM SegSelect)
SELECT TerrID, dbName, sqldef
FROM SegDefs
INNER JOIN a
ON a.tidFilter IS TerrID
 AND a.dbFilter IS dbName
WHERE TerrID IS a.tidFilter
 AND dbName IS a.dbFilter;

-- **** test 2 *****;
-- * territory id  and dbname query setup and test;
delete from SegSelect;
insert into SegSelect(Type, tidFilter, dbFilter)
values('terrid','284', 'CapriIslesBlvd');

WITH a AS (SELECT * FROM SegSelect)
SELECT TerrID, dbName, sqldef
FROM SegDefs
INNER JOIN a
ON a.tidFilter IS TerrID
 AND a.dbFilter IS dbName
WHERE TerrID IS a.tidFilter
 AND dbName IS a.dbFilter;

-- get records based on SegSelect;
delete from SegSelect;
INSERT INTO SegSelect(Type,dbFilter)
VALUES('dbname','VillageCir');
INSERT INTO SegSelect(Type,dbFilter)
VALUES('dbname','BayLakeMHP');

DROP TABLE IF EXISTS TempQuery;
CREATE TABLE TempQuery(
 TerrID TEXT,
 dbName TEXT,
 sqldef TEXT
 );
 
WITH a AS (SELECT * FROM SegSelect)
INSERT INTO TempQuery
SELECT CASE WHEN dbName
 IN (SELECT dbFilter FROM a)
 OR TerrID IN (SELECT tidFilter FROM a)
 THEN TerrID
 END TerrID,
CASE WHEN dbName
 IN (SELECT dbFilter FROM a)
 OR TerrID IN (SELECT tidFilter FROM a)
 THEN dbName
 END dbName,
CASE WHEN dbName
 IN (SELECT dbFilter FROM a)
 OR TerrID IN (SELECT tidFilter FROM a)
 THEN sqldef
 END sqldef
FROM SegDefs;

select * from TempQuery;

delete from TempQuery
WHERE TerrID ISNULL;
