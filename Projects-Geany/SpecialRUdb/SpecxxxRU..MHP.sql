-- SpecxxxRU.sql - (template) extract RU records from Special dbs for territory xxx.
--	11/12/21.	wmk.
--
--	Special Databases and Tables.
--	-----------------------------
-- *	Specxxx_RU.db - as main, new database for special SC territory xxx.
-- *	  Spec_SCBridge - Bridge records from special database.
-- * 19 BayIndiesMHP.db - as db18, SC download data for street <special-street>.
-- *	  Spec_RUBridge - template bridge records for units on <special-street>.
--
--	Dependencies.
--	--------------
--	make MakeSpecTerrQuery must be run to generate SQLTemp.sql with environment
--    vars and territory ID substituted in this template.
--
--	Modification History.
--	---------------------
-- * 8/15/21.	wmk.	original query.
-- * 11/11/21.	wmk.	edited for territory 235; SELECT changed to match RegenSpecDB.
-- * 11/12/21.	wmk.	bug fix residual reference to 601 removed.
--;

.open '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Specxxx_RU.db'
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
--* <special-db>;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/<special-db>.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terrxxx_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
.quit
-- end SpecxxxRU;
