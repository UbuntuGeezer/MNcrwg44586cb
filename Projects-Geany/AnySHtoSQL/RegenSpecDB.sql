#procbodyhere
pushd ./ > $TEMP_PATH/bitbucket.txt
-- RegenSpecDB.sq- Regenerate Spec288_RU.db in RU territory folder (template).
--	8/22/21.	wmk.
-- copy and edit this SQL template to territory RU download folder.
.cd '$folderbase/Territories'
.cd './RawData/RefUSA/RefUSA-Downloads/Terr288'
--.trace 'Procs-Dev/SQLTrace.txt'
--.cd './Special'
-- .open 'Spec288_RU.db';
--#echo $DB_NAME;
.open 'Spec288_RU.db' 
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
-- * fix OwningParcels in GondolaParkDr.db;
ATTACH '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/Terr288'
   || '/Terr288_SC.db'
   AS db11;
.cd '../Special'
ATTACH 'GondolaParkDr.db' AS db29;
-- * first, set parcelIDs in all GondolaParkDr.db records belonging to territory 288;
WITH a AS (SELECT OwningParcel AS Acct, UnitAddress AS StreetAddr,
 Unit AS TUnit FROM db11.Terr288_SCBridge)
UPDATE db29.Spec_RUBridge
SET OwningParcel =
CASE
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
   WHERE StreetAddr IS upper(trim(UnitAddress)) )
ELSE OwningParcel
END;
-- Now attach Special databases and select/insert their records;
-- and populate the RUBridge table;
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge 
 WHERE CAST(OWNINGPARCEL AS INTEGER) >= 411113017
  and  CAST(OWNINGPARCEL AS INTEGER) <= 411113080;
;
DETACH db29;
-- Repeat above block for each Special database.;
.quit
-- end RegenSpecDB_db.sq;

#endprocbody
