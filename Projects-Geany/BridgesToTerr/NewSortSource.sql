-- * NewSortSource.sql
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * SortQTerrByAddr query as batch run." > SQLTemp.sql
-- * entry env vars folderbase=Territories base directory
-- * TID = territory ID,
-- * NAME_PRFX="QTerr$TID"
-- * NAME_SUFFX="U"
-- * DB_END=".db"
-- * TBL_NAME1="QSplit"
-- * TBL_NAME2="QSort"
-- * TBL_NAME3="QSorted"
-- * DB_NAME="$NAME_PRFX$DB_END"
.cd '$pathbase'
.cd './TerrData/Terr$TID/Working-Files'
.open $NAME_PRFX$DB_END
DROP TABLE IF EXISTS $NAME_PRFX$NAME_SUFFX;
DROP TABLE IF EXISTS $TBL_NAME1;
CREATE TEMP TABLE $TBL_NAME1
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
INSERT INTO $TBL_NAME1
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
 FROM $NAME_PRFX
;
-- * QSort same structure as QSplit;
DROP TABLE IF EXISTS $TBL_NAME2;
CREATE TEMP TABLE $TBL_NAME2
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
 INSERT INTO $TBL_NAME2
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
 FROM $TBL_NAME1
  ORDER BY AddrStreet, CAST(AddrNo AS INT), Unit
;
-- * QSorted table same structure as QTerrxxx;
CREATE TABLE $TBL_NAME3
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
INSERT INTO $TBL_NAME3 
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
FROM $TBL_NAME2;

DROP TABLE IF EXISTS $NAME_PRFX$NAME_SUFFX;
alter table $$NAME_PRFX rename to $NAME_PRFX$NAME_SUFFX;
alter table $TBL_NAME3 rename to $NAME_PRFX;
-- end NewSortSource;
