-- SpecxxxSC.sql - (template) extract SC records from Special dbs for territory xxx.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--	8/15/21.	wmk.
--
--	Special Databases and Tables.
--	-----------------------------
-- *	Specxxx_SC.db - as main, new database for special SC territory xxx.
-- *	  Spec_SCBridge - Bridge records from special database.
-- * 18 <special-db>.db - as db18, SC download data for street <special-street>.
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
--;

.open '$pathbase/RawData/SCPA/SCPA-Downloads/Terrxxx/Specxxx_SC.db'
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
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Special'
   || '/<special-db>.db'
   AS db18;
INSERT INTO Spec_SCBridge
SELECT * FROM db18.Spec_SCBridge 
 WHERE CAST(OWNINGPARCEL AS INTEGER) >= 411113001
  and  CAST(OWNINGPARCEL AS INTEGER) <= 411113016;
.quit
-- end SpecxxxSC;
