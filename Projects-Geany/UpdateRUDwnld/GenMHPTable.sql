-- GenMHPTable.sq - Generate the Terr107_MHP table from the Terr107_RUPoly table.
--	7/6/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 7/6/21.	wmk.	original code (multihost support included).
-- *;

-- * subquery list.
-- * --------------
-- * GenMHPTable - Generate the Terr107_MHP table from the Terr107_RUPoly table.
-- *;

-- ** GenMHPTable **********
-- *	7/6/21.	wmk.
-- *------------------------
-- *
-- * GenMHPTable - Generate the Terr107_MHP table from the Terr107_RUPoly table.
-- *
-- * Entry DB and table dependencies.
-- *	./Previous/Terr107_RU.db - as db30, previous download database
-- *	  Terr107_MHP table - MHP address list of territory 107
-- *	Terr107_RU.db - as main, current download database
-- *
-- * Exit DB and table results.
-- *	Terr107_RU.db - current download database, table Terr107_MHP added
-- *	  Terr107_MHP table - clone of previous download address list
-- *
-- * Notes. This query assumes the existence of the table Terr107_RUPOly
-- * in the Terr107_RU.db. It will create a new table Terr107_MHP and
-- * populate it with a copy of all Terr107_RUPoly records.
-- * (%)folderbase is used in place of ($)folderbase, since the calling
-- * shell will replace it with the environment var ($)folderbase.
-- *;

-- GenMHPTable.sql - copy ./Previous/Terr107_RU.db Terr237_MHP table.
.cd '/home/vncwmk3/Territories/RawData/RefUSA/RefUSA-Downloads'
.cd './Terr107'
.open 'Terr107_RU.db'
DROP TABLE IF EXISTS Terr107_MHP;
CREATE TABLE Terr107_MHP ("Last Name" TEXT,"First Name" TEXT,
 "House Number" TEXT, "Pre-directional" TEXT,"Street" TEXT,
  "Street Suffix" TEXT, "Post-directional" TEXT,"Apartment Number" TEXT,
  "City" TEXT, "State" TEXT,"ZIP Code" TEXT, "County Name" TEXT,
  "Phone Number" TEXT);
INSERT INTO Terr107_MHP
SELECT * FROM Terr107_RUPoly;
.quit

-- ** END GenMHPTable **********;
