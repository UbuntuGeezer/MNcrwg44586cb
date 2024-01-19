-- * NewLetter.psq/sql - Create new letter territory SQL.
-- *	2/20/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/20/23.	wmk.	VeniceNTerritory/NVenAll > Terr86777; change to use
-- *			 *pathbase, *scpath.
-- * 2/21/23.	wmk.	correct HouseNumber placement in Terrxxx_SCPoly
-- * Legacy mods.
-- * 9/20/21.	original  code (for RUNewLetter).
-- * 9/21/21.	modified for use with SCNewLetter.
-- * 10/4/21.	bug fix in output path for Mapxxx_SC.csv; 632 hardwired
-- *			in some code replaced with y yy.
-- * 10/11/21.	documentation added; Unit field added by name into
-- *			table Lett220_TS replacing unnamed field before City.
-- * 10/22/21.	bug fix DROP TABLE Lett220_TS was incorrect.
-- *
-- * Notes. NewLetter.psq is transformed into NewLetter.sql by DoSed.sh
-- * NewLetter.sql performs the following operations:
-- *	open a new database SCPA-Downloads/Terr220/Terr220_SC.db
-- *	create table Terr220_SCPoly with fields matching SCPA polygon download
-- *	import raw download into table Terrxxx_TSRaw
-- *	copy TSRaw records into SCPoly table
-- *	create table Terrxxx_SCBridge and populate from SCPoly records
-- *	set OwningParcel, Resident1, SitusAddress, PropUse, and RecordType
-- *	 from Terr86777 SCPA records
-- *	set RecordType fields to correct record type for PropUse
-- * The Terrxxx_SC.db now has the basic SC download data.
-- * AddZips needs to run to add in the zip codes to the UnitAddress,s
-- * the "TIDY" utility needs to run to tidy up the records just added.

.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr220/Terr220_SC.db'
DROP TABLE IF EXISTS Terr220_SCPoly;
CREATE TABLE Terr220_SCPoly 
( Account TEXT, Name TEXT, Name2 TEXT, ADDRESS TEXT, CITY TEXT, 
STATE TEXT, ZIP TEXT, COUNTRY TEXT, LOCATIONNAME TEXT, 
LOCATIONSTREET TEXT, LOCATIONDIRECTION TEXT, UNIT TEXT, 
LOCATIONCITY TEXT, LOCATIONZIP TEXT);
 -- import Lett220_TS.csv into Terr220_SC.db.Terr220_TSRaw;
DROP TABLE IF EXISTS Terr220_TSRaw;
CREATE TABLE Terr220_TSRaw
(AreaName TEXT, HouseNumber TEXT, Street1 TEXT, Street2 TEXT,
 Street3 TEXT, Unit TEXT, City TEXT, Empty TEXT, State TEXT, Zip TEXT );
.headers ON
.mode csv
.separator ,
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr220/Lett220_TS.csv' Terr220_TSRaw
--DROP TABLE IF EXISTS Terr220_TSRaw;
--ALTER TABLE Lett220_TS RENAME TO Terr220_TSRaw;
-- now populate Terr220_SCPoly with data from Terr220_TSRaw;
INSERT INTO Terr220_SCPoly(LOCATIONNAME,LOCATIONSTREET,UNIT,LOCATIONCITY,LOCATIONZIP)
SELECT HouseNumber, 
 Street1 || ' ' || Street2 || ' ' || Street3, Unit,
 City, Zip
 FROM Terr220_TSRaw;

 -- now populate TerrSCBridge from Terr_SCPoly;
 DROP TABLE IF EXISTS Terr220_SCBridge;
CREATE TABLE Terr220_SCBridge
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
-- now populate the SCBridge table;
WITH a AS (SELECT CASE WHEN LocationDirection is not NULL
 THEN LocationName || '   ' || LocationStreet || ' ' || LocationDirection
 ELSE LocationName || '   ' || LocationStreet
 END
 AS StreetAddr, Unit AS PUnit,
 Date('now') AS RecDate
FROM Terr600_SCPoly) 
INSERT INTO Terr220_SCBridge
( OwningParcel, UnitAddress,
 Unit, CongTerrID, RecordDate)
SELECT '-', StreetAddr,
  PUnit,'220',RecDate
FROM a;
-- now select all the records just created and make a pseudo Map220_SC.csv;
-- this .csv will be used in the unlikely event that SCNewTerritory gets run
-- so there is a .csv file to pick up..;
.headers ON
.mode csv
.separator ,
.output '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr220/Map220_SC.csv'
select * from Terr220_SCPoly;

