-- * DevelQueries.sql - Development queries for DNC management.
-- *	7/12/22.	wmk.

-- initialize "foreign" to rowid in DoNotCalls;
--UPDATE db8.DoNotCalls
--SET "Foreign" = 
--CASE 
--WHEN "Foreign" IS 1
-- THEN rowid
--ELSE "Foreign"
--END;

-- create FLAddress table within TerrIDData;
--"CREATE TABLE FLAddress
--(FLid INTEGER PRIMARY KEY AUTOINCREMENT,
-- PropID TEXT, Unit TEXT, Initials TEXT,
-- RecDate TEXT, LangID INTEGER)"

-- populate FLAddress table with current DoNotCalls;
--WITH a AS (SELECT "Foreign" dflid, PropID pid,
-- Unit ut, RecDate rd,
-- CASE
-- WHEN INSTR(upper(Notes),"SPANISH") > 0
--  THEN 1
-- WHEN INSTR(upper(Notes),"POLISH") > 0
--  THEN 2
-- WHEN INSTR(upper(Notes),"RUSSIAN") > 0
--  THEN 3
-- ELSE NULL
-- END lang
-- FROM DoNotCalls
-- WHERE dflid > 0 AND LENGTH(dflid) > 0
--   AND rd LIKE '2022-MM-DD'
--)
--INSERT INTO FLAddress
--SELECT dflid, pid, ut, 'wmk',
-- rd, lang FROM a);

-- create FLInfo table within TerrIDData;
--"CREATE TABLE FLInfo
--(Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT,
-- FLid INTEGER NOT NULL,
-- PRIMARY KEY(FLid),
-- FOREIGN KEY(FLid)
--  REFERENCES FLAddress(FLid))"

-- populate FLInfo with existing records from DoNotCalls;
--WITH a AS(SELECT Name nm, UnitAddress ad, Unit ut, Phone ph, Notes nt,
--  ZipCode zc, "Foreign" dflid FROM DoNotCalls
-- WHERE dflid > 0 AND LENGTH(dflid) > 0)
--INSERT INTO FLInfo
--SELECT nm, ad, ut, ph, nt, zc, dflid FROM a;

-- create FLCong in TerrIDData;
--CREATE TABLE FLCong (7/12/22 done)
--(LangID INTEGER PRIMARY KEY AUTOINCREMENT,
-- Lang TEXT, CongName TEXT, CongAddress TEXT);

-- select UnitAddress and PropID from DoNotCalls
-- where UnitAddress has a comma;
WITH a AS(select 
case
WHEN INSTR(UnitAddress,',') > 0 
THEN substr(unitaddress,1,
instr(unitaddress,',')-1)
ELSE ''
END streetonly, PropID pid
 from DoNotCalls)
SELECT UnitAddress, PropID from DoNotCalls
where PropID in (select pid FROM a
  where streetonly NOTNULL);
