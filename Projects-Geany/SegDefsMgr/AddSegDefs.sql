-- * AddSegDefs.psq/sql - Add content of TerrIDData.Defs308 table into TerriDData.SegDefs table.
-- * 2/12/23.	wmk.
-- *
-- * Entry. table TerriDData.Defs308 created by loading /Terr308/segdefs.csv
-- *	    table TerrIDData.308Counts created by querying SegDefs table for terr 308.
-- *
-- * Exit. table TerrIDData.SegDefs has new records added from Defs308 table.
-- *       tables Defs308 and 308Counts removed from TerrIDData.
-- *	   "Segmented" field set to 1 in Territory table for Terrxxx.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/11/23.	wmk.	original code.
-- * 2/12/23.	wmk.	.open statement added to Jumpto.sql; PrevCounts references
-- * 			 removed; bug fix Defxxx corrected to Defsxxx; exit conditions
-- *			 documented.
-- *
-- * Notes. segdefs contains a set of WHERE clauses with the following pattern:
-- *	WHERE UnitAddress LIKE '%street1%'
-- *       OR UnitAddress LIKE '%street2%'
-- *	   OR (UnitAddress LIKE '%street3%'
-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n1
-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n2
-- *         AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT)%2 = 1)
-- *
-- * if TerrIDData.SegDefs already has entries for Territoryxxx, this query will do nothing.
-- * test code... this query stops just short, creating Jumpto.sql in /Special.
-- *
-- * This query is the last in the sequence; it uses the table EndMessage to write
-- * a script to Jumpto.sql that issues the "complete" or "abandoned" message..
-- *
-- * tables.
-- *	EndMessage - ending message table; messages written by Jumpto.sql
-- *	308Counts = .status, DefLines, status=0 if Def308
-- *	DefExists,status = 0 if Defs308 table exists
-- *
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'

--DROP TABLE IF EXISTS EndMessage;
--CREATE TABLE EndMessage(
-- msg TEXT);
 
DROP TABLE IF EXISTS "308Counts";
CREATE TEMP TABLE "308Counts"(
 DefLines INTEGER )
 ;

INSERT INTO EndMessage(msg)
VALUES("  ** AddSegDefs FAILED - Check TerrIDData database for territory 308 **");

CREATE TEMP TABLE DefExists(
 status INTEGER)
 ;
INSERT INTO DefExists(status)
SELECT EXISTS(
SELECT name FROM sqlite_schema
 WHERE type is 'table'
   AND name is 'Defs308');
   
-- -------------- insert records here ---------------------------;
-- * unconditionally insert new records;
INSERT INTO SegDefs(TerriD, dbName, sqldef)
SELECT '308', 'SCPA', newsql
FROM Defs308;

-- set ending message;
DELETE FROM EndMessage;

INSERT INTO EndMessage(msg)
VALUES('  AddSegDefs for 308 complete.');

DROP TABLE IF EXISTS Defs308;

-- * ensure Segmented flag set if there are defs for this territory;
UPDATE Territory
SET Segmented =
CASE WHEN (SELECT COUNT() TerrID FROM SegDefs
 WHERE TerrID IS '308') > 0
 THEN 1
ELSE 0
END 
WHERE TerrID IS '308';


-- ---------- write completion message --------------;
-- do this in all cases; write to EndMessage code to Jumpto.sql;
-- entry. 308Counts.DefLines = line count
.mode csv
.headers OFF
.separator "|"
.output '$pathbase/$rupath/Special/Jumpto.sql'
DROP TABLE IF EXISTS JumptoSQL;
CREATE TEMP TABLE JumptoSQL(
 sqlsrc TEXT);
-- * write SQL source code to table then export;

-- .open database line;
INSERT INTO JumptoSQL
VALUES(".open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/TerrIDData.db'");


-- line 1;
INSERT INTO JumptoSQL
VALUES('SELECT * FROM EndMessage;');

-- line 3;
INSERT INTO JumptoSQL
VALUES('.quit');

