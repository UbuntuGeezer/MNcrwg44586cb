-- * NewFromSegDefs.psq/sql - Create new letter territory SQL.
-- *	2/25/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/25/23.	wmk.	original code; adapted from NewLetter.sql.
-- * Legacy mods.
-- * 2/20/23.	wmk.	VeniceNTerritory/NVenAll > Terr86777; change to use
-- *			 *pathbase, *scpath.
-- * 2/21/23.	wmk.	correct HouseNumber placement in Terrxxx_SCPoly
-- * Legacy mods.
-- * 9/20/21.	original  code (for RUNewFromSegDefs).
-- * 9/21/21.	modified for use with SCNewFromSegDefs.
-- * 10/4/21.	bug fix in output path for Mapxxx_SC.csv; 632 hardwired
-- *			in some code replaced with y yy.
-- * 10/11/21.	documentation added; Unit field added by name into
-- *			table Lett106_TS replacing unnamed field before City.
-- * 10/22/21.	bug fix DROP TABLE Lett106_TS was incorrect.
-- *
-- * Notes. NewFromSegDefs.psq is transformed into NewFromSegDefs.sql by DoSed.sh
-- * NewFromSegDefs.sql performs the following operations:
-- *	open a new database SCPA-Downloads/Terr106/Terr106_SC.db
-- *	create table Terr106_SCPoly with fields matching SCPA polygon download
-- *	import raw download into table Terrxxx_TSRaw
-- *	copy TSRaw records into SCPoly table
-- *	create table Terrxxx_SCBridge and populate from SCPoly records
-- *	set OwningParcel, Resident1, SitusAddress, PropUse, and RecordType
-- *	 from Terr86777 SCPA records
-- *	set RecordType fields to correct record type for PropUse
-- * The Terrxxx_SC.db now has the basic SC download data.
-- * AddZips needs to run to add in the zip codes to the UnitAddress,s
-- * the "TIDY" utility needs to run to tidy up the records just added.

.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr106/Terr106_SC.db'
 -- import Lett106_TS.csv into Terr106_SC.db.Terr106_TSRaw;
DROP TABLE IF EXISTS Terr106_TSRaw;
CREATE TABLE Terr106_TSRaw
(AreaName TEXT, HouseNumber TEXT, Street1 TEXT, Street2 TEXT,
 Street3 TEXT, Unit TEXT, City TEXT, Empty TEXT, State TEXT, Zip TEXT );
 -- this block inserted data by using territory servant...;

.headers ON
.mode csv
.separator ,
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr106/Lett106_TS.csv' Terr106_TSRaw
 -- above block inserted data by using territory servant...;

DROP TABLE IF EXISTS Terr106_TSRaw;
CREATE TABLE Terr106_TSRaw
(AreaName TEXT, HouseNumber TEXT, Street1 TEXT, Street2 TEXT,
 Street3 TEXT, Unit TEXT, City TEXT, Empty TEXT, State TEXT, Zip TEXT );
 -- this block inserted data by using territory servant...;

--.headers ON
--.mode csv
--.separator ,
--.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr106/Lett106_TS.csv' Terr106_TSRaw
 -- above block inserted data by using territory servant...;
WITH a AS (SELECT * FROM Terr86777
--inserthere
WHERE "situs address (property address)" LIKE '214%bayshore cir%'
OR  "situs address (property address)" LIKE '216%bayshore cir%'
)
INSERT INTO Terr106_TSRaw(AreaName,HouseNumber,Street1,
   Unit,City,State,Zip)
SELECT 'Terr106', 
TRIM(SUBSTR("situs address (property address)",1,
     INSTR("situs address (property address)",' '))),
TRIM(SUBSTR("situs address (property address)",
	  INSTR("situs address (property address)",' ')),
     36-INSTR("situs address (property address)",' ')),
TRIM(SUBSTR("situs address (property address)",36)),
     "situs city", 'FL', "situs zip code"
FROM db2.Terr86777
 WHERE "situs address (property address)"
  IN (SELECT "situs address (property address)" FROM a);
--endwhere

DROP TABLE IF EXISTS Terr106_SCPoly;
CREATE TABLE Terr106_SCPoly 
( Account TEXT, Name TEXT, Name2 TEXT, ADDRESS TEXT, CITY TEXT, 
STATE TEXT, ZIP TEXT, COUNTRY TEXT, LOCATIONNAME TEXT, 
LOCATIONSTREET TEXT, LOCATIONDIRECTION TEXT, UNIT TEXT, 
LOCATIONCITY TEXT, LOCATIONZIP TEXT);
-- now populate Terr106_SCPoly with data from Terr106_TSRaw;
-- now populate Terr106_SCPoly with data from Terr106_TSRaw;
INSERT INTO Terr106_SCPoly(LOCATIONNAME,LOCATIONSTREET,UNIT,LOCATIONCITY,LOCATIONZIP)
SELECT HouseNumber,
 CASE WHEN Street3 NOTNULL
  THEN TRIM(Street1 || ' ' || Street2 || ' ' || Street3)
 WHEN StreeT2 NOTNULL
  THEN TRIM(Street1 || ' ' || Street2)
 ELSE Street1
 END,
  Unit,
 City, Zip
 FROM Terr106_TSRaw;

 -- now populate TerrSCBridge from Terr_SCPoly;
DROP TABLE IF EXISTS Terr106_SCBridge;
CREATE TABLE Terr106_SCBridge
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
 THEN TRIM(LocationName) || '   ' || TRIM(LocationStreet) || ' ' || TRIM(LocationDirection)
 ELSE TRIM(LocationName) || '   ' || TRIM(LocationStreet)
 END
 AS StreetAddr, Unit AS PUnit,
 Date('now') AS RecDate
FROM Terr106_SCPoly) 
INSERT INTO Terr106_SCBridge
( OwningParcel, UnitAddress,
 Unit, CongTerrID, RecordDate)
SELECT '-', StreetAddr,
  PUnit,'106',RecDate
FROM a;

-- now set RecordType fields;
WITH a AS (SELECT Code,RType FROM db2.SCPropUse)
UPDATE Terr106_SCBridge
SET RecordType =
CASE WHEN PropUse IN (SELECT Code FROM a)
 THEN (SELECT RType FROM a
  WHERE Code IS PropUse)
ELSE RecordType
END;

.quit
--======================================================================
-- now select all the records just created and make a pseudo Map106_SC.csv;
-- this .csv will be used in the unlikely event that SCNewTerritory gets run
-- so there is a .csv file to pick up..;
.headers ON
.mode csv
.separator ,
.output '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr106/Map106_SC.csv'
select * from Terr106_SCPoly;

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
  FROM Terr106_SCBridge) )
UPDATE Terr106_SCBridge
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
UPDATE Terr106_SCBridge
SET RecordType = 
CASE 
WHEN PropUse IN (SELECT Code FROM db2.SCPropUse)
 THEN (SELECT RType FROM db2.SCPropUse
  WHERE Code IS PropUse)
ELSE RecordType
END
;
-- *;
-- Attach TerrIDData.db and extract Terr106Hdr.csv, saving into folder
--  TerrData/Terr106/Working-Files;
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777'
	||		'/DB-Dev/TerrIDData.db'
	AS db4;
-- pragma db4.table_info(Territories);
.headers ON
.mode csv
.separator ,
.output '/home/vncwmk3/Territories/FL/SARA/86777/TerrData/Terr106/Working-Files/Terr106Hdr.csv'
SELECT * FROM db4.Territory
WHERE TerrID is '106';	
.quit


