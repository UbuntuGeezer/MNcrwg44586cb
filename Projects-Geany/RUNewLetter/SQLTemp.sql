-- SQLTemp.sql - RUNewTerr raw .csv to .db.
.cd '/home/vncwmk3/Territories/FL/SARA/86777'
.cd './RawData/RefUSA/RefUSA-Downloads'
.cd './Terr600'
.open Terr600_RU.db 
DROP TABLE IF EXISTS Terr600_RURaw;
CREATE TABLE Terr600_RURaw
("Last Name" TEXT,"First Name" TEXT,
"House Number" TEXT,
"Pre-directional" TEXT,"Street" TEXT,
"Street Suffix" TEXT,
"Post-directional" TEXT,"Apartment Number" TEXT,
"City" TEXT,"State" TEXT,"ZIP Code" TEXT,
"County Name" TEXT,
"Phone Number" TEXT);
-- setup and import new records to Terr600_RURaw
.headers ON
.mode csv
.separator ,
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Terr600/Map600_RU.csv' Terr600_RURaw
DROP TABLE IF EXISTS Terr600_RUPoly;
CREATE TABLE Terr600_RUPoly
("Last Name" TEXT,"First Name" TEXT,
"House Number" TEXT,
"Pre-directional" TEXT,"Street" TEXT,
"Street Suffix" TEXT,
"Post-directional" TEXT,"Apartment Number" TEXT,
"City" TEXT,"State" TEXT,"ZIP Code" TEXT,
"County Name" TEXT,
"Phone Number" TEXT);
INSERT INTO Terr600_RUPoly 
("Last Name","First Name",
"House Number",
"Pre-directional","Street",
"Street Suffix",
"Post-directional","Apartment Number",
"City","State","ZIP Code",
"County Name",
"Phone Number" ) 
SELECT * FROM Terr600_RURaw  
 ORDER BY "Street", "Post-directional",
    "House Number", "Apartment Number" ;
DROP TABLE IF EXISTS Terr600_RUBridge;
CREATE TABLE Terr600_RUBridge
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
WITH a AS (SELECT "Last Name",
 "First Name", TRIM("House Number") AS House,
 "Pre-directional",
"Street", "Street Suffix", "Post-Directional",
 "Apartment Number",
"Phone Number" FROM Terr600_RUPoly) 
INSERT INTO Terr600_RUBridge
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
 "", "", "Phone Number", "", "600", NULL, NULL, NULL,
  DATE('now'), "", "", NULL,NULL 
FROM a;
.quit