SELECT * FROM JumptoSQL;
--========== end block which writes to Jumpto.sql =============;

.quit
-- ==============================================================;
-- more experimental code...;


DROP TABLE IF EXISTS "308Counts";
CREATE TEMP TABLE "308Counts"(
 status INTEGER,
 DefLines INTEGER )
 ;
WITH a AS (SELECT status FROM DefExists)
INSERT INTO "308Counts"(status)
SELECT a.status
FROM SegDefs
INNER JOIN a
ON a.status IS NOT NULL
LIMIT 1;

UPDATE "308Counts"
SET DefLines =
CASE WHEN status > 0 THEN
 (SELECT COUNT() sqldef FROM SegDefs 
  WHERE TerrID is '308')
 ELSE 0
 END;


--===================================================================;
--CREATE TEMP TABLE "308Defs"(;
CREATE TEMP TABLE "308Defs"(
 newsql TEXT)
;
.mode csv
.headers OFF
.import '$pathbase/$rupath/Terr308/sqldefs.csv' "308Defs"
DROP TABLE IF EXISTS NewDefs;
CREATE TABLE NewDefs(
 newsql TEXT)
 ;

.import '$pathbase/$rupath/Terr308/segdefs.csv' NewDefs
INSERT INTO 

.mode csv
.headers OFF
.separator |
.output '$pathbase/$rupath/Special/Jumpto.sql'
WITH a AS (SELECT DefLines dl FROM "308Counts")
SELECT CASE WHEN a.dl > 0
THEN 'select '** '
END FROM "308Counts"
INNER JOIN a
ON a.dl > 0;

.read '$pathbase/$rupath/Special/Jumpto.sql'
.quit



--################################################
WITH a AS (SELECT DefLines dl FROM "308Counts"),
 b AS (SELECT newsql newdef FROM "308Defs")
INSERT INTO SegDefs(TerrID,dbName,sqldef)
SELECT CASE WHEN a.dl > 0
THEN '.quit'
END FROM 308Counts;

WITH a AS (SELECT DefLines dl FROM "308Counts")
SELECT CASE WHEN a.dl > 0
THEN sqldef
END sqldef FROM SegDefs
INNER JOIN a
ON a.dl > 0;
-- * END AddSegDefs.sql;
--========================================================
all the code from EXECUTE SQL..
WITH a AS (SELECT DefLines dl FROM "308Counts"),
 b AS (SELECT newsql newdef FROM "308Defs")
INSERT INTO SegDefs(TerrID,dbName,sqldef)
SELECT CASE WHEN a.dl = 0
'371','BayLakeMHP',b.newdef
FROM "308Defs"
UNION a,b;

WITH a AS (SELECT DefLines dl FROM "308Counts"),
 b AS (SELECT sqldef newdef FROM "308Defs")
INSERT INTO SegDefs(TerrID,dbName,sqldef)
SELECT CASE WHEN a.dl = 0
'371','BayLakeMHP',b.newdef
FROM "308Defs"
UNION a,b;


clear;

--this code only selects records if 308Counts.dl=0;
WITH a AS (SELECT DefLines dl FROM "308Counts"),
 b AS (SELECT newsql newdef FROM "308Defs")
SELECT CASE WHEN a.dl = 0
THEN '371' END terrid,
CASE WHEN a.dl = 0 THEN 'BayLakeMHP' END dname,
CASE WHEN a.dl = 0 THEN b.newdef END segsql
FROM "308Defs"
INNER JOIN a
ON a.dl = 0
INNER JOIN b
ON b.newdef NOT NULL;

WITH a AS (SELECT DefLines dl FROM "308Counts"),
 b AS (SELECT newsql newdef FROM "308Defs")
SELECT CASE WHEN a.dl = 0
THEN '371' END,
CASE WHEN a.dl = 0 THEN 'BayLakeMHP' END,
CASE WHEN a.dl = 0 THEN b.newdef END
FROM "308Defs"
INNER JOIN a
ON a.dl = 0
INNER JOIN b
ON b.newdef NOT NULL;

