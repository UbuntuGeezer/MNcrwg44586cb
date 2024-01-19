-- * RUSpecTerr_db.sql - RUSpecTerr raw .csv to .db template.
-- *	3/1/23.	wmk.
-- * Modification History.
-- * ---------------------
-- * 3/1/23.	wmk.	INSERT simplified using only populated fields; *csvdate
-- *			 environment var dependency; change to import from
-- *			 <special>.csv.imp to preseve date on .csv download file.
-- * Legacy mods.
-- * 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
-- *			 *congterr*, *conglib* env vars introduced.
-- * 4/25/22.	wmk.	bug fix in .import missing *pathbase*.
-- * Legacy mods.
-- * 11/28/21.	wmk.	bug fix where pre-directional not incorporated into
-- *					Bridge UnitAddress fields.
-- *;
-- If table <special-db> exists, leave it alone.
-- Create anew tables Spec_RURaw, Spec_RUPoly, Spec_RUBridge;
-- Create anew table TerrList, add count field;
-- Set CongTerrids from PolyTerri and MultiMail, updating TerrList.
-- * open files  ************************;
.cd '$pathbase'
.cd './RawData/RefUSA/RefUSA-Downloads'
--.trace 'Procs-Dev/SQLTrace.txt'
.cd './Special'
-- .open './DB/PolyTerri.db';
--#echo $DB_NAME;
.open $DB_NAME 
-- * create initial RURaw table.***************;
DROP TABLE IF EXISTS $TBL_NAME1;
-- insert CREATE TABLE for Terrxxx_RURaw here;
CREATE TABLE $TBL_NAME1
("Last Name" TEXT,"First Name" TEXT,
"House Number" TEXT,
"Pre-directional" TEXT,"Street" TEXT,
"Street Suffix" TEXT,
"Post-directional" TEXT,"Apartment Number" TEXT,
"City" TEXT,"State" TEXT,"ZIP Code" TEXT,
"County Name" TEXT,
"Phone Number" TEXT);
-- setup and import new records to $TBL_NAME1;
.headers ON
.mode csv
.separator ,
--# note. .csv file must not contain headers for batch .import
--#.import 'Map$TID.csv' $TBL_NAME;
.import '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/$CSV_NAME1.imp' $TBL_NAME1
UPDATE $TBL_NAME1
SET "House Number" = TRIM("House Number");
-- *;
-- * create Terrxxx_RUPoly, then populate with sorted RURaw records *******************;
DROP TABLE IF EXISTS $TBL_NAME2;
CREATE TABLE $TBL_NAME2
("Last Name" TEXT,"First Name" TEXT,
"House Number" TEXT,
"Pre-directional" TEXT,"Street" TEXT,
"Street Suffix" TEXT,
"Post-directional" TEXT,"Apartment Number" TEXT,
"City" TEXT,"State" TEXT,"ZIP Code" TEXT,
"County Name" TEXT,
"Phone Number" TEXT);
INSERT INTO $TBL_NAME2 
("Last Name","First Name",
"House Number",
"Pre-directional","Street",
"Street Suffix",
"Post-directional","Apartment Number",
"City","State","ZIP Code",
"County Name",
"Phone Number" ) 
SELECT * FROM $TBL_NAME1  
ORDER BY "Street", "Post-directional",
   CAST("House Number" AS INT), "Apartment Number" ;
-- *;
-- now create Bridge table. ******************************;
DROP TABLE IF EXISTS $TBL_NAME3;
CREATE TABLE $TBL_NAME3
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
"Phone Number" FROM $TBL_NAME2) 
INSERT INTO $TBL_NAME3
( "OwningParcel", "UnitAddress",
 "Unit", "Resident1",
 "RefUSA-Phone", "RecordDate")
