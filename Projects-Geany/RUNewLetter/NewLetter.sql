-- NewLetter.sql - Create new letter territory SQL.
--	9/21/21.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 9/20/21.	wmk.	original code.
-- * 9/21/21.	wmk.	stubbed for SPECIAL processing.
-- *;
.quit
.open '/media/ubuntu/Windows/Users/Bill/Territories/RawData/RefUSA/RefUSA-Downloads/Terr632/Terr632_RU.db'
DROP TABLE IF EXISTS Terr632_RUPoly;
CREATE TABLE Terr632_RUPoly ("Last Name" TEXT,"First Name" TEXT,
 "House Number" TEXT, "Pre-directional" TEXT,"Street" TEXT, 
 "Street Suffix" TEXT, "Post-directional" TEXT,"Apartment Number" TEXT, 
 "City" TEXT,"State" TEXT,"ZIP Code" TEXT, "County Name" TEXT, 
 "Phone Number" TEXT);
 -- import Lett632_TS.csv into Terr632.db.Terr632_TSRaw;
.headers ON
.mode csv
.separator ,
.import '/media/ubuntu/Windows/Users/Bill/Territories/RawData/RefUSA/RefUSA-Downloads/Terr632/Lett632_TS.csv' Terr632_TSRaw
-- now populate Terr632_RUPoly with data from Terr632_TSRaw;
INSERT INTO Terr632_RUPoly
SELECT '', '', HouseNumber, '', Street1 || ' ' || Street2,
 Street3, ' ',' ',City,"State",Zip,'', ''
 FROM Terr632_TSRaw;
 -- now populate Terr_RUBridge from Terr_RUPoly;
 DROP TABLE IF EXISTS Terr632_RUBridge;
CREATE TABLE Terr632_RUBridge
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
-- now populate the RUBridge table;
WITH a AS (SELECT "Last Name",
 "First Name", TRIM("House Number") AS House,
 "Pre-directional",
"Street", "Street Suffix", "Post-Directional",
 "Apartment Number",
"Phone Number" FROM Terr632_RUPoly) 
INSERT INTO Terr632_RUBridge
( "OwningParcel", "UnitAddress",
 "Unit", "Resident1", "Phone1", "Phone2",
 "RefUSA-Phone", "SubTerritory", "CongTerrID", "DoNotCall",
  "RSO", "Foreign", "RecordDate", "SitusAddress",
  "PropUse", "DelPending", "RecordType")
SELECT "-",
   CASE
   WHEN LENGTH("Pre-directional") > 0
    THEN
    CASE
    WHEN LENGTH("Street Suffix") > 0
     THEN
		TRIM(House || "   " || TRIM("Pre-Directional") || " "
		|| "Street" || " "
		|| TRIM("Street Suffix") || " " || "Post-Directional")
     ELSE
		TRIM(House || "   " ||TRIM("Pre-Directional") || " "
		|| "Street" || " "
		|| "Post-Directional")
     END
  ELSE
    CASE
    WHEN LENGTH("Street Suffix") > 0
     THEN
		TRIM(House || "   "
		|| "Street" || " "
		|| TRIM("Street Suffix") || " " || "Post-Directional")
    ELSE
		TRIM(House || "   "
		|| "Street" || " "
		|| "Post-Directional")
    END
  END,
  "Apartment Number",
  TRIM("First Name") || " " || TRIM("Last Name"),
 "", "", "Phone Number", "", "$TID", NULL, NULL, NULL,
  DATE('now'), "", "", NULL,NULL 
FROM a;
-- now select all the records just created and make a pseudo Map632_RU.csv;
.headers ON
.mode csv
.separator ,
.output '/media/ubuntu/Windows/Users/Bill/Territories/RawData/RefUSA/RefUSA-Downloads/Terr632/Map632_RU.csv'
select * from Terr632_RUPoly;

.quit

--**************************************************************************;
.open /media/ubuntu/Windows/Users/Bill/Territories/RefUSA/RefUSA-Downloads/Terr632/Terr632_RU.db'
CREATE TABLE Terr632_RUPoly ("Last Name" TEXT,"First Name" TEXT,
 "House Number" TEXT, "Pre-directional" TEXT,"Street" TEXT, 
 "Street Suffix" TEXT, "Post-directional" TEXT,"Apartment Number" TEXT, 
 "City" TEXT,"State" TEXT,"ZIP Code" TEXT, "County Name" TEXT, 
 "Phone Number" TEXT);
 -- import Lett632_TS.csv into Terr632.db.Terr632_TSRaw;
.import '/media/ubuntu/Windows/Users/Bill/Territories/RefUSA/RefUSA-Downloads/Terr632/Lett632_TS.csv' Terr632_TSRaw
-- now populate Terr632_RUPoly with data from Terr632_TSRaw;
INSERT INTO Terr632_RUPoly
SELECT '', '', HouseNumber, '', Street1 || ' ' || Street2,
 Street3, ' ',' ',City,"State",Zip,'', ''
 FROM Terr632_TSRaw;

#
#   CASE
#   WHEN LENGTH("Street Suffix") > 0 
#		AND LENGTH("Pre-Directional") = 0 
#   THEN
#		House || "   " || "Street" || " "
#		|| TRIM("Street Suffix") || " " || "Post-Directional"
#   ELSE
#		House || "   " || "Street" || " "
#		|| "Post-Directional"
#   END,
#
