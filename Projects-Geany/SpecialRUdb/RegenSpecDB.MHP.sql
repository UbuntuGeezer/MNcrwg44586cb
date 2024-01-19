-- RegenSpecDB.sq- Regenerate Specxxx_RU.db in RU territory folder (template).
--	4/24/22.	wmk.
-- copy and edit this SQL template to territory RU download folder.
-- * Modification History.
-- * ---------------------
-- * 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
-- *			 *congterr*, *conglib* env vars introduced.
-- * Legacy mods.
-- * 8/15/21.	wmk.	original code; using BayIndies.db
-- * 11/11/21.	wmk.	change to BayIndiesMHP.db; change to use UnitAddress
-- *					fields in Terr235_SC.db.Terr235_SCBridge as template
-- *					for extraction from Special db.
-- * 11/12/21.	wmk.	bug fix where select using OwningParcel, must use 
-- *					UnitAddress for MHP.
.cd '$pathbase'
.cd './RawData/RefUSA/RefUSA-Downloads/Terrxxx'
--.trace 'Procs-Dev/SQLTrace.txt'
--.cd './Special'
-- .open 'Specxxx_RU.db';
--#echo $DB_NAME;
.open 'Specxxx_RU.db' 
-- drop old version of Special Bridge and recreate;
DROP TABLE IF EXISTS Spec_RUBridge;
CREATE TABLE Spec_RUBridge
( OwningParcel TEXT NOT NULL,
 UnitAddress TEXT NOT NULL,
 Unit TEXT, Resident1 TEXT, 
 Phone1 TEXT,  Phone2 TEXT,
 "RefUSA-Phone" TEXT, SubTerritory TEXT,
 CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,
 RSO INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
 RecordDate REAL DEFAULT 0,
 SitusAddress TEXT, PropUse TEXT,
  DelPending INTEGER DEFAULT 0,
 RecordType TEXT);
ATTACH '$pathbase/RawData/SCPA'
 || '/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
 AS db11;
-- Now attach Special databases and select/insert their records;
-- and populate the RUBridge table;
.cd '../Special'
--* <special-db>;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/<special-db>.db'
   AS db29;
WITH a AS (SELECT UnitAddress AS StreetAddr
 FROM db11.Terrxxx_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE upper(UnitAddress) IN (SELECT StreetAddr FROM a);
DETACH db29;
--*;
.quit
-- end RegenSpecDB.MHP.sql;
