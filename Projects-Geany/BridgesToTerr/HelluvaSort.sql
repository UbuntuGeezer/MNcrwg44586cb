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