-- now set OwningParcel, Resident1, SitusAddress, PropUse, and RecordType from
-- TerritoryNVenice. Terr86777 and SCPropUse tables;
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
 AS db2;

WITH a AS (SELECT "Account #" AS Acct,
 CASE 
 WHEN LENGTH("Owner 3") > 0
  THEN "Owner 1" || ', ' || "Owner 2" || ', ' || "Owner 3"
 WHEN LENGTH("Owner 2") > 0
  THEN "Owner 1" || ', ' || "Owner 2"
 ELSE "Owner 1"
 END As WhoIsThere,
 "situs address (property address)" AS Situs,
 TRIM(SUBSTR("situs address (property address)",1,35)) AS StreetAddr,
 "property use code" AS SCPropUse,
 CASE 
 WHEN "Homestead Exemption" IS 'YES'
  THEN '*'
 ELSE ''
 END AS Hstead
 FROM Terr86777
 WHERE StreetAddr IN (SELECT UPPER(TRIM(UnitAddress))
  FROM Terr220_SCBridge) )
UPDATE Terr220_SCBridge
SET OwningParcel =
CASE 
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )
ELSE OwningParcel
END,
 Resident1 =
CASE 
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT WhoIsThere FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )
ELSE Resident1
END, 
 SitusAddress = 
CASE 
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )
ELSE SitusAddress
END,
 Phone2 = 
CASE 
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Hstead FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )
ELSE Phone2
END, 
 PropUse =
CASE 
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT SCPropUse FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )
ELSE PropUse
END
WHERE OwningParcel IS '-';

-- set record types;
UPDATE Terr220_SCBridge
SET RecordType = 
CASE 
WHEN PropUse IN (SELECT Code FROM db2.SCPropUse)
 THEN (SELECT RType FROM db2.SCPropUse
  WHERE Code IS PropUse)
ELSE RecordType
END
;
-- *;
-- Attach TerrIDData.db and extract Terr220Hdr.csv, saving into folder
--  TerrData/Terr220/Working-Files;
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777'
	||		'/DB-Dev/TerrIDData.db'
	AS db4;
-- pragma db4.table_info(Territories);
.headers ON
.mode csv
.separator ,
.output '/home/vncwmk3/Territories/FL/SARA/86777/TerrData/Terr220/Working-Files/Terr220Hdr.csv'
SELECT * FROM db4.Territory
WHERE TerrID is '220';	
.quit

--**************************************************************************;
.open /home/vncwmk3/Territories/RefUSA/RefUSA-Downloads/Terr220/Terr220_RU.db'
CREATE TABLE Terr220_RUPoly ("Last Name" TEXT,"First Name" TEXT,
 "House Number" TEXT, "Pre-directional" TEXT,"Street" TEXT, 
 "Street Suffix" TEXT, "Post-directional" TEXT,"Apartment Number" TEXT, 
 "City" TEXT,"State" TEXT,"ZIP Code" TEXT, "County Name" TEXT, 
 "Phone Number" TEXT);
 -- import Lett220_TS.csv into Terr220.db.Terr220_TSRaw;
.import '/home/vncwmk3/Territories/RefUSA/RefUSA-Downloads/Terr220/Lett220_TS.csv' Terr220_TSRaw
-- now populate Terr220_RUPoly with data from Terr220_TSRaw;
INSERT INTO Terr220_RUPoly
SELECT '', '', HouseNumber, '', Street1 || ' ' || Street2,
 Street3, ' ',' ',City,"State",Zip,'', ''
 FROM Terr220_TSRaw;

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
'
 Resident1 =
CASE
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN
 
 CASE 
 WHEN LENGTH("Owner 3") > 0
  THEN "Owner 1" || ', ' || "Owner 2" || ', ' || "Owner 3"
 WHEN LENGTH("Owner 2") > 0
  THEN "Owner 1" || ', ' || "Owner 2"
 ELSE "Owner 1"
 END As WhoIsThere

END, 

CASE
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN
 CASE 
 WHEN LENGTH(SELECT Own3 FROM a 
   WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) ) > 0
  THEN (SELECT Own1 || ', ' || Own2 || ', ' || Own3 FROM a
   WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) ) 
 WHEN LENGTH(SELECT Own2 FROM a 
   WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) ) > 0
  THEN (SELECT Own1 || ', ' || Own2  FROM a
   WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) ) 
 ELSE (SELECT Own1 FROM a
   WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) ) 
 END
ELSE Resident1
END, 
