-- * QGetTerr query as batch run.
-- *	6/26/22.	wmk.
.cd '$pathbase'
.cd './TerrData/Terr$TID/Working-Files'
.shell echo "Opening ./Terr$TID/Working-Files/$DB_NAME" | awk '{print \$1}' > SQLTrace.txt
.open $DB_NAME 
-- insert new code here...;
.shell echo "Creating TEMP table QGetTerr" | awk '{print \$1}' > SQLTrace.txt
-- ATTACH PolyTerri and MultiMail databases;
ATTACH '$pathbase'
||		'/DB-Dev/MultiMail.db'
 AS db3;
ATTACH '$pathbase'
 ||		'/DB-Dev/PolyTerri.db'
  AS db5;
-- create TEMP table with extracted records and extra fields for sorting;
CREATE TEMP TABLE QGetTerr( OwningParcel TEXT NOT NULL,
 UnitAddress TEXT, QNum TEXT, QSitus TEXT, 
 QDir TEXT, Unit TEXT,
 Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,
   "RefUSA-Phone" TEXT,SubTerritory TEXT,
    CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,
     RSO INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
      RecordDate REAL DEFAULT 0, SitusAddress TEXT DEFAULT "",
       PropUse INTEGER
 );
-- populate temp table with extra sorting fields from PolyTerri and MultiMail; TerrProps and;
--  SplitProps records for territory;
.shell echo "Populating TEMP table QGetTerr from .Props tables" | awk '{print \$1}' >> SQLTrace.txt
-- use homestead information already in records;
 INSERT INTO QGetTerr
( OwningParcel, UnitAddress,
 QNum, QSitus, QDir, Unit,
  Resident1, Phone1, Phone2,
  "RefUSA-Phone", SubTerritory,
    CongTerrID, DoNotCall,
     RSO, "Foreign",
      RecordDate, SitusAddress,
       PropUse
 )
SELECT OWNINGPARCEL, UNITADDRESS,
CAST(SUBSTR(UNITADDRESS,1,INSTR(UNITADDRESS," ")-1) AS INTEGER) AS Num,
TRIM(SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS, " "),36-INSTR(SITUSADDRESS, " "))) AS SCSitus, 
CASE
WHEN INSTR("NSEW",
	SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS," ")-1,1)) > 0
 THEN SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS," ")-1,1)
ELSE ""
END AS NSEW,
 UNIT,
Resident1, Phone1,
CASE 
WHEN Phone2 IS "*" 
  AND UPPER(UNITADDRESS) IS UNITADDRESS 
 THEN Phone2 
ELSE "" 
END AS H, 
  "RefUSA-Phone" AS RefUSAPhone,
SubTerritory, CongTerrID, DoNotCall, RSO,
"Foreign", RecordDate, SitusAddress, PropUse 
FROM db5.TERRPROPS
WHERE CONGTERRID IS "$TID"
 AND SITUSADDRESS NOTNULL 
 AND SITUSADDRESS IS NOT ""
 AND cast(DELPENDING as INT) IS NOT 1
ORDER BY SCSitus,Num,Unit ;

-- MultiMail records;
 INSERT INTO QGetTerr
( OwningParcel, UnitAddress,
 QNum, QSitus, QDir, Unit,
  Resident1, Phone1, Phone2,
  "RefUSA-Phone", SubTerritory,
    CongTerrID, DoNotCall,
     RSO, "Foreign",
      RecordDate, SitusAddress,
       PropUse
 )
SELECT OWNINGPARCEL, UNITADDRESS,
CAST(SUBSTR(UNITADDRESS,1,INSTR(UNITADDRESS," ")-1) AS INTEGER) AS Num,
TRIM(SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS, " "),36-INSTR(SITUSADDRESS, " "))) AS SCSitus, 
CASE
WHEN INSTR("NSEW",
	SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS," ")-1,1)) > 0
 THEN SUBSTR(SITUSADDRESS,INSTR(SITUSADDRESS," ")-1,1)
