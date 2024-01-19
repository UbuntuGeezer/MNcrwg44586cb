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