SELECT "-",
CASE
   WHEN LENGTH("Pre-directional") > 0   -- have predirectional
   THEN
     CASE
	 WHEN LENGTH("Street Suffix") > 0
	 THEN
	  CASE
	  WHEN LENGTH("Post-directional") > 0
	  THEN
		House || '   ' || "Pre-Directional" || ' ' || "Street" || ' '
		|| TRIM("Street Suffix") || ' ' || "Post-Directional"
	  ELSE  -- no postdirectional
		House || '   ' || "Pre-Directional" || ' ' || "Street" || ' '
		|| TRIM("Street Suffix")
	  END  -- postdirectional
	 ELSE	-- no street suffix
	  CASE
	  WHEN LENGTH("Post-directional") > 0
	  THEN
		House || '   ' || "Pre-Directional" || ' ' || "Street" || ' '
		|| "Post-Directional"
	  ELSE -- no postidirectional
		House || '   ' || "Pre-Directional" || ' ' || "Street"
	  END -- postdirectional
	 END  -- street suffix
ELSE -- no predirectional
     CASE
     WHEN LENGTH("Street Suffix") > 0
     THEN
      CASE
      WHEN LENGTH("Post-directional") > 0
      THEN
		House || '   ' || "Street" || ' ' || TRIM("Street Suffix") || ' '
		|| "Post-Directional"
	  ELSE -- no postdirectional
		House || '   ' || "Street" || ' ' || TRIM("Street Suffix")
	  END -- postdirectional
    ELSE -- no street suffix
     CASE
     WHEN LENGTH("Post-directional") > 0
     THEN
	  House || "   " || "Street" || " "
		|| "Post-Directional"
	 ELSE -- no postdirectional
	  House || "   " || "Street"
	 END	-- postdirectional
   END	-- predirectional
END,

  "Apartment Number",
  TRIM("First Name") || " " || TRIM("Last Name"),
  "Phone Number", "$csvdate" 
FROM a;
-- *;
-- now create TerrList table. ***********************************;
DROP TABLE IF EXISTS TerrList;
CREATE TABLE TerrList
(TerrID TEXT, Counts INTEGER DEFAULT 0);
-- *;
-- * set territory ids from PolyTerri and MultiMail records *****;
ATTACH '$pathbase/DB-Dev/PolyTerri.db'
 AS db5;
ATTACH '$pathbase/DB-Dev/MultiMail.db'
 AS db3;
-- find matches in TerrProps;
with a AS (select DISTINCT upper(TRIM(UnitAddress)) AS StreetAddr,
 CongTerrID AS TerrNo FROM TerrProps) 
UPDATE Spec_RUBridge
SET CongTerrID = 
CASE 
WHEN UPPER(TRIM(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
THEN (SELECT TerrNo FROM a 
 WHERE StreetAddr IS UPPER(trim(UnitAddress)))
ELSE CongTerrID
END 
WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);
-- now find matches in SplitProps;
with a AS (select DISTINCT UPPER(TRIM(UnitAddress)) AS StreetAddr,
 CongTerrID AS TerrNo FROM SplitProps )
UPDATE Spec_RUBridge
SET CongTerrID =
CASE 
WHEN UPPER(TRIM(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
THEN (SELECT TerrNo FROM a 
 WHERE StreetAddr IS UPPER(trim(UnitAddress)))
ELSE CongTerrID
END 
WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);
-- end SetNewBridgeTerrs.sq;
-- *;
-- * set TerrList and Counts in Territories **********************;
INSERT INTO TerrList
SELECT DISTINCT CongTerrID,0
FROM Spec_RUBridge;
--;
WITH a AS (SELECT TerrID FROM Spec_RUBridge)
UPDATE TerrList
SET Counts =
CASE 
WHEN TerrID IN (SELECT TerrID FROM a)
 THEN (SELECT COUNT() FROM Spec_RUBridge
    WHERE TerrID IS TerrList.TerrID)
ELSE Counts
END;
--;
.quit
-- end RUSpecTerr_db.sq;
