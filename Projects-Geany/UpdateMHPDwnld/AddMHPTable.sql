-- AddMHPTable.sq - Add Terr244_MHP table to MHP territory template.
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--	7/4/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 7/4/21.	wmk.	original code.
-- *
-- * Notes. AddMHPTable adds the table Terr244_MHP to any RU territory
-- * db. The table has the same structure as the polygon data .csv
-- * record order. This table is initially populated with the records
-- * from the Terr244_RUPoly table. They are the sorted RURaw download
-- * records from the current download data in use.
-- *;

-- * subquery list.
-- * --------------
-- * AddMHPTable - Add Terr244_MHP table to MHP territory.
-- *;

-- ** AddMHPTable **********
-- *	7/4/21.	wmk.
-- *------------------------
-- *
-- * AddMHPTable - Add Terr244_MHP table to MHP territory.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *;

.open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr244/Terr244_RU.db
DROP TABLE IF EXISTS Terr244_MHP;
CREATE TABLE Terr244_MHP
 ("Last Name" TEXT,"First Name" TEXT, "House Number" TEXT,
  "Pre-directional" TEXT,"Street" TEXT, "Street Suffix" TEXT,
  "Post-directional" TEXT,"Apartment Number" TEXT, "City" TEXT,
  "State" TEXT,"ZIP Code" TEXT, "County Name" TEXT,
  "Phone Number" TEXT);
INSERT INTO Terr244_MHP
SELECT * FROM Terr244_RUPoly;
.quit

-- ** END AddMHPTable**********;