ELSE ""
END AS NSEW,
 UNIT,
Resident1, Phone1,
CASE 
WHEN Phone2 IS "*" 
  AND UPPER(UNITADDRESS) IS UNITADDRESS 
 THEN Phone2 
ELSE "" 
END AS H, 
  "RefUSA-Phone" AS RefUSAPhone,
SubTerritory, CongTerrID, DoNotCall, RSO,
"Foreign", RecordDate, SitusAddress, PropUse 
FROM db3.SPLITPROPS
WHERE CONGTERRID IS "$TID"
 AND SITUSADDRESS  NOTNULL 
 AND SITUSADDRESS IS NOT ""
 AND cast(DELPENDING as INT) IS NOT 1 
ORDER BY SCSitus,Num,Unit ;
-- begin 2/5/21 mod;
CREATE TEMP TABLE HelluvaSort 
( OwningParcel TEXT NOT NULL,
 UnitAddress TEXT, QNum TEXT, QSitus TEXT, 
 QDir TEXT, Unit TEXT,
 Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,
   "RefUSA-Phone" TEXT,SubTerritory TEXT,
    CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,
     RSO INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
      RecordDate REAL DEFAULT 0, SitusAddress TEXT DEFAULT "",
       PropUse INTEGER
 );
INSERT INTO HelluvaSort 
SELECT * FROM QGetTerr 
 ORDER BY QSitus,QNum,Unit;  
--end 2/5/21 mod.;
-- NOW select all records from QGetTerr back into QTerrxxx omitting Num;
-- SCSitus, NSEW all presorted;
.shell echo "Select sorted records back into $TBL_NAME1" | awk '{print \$1}' >> SQLTrace.txt
DROP TABLE IF EXISTS $TBL_NAME1;
CREATE TABLE $TBL_NAME1
( OwningParcel TEXT NOT NULL, UnitAddress TEXT NOT NULL, 
 Unit TEXT, Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,
 "RefUSA-Phone" TEXT, SubTerritory TEXT, CongTerrID TEXT,
 DoNotCall INTEGER DEFAULT 0, RSO INTEGER DEFAULT 0,
 "Foreign" INTEGER DEFAULT 0, RecordDate REAL DEFAULT 0,
 SitusAddress TEXT DEFAULT "", PropUse INTEGER,
 DelPending INTEGER DEFAULT 0 );
INSERT OR IGNORE INTO $TBL_NAME1 
 SELECT 
 OwningParcel,
 UnitAddress,
 Unit,
 Resident1, Phone1, Phone2 AS H,
   "RefUSA-Phone" AS RefUSAPhone ,SubTerritory ,
    CongTerrID, DoNotCall,
     RSO , "Foreign",
      RecordDate, SitusAddress,
       PropUse, NULL 
 FROM HelluvaSort  
;
-- Delete duplicate DONOTCALL records;
DELETE FROM $TBL_NAME1
WHERE DONOTCALL IS 1 
 AND rowid NOT IN (SELECT MIN(rowid) FROM $TBL_NAME1
   GROUP BY OwningParcel, UnitAddress, Unit);
-- Delete duplicate records from $TBL_NAME1;
-- Delete duplicate records from $TBL_NAME1;
.shell echo "Deleting duplicate records from $TBL_NAME1" | awk '{print \$1}' >> SQLTrace.txt
DELETE FROM $TBL_NAME1
WHERE rowid
  NOT IN (SELECT MAX(rowid) 
		from $TBL_NAME1
		group by  owningparcel,
			 unitaddress, unit, resident1);
-- Generate $TBL_NAME1.csv;
.shell echo "Generating $TBL_NAME1.csv" | awk '{print \$1}' >> SQLTrace.txt
.headers ON
.output '$TBL_NAME1.csv'
SELECT * FROM $TBL_NAME1;
-- END QGetTerr.sql;
