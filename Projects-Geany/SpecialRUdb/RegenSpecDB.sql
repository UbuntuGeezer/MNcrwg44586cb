-- * RegenSpecDB.sql- Regenerate Specxxx_RU.db in RU territory folder.
-- *	3/26/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/24/22.	wmk.	original code; template.
-- * 6/19/22.	wmk.	edited for territory xxx.
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
( "OwningParcel" TEXT NOT NULL,
 "UnitAddress" TEXT NOT NULL,
 "Unit" TEXT, "Resident1" TEXT, 
 "Phone1" TEXT,  "Phone2" TEXT,
 "RefUSA-Phone" TEXT, "SubTerritory" TEXT,
 "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0,
 "RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
 "RecordDate" REAL DEFAULT 0,
 "SitusAddress" TEXT, "PropUse" TEXT,
  "DelPending" INTEGER DEFAULT 0,
 "RecordType" TEXT);
ATTACH '$pathbase/RawData/SCPA'
 || '/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
 AS db11;
-- Now attach Special databases and select/insert their records;
-- and populate the RUBridge table;
.cd '../Special'
-- * InnerDR.db -  Inner Dr RU download
-- * Outer Dr - Outer Dr download
--*;
-- * InnerDr;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/InnerDr.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terrxxx_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE CongTerrID IS 'xxx';
DETACH db29;
--*;
-- * OuterDr;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/OuterDr.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terrxxx_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE CongTerrID IS 'xxx';
DETACH db29;
--*;
--** END RegenSpecDB **********;

