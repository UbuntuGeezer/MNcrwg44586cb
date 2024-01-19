-- Spec141SC.sql - (template) extract SC records from Special dbs for territory 141.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
--	12/1/21.	wmk.
--
--	Special Databases and Tables.
--	-----------------------------
-- *	Spec141_SC.db - as main, new database for special SC territory 141.
-- *	  Spec_SCBridge - Bridge records from special database.
-- * 18 CountryClubMHP.db - as db18, SC download data for street <special-street>.
-- *	  Spec_SCBridge - template bridge records for units on <special-street>.
--
--	Dependencies.
--	--------------
--	make MakeSpecTerrQuery must be run to generate SQLTemp.sql with environment
--    vars and territory ID substituted in this template.
--
--	Modification History.
--	---------------------
--	8/15/21.	wmk.	original query.
--	12/1/21.	wmk.	edited for territory 141.
--;

.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr141/Spec141_SC.db'
DROP TABLE IF EXISTS Spec_SCBridge;
CREATE TABLE Spec_SCBridge
( "OwningParcel" TEXT NOT NULL, "UnitAddress" TEXT NOT NULL, "Unit" TEXT,
 "Resident1" TEXT, "Phone1" TEXT, "Phone2" TEXT, "RefUSA-Phone" TEXT, 
 "SubTerritory" TEXT, "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0, 
 "RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0, 
 "RecordDate" REAL DEFAULT 0, "SitusAddress" TEXT, "PropUse" TEXT, 
 "DelPending" INTEGER DEFAULT 0, "RecordType" TEXT);
-- repeat block below for each special database having recods in this territory.
-- at this point, we have not assigned territory IDs in the special database.
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Special'
   || '/CountryClubMHP.db'
   AS db29;
-- * Notes. WHERE clause below should match WHERE clause for Spec141RU.sql;
INSERT INTO Spec_SCBridge
SELECT * FROM db29.Spec_SCBridge 
WHERE UnitAddress LIKE '%turf%'
   OR UnitAddress LIKE '%bogie%'
   OR (UnitAddress LIKE '%s waterway%'
    AND CAST(SUBSTR(UnitAddress,1,3) AS INTEGER) >= 802
    AND CAST(SUBSTR(UnitAddress,1,3) AS INTEGER) <= 833)
   OR (UnitAddress LIKE '%s green%'
    AND CAST(SUBSTR(UnitAddress,1,3) AS INTEGER) >= 853
    AND CAST(SUBSTR(UnitAddress, 1,3) AS INTEGER) <= 875) ;
.quit
-- end Spec141SC;
