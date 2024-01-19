-- Spec101RU.sql - (template) extract RU records from Special dbs for territory 101.
--	9/18/21.	wmk.
--
--	Special Databases and Tables.
--	-----------------------------
-- *	Spec101_RU.db - as main, new database for special SC territory 101.
-- *	  Spec_SCBridge - Bridge records from special database.
-- * 18 TheEsplanade.db - as db18, SC download data for The Esplanade.
-- *	  Spec_RUBridge - template bridge records for units on TheEsplanade.
--
--	Dependencies.
--	--------------
--	make MakeSpecTerrQuery must be run to generate SQLTemp.sql with environment
--    vars and territory ID substituted in this template.
--
--	Modification History.
--	---------------------
--	8/15/21.	wmk.	original query.
--	9/18/21.	wmk.	edited for territory 101.
--;

.open '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terr101/Spec101_RU.db'
DROP TABLE IF EXISTS Spec_RUBridge;
CREATE TABLE Spec_RUBridge
( "OwningParcel" TEXT NOT NULL, "UnitAddress" TEXT NOT NULL, "Unit" TEXT,
 "Resident1" TEXT, "Phone1" TEXT, "Phone2" TEXT, "RefUSA-Phone" TEXT, 
 "SubTerritory" TEXT, "CongTerrID" TEXT, "DoNotCall" INTEGER DEFAULT 0, 
 "RSO" INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0, 
 "RecordDate" REAL DEFAULT 0, "SitusAddress" TEXT, "PropUse" TEXT, 
 "DelPending" INTEGER DEFAULT 0, "RecordType" TEXT);
-- repeat block below for each special database having recods in this territory.
-- at this point, we have not assigned territory IDs in the special database.
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/TheEsplanade.db'
   AS db18;
INSERT INTO Spec_RUBridge
SELECT * FROM db18.Spec_RUBridge 
where cast(HouseNumber AS INT) = 845
ORDER BY HOUSENUMBER, ApartmentNumber
;
.quit
-- end Spec101RU;
