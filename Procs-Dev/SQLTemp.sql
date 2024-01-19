-- SQLTemp.sql - RUNewTerr raw .csv to .db.
.cd '/home/vncwmk3/Territories/MN/CRWG/44586'
.cd './RawData/RefUSA/RefUSA-Downloads'
.cd './Terr275'
.open Terr275_RU.db 
DROP TABLE IF EXISTS Terr275_RURaw;
CREATE TABLE Terr275_RURaw
("Last Name" TEXT,"First Name" TEXT,
"House Number" TEXT,
"Pre-directional" TEXT,"Street" TEXT,
"Street Suffix" TEXT,
"Post-directional" TEXT,"Apartment Number" TEXT,
"City" TEXT,"State" TEXT,"ZIP Code" TEXT,
"County Name" TEXT,
"Phone Number" TEXT);
-- setup and import new records to Terr275_RURaw
.headers ON
.mode csv
.separator ,
.import '/home/vncwmk3/Territories/MN/CRWG/44586/RawData/RefUSA/RefUSA-Downloads/Terr275/Map275_RU.csv' Terr275_RURaw
DROP TABLE IF EXISTS Terr275_RUPoly;
CREATE TABLE Terr275_RUPoly
("Last Name" TEXT,"First Name" TEXT,
"House Number" TEXT,
"Pre-directional" TEXT,"Street" TEXT,
"Street Suffix" TEXT,
"Post-directional" TEXT,"Apartment Number" TEXT,
"City" TEXT,"State" TEXT,"ZIP Code" TEXT,
"County Name" TEXT,
"Phone Number" TEXT);
INSERT INTO Terr275_RUPoly 
("Last Name","First Name",
"House Number",
"Pre-directional","Street",
"Street Suffix",
"Post-directional","Apartment Number",
"City","State","ZIP Code",
"County Name",
"Phone Number" ) 
SELECT * FROM Terr275_RURaw  
 ORDER BY "Street", "Post-directional",
    "House Number", "Apartment Number" ;
DROP TABLE IF EXISTS Terr275_RUBridge;
CREATE TABLE Terr275_RUBridge
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
"Phone Number" FROM Terr275_RUPoly) 
INSERT INTO Terr275_RUBridge
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
 "", "", "Phone Number", "", "275", NULL, NULL, NULL,
  DATE('now'), "", "", NULL,NULL 
FROM a;
.quit
