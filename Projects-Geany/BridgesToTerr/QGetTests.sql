-- MultiMail.db as main;
-- PolyTerri.db as db5;
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
-- *;
INSERT INTO HelluvaSort
SELECT a.OwningParcel, a.UnitAddress,
 SUBSTR(a.UnitAddress,1,INSTR(a.UnitAddress,' ')-1)
  QNum, 
 a.SitusAddress QSitus, 
 CASE WHEN INSTR(SUBSTR(a.UnitAddress,LENGTH(a.UnitAddress)-1,
   2),' N S E W') > 0
  THEN SUBSTR(a.UnitAddress,LENGTH(a.UnitAddress),1)
 ELSE ''
 END QDir, a.Unit,
  a.Resident1, a.Phone1, a.Phone2,
  a."RefUSA-Phone", a.SubTerritory,
    a.CongTerrID, a.DoNotCall,
     a.RSO, a."Foreign",
      a.RecordDate, a.SitusAddress,
       a.PropUse
 FROM SplitProps a
 INNER JOIN TerrProps
 ON TerrProps.CongTerrID = a.CongTerrID
 WHERE a.CongTerrID IS '212'
 ORDER BY QSitus,QNum,a.Unit ;
-- *;
DELETE FROM HelluvaSort
WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM HelluvaSort
  GROUP BY OwningParcel,UnitAddress,Resident1);

