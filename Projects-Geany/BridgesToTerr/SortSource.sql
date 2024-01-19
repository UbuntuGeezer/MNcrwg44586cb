-- * SortQTerrByAddr query as batch run." > SQLTemp.sql
.cd '$pathbase'
.cd './TerrData/Terr103/Working-Files'
.open QTerr103.db 
DROP TABLE IF EXISTS QTerr103U;
DROP TABLE IF EXISTS QSplit;
CREATE TEMP TABLE QSplit
 ( OwningParcel TEXT,
 AddrStreet TEXT,
  AddrNo TEXT NOT NULL,
 Unit TEXT,
 Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,
 "RefUSA-Phone" TEXT, SubTerritory TEXT,
 CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,
 RSO INTEGER DEFAULT 0,
 "Foreign" INTEGER DEFAULT 0,
 RecordDate REAL DEFAULT 0,
 SitusAddress TEXT DEFAULT "", PropUse INTEGER,
 DelPending INTEGER DEFAULT 0 )
;
INSERT INTO QSplit
( OwningParcel,
AddrStreet,
 AddrNo,
 Unit,
 Resident1, Phone1, Phone2,
 "RefUSA-Phone", SubTerritory,
 CongTerrID, DoNotCall,
 RSO,
 "Foreign",
 RecordDate,
 SitusAddress, PropUse,
 DelPending )
select
OwningParcel,		#street,addrno,unit
TRIM(SUBSTR(UnitAddress,INSTR(UnitAddress," "),
      36-INSTR(UnitAddress," "))) AS Street, 
SUBSTR(UnitAddress,1,INSTR(UnitAddress, " ")-1) AS AddrNo, 
Unit, 
 Resident1,
 Phone1, Phone2,
 "RefUSA-Phone", SubTerritory,
 CongTerrID,
 DoNotCall,
 RSO,
 "Foreign",
 RecordDate,
 SitusAddress,
 PropUse, DelPending
 FROM QTerr103
;
-- * QSort same structure as QSplit;
DROP TABLE IF EXISTS QSort;
CREATE TEMP TABLE QSort
 ( OwningParcel TEXT NOT NULL,
AddrStreet TEXT,
 AddrNo TEXT,
 Unit TEXT,
 Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,
 "RefUSA-Phone" TEXT, SubTerritory TEXT,
 CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,
 RSO INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
 RecordDate REAL DEFAULT 0,
 SitusAddress TEXT DEFAULT "", PropUse INTEGER,
 DelPending INTEGER DEFAULT 0 );
-- * populate from QSplit, sorting by address fields;
 INSERT INTO QSort
  ( OwningParcel,
 AddrStreet,
 AddrNo,
 Unit,
 Resident1, Phone1, Phone2,
 "RefUSA-Phone", SubTerritory,
 CongTerrID, DoNotCall,
 RSO, "Foreign",
 RecordDate,
 SitusAddress, PropUse,
 DelPending)
 SELECT 
 OwningParcel,
 AddrStreet, AddrNo, AddrUnit,
 Resident1, Phone1, Phone2,
 "RefUSA-Phone", SubTerritory,
 CongTerrID, DoNotCall,
 RSO,
 "Foreign",
 RecordDate,
 SitusAddress, PropUse,
 DelPending
 FROM QSplit
  ORDER BY AddrStreet, CAST(AddrNo AS INT), Unit
;
-- * QSorted table same structure as QTerrxxx;
CREATE TABLE QSorted
 ( OwningParcel TEXT,
 UnitAddress TEXT,
 Unit TEXT,
 Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,
 "RefUSA-Phone" TEXT, SubTerritory TEXT,
 CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,
 RSO INTEGER DEFAULT 0,
 "Foreign" INTEGER DEFAULT 0,
 RecordDate REAL DEFAULT 0,
 SitusAddress TEXT DEFAULT "", PropUse INTEGER,
 DelPending INTEGER DEFAULT 0 )
;
INSERT INTO QSorted 
SELECT OwningParcel,
 AddrNo || "   " || TRIM(AddrStreet) 
 Unit,
 Resident1, Phone1, Phone2,
 "RefUSA-Phone", SubTerritory,
 CongTerrID, DoNotCall,
 RSO, "Foreign",
 RecordDate,
 SitusAddress, PropUse,
 DelPending
FROM QSort;

DROP TABLE IF EXISTS QTerr103U;
alter table QTerr103 rename to QTerr103U;
alter table QSorted rename to QTerr103;
